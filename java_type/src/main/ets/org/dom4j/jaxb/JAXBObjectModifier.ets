export default  interface JAXBObjectModifier {
  modifyObject(element: Element): Promise<Element>;
}