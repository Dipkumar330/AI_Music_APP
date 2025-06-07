import { HttpException, HttpStatus } from '@nestjs/common';

export const TypeExceptions = {
  NotFoundCommonFunction(message: string): HttpException {
    return new HttpException(
      {
        message: message,
        error: 'Not Found',
        statusCode: HttpStatus.NOT_FOUND
      },
      HttpStatus.NOT_FOUND
    );
  },

  AlreadyExistsCommonFunction(message: string): HttpException {
    return new HttpException(
      {
        message: message,
        error: 'Already Exists',
        statusCode: HttpStatus.CONFLICT
      },
      HttpStatus.CONFLICT
    );
  },

  InvalidFile(): HttpException {
    return new HttpException(
      {
        message: 'Uploaded file is invalid',
        error: 'InvalidFile',
        statusCode: HttpStatus.BAD_REQUEST
      },
      HttpStatus.BAD_REQUEST
    );
  },

  NoTaskFound(): HttpException {
    return new HttpException(
      {
        message: 'No Task Found',
        error: 'InvalidTask',
        statusCode: HttpStatus.BAD_REQUEST
      },
      HttpStatus.BAD_REQUEST
    );
  },

  BadReqCommonFunction(message: string) {
    return new HttpException(
      {
        statusCode: HttpStatus.BAD_REQUEST,
        message: message,
        error: 'Not Found'
      },
      HttpStatus.BAD_REQUEST
    );
  },

  UnknownError(message) {
    return new HttpException(
      {
        statusCode: HttpStatus.BAD_GATEWAY,
        message: message,
        data: {}
      },
      HttpStatus.BAD_GATEWAY
    );
  },

  Unauthorized(message) {
    return new HttpException(
      {
        statusCode: HttpStatus.UNAUTHORIZED,
        message: message,
        data: {}
      },
      HttpStatus.UNAUTHORIZED
    );
  },

  SubscriptionExpire(message) {
    return new HttpException(
      {
        statusCode: HttpStatus.PAYMENT_REQUIRED,
        message: message,
        data: {}
      },
      HttpStatus.PAYMENT_REQUIRED
    );
  },

  Forbidden(message) {
    return new HttpException(
      {
        statusCode: HttpStatus.FORBIDDEN,
        message: message,
        data: {}
      },
      HttpStatus.FORBIDDEN
    );
  }
};
