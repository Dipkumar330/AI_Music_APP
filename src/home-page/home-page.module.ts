import { Module, OnModuleInit } from '@nestjs/common';
import { HomePageService } from './home-page.service';
import { HomePageController } from './home-page.controller';
import { MongooseModule } from '@nestjs/mongoose';
import { SongCollection, SongCollectionSchema } from './schemas/song-collection.schema';
import { Artist, ArtistSchema } from './schemas/artist.schema';

@Module({
   imports: [
      MongooseModule.forFeature([{ name: SongCollection.name, schema: SongCollectionSchema },
        { name: Artist.name, schema: ArtistSchema }
      ]),
    ],
  controllers: [HomePageController],
  providers: [HomePageService],
})

export class HomePageModule implements OnModuleInit {
  constructor(private readonly homePageService: HomePageService) {}

  async onModuleInit(): Promise<void> {
    await this.homePageService.songCollectionList();
      await this.homePageService.artistList();
  }
}
