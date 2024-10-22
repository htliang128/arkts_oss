import ClientConfiguration from './ClientConfiguration';

export default class ClientBuilderConfiguration extends ClientConfiguration {
  constructor() {
    super();
    this.supportCname = false;
  }
}