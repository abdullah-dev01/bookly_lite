class BookVolumesResult {
  final String kind;
  final int totalItems;
  final List<BookVolume> items;

  BookVolumesResult({
    required this.kind,
    required this.totalItems,
    required this.items,
  });

  factory BookVolumesResult.fromJson(Map<String, dynamic> json) {
    return BookVolumesResult(
      kind: json['kind'] as String,
      totalItems: json['totalItems'] as int,
      items: (json['items'] as List<dynamic>?)
              ?.map((item) => BookVolume.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class BookVolume {
  final String kind;
  final String id;
  final String etag;
  final String selfLink;
  final VolumeInfo volumeInfo;
  final SaleInfo? saleInfo;
  final AccessInfo? accessInfo;
  final SearchInfo? searchInfo;

  BookVolume({
    required this.kind,
    required this.id,
    required this.etag,
    required this.selfLink,
    required this.volumeInfo,
    this.saleInfo,
    this.accessInfo,
    this.searchInfo,
  });

  factory BookVolume.fromJson(Map<String, dynamic> json) {
    return BookVolume(
      kind: json['kind'] as String,
      id: json['id'] as String,
      etag: json['etag'] as String,
      selfLink: json['selfLink'] as String,
      volumeInfo: VolumeInfo.fromJson(json['volumeInfo'] as Map<String, dynamic>),
      saleInfo:
          json['saleInfo'] != null ? SaleInfo.fromJson(json['saleInfo'] as Map<String, dynamic>) : null,
      accessInfo:
          json['accessInfo'] != null ? AccessInfo.fromJson(json['accessInfo'] as Map<String, dynamic>) : null,
      searchInfo:
          json['searchInfo'] != null ? SearchInfo.fromJson(json['searchInfo'] as Map<String, dynamic>) : null,
    );
  }
}

class VolumeInfo {
  final String title;
  final String? subtitle;
  final List<String>? authors;
  final String? publisher;
  final String? publishedDate;
  final String? description;
  final List<IndustryIdentifier>? industryIdentifiers;
  final ReadingModes? readingModes;
  final int? pageCount;
  final String? printType;
  final List<String>? categories;
  final String? maturityRating;
  final bool? allowAnonLogging;
  final String? contentVersion;
  final PanelizationSummary? panelizationSummary;
  final ImageLinks? imageLinks;
  final String? language;
  final String? previewLink;
  final String? infoLink;
  final String? canonicalVolumeLink;

  VolumeInfo({
    required this.title,
    this.subtitle,
    this.authors,
    this.publisher,
    this.publishedDate,
    this.description,
    this.industryIdentifiers,
    this.readingModes,
    this.pageCount,
    this.printType,
    this.categories,
    this.maturityRating,
    this.allowAnonLogging,
    this.contentVersion,
    this.panelizationSummary,
    this.imageLinks,
    this.language,
    this.previewLink,
    this.infoLink,
    this.canonicalVolumeLink,
  });

  factory VolumeInfo.fromJson(Map<String, dynamic> json) {
    return VolumeInfo(
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String?,
      authors: (json['authors'] as List?)?.map((e) => e as String).toList(),
      publisher: json['publisher'] as String?,
      publishedDate: json['publishedDate'] as String?,
      description: json['description'] as String?,
      industryIdentifiers: (json['industryIdentifiers'] as List?)
          ?.map((e) => IndustryIdentifier.fromJson(e as Map<String, dynamic>))
          .toList(),
      readingModes: json['readingModes'] != null
          ? ReadingModes.fromJson(json['readingModes'] as Map<String, dynamic>)
          : null,
      pageCount: json['pageCount'] as int?,
      printType: json['printType'] as String?,
      categories: (json['categories'] as List?)?.map((e) => e as String).toList(),
      maturityRating: json['maturityRating'] as String?,
      allowAnonLogging: json['allowAnonLogging'] as bool?,
      contentVersion: json['contentVersion'] as String?,
      panelizationSummary: json['panelizationSummary'] != null
          ? PanelizationSummary.fromJson(json['panelizationSummary'] as Map<String, dynamic>)
          : null,
      imageLinks: json['imageLinks'] != null
          ? ImageLinks.fromJson(json['imageLinks'] as Map<String, dynamic>)
          : null,
      language: json['language'] as String?,
      previewLink: json['previewLink'] as String?,
      infoLink: json['infoLink'] as String?,
      canonicalVolumeLink: json['canonicalVolumeLink'] as String?,
    );
  }
}

class IndustryIdentifier {
  final String type;
  final String identifier;

  IndustryIdentifier({
    required this.type,
    required this.identifier,
  });

  factory IndustryIdentifier.fromJson(Map<String, dynamic> json) {
    return IndustryIdentifier(
      type: json['type'] as String,
      identifier: json['identifier'] as String,
    );
  }
}

class ReadingModes {
  final bool text;
  final bool image;

  ReadingModes({
    required this.text,
    required this.image,
  });

  factory ReadingModes.fromJson(Map<String, dynamic> json) {
    return ReadingModes(
      text: json['text'] as bool? ?? false,
      image: json['image'] as bool? ?? false,
    );
  }
}

class PanelizationSummary {
  final bool? containsEpubBubbles;
  final bool? containsImageBubbles;

  PanelizationSummary({
    this.containsEpubBubbles,
    this.containsImageBubbles,
  });

  factory PanelizationSummary.fromJson(Map<String, dynamic> json) {
    return PanelizationSummary(
      containsEpubBubbles: json['containsEpubBubbles'] as bool?,
      containsImageBubbles: json['containsImageBubbles'] as bool?,
    );
  }
}

class ImageLinks {
  final String? smallThumbnail;
  final String? thumbnail;

  ImageLinks({
    this.smallThumbnail,
    this.thumbnail,
  });

  factory ImageLinks.fromJson(Map<String, dynamic> json) {
    return ImageLinks(
      smallThumbnail: json['smallThumbnail'] as String?,
      thumbnail: json['thumbnail'] as String?,
    );
  }
}

class SaleInfo {
  final String country;
  final String saleability;
  final bool isEbook;
  final Price? listPrice;
  final Price? retailPrice;
  final String? buyLink;
  final List<Offer>? offers;

  SaleInfo({
    required this.country,
    required this.saleability,
    required this.isEbook,
    this.listPrice,
    this.retailPrice,
    this.buyLink,
    this.offers,
  });

  factory SaleInfo.fromJson(Map<String, dynamic> json) {
    return SaleInfo(
      country: json['country'] as String,
      saleability: json['saleability'] as String,
      isEbook: json['isEbook'] as bool? ?? false,
      listPrice: json['listPrice'] != null
          ? Price.fromJson(json['listPrice'] as Map<String, dynamic>)
          : null,
      retailPrice: json['retailPrice'] != null
          ? Price.fromJson(json['retailPrice'] as Map<String, dynamic>)
          : null,
      buyLink: json['buyLink'] as String?,
      offers: (json['offers'] as List?)
          ?.map((e) => Offer.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class Price {
  final double? amount;
  final String? currencyCode;
  final int? amountInMicros;

  Price({
    this.amount,
    this.currencyCode,
    this.amountInMicros,
  });

  factory Price.fromJson(Map<String, dynamic> json) {
    return Price(
      amount: (json['amount'] is int)
          ? (json['amount'] as int).toDouble()
          : (json['amount'] as num?)?.toDouble(),
      currencyCode: json['currencyCode'] as String?,
      amountInMicros: json['amountInMicros'] as int?,
    );
  }
}

class Offer {
  final int? finskyOfferType;
  final Price? listPrice;
  final Price? retailPrice;
  final bool? giftable;

  Offer({
    this.finskyOfferType,
    this.listPrice,
    this.retailPrice,
    this.giftable,
  });

  factory Offer.fromJson(Map<String, dynamic> json) {
    return Offer(
      finskyOfferType: json['finskyOfferType'] as int?,
      listPrice: json['listPrice'] != null
          ? Price.fromJson(json['listPrice'] as Map<String, dynamic>)
          : null,
      retailPrice: json['retailPrice'] != null
          ? Price.fromJson(json['retailPrice'] as Map<String, dynamic>)
          : null,
      giftable: json['giftable'] as bool?,
    );
  }
}

class AccessInfo {
  final String country;
  final String viewability;
  final bool embeddable;
  final bool publicDomain;
  final String textToSpeechPermission;
  final Epub? epub;
  final Pdf? pdf;
  final String? webReaderLink;
  final String? accessViewStatus;
  final bool? quoteSharingAllowed;

  AccessInfo({
    required this.country,
    required this.viewability,
    required this.embeddable,
    required this.publicDomain,
    required this.textToSpeechPermission,
    this.epub,
    this.pdf,
    this.webReaderLink,
    this.accessViewStatus,
    this.quoteSharingAllowed,
  });

  factory AccessInfo.fromJson(Map<String, dynamic> json) {
    return AccessInfo(
      country: json['country'] as String,
      viewability: json['viewability'] as String,
      embeddable: json['embeddable'] as bool? ?? false,
      publicDomain: json['publicDomain'] as bool? ?? false,
      textToSpeechPermission: json['textToSpeechPermission'] as String? ?? '',
      epub: json['epub'] != null ? Epub.fromJson(json['epub'] as Map<String, dynamic>) : null,
      pdf: json['pdf'] != null ? Pdf.fromJson(json['pdf'] as Map<String, dynamic>) : null,
      webReaderLink: json['webReaderLink'] as String?,
      accessViewStatus: json['accessViewStatus'] as String?,
      quoteSharingAllowed: json['quoteSharingAllowed'] as bool?,
    );
  }
}

class Epub {
  final bool isAvailable;
  final String? acsTokenLink;

  Epub({
    required this.isAvailable,
    this.acsTokenLink,
  });

  factory Epub.fromJson(Map<String, dynamic> json) {
    return Epub(
      isAvailable: json['isAvailable'] as bool? ?? false,
      acsTokenLink: json['acsTokenLink'] as String?,
    );
  }
}

class Pdf {
  final bool isAvailable;
  final String? acsTokenLink;

  Pdf({
    required this.isAvailable,
    this.acsTokenLink,
  });

  factory Pdf.fromJson(Map<String, dynamic> json) {
    return Pdf(
      isAvailable: json['isAvailable'] as bool? ?? false,
      acsTokenLink: json['acsTokenLink'] as String?,
    );
  }
}

class SearchInfo {
  final String? textSnippet;

  SearchInfo({this.textSnippet});

  factory SearchInfo.fromJson(Map<String, dynamic> json) {
    return SearchInfo(
      textSnippet: json['textSnippet'] as String?,
    );
  }
}
