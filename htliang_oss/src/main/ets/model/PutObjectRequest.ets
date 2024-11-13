import InputStream from '@htliang/java_type/src/main/ets/java/io/InputStream';
import fs from '@ohos.file.fs';
import CallbackInfo from './CallbackInfo';
import GenericRequest from './GenericRequest';
import ObjectMetadata from './ObjectMetadata';

export default class PutObjectRequest extends GenericRequest {
  file?: fs.File;
  inputStream?: InputStream;
  metadata?: ObjectMetadata;
  callback?: CallbackInfo;
  process?: string;
  trafficLimit?: number;

  constructor(bucketName: string, key: string, file: fs.File);

  constructor(bucketName: string, key: string, file: fs.File, metadata: ObjectMetadata);

  constructor(bucketName: string, key: string, input: InputStream);

  constructor(bucketName: string, key: string, input: InputStream, metadata: ObjectMetadata);

  constructor(bucketName: string, key: string, input: fs.File | InputStream, metadata?: ObjectMetadata) {
    super(bucketName, key);
    this.metadata = metadata;
    if (input instanceof InputStream) {
      this.inputStream = input;
    } else {
      this.file = input;
    }
  }

  getFile(): fs.File | undefined {
    return this.file;
  }

  setFile(file: fs.File): void {
    this.file = file;
  }

  getInputStream(): InputStream | undefined {
    return this.inputStream;
  }

  setInputStream(inputStream: InputStream): void {
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