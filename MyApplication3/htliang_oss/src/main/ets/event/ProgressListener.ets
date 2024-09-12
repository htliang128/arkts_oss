import ProgressEvent from './ProgressEvent';

export default interface ProgressListener {
  progressChanged(progressEvent: ProgressEvent): void;
}

class ProgressListenerIns implements ProgressListener {
  progressChanged(progressEvent: ProgressEvent): void {
    // Do nothing
  }
}

export const NOOP: ProgressListener = new ProgressListenerIns();