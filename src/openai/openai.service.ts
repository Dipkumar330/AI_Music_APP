import { Injectable } from '@nestjs/common';
import OpenAI from 'openai';
import ffmpeg from 'fluent-ffmpeg'; // ✅ Correct function import
import * as fs from 'fs';
import ffmpegPath from 'ffmpeg-static'; // ✅ Direct path string
import { SpeechClient } from '@google-cloud/speech';
import * as ffmpegInstaller from '@ffmpeg-installer/ffmpeg';
import * as ffprobeInstaller from '@ffprobe-installer/ffprobe';
import * as path from 'path';
import { PutObjectCommand, S3Client } from '@aws-sdk/client-s3';
import { v4 as uuid } from 'uuid';
import axios from 'axios';
import * as credentials from '../cred-json/google-credentials.json';
import { statusOk } from 'src/common/constants/respones.status.constant';
import { successResponse } from 'src/common/helpers/responses/success.helper';

const youtubeDl = require('youtube-dl-exec');

// ✅ Set binary paths only once
ffmpeg.setFfmpegPath(ffmpegPath);
ffmpeg.setFfprobePath(ffprobeInstaller.path);

const client = new SpeechClient({
  credentials: {
    client_email: credentials.client_email,
    private_key: credentials.private_key,
  },
  projectId: credentials.project_id,
});

@Injectable()
export class OpenaiService {
  private readonly openai: OpenAI;
  private readonly s3: S3Client;
  private readonly bucketS3: string;

  constructor() {
    this.openai = new OpenAI({
      apiKey: process.env.OPENAI_API_KEY,
    });
    this.s3 = new S3Client({
      region: process.env.S3_REGION,
      endpoint: process.env.S3_ENDPOINT,
      credentials: {
        accessKeyId: process.env.S3_ACCESS_KEY_ID,
        secretAccessKey: process.env.S3_SECRET_ACCESS_KEY,
      },
    });
    this.bucketS3 = process.env.S3_BUCKETS;
  }

  async getCompletion(body, res) {
    // Define the system prompt for NCS music expert
    const systemMessage = `You are a music expert specialized in NoCopyrightSounds (NCS) music.

Your task is to recommend exactly 5 songs from the official NCS catalog.

Only include songs that:
- Are officially released by NCS
- Are publicly available
- Are safe for use in content creation (royalty-free, no copyright claims)

For each song, include the following in this **exact structure** and order:

Song: <Song Title>  
Artist: <Artist Name>  
YouTube: <Full YouTube Link>  
Lyrics: <Full Lyrics Text (or "Instrumental" if no lyrics)>

Only repeat this structure 5 times.  
Do not use bullet points, markdown, or numbering.  
Do not add any explanations or extra text outside of the format.  
`;

    // Define a default prompt if none is provided
    const userPrompt =
      body.prompt?.trim() || 'Suggest 5 popular and safe-to-use NCS songs for background music.';

    const messages: any = [
      { role: 'system', content: systemMessage },
      {
        role: 'user',
        content: 'Suggest 5' + userPrompt + 'and safe-to-use NCS songs and with lyrics',
      },
    ];

    const response = await this.openai.chat.completions.create({
      model: 'gpt-3.5-turbo',
      messages,
    });

    const text = response.choices[0]?.message?.content ?? '';
    const links = this.extractYouTubeLinks(text);
    const songText = this.extractSongDetails(text);
    console.log('links: ', links);

    // Create folder for MP3s
    const outputDir = path.resolve(__dirname, '../../uploads');

    const projectDir = path.resolve(__dirname, '../../');
    console.log('projectDir: ', projectDir);

    const mp3Files: any[] = [];

    for (let i = 0; i < links.length; i++) {
      const { url, song, artist } = songText[i];
      const audioName = `song_${i + 1}_${Date.now()}.mp3`;

      const outputPath = path.join(outputDir, audioName);

      try {
        await this.downloadYouTubeToMp3(url, outputPath, audioName);
        const fileBuffer = fs.readFileSync(`${projectDir}/${audioName}`);

        await this.uploadToS3(fileBuffer, audioName, 'audio/mpeg');

        fs.unlinkSync(`${projectDir}/${audioName}`)

        mp3Files.push({
          mp3: `${process.env.S3_URL_KEY}${audioName}`,
          songName: song,
          artistName: artist,
          youtube: url,
        });

        // ✅ Stop after first successful download
        break;
      } catch (err) {
        console.error(`Failed to download/convert ${url}`, err);
      }
    }

    if (mp3Files.length === 0) {
      return { error: 'No MP3 could be downloaded.', text };
    }

    console.log('mp3Files: ', mp3Files);

    return res.status(statusOk).json(successResponse(statusOk, 'success', mp3Files));
  }

  // Helper: extract YouTube URLs from text
  extractYouTubeLinks(text: string): string[] {
    const regex = /(https?:\/\/www\.youtube\.com\/watch\?v=[\w-]+)/g;
    return text.match(regex) || [];
  }

  extractSongDetails(text: string) {
    const lines = text
      .split('\n')
      .map((line) => line.trim())
      .filter((line) => line.length > 0);
    console.log('lines: ', lines);
    const results = [];

    for (let i = 0; i < lines.length; i += 3) {
      const songMatch = lines[i]?.match(/^Song:\s*(.+)$/i);
      const artistMatch = lines[i + 1]?.match(/^Artist:\s*(.+)$/i);
      const linkMatch = lines[i + 2]?.match(
        /^YouTube:\s*(https:\/\/www\.youtube\.com\/watch\?v=[\w-]+)$/i,
      );

      if (songMatch && artistMatch && linkMatch) {
        results.push({
          song: songMatch[1].trim(),
          artist: artistMatch[1].trim(),
          url: linkMatch[1].trim(),
        });
      }
    }

    return results;
  }

  // Helper: download and convert YouTube video audio to mp3
  async downloadYouTubeToMp3(url: string, outputPath: string, fileName: string): Promise<void> {
    await youtubeDl(url, {
      extractAudio: true,
      audioFormat: 'mp3',
      output: fileName, // just filename, full path won't work reliably
      paths: {
        home: outputPath,
      },
      ffmpegLocation: ffmpegInstaller.path,
      noCheckCertificates: true,
      noWarnings: true,
      preferFreeFormats: true,
      addHeader: ['referer:youtube.com', 'user-agent:googlebot'],
    });
  }

  async mp3ToLrc(url) {
    try {
      const mp3Url = url;

      // Prepare local file paths
      const id = uuid();
      const tempDir = path.resolve(__dirname, '../../uploads');
      if (!fs.existsSync(tempDir)) fs.mkdirSync(tempDir, { recursive: true });

      const mp3Path = path.join(tempDir, ` ${id}.mp3`);
      const wavPath = mp3Path.replace('.mp3', '.wav');
      const lrcPath = mp3Path.replace('.mp3', '.lrc');

      // Step 1: Download MP3 from S3 to local
      const response = await axios.get(mp3Url, { responseType: 'stream' });
      const writer = fs.createWriteStream(mp3Path);

      response.data.pipe(writer);

      writer.on('finish', () => {
        console.log('✅ Download finished successfully');
      });

      writer.on('error', (err) => {
        console.error('❌ Error writing the file:', err);
      });

      // Step 2: Convert MP3 to WAV
      await new Promise((resolve, reject) => {
        ffmpeg(mp3Path)
          .setFfmpegPath(ffmpegPath)
          .output(wavPath)
          .audioCodec('pcm_s16le')
          .audioChannels(1)
          .audioFrequency(16000)
          .on('end', (succ) => {
            console.log('✅ WAV conversion completed.');
            resolve(succ); // ✅ must be called
          })
          .on('error', (err) => {
            console.error('❌ Error during WAV conversion:', err);
            reject(err); // ✅ must be called
          })
          .run();
      });

      // Step 3: Read WAV and send to Google STT
      const audioBytes = fs.readFileSync(wavPath).toString('base64');
      console.log('audioBytes: ', audioBytes);

      const [sttResponse] = await client.recognize({
        audio: { content: audioBytes },
        config: {
          encoding: 'LINEAR16',
          sampleRateHertz: 16000,
          languageCode: 'en-US',
          enableWordTimeOffsets: true,
          enableAutomaticPunctuation: true,
          model: 'default',
          useEnhanced: true,
        },
      });
      console.log('STT response:', JSON.stringify(sttResponse, null, 2));

      // Step 4: Generate LRC lines
      const lrcLines: string[] = [];
      for (const result of sttResponse.results) {
        const alt = result.alternatives[0];
        for (const wordInfo of alt.words) {
          const time = wordInfo.startTime;
          const minutes = String(Math.floor(Number(time.seconds) / 60)).padStart(2, '0');
          const seconds = String(Number(time.seconds) % 60).padStart(2, '0');
          const millis = String(Math.floor(Number(time.nanos) / 1e7)).padStart(2, '0');
          const timestamp = [`${minutes}:${seconds}.${millis}`];
          lrcLines.push(`${timestamp} ${wordInfo.word}`);
        }
      }
      console.log('lrcLines: ', lrcLines);

      // Step 5: Write LRC file
      fs.writeFileSync(lrcPath, lrcLines.join('\n'), 'utf8');
      console.log(`✅ LRC file saved to ${lrcPath}`);

      // Step 6: Upload LRC to S3
      const lrcFileBuffer = fs.readFileSync(lrcPath);
      const lrcFileName = path.basename(lrcPath);

      const uploadParams = {
        Bucket: process.env.S3_BUCKETS,
        Key: `${lrcFileName}`,
        Body: lrcFileBuffer,
        ContentType: 'text/plain',
      };

      await this.s3.send(new PutObjectCommand(uploadParams));
      console.log(`✅ LRC file uploaded to S3 as: lyrics/${lrcFileName}`);

      //  Cleanup
      fs.unlinkSync(lrcPath);
      fs.unlinkSync(mp3Path);
      fs.unlinkSync(wavPath);

      return lrcFileName;
    } catch (error) {
      console.error('❌ Error generating LRC:', error);
    }
  }

  async uploadToS3(fileContent: Buffer, fileName: string, contentType: string) {
    const params = {
      Bucket: this.bucketS3,
      Key: String(fileName),
      Body: fileContent,
      ContentType: contentType, // Set the content type
      // ACL: "public-read",
      // "Cache-Control": "public, max-age=31557600",
    };
    const command = new PutObjectCommand(params);

    try {
      await this.s3.send(command);
      console.log(`✅ Uploaded to S3: ${fileName}`);
    } catch (err) {
      console.error('❌ S3 upload error:', err);
      throw new Error('S3 upload failed');
    }
  }
}
