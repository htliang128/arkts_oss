import Serializable from "../../java/io/Serializable";
import DocumentFactory from "./DocumentFactory";
import Namespace from "./Namespace";
import QNameCache from "./tree/QNameCache";

export default class QName implements Serializable {
  private static singleton = new QNameCache();
  private static RE_NAME =
    new RegExp("[_A-Za-z\u00C0-\u00D6\u00D8-\u00F6\u00F8-\u02FF\u0370-\u037D\u037F-\u1FFF\u200C-\u200D\u2070-\u218F\u2C00-\u2FEF\u3001-\uD7FF\uF900-\uFDCF\uFDF0-\uFFFD][-._A-Za-z\u00C0-\u00D6\u00D8-\u00F6\u00F8-\u02FF\u0370-\u037D\u037F-\u1FFF\u200C-\u200D\u2070-\u218F\u2C00-\u2FEF\u3001-\uD7FF\uF900-\uFDCF\uFDF0-\uFFFD0-9\u00B7\u0300-\u036F\u203F-\u2040]*");
  private static RE_NCNAME =
    new RegExp("[_A-Za-z\u00C0-\u00D6\u00D8-\u00F6\u00F8-\u02FF\u0370-\u037D\u037F-\u1FFF\u200C-\u200D\u2070-\u218F\u2C00-\u2FEF\u3001-\uD7FF\uF900-\uFDCF\uFDF0-\uFFFD][-._A-Za-z\u00C0-\u00D6\u00D8-\u00F6\u00F8-\u02FF\u0370-\u037D\u037F-\u1FFF\u200C-\u200D\u2070-\u218F\u2C00-\u2FEF\u3001-\uD7FF\uF900-\uFDCF\uFDF0-\uFFFD0-9\u00B7\u0300-\u036F\u203F-\u2040]*");
  private static RE_QNAME = new RegExp("(?:" + QName.RE_NCNAME.source + ":)?" + QName.RE_NCNAME.source);
  private name: string;
  private qualifiedName?: string;
  private namespace: Namespace;
  private hashCodeNum: number = 0;
  private documentFactory?: DocumentFactory;

  constructor(name: string, namespace: Namespace = Namespace.NO_NAMESPACE, qualifiedName?: string) {
    this.name = name || "";
    this.namespace = namespace || Namespace.NO_NAMESPACE;
    this.qualifiedName = qualifiedName;

    if (this.namespace === Namespace.NO_NAMESPACE) {
      QName.validateName(this.name);
    } else {
      QName.validateNCName(this.name);
    }

    if (this.qualifiedName) {
      QName.validateQName(this.qualifiedName);
    }
  }

  static get(name: string, namespace?: Namespace, qualifiedName?: string): QName {
    return QName.singleton.get(name, namespace, qualifiedName);
  }

  getName() {
    return this.name;
  }

  getQualifiedName() {
    if (!this.qualifiedName) {
      let prefix = this.getNamespacePrefix();

      if (prefix && prefix.length > 0) {
        this.qualifiedName = prefix + ":" + this.name;
      } else {
        this.qualifiedName = this.name;
      }
    }

    return this.qualifiedName;
  }

  getNamespace() {
    return this.namespace;
  }

  getNamespacePrefix() {
    return this.namespace ? this.namespace.getPrefix() : "";
  }

  getNamespaceURI() {
    return this.namespace ? this.namespace.getURI() : "";
  }

  hashCode() {
    if (this.hashCodeNum === 0) {
      this.hashCodeNum = this.getName().hashCode() ^ this.getNamespaceURI().hashCode();

      if (this.hashCodeNum === 0) {
        this.hashCodeNum = 0xbabe;
      }
    }

    return this.hashCodeNum;
  }

  equals(object: ESObject) {
    if (this === object) {
      return true;
    } else if (object instanceof QName) {
      let that = object as QName;

      // we cache hash codes so this should be quick
      if (this.hashCode() === that.hashCode()) {
        return this.getName() === that.getName() && this.getNamespaceURI() === that.getNamespaceURI();
      }
    }

    return false;
  }

  toString() {
    return super.toString() + " [name: " + this.getName() + " namespace: \"" + this.getNamespace() + "\"]";
  }

  getDocumentFactory() {
    return this.documentFactory;
  }

  setDocumentFactory(documentFactory: DocumentFactory) {
    this.documentFactory = documentFactory;
  }

  protected static validateName(name: string) {
    if (!QName.RE_NAME.test(name)) {
      throw new Error(`Illegal character in name: '${name}'.`);
    }
  }

  public static validateNCName(ncname: string) {
    if (!QName.RE_NCNAME.test(ncname)) {
      throw new Error(`Illegal character in local name: '${ncname}'.`);
    }
  }

  protected static validateQName(qname: string) {
    if (!QName.RE_QNAME.test(qname)) {
      throw new Error(`Illegal character in qualified name: '${qname}'.`);
    }
  }
}