import { Injectable } from "@nestjs/common";
import * as dotenv from 'dotenv';
dotenv.config();

import twilio from 'twilio';
const client = twilio(process.env.ACCOUNT_SID, process.env.AUTH_TOKEN);

@Injectable()
export class TwilioService {
    async sendOtp(number) {
        console.log('process.env.VERIFY_SERVICE_SID: ', process.env.VERIFY_SERVICE_SID);
        console.log('number: ', number);
    await client.verify.v2
      .services(process.env.VERIFY_SERVICE_SID)
      .verifications.create({ to: number, channel: 'sms' })
      .then((verification) => {
        console.log('verification: ', verification);
        return verification;
      })
      .catch((error) => {
        console.log('send otp error line no 21 common.service.ts:--> ', error);
        // throw error;
      });
  }

  /**
   * Verify Otp common function
   * @param {number}
   * @param {otp}
   */
async verifyOtp(number: string, otp: string): Promise<boolean> {
  try {
    const check = await client.verify.v2
      .services(process.env.VERIFY_SERVICE_SID!)
      .verificationChecks.create({ to: number, code: otp });

    return check.status === 'approved';
  } catch (err) {
    console.error('verifyOtp error:', err);
    return false;
  }
}
}