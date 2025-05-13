import { Injectable } from "@nestjs/common";
import { ConfigService } from "@nestjs/config";
import { InjectModel } from "@nestjs/mongoose";
import * as bcrypt from "bcrypt";
import mongoose, { Model } from "mongoose";
import { LoginDto } from "../common/dto/common.dto";
import {
  AuthExceptions,
  CustomError,
  TypeExceptions,
} from "../common/helpers/exceptions";
import { LoggerService } from "../common/logger/logger.service";
import { Users, UsersDocument } from "../users/schemas/user.schema";
import { CreateUserDto } from "./dto/create-user.dto";
import { UpdateUserDto } from "./dto/update-user.dto";
import {
  RESPONSE_ERROR,
  USER_RESPONSE_SUCCESS,
} from "../common/constants/response.constant";
import { Response } from "express";
import { statusOk } from "src/common/constants/respones.status.constant";
import { successResponse } from "src/common/helpers/responses/success.helper";
import { CommonService } from "src/common/services/common.service";

@Injectable()
export class UsersService {
  constructor(
    @InjectModel(Users.name) private userModel: Model<UsersDocument>,
    private myLogger: LoggerService,
    private configService: ConfigService,
    private readonly commonService: CommonService
  ) {
    // Due to transient scope, UsersService has its own unique instance of MyLogger,
    // so setting context here will not affect other instances in other services
    this.myLogger.setContext(UsersService.name);
  }

  async signUp(body: CreateUserDto, res: Response) {
    try {
      // Check duplicate user
      if (await this.getUserByEmail(body.email)) {
        throw TypeExceptions.AlreadyExistsCommonFunction(
          RESPONSE_ERROR.USER_ALREADY_EXIST
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
        type: "user",
      };

      // Generate JWT token for the admin
      const jwtToken = await this.commonService.generateAuthToken(payload);

      return res.status(statusOk).json(
        successResponse(statusOk, USER_RESPONSE_SUCCESS.USER_SIGN_UP_SUCC, {
          authToken: jwtToken,
        })
      );
    } catch (error) {
      throw CustomError.UnknownError(error?.message, error?.status);
    }
  }

  async userDetails(req, res: Response) {
    try {
      const id = req["user"]._id;
      const findUserDetails = await this.getUserById(id);
      if (!findUserDetails) {
        throw TypeExceptions.NotFoundCommonFunction(
          USER_RESPONSE_SUCCESS.USER_NOT_FOUND
        );
      }

      delete findUserDetails.password;

      return res.status(statusOk).json(
        successResponse(statusOk, USER_RESPONSE_SUCCESS.USER_SIGN_UP_SUCC, {
          ...findUserDetails,
        })
      );
    } catch (error) {
      throw CustomError.UnknownError(error?.message, error?.status);
    }
  }

  async update(body: UpdateUserDto, req, res: Response) {
    try {
      const id = req["user"]._id;
      const findUserDetails = await this.getUserById(id);
      if (!findUserDetails) {
        throw TypeExceptions.NotFoundCommonFunction(
          USER_RESPONSE_SUCCESS.USER_NOT_FOUND
        );
      }

      await this.userModel.findOneAndUpdate(
        {
          _id: new mongoose.Types.ObjectId(id),
        },
        {
          $set: {
            ...body,
          },
        }
      );

      return res
        .status(statusOk)
        .json(
          successResponse(statusOk, USER_RESPONSE_SUCCESS.USER_UPDATED_SUCC, {})
        );
    } catch (error) {
      throw CustomError.UnknownError(error?.message, error?.status);
    }
  }

  async createInitialUser(): Promise<void> {
    const user = await this.getUserByEmail(
      this.configService.get("database.initialUser.email")
    );

    if (user) {
      this.myLogger.customLog("Initial user already loaded.");
    } else {
      const params: CreateUserDto = {
        name: this.configService.get("database.initialUser.name"),
        phoneNumber: this.configService.get("database.initialUser.phoneNumber"),
        countryCode: this.configService.get("database.initialUser.countryCode"),
        birthDate: this.configService.get("database.initialUser.birthDate"),
        email: this.configService.get("database.initialUser.email"),
        password: "",
        isActive: true,
      };

      const salt = bcrypt.genSaltSync(10);
      const hash = bcrypt.hashSync(
        this.configService.get("database.initialUser.password"),
        salt
      );

      params.password = hash;

      await this.userModel.create(params);
      this.myLogger.log("Initial user loaded successfully.");
    }
  }

  async login(params: LoginDto) {
    const user = await this.userModel.findOne({
      email: params.email,
    });

    if (!user) {
      throw AuthExceptions.AccountNotExist();
    }

    if (!user.isActive) {
      throw AuthExceptions.AccountNotActive();
    }

    if (!bcrypt.compareSync(params.password, user.password)) {
      throw AuthExceptions.InvalidPassword();
    }
    delete user.password;
    delete user.__v;

    return user;
  }

  async getUserByEmail(email: string) {
    return await this.userModel.findOne({
      email: email,
    });
  }

  async getUserById(id: string) {
    return await this.userModel
      .findOne({
        _id: new mongoose.Types.ObjectId(id),
      })
      .lean();
  }
}
