import fs from '@ohos.file.fs';
import CallbackInfo from './CallbackInfo';
import GenericRequest from './GenericRequest';
import ObjectMetadata from './ObjectMetadata';

export default class PutObjectRequest extends GenericRequest{
  file?: fs.File;
  inputStream?: fs.ReadStream;
  metadata?: ObjectMetadata;
  callback?: CallbackInfo;
  process?: string;
  trafficLimit?: number;

  constructor(bucketName: string, key: string, file: fs.File | undefined, inputStream: fs.ReadStream|undefined,
    metadata?: ObjectMetadata) {
    super(bucketName, key);
    this.file = file;
    this.inputStream = inputStream;
    this.metadata = this.metadata;
  }

  getFile(): fs.File | undefined {
    return this.file;
  }

  setFile(file: fs.File): void {
    this.file = file;
  }

  getInputStream(): fs.ReadStream | undefined {
    return this.inputStream;
  }

  setInputStream(inputStream: fs.ReadStream): void {
    this.inputStream = inputStream;
  }

  getMetadata(): ObjectMetadata | undefined {
    return this.metadata;
  }

  setMetadata(metadata: ObjectMetadata): void {
    this.metadata = metadata;
  }

  getCallback(): CallbackInfo | undefined {
    return this.callback;
  }

  setCallback(callback: CallbackInfo): void {
    this.callback = callback;
  }

  getProcess(): string | undefined {
    return this.process;
  }

  setProcess(process: string): void {
    this.process = process;
  }

  setTrafficLimit(trafficLimit: number): void {
    this.trafficLimit = trafficLimit;
  }

  getTrafficLimit(): number | undefined {
    return this.trafficLimit;
  }
}