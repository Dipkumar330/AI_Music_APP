import { Prop, Schema, SchemaFactory } from "@nestjs/mongoose";
import { Document } from "mongoose";
import { TABLE_NAMES } from "../../common/constants/table-name.constant";

export type UsersDocument = Users & Document;

@Schema({ collection: TABLE_NAMES.USER, timestamps: true })
export class Users {
  @Prop({ required: true })
  name: string;

  @Prop({ required: true })
  phoneNumber: string;

  @Prop({ required: true })
  countryCode: string;

  @Prop({ required: true })
  birthDate: Date;

  @Prop({ required: true, unique: true, index: true })
  email: string;

  @Prop({ required: true })
  password: string;

  @Prop({ required: true, default: false })
  isActive: boolean;
}

export const UsersSchema = SchemaFactory.createForClass(Users);
