import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { InjectModel } from '@nestjs/mongoose';
import * as bcrypt from 'bcrypt';
import mongoose, { Model } from 'mongoose';
import { LoginDto } from '../common/dto/common.dto';
import { AuthExceptions, CustomError, TypeExceptions } from '../common/helpers/exceptions';
import { LoggerService } from '../common/logger/logger.service';
import { Users, UsersDocument } from '../users/schemas/user.schema';
import { CreateUserDto } from './dto/create-user.dto';
import { UpdateUserDto } from './dto/update-user.dto';
import { RESPONSE_ERROR, USER_RESPONSE_SUCCESS } from '../common/constants/response.constant';
import { Response } from 'express';
import { statusOk } from 'src/common/constants/respones.status.constant';
import { successResponse } from 'src/common/helpers/responses/success.helper';
import { CommonService } from 'src/common/services/common.service';
import { TwilioService } from 'src/common/helpers/twilio.service';
import { VerifyOtpDto } from './dto/verify-otp.dto';
import { SendOtpDto } from './dto/send-otp.dto';

@Injectable()
export class UsersService {
  constructor(
    @InjectModel(Users.name) private readonly userModel: Model<UsersDocument>,
    private readonly myLogger: LoggerService,
    private readonly configService: ConfigService,
    private readonly commonService: CommonService,
    private readonly twilioService: TwilioService,
  ) {
    // Due to transient scope, UsersService has its own unique instance of MyLogger,
    // so setting context here will not affect other instances in other services
    this.myLogger.setContext(UsersService.name);
  }

  async signUp(body: CreateUserDto, res: Response) {
    console.log('body: ', body);
    console.log('body.email: ', body.email);
    try {
      // Check duplicate user
      if (await this.getUserByEmail(body.email)) {
        throw TypeExceptions.AlreadyExistsCommonFunction(RESPONSE_ERROR.USER_ALREADY_EXIST);
      }

      if (await this.getUserByPhoneNumber(body.phoneNumber)) {
        throw TypeExceptions.AlreadyExistsCommonFunction(
          RESPONSE_ERROR.USER_ALREADY_EXIST_PHONE_NUMBER,
        );
      }

      const insertObj = {
        ...body,
        password: await bcrypt.hash(body.password, 10),
        createdDate: new Date().toISOString(),
        updatedDate: new Date().toISOString(),
      };

      const createdUser = await this.userModel.create(insertObj);

      // Jwt payload create
      const payload = {
        _id: createdUser._id,
        email: createdUser.email,
        type: 'user',
      };

      // Generate JWT token for the admin
      const jwtToken = await this.commonService.generateAuthToken(payload);
      
      return res.status(statusOk).json(
        successResponse(statusOk, USER_RESPONSE_SUCCESS.USER_SIGN_UP_SUCC, {
          _id: createdUser._id,
          name: createdUser.name,
          phoneNumber: createdUser.phoneNumber,
          countryCode: createdUser.countryCode,
          birthDate: createdUser.birthDate,
          email: createdUser.email,
          authToken: jwtToken,
        }),
      );
    } catch (error) {
      throw CustomError.UnknownError(error?.message, error?.status);
    }
  }

  async userDetails(req, res: Response) {
    try {
      const id = req['user']._id;
      const findUserDetails = await this.getUserById(id);
      if (!findUserDetails) {
        throw TypeExceptions.NotFoundCommonFunction(USER_RESPONSE_SUCCESS.USER_NOT_FOUND);
      }

      delete findUserDetails.password;

      return res.status(statusOk).json(
        successResponse(statusOk, USER_RESPONSE_SUCCESS.USER_SIGN_UP_SUCC, {
          ...findUserDetails,
        }),
      );
    } catch (error) {
      throw CustomError.UnknownError(error?.message, error?.status);
    }
  }

  async update(body: UpdateUserDto, req, res: Response) {
    try {
      const id = req['user']._id;
      const findUserDetails = await this.getUserById(id);
      if (!findUserDetails) {
        throw TypeExceptions.NotFoundCommonFunction(USER_RESPONSE_SUCCESS.USER_NOT_FOUND);
      }

      await this.userModel.findOneAndUpdate(
        {
          _id: new mongoose.Types.ObjectId(id),
        },
        {
          $set: {
            ...body,
          },
        },
      );

      return res
        .status(statusOk)
        .json(successResponse(statusOk, USER_RESPONSE_SUCCESS.USER_UPDATED_SUCC, {}));
    } catch (error) {
      throw CustomError.UnknownError(error?.message, error?.status);
    }
  }

  async createInitialUser(): Promise<void> {
    const user = await this.getUserByEmail(this.configService.get('database.initialUser.email'));

    if (user) {
      this.myLogger.customLog('Initial user already loaded.');
    } else {
      const params = {
        name: this.configService.get('database.initialUser.name'),
        phoneNumber: this.configService.get('database.initialUser.phoneNumber'),
        countryCode: this.configService.get('database.initialUser.countryCode'),
        birthDate: this.configService.get('database.initialUser.birthDate'),
        email: this.configService.get('database.initialUser.email'),
        password: '',
        isActive: true,
      };

      const salt = bcrypt.genSaltSync(10);
      const hash = bcrypt.hashSync(this.configService.get('database.initialUser.password'), salt);

      params.password = hash;

      await this.userModel.create(params);
      this.myLogger.log('Initial user loaded successfully.');
    }
  }

  async login(params: LoginDto, res: Response) {
    try {
      const { email, password, phoneNumber } = params;

      let user: any;

      if (email) {
        user = await this.userModel.findOne({ email: email.toLowerCase() }).lean();
        if (!user) {
          throw AuthExceptions.AccountNotExist();
        }

        const isPasswordValid = await bcrypt.compare(password || '', user.password);
        if (!isPasswordValid) {
          throw AuthExceptions.InvalidPassword();
        }
      } else if (phoneNumber) {
        user = await this.userModel.findOne({ phoneNumber }).lean();
        console.log('user: ', user);
        if (!user) {
          throw AuthExceptions.AccountNotExist();
        }

        await this.twilioService.sendOtp(`${params.contryCode}${params.phoneNumber}`);
      } else {
        throw AuthExceptions.InvalidPassword(); // Add a generic invalid credentials exception
      }

      // Clean up sensitive fields
      delete user.password;
      delete user.__v;

      // Create JWT payload
      const payload = {
        _id: user._id,
        email: user.email,
        type: 'user',
      };

      // Generate token
      const jwtToken = await this.commonService.generateAuthToken(payload);
      user.authToken = jwtToken;

      return res
        .status(statusOk)
        .json(successResponse(statusOk, USER_RESPONSE_SUCCESS.USER_LOGIN_SUCC, user));
    } catch (error) {
      console.log('error: ', error);
      throw CustomError.UnknownError(error?.message, error?.status);
    }
  }

  async getUserByEmail(email: string) {
    return await this.userModel.findOne({
      email: email,
    });
  }

  async getUserByPhoneNumber(phoneNumber: string) {
    return await this.userModel.findOne({
      phoneNumber: phoneNumber,
    });
  }

  async getUserById(id: string) {
    return await this.userModel
      .findOne({
        _id: new mongoose.Types.ObjectId(id),
      })
      .lean();
  }

  async verifyOtp(body: VerifyOtpDto, res) {
    try {
      if(body.isSignUp){
        const user = await this.getUserByPhoneNumber(body.phoneNumber);
        if (!user) throw AuthExceptions.AccountNotExist();
      }

      const verified = await this.twilioService.verifyOtp(
        `${body.countryCode}${body.phoneNumber}`,
        body.otp,
      );

      if (verified) {
        return res
          .status(statusOk)
          .json(successResponse(statusOk, USER_RESPONSE_SUCCESS.USER_VERIFY_OTP_SUCC, {}));
      } else {
        throw TypeExceptions.BadReqCommonFunction('Invalid OTP');
      }
    } catch (error) {
      console.error('OTP verify controller error:', error);
      throw CustomError.UnknownError(error?.message, error?.status);
    }
  }

  async sendOtp(body: SendOtpDto, res) {
    try {
      await this.twilioService.sendOtp(
        `${body.countryCode}${body.phoneNumber}`,
      );
      
    
    
        return res
          .status(statusOk)
          .json(successResponse(statusOk, USER_RESPONSE_SUCCESS.USER_SEND_OTP_SUCC, {}));
      
    } catch (error) {
      throw CustomError.UnknownError(error?.message, error?.status);
    }
  }
}
