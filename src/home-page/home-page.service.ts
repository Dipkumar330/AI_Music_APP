import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { SongCollection, SongCollectionDocument } from './schemas/song-collection.schema';
import { Model } from 'mongoose';
import { CustomError } from 'src/common/helpers/exceptions';
import { statusOk } from 'src/common/constants/respones.status.constant';
import { successResponse } from 'src/common/helpers/responses/success.helper';
import { HOMEPAGE_RESPONSE_SUCCESS } from 'src/common/constants/response.constant';
import { Artist, ArtistDocument } from './schemas/artist.schema';

@Injectable()
export class HomePageService {
  constructor(
    @InjectModel(SongCollection.name)
    private readonly songCollectionModelModel: Model<SongCollectionDocument>,
    @InjectModel(Artist.name)
    private readonly artistModel: Model<ArtistDocument>,
  ) {}
  async songCollectionList() {
    try {
      const songCollectionArray = [
        {
          artistName: 'Ruth B',
          songName: 'dandelions',
          imageName: 'dandelions.jpg',
          mp3File: 'dandelions.mp3',
          lrcFile: 'dandelions.lrc',
        },
        {
          artistName: 'Ellie Goulding',
          songName: 'love_me_like_you_do',
          imageName: 'love_me_like_you_do.jpg',
          mp3File: 'love_me_like_you_do.mp3',
          lrcFile: 'love_me_like_you_do.lrc',
        },
        {
          artistName: 'One Direction',
          songName: 'night_changes',
          imageName: 'night_changes.jpg',
          mp3File: 'night_changes.mp3',
          lrcFile: 'night_changes.lrc',
        },
        {
          artistName: 'Alan Jackson',
          songName: 'the_older_i_get',
          imageName: 'the_older_i_get.jpg',
          mp3File: 'the_older_i_get.mp3',
          lrcFile: 'the_older_i_get.lrc',
        },
        {
          artistName: 'Imagine Dragons',
          songName: 'believer',
          imageName: 'believer.jpg',
          mp3File: 'believer.mp3',
          lrcFile: 'believer.lrc',
        },
        {
          artistName: 'Bryson Bernard',
          songName: 'cupid',
          imageName: 'cupid.jpg',
          mp3File: 'cupid.mp3',
          lrcFile: 'cupid.lrc',
        },
        {
          artistName: 'Alphaville',
          songName: 'forever_young',
          imageName: 'forever_young.jpg',
          mp3File: 'forever_young.mp3',
          lrcFile: 'forever_young.lrc',
        },
        {
          artistName: 'Wiz Khalifa',
          songName: 'see_you_again',
          imageName: 'see_you_again.jpg',
          mp3File: 'see_you_again.mp3',
          lrcFile: 'see_you_again.lrc',
        },
        {
          artistName: 'Shawn Mendes',
          songName: 'senorita',
          imageName: 'senorita.jpg',
          mp3File: 'senorita.mp3',
          lrcFile: 'senorita.lrc',
        },
        {
          artistName: 'Ed Sheeran',
          songName: 'shape_of_you',
          imageName: 'shape_of_you.jpg',
          mp3File: 'shape_of_you.mp3',
          lrcFile: 'shape_of_you.lrc',
        },
        {
          artistName: 'Sia',
          songName: 'unstoppable',
          imageName: 'unstoppable.jpg',
          mp3File: 'unstoppable.mp3',
          lrcFile: 'unstoppable.lrc',
        },
      ];

      const findSongCollection = await this.songCollectionModelModel.find({});

      if (findSongCollection?.length != 11) {
        await this.songCollectionModelModel.insertMany(songCollectionArray);
      }

      return true;
    } catch (error) {}
  }

  async artistList() {
    try {
      const artistList = [
        {
          name: 'Alan Walker',
          image: 'alan_walker.jpg',
          details: `Alan Olav Walker is a Norwegian DJ and record producer. His songs "Faded", "Sing Me to Sleep", "Alone", "All Falls Down" and "Darkside" have each been multi-platinum-certified and reached number 1 on the VG-lista chart in Norway.`,
          born: '24 August 1997',
          link: 'https://www.youtube.com/channel/UCJrOtniJ0-NWz37R30urifQ',
        },
        {
          name: 'Justin Bieber',
          image: 'justin_bieber.jpg',
          details:
            'Justin Drew Bieber is a Canadian singer-songwriter. Regarded as a pop icon, he is recognized for his multi-genre musical performances. ',
          born: '1 March 1994',
          link: 'https://www.youtube.com/channel/UCIwFjwMjI0y7PDBVEO9-bkQ',
        },
        {
          name: 'Jennifer Lopez',
          image: 'jennifer_lopez.jpg',
          details:
            'Jennifer Lynn Lopez, also known by her nickname J.Lo, is an American singer, songwriter, actress, dancer and businesswoman. Lopez is regarded as one of the most influential entertainers of her time, credited with breaking barriers for Latino Americans in Hollywood and helping propel the Latin pop movement in music.',
          born: '24 July 1969',
          link: 'https://www.youtube.com/channel/UCr8RjWUQ_9KYcIPmWiqBroQ',
        },
        {
          name: 'Adele',
          image: 'adele.jpg',
          details:
            'Adele Laurie Blue Adkins is an English singer-songwriter. Regarded as a British icon, she is known for her mezzo-soprano vocals and sentimental songwriting. Her accolades include 16 Grammy Awards, 12 Brit Awards, an Academy Award, a Primetime Emmy Award, and a Golden Globe Award.',
          born: '5 May 1988',
          link: 'https://www.youtube.com/channel/UCsRM0YB_dabtEPGPTKo-gcw',
        },
        {
          name: 'Christina Perri',
          image: 'christina_perri.jpeg',
          details: `Christina Judith Perri is an American singer and songwriter. After her debut single "Jar of Hearts" was featured on the television series So You Think You Can Dance in 2010, Perri signed with Atlantic Records and released her debut extended play, The Ocean Way Sessions.`,
          born: '19 August 1986',
          link: 'https://www.youtube.com/channel/UC2gMECGMn5TVbRN5S5tKb8Q',
        },
      ];

      const findArtistList = await this.artistModel.find({});

      if (findArtistList?.length != 5) {
        await this.artistModel.insertMany(artistList);
      }

      return true;
    } catch (error) {}
  }

  async homePageList(res) {
    try {
      const homePageList = await this.songCollectionModelModel.find({});

      const updatedList = [];
      for (const element of homePageList) {
        updatedList.push({
          artistName: element.artistName,
          songName: element.songName,
          imageName: `${process.env.S3_URL_KEY}songs/${element.imageName}`,
          mp3File: `${process.env.S3_URL_KEY}songs/${element.mp3File}`,
          lrcFile: `${process.env.S3_URL_KEY}songs/${element.lrcFile}`,
        });
      }
      console.log('updatedList: ', updatedList);

      return res
        .status(statusOk)
        .json(
          successResponse(statusOk, HOMEPAGE_RESPONSE_SUCCESS.HOME_PAGE_LIST_SUCC, updatedList),
        );
    } catch (error) {
      throw CustomError.UnknownError(error?.message, error?.status);
    }
  }

  async artistListRes(res) {
    try {
      const artistList = await this.artistModel.find({});

      const updatedList = [];
      for (const element of artistList) {
        updatedList.push({
          name: element.name,
          image: `${process.env.S3_URL_KEY}artist/${element.image}`,
          details: element.details,
          born: element.born,
          link: element.link,
        });
      }
      console.log('updatedList: ', updatedList);

      return res
        .status(statusOk)
        .json(
          successResponse(statusOk, HOMEPAGE_RESPONSE_SUCCESS.HOME_PAGE_LIST_SUCC, updatedList),
        );
    } catch (error) {
      throw CustomError.UnknownError(error?.message, error?.status);
    }
  }
}
