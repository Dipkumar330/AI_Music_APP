import { ValidationPipe } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { NestFactory } from '@nestjs/core';
import { NestExpressApplication } from '@nestjs/platform-express';
import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';
import helmet from 'helmet';

import { AppModule } from './app.module';
import { AppEnvironment } from './common/constants/enum.constant';
import { LoggerService } from './common/logger/logger.service';

async function bootstrap() {
  const app = await NestFactory.create<NestExpressApplication>(AppModule);

  // Get app config for cors/helmet settings and starting the app.
  const configService = app.get(ConfigService);
  const appConfig = configService.get('express');

  // Configure OPEN API/Swagger
  const swaggerConfig = new DocumentBuilder()
    .setTitle(appConfig.name)
    .setDescription(appConfig.description)
    .setVersion(appConfig.version)
    .addServer('/')
    .addServer('/xcode')
    .addBearerAuth()
    .build();

  const document = SwaggerModule.createDocument(app, swaggerConfig);

  if (appConfig.environment != AppEnvironment.PRODUCTION) {
    SwaggerModule.setup('/', app, document);
  }

  // Apply custom logger
  app.useLogger(new LoggerService());

  // Use Helmet middleware for securing HTTP headers
  app.use(helmet());

  // Enable/Disable CORS
  if (appConfig.enableCors) {
    app.enableCors();
  }

  // Apply global validation pipe to handle DTO validation
  app.useGlobalPipes(
    new ValidationPipe({
      transform: true
    })
  );

  // Apply the HttpExceptionFilter globally
  app.useGlobalFilters();

  await app.listen(appConfig.port);
}
bootstrap();
