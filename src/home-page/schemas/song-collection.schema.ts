import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document } from 'mongoose';
import { TABLE_NAMES } from '../../common/constants/table-name.constant';

export type SongCollectionDocument = SongCollection & Document;

@Schema({ collection: TABLE_NAMES.SONG_COLLECTION, timestamps: true })
export class SongCollection {
  @Prop({ required: true })
  artistName: string;

  @Prop({ required: true })
  songName: string;

  @Prop({ required: true })
  imageName: string;

  @Prop({ required: true })
  mp3File: string;

  @Prop({ required: true })
  lrcFile: string;
}

export const SongCollectionSchema = SchemaFactory.createForClass(SongCollection);
