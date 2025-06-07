import { Controller, Get, Res } from '@nestjs/common';
import { HomePageService } from './home-page.service';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { Response } from 'express';
import { Public } from 'src/security/auth/auth.decorator';

@Public()
@ApiTags('Home Page Management')
@Controller('homePage')
export class HomePageController {
  constructor(private readonly homePageService: HomePageService) {}

  @ApiBearerAuth()
  @Get('get')
  userDetails(@Res() res: Response) {
    return this.homePageService.homePageList(res);
  }

  @ApiBearerAuth()
  @Get('artistList')
  artistListRes(@Res() res: Response) {
    return this.homePageService.artistListRes(res);
  }
}
