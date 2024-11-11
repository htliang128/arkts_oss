import AutoCloseable from "../lang/AutoCloseable";

export default interface Closeable extends AutoCloseable {
  close(): void;
}