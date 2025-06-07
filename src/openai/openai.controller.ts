import { Controller, Get, Post, Body, Patch, Param, Delete, Res } from '@nestjs/common';
import { CreateOpenaiDto } from './dto/create-openai.dto';
import { Public } from 'src/security/auth/auth.decorator';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { Response } from 'express';
import { OpenaiService } from './openai.service';


@Public()
@Controller('openai')
@ApiTags("Open ai Management")
@ApiBearerAuth()
export class OpenaiController {
  constructor(private readonly openaiService: OpenaiService) {}

  @Post('openAi')
  create(@Body() createOpenaiDto: CreateOpenaiDto, @Res() res:Response) {
    return this.openaiService.getCompletion(createOpenaiDto, res);
  }

}
