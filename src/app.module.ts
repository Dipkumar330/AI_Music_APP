import { MiddlewareConsumer, Module, NestModule } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { APP_FILTER, APP_GUARD, APP_INTERCEPTOR } from '@nestjs/core';
import { TransformInterceptor } from './common/interceptors/transform.interceptor';
import { LoggerModule } from './common/logger/logger.module';
import AppConfiguration from './config/app.config';
import AuthConfiguration from './config/auth.config';
import DatabaseConfiguration from './config/database.config';
import { DatabaseModule } from './providers/database/mongo/database.module';
import { JwtAuthGuard } from './security/auth/guards/jwt-auth.guard';
import { ThrottleModule } from './security/throttle/throttle.module';
import { UsersModule } from './users/users.module';
import { userAuthMiddleware } from './common/middleware/userAuth.middleware';
import { MongooseModule } from '@nestjs/mongoose';
import { Users, UsersSchema } from './users/schemas/user.schema';
import { JwtService } from '@nestjs/jwt';
import { OpenaiModule } from './openai/openai.module';
import { CustomExceptionFilter } from './common/exceptions/http-exception.filter';
import { HomePageModule } from './home-page/home-page.module';

@Module({
  imports: [
    ConfigModule.forRoot({
      load: [AppConfiguration, DatabaseConfiguration, AuthConfiguration],
      ignoreEnvFile: false,
      isGlobal: true,
    }),
    MongooseModule.forFeature([{ name: Users.name, schema: UsersSchema }]),
    DatabaseModule,
    LoggerModule,
    ThrottleModule,
    UsersModule,
    OpenaiModule,
    HomePageModule,
  ],
  providers: [
    {
      provide: APP_GUARD,
      useClass: JwtAuthGuard,
    },
    // {
    //   provide: APP_GUARD,
    //   useClass: ThrottlerGuard,
    // },
    {
      provide: APP_FILTER,
      useClass: CustomExceptionFilter,
    },
    JwtService,
  ],
})
export class AppModule implements NestModule {
  configure(consumer: MiddlewareConsumer) {
    consumer.apply(userAuthMiddleware).forRoutes('/users/*');
  }
}
