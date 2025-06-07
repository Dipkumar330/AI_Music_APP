import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document } from 'mongoose';
import { TABLE_NAMES } from '../../common/constants/table-name.constant';

export type ArtistDocument = Artist & Document;

@Schema({ collection: TABLE_NAMES.ARTIST, timestamps: true })
export class Artist {
  @Prop({ required: true })
  name: string;

  @Prop({ required: true })
  image: string;

  @Prop({ required: true })
  details: string;

  @Prop({ required: true })
  born: string;

  @Prop({ required: true })
  link: string;
}

export const ArtistSchema = SchemaFactory.createForClass(Artist);
