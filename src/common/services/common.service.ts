import { Injectable } from "@nestjs/common";
import { JwtPayload } from "../interfaces/jwt.interface";
import { JwtService } from "@nestjs/jwt";

@Injectable()
export class CommonService {
  constructor(private jwtService: JwtService) {}

  async generateAuthToken(user) {
    const payload: JwtPayload = {
      _id: user._id,
      email: user.email,
      role: user.role,
      type: user.type,
    } as never;
    return this.jwtService.sign(payload, {
      secret: process.env.JWT_TOKEN_SECRET,
      expiresIn: process.env.JWT_TONE_EXPIRY_TIME,
    });
  }
}
