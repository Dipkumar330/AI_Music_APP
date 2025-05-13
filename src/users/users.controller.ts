import {
  Controller,
  Get,
  Post,
  Body,
  HttpStatus,
  Res,
  Req,
} from "@nestjs/common";
import {
  ApiBadRequestResponse,
  ApiBearerAuth,
  ApiOkResponse,
  ApiOperation,
  ApiTags,
} from "@nestjs/swagger";
import { UsersService } from "./users.service";
import { CreateUserDto } from "./dto/create-user.dto";
import { UpdateUserDto } from "./dto/update-user.dto";
import { RESPONSE_SUCCESS } from "../common/constants/response.constant";
import { ResponseMessage } from "../common/decorators/response.decorator";
import { Public } from "../security/auth/auth.decorator";
import { Request, Response } from "express";

@Public()
@Controller("users")
@ApiTags("User Management")
@ApiBearerAuth()
export class UsersController {
  constructor(private readonly usersService: UsersService) {}

  @Post("signUp")
  @ResponseMessage(RESPONSE_SUCCESS.USER_INSERTED)
  @Public()
  @ApiOperation({
    description: `
    This API will be used for creating new user using the admin panel.

    Figma Screen Reference: AP - User 1.0 To 1.6
        
    Below is the flow:

    1). Check email is exist OR not in tbl_user table if the user is already exist then give the error response with **This email is already registered with us.** Otherwise we have to insert the new user into the tbl_user table also we need to create a JWT token for the user and returning to the response.

    2). Password should be encrypted while storing the user information into the database.
    `,
  })
  @ApiOkResponse({
    schema: {
      example: {
        statusCode: HttpStatus.OK,
        message: RESPONSE_SUCCESS.USER_INSERTED,
        data: {
          firstName: "string",
          lastName: "string",
          gender: "string",
          email: "string",
          accessToken: "string",
        },
      },
    },
  })
  @ApiBadRequestResponse({
    schema: {
      example: {
        statusCode: HttpStatus.BAD_REQUEST,
        message: "This email is already registered with us.",
        data: {},
      },
    },
  })
  signUp(@Body() body: CreateUserDto, @Res() res: Response) {
    return this.usersService.signUp(body, res);
  }

  @ApiBearerAuth()
  @Get("get/:id")
  @ResponseMessage(RESPONSE_SUCCESS.USER_LISTED)
  userDetails(@Req() req: Request, @Res() res: Response) {
    return this.usersService.userDetails(req, res);
  }

  @ApiBearerAuth()
  @Post("update")
  @ResponseMessage(RESPONSE_SUCCESS.USER_UPDATED)
  update(
    @Body() body: UpdateUserDto,
    @Req() req: Request,
    @Res() res: Response
  ) {
    return this.usersService.update(body, req, res);
  }
}
