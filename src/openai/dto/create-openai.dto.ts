import { ApiProperty } from "@nestjs/swagger";
import { IsNotEmpty, IsString } from "class-validator";

export class CreateOpenaiDto {
    @ApiProperty()
    @IsString()
    @IsNotEmpty()
    prompt: string;
}
