export default class Mimetypes {
  // The default MIME type
  public static readonly DEFAULT_MIMETYPE = "application/octet-stream";
  private static instance: Mimetypes | null = null;
  private extensionToMimetypeMap: Map<string, string>;

  private constructor(extensionToMimetypeMap: Map<string, string>) {
    this.extensionToMimetypeMap = extensionToMimetypeMap
  }

  public static getInstance(): Mimetypes {
    if (Mimetypes.instance) {
      return Mimetypes.instance;
    }

    Mimetypes.instance = new Mimetypes(Mimetypes.initMimeTypeMap());

    return Mimetypes.instance;
  }

  private static initMimeTypeMap(): Map<string, string> {
    let mimetypeMap: Map<string, string> = new Map<string, string>();
    mimetypeMap.set("xlsx", "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
    mimetypeMap.set("xltx", "application/vnd.openxmlformats-officedocument.spreadsheetml.template");
    mimetypeMap.set("potx", "application/vnd.openxmlformats-officedocument.presentationml.template");
    mimetypeMap.set("ppsx", "application/vnd.openxmlformats-officedocument.presentationml.slideshow");
    mimetypeMap.set("pptx", "application/vnd.openxmlformats-officedocument.presentationml.presentation");
    mimetypeMap.set("sldx", "application/vnd.openxmlformats-officedocument.presentationml.slide");
    mimetypeMap.set("docx", "application/vnd.openxmlformats-officedocument.wordprocessingml.document");
    mimetypeMap.set("dotx", "application/vnd.openxmlformats-officedocument.wordprocessingml.template");
    mimetypeMap.set("xlam", "application/vnd.ms-excel.addin.macroEnabled.12");
    mimetypeMap.set("xlsb", "application/vnd.ms-excel.sheet.binary.macroEnabled.12");
    mimetypeMap.set("apk", "application/vnd.android.package-archive");
    mimetypeMap.set("hqx", "application/mac-binhex40");
    mimetypeMap.set("cpt", "application/mac-compactpro");
    mimetypeMap.set("doc", "application/msword");
    mimetypeMap.set("ogg", "application/ogg");
    mimetypeMap.set("pdf", "application/pdf");
    mimetypeMap.set("rtf", "text/rtf");
    mimetypeMap.set("mif", "application/vnd.mif");
    mimetypeMap.set("xls", "application/vnd.ms-excel");
    mimetypeMap.set("ppt", "application/vnd.ms-powerpoint");
    mimetypeMap.set("odc", "application/vnd.oasis.opendocument.chart");
    mimetypeMap.set("odb", "application/vnd.oasis.opendocument.database");
    mimetypeMap.set("odf", "application/vnd.oasis.opendocument.formula");
    mimetypeMap.set("odg", "application/vnd.oasis.opendocument.graphics");
    mimetypeMap.set("otg", "application/vnd.oasis.opendocument.graphics-template");
    mimetypeMap.set("odi", "application/vnd.oasis.opendocument.image");
    mimetypeMap.set("odp", "application/vnd.oasis.opendocument.presentation");
    mimetypeMap.set("otp", "application/vnd.oasis.opendocument.presentation-template");
    mimetypeMap.set("ods", "application/vnd.oasis.opendocument.spreadsheet");
    mimetypeMap.set("ots", "application/vnd.oasis.opendocument.spreadsheet-template");
    mimetypeMap.set("odt", "application/vnd.oasis.opendocument.text");
    mimetypeMap.set("odm", "application/vnd.oasis.opendocument.text-master");
    mimetypeMap.set("ott", "application/vnd.oasis.opendocument.text-template");
    mimetypeMap.set("oth", "application/vnd.oasis.opendocument.text-web");
    mimetypeMap.set("sxw", "application/vnd.sun.xml.writer");
    mimetypeMap.set("stw", "application/vnd.sun.xml.writer.template");
    mimetypeMap.set("sxc", "application/vnd.sun.xml.calc");
    mimetypeMap.set("stc", "application/vnd.sun.xml.calc.template");
    mimetypeMap.set("sxd", "application/vnd.sun.xml.draw");
    mimetypeMap.set("std", "application/vnd.sun.xml.draw.template");
    mimetypeMap.set("sxi", "application/vnd.sun.xml.impress");
    mimetypeMap.set("sti", "application/vnd.sun.xml.impress.template");
    mimetypeMap.set("sxg", "application/vnd.sun.xml.writer.global");
    mimetypeMap.set("sxm", "application/vnd.sun.xml.math");
    mimetypeMap.set("sis", "application/vnd.symbian.install");
    mimetypeMap.set("wbxml", "application/vnd.wap.wbxml");
    mimetypeMap.set("wmlc", "application/vnd.wap.wmlc");
    mimetypeMap.set("wmlsc", "application/vnd.wap.wmlscriptc");
    mimetypeMap.set("bcpio", "application/x-bcpio");
    mimetypeMap.set("torrent", "application/x-bittorrent");
    mimetypeMap.set("bz2", "application/x-bzip2");
    mimetypeMap.set("vcd", "application/x-cdlink");
    mimetypeMap.set("pgn", "application/x-chess-pgn");
    mimetypeMap.set("cpio", "application/x-cpio");
    mimetypeMap.set("csh", "application/x-csh");
    mimetypeMap.set("dvi", "application/x-dvi");
    mimetypeMap.set("spl", "application/x-futuresplash");
    mimetypeMap.set("gtar", "application/x-gtar");
    mimetypeMap.set("hdf", "application/x-hdf");
    mimetypeMap.set("jar", "application/x-java-archive");
    mimetypeMap.set("jnlp", "application/x-java-jnlp-file");
    mimetypeMap.set("js", "application/x-javascript");
    mimetypeMap.set("ksp", "application/x-kspread");
    mimetypeMap.set("chrt", "application/x-kchart");
    mimetypeMap.set("kil", "application/x-killustrator");
    mimetypeMap.set("latex", "application/x-latex");
    mimetypeMap.set("rpm", "application/x-rpm");
    mimetypeMap.set("sh", "application/x-sh");
    mimetypeMap.set("shar", "application/x-shar");
    mimetypeMap.set("swf", "application/x-shockwave-flash");
    mimetypeMap.set("sit", "application/x-stuffit");
    mimetypeMap.set("sv4cpio", "application/x-sv4cpio");
    mimetypeMap.set("sv4crc", "application/x-sv4crc");
    mimetypeMap.set("tar", "application/x-tar");
    mimetypeMap.set("tcl", "application/x-tcl");
    mimetypeMap.set("tex", "application/x-tex");
    mimetypeMap.set("man", "application/x-troff-man");
    mimetypeMap.set("me", "application/x-troff-me");
    mimetypeMap.set("ms", "application/x-troff-ms");
    mimetypeMap.set("ustar", "application/x-ustar");
    mimetypeMap.set("src", "application/x-wais-source");
    mimetypeMap.set("zip", "application/zip");
    mimetypeMap.set("m3u", "audio/x-mpegurl");
    mimetypeMap.set("ra", "audio/x-pn-realaudio");
    mimetypeMap.set("wav", "audio/x-wav");
    mimetypeMap.set("wma", "audio/x-ms-wma");
    mimetypeMap.set("wax", "audio/x-ms-wax");
    mimetypeMap.set("pdb", "chemical/x-pdb");
    mimetypeMap.set("xyz", "chemical/x-xyz");
    mimetypeMap.set("bmp", "image/bmp");
    mimetypeMap.set("gif", "image/gif");
    mimetypeMap.set("ief", "image/ief");
    mimetypeMap.set("png", "image/png");
    mimetypeMap.set("wbmp", "image/vnd.wap.wbmp");
    mimetypeMap.set("ras", "image/x-cmu-raster");
    mimetypeMap.set("pnm", "image/x-portable-anymap");
    mimetypeMap.set("pbm", "image/x-portable-bitmap");
    mimetypeMap.set("pgm", "image/x-portable-graymap");
    mimetypeMap.set("ppm", "image/x-portable-pixmap");
    mimetypeMap.set("rgb", "image/x-rgb");
    mimetypeMap.set("xbm", "image/x-xbitmap");
    mimetypeMap.set("xpm", "image/x-xpixmap");
    mimetypeMap.set("xwd", "image/x-xwindowdump");
    mimetypeMap.set("css", "text/css");
    mimetypeMap.set("rtx", "text/richtext");
    mimetypeMap.set("tsv", "text/tab-separated-values");
    mimetypeMap.set("jad", "text/vnd.sun.j2me.app-descriptor");
    mimetypeMap.set("wml", "text/vnd.wap.wml");
    mimetypeMap.set("wmls", "text/vnd.wap.wmlscript");
    mimetypeMap.set("etx", "text/x-setext");
    mimetypeMap.set("mxu", "video/vnd.mpegurl");
    mimetypeMap.set("flv", "video/x-flv");
    mimetypeMap.set("wm", "video/x-ms-wm");
    mimetypeMap.set("wmv", "video/x-ms-wmv");
    mimetypeMap.set("wmx", "video/x-ms-wmx");
    mimetypeMap.set("wvx", "video/x-ms-wvx");
    mimetypeMap.set("avi", "video/x-msvideo");
    mimetypeMap.set("movie", "video/x-sgi-movie");
    mimetypeMap.set("ice", "x-conference/x-cooltalk");
    mimetypeMap.set("3gp", "video/3gpp");
    mimetypeMap.set("ai", "application/postscript");
    mimetypeMap.set("aif", "audio/x-aiff");
    mimetypeMap.set("aifc", "audio/x-aiff");
    mimetypeMap.set("aiff", "audio/x-aiff");
    mimetypeMap.set("asc", "text/plain");
    mimetypeMap.set("atom", "application/atom+xml");
    mimetypeMap.set("au", "audio/basic");
    mimetypeMap.set("bin", "application/octet-stream");
    mimetypeMap.set("cdf", "application/x-netcdf");
    mimetypeMap.set("cgm", "image/cgm");
    mimetypeMap.set("class", "application/octet-stream");
    mimetypeMap.set("dcr", "application/x-director");
    mimetypeMap.set("dif", "video/x-dv");
    mimetypeMap.set("dir", "application/x-director");
    mimetypeMap.set("djv", "image/vnd.djvu");
    mimetypeMap.set("djvu", "image/vnd.djvu");
    mimetypeMap.set("dll", "application/octet-stream");
    mimetypeMap.set("dmg", "application/octet-stream");
    mimetypeMap.set("dms", "application/octet-stream");
    mimetypeMap.set("dtd", "application/xml-dtd");
    mimetypeMap.set("dv", "video/x-dv");
    mimetypeMap.set("dxr", "application/x-director");
    mimetypeMap.set("eps", "application/postscript");
    mimetypeMap.set("exe", "application/octet-stream");
    mimetypeMap.set("ez", "application/andrew-inset");
    mimetypeMap.set("gram", "application/srgs");
    mimetypeMap.set("grxml", "application/srgs+xml");
    mimetypeMap.set("gz", "application/x-gzip");
    mimetypeMap.set("tgz", "application/x-gzip");
    mimetypeMap.set("htm", "text/html");
    mimetypeMap.set("html", "text/html");
    mimetypeMap.set("ico", "image/x-icon");
    mimetypeMap.set("ics", "text/calendar");
    mimetypeMap.set("ifb", "text/calendar");
    mimetypeMap.set("iges", "model/iges");
    mimetypeMap.set("igs", "model/iges");
    mimetypeMap.set("jp2", "image/jp2");
    mimetypeMap.set("jpe", "image/jpeg");
    mimetypeMap.set("jpeg", "image/jpeg");
    mimetypeMap.set("jpg", "image/jpeg");
    mimetypeMap.set("kar", "audio/midi");
    mimetypeMap.set("lha", "application/octet-stream");
    mimetypeMap.set("lzh", "application/octet-stream");
    mimetypeMap.set("m4a", "audio/mp4a-latm");
    mimetypeMap.set("m4p", "audio/mp4a-latm");
    mimetypeMap.set("m4u", "video/vnd.mpegurl");
    mimetypeMap.set("m4v", "video/x-m4v");
    mimetypeMap.set("mac", "image/x-macpaint");
    mimetypeMap.set("mathml", "application/mathml+xml");
    mimetypeMap.set("mesh", "model/mesh");
    mimetypeMap.set("mid", "audio/midi");
    mimetypeMap.set("midi", "audio/midi");
    mimetypeMap.set("mov", "video/quicktime");
    mimetypeMap.set("mp2", "audio/mpeg");
    mimetypeMap.set("mp3", "audio/mpeg");
    mimetypeMap.set("mp4", "video/mp4");
    mimetypeMap.set("mpe", "video/mpeg");
    mimetypeMap.set("mpeg", "video/mpeg");
    mimetypeMap.set("mpg", "video/mpeg");
    mimetypeMap.set("mpga", "audio/mpeg");
    mimetypeMap.set("msh", "model/mesh");
    mimetypeMap.set("nc", "application/x-netcdf");
    mimetypeMap.set("oda", "application/oda");
    mimetypeMap.set("ogv", "video/ogv");
    mimetypeMap.set("pct", "image/pict");
    mimetypeMap.set("pic", "image/pict");
    mimetypeMap.set("pict", "image/pict");
    mimetypeMap.set("pnt", "image/x-macpaint");
    mimetypeMap.set("pntg", "image/x-macpaint");
    mimetypeMap.set("ps", "application/postscript");
    mimetypeMap.set("qt", "video/quicktime");
    mimetypeMap.set("qti", "image/x-quicktime");
    mimetypeMap.set("qtif", "image/x-quicktime");
    mimetypeMap.set("ram", "audio/x-pn-realaudio");
    mimetypeMap.set("rdf", "application/rdf+xml");
    mimetypeMap.set("rm", "application/vnd.rn-realmedia");
    mimetypeMap.set("roff", "application/x-troff");
    mimetypeMap.set("sgm", "text/sgml");
    mimetypeMap.set("sgml", "text/sgml");
    mimetypeMap.set("silo", "model/mesh");
    mimetypeMap.set("skd", "application/x-koan");
    mimetypeMap.set("skm", "application/x-koan");
    mimetypeMap.set("skp", "application/x-koan");
    mimetypeMap.set("skt", "application/x-koan");
    mimetypeMap.set("smi", "application/smil");
    mimetypeMap.set("smil", "application/smil");
    mimetypeMap.set("snd", "audio/basic");
    mimetypeMap.set("so", "application/octet-stream");
    mimetypeMap.set("svg", "image/svg+xml");
    mimetypeMap.set("t", "application/x-troff");
    mimetypeMap.set("texi", "application/x-texinfo");
    mimetypeMap.set("texinfo", "application/x-texinfo");
    mimetypeMap.set("tif", "image/tiff");
    mimetypeMap.set("tiff", "image/tiff");
    mimetypeMap.set("tr", "application/x-troff");
    mimetypeMap.set("txt", "text/plain");
    mimetypeMap.set("vrml", "model/vrml");
    mimetypeMap.set("vxml", "application/voicexml+xml");
    mimetypeMap.set("webm", "video/webm");
    mimetypeMap.set("wrl", "model/vrml");
    mimetypeMap.set("xht", "application/xhtml+xml");
    mimetypeMap.set("xhtml", "application/xhtml+xml");
    mimetypeMap.set("xml", "application/xml");
    mimetypeMap.set("xsl", "application/xml");
    mimetypeMap.set("xslt", "application/xslt+xml");
    mimetypeMap.set("xul", "application/vnd.mozilla.xul+xml");
    mimetypeMap.set("webp", "image/webp");
    mimetypeMap.set("csv", "text/csv");
    mimetypeMap.set("json", "application/json");

    return mimetypeMap;
  }

  public getMimetype(fileName: string, secondaryObject?: string): string {
    let mimeType = this.getMimetypeByExt(fileName);
    if (mimeType) {
      return mimeType;
    }

    if (secondaryObject) {
      mimeType = this.getMimetypeByExt(secondaryObject);
    }

    return mimeType ?? Mimetypes.DEFAULT_MIMETYPE;
  }

  private getMimetypeByExt(fileName: string): string | null {
    const lastPeriodIndex = fileName.lastIndexOf(".");
    if (lastPeriodIndex > 0 && lastPeriodIndex + 1 < fileName.length) {
      const ext = fileName.substring(lastPeriodIndex + 1).toLowerCase();
      return this.extensionToMimetypeMap.get(ext) || null;
    }
    return null;
  }
}
