class AttractionModel {
  List<Attraction> data;
  Paging paging;

  AttractionModel({required this.data, required this.paging});

  factory AttractionModel.fromJson(Map<String, dynamic> json) {
    return AttractionModel(
      data: List<Attraction>.from(json['data'].map((attraction) => Attraction.fromJson(attraction))),
      paging: Paging.fromJson(json['paging']),
    );
  }
}

class Attraction {
  String name;
  String latitude;
  String longitude;
  String numReviews;
  String timezone;
  String locationString;
  String smallPhotoUrl;
  bool isClosed;
  bool isLongClosed;
  String description;
  String locationId;

  Attraction({
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.numReviews,
    required this.timezone,
    required this.locationString,
    required this.smallPhotoUrl,
    required this.isClosed,
    required this.isLongClosed,
    required this.description,
    required this.locationId,
  });

  factory Attraction.fromJson(Map<String, dynamic> json) {
    String locationId = json['ancestors'][0]['location_id'];
    return Attraction(
      name: json['name'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      numReviews: json['num_reviews'],
      timezone: json['timezone'],
      locationString: json['location_string'],
      smallPhotoUrl: json['photo']['images']['small']['url'],
      isClosed: json['is_closed'],
      isLongClosed: json['is_long_closed'],
      description: json['description'],
      locationId: locationId,
    );
  }
}

class Ancestor {
  String name;
  String locationId;

  Ancestor({required this.name, required this.locationId});

  factory Ancestor.fromJson(Map<String, dynamic> json) {
    return Ancestor(
      name: json['name'],
      locationId: json['location_id'],
    );
  }
}


class Photo {
  Images images;
  bool isBlessed;
  String uploadedDate;
  String caption;
  String id;
  String helpfulVotes;
  String publishedDate;
  dynamic user;

  Photo({
    required this.images,
    required this.isBlessed,
    required this.uploadedDate,
    required this.caption,
    required this.id,
    required this.helpfulVotes,
    required this.publishedDate,
    required this.user,
  });

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      images: Images.fromJson(json['images']),
      isBlessed: json['is_blessed'],
      uploadedDate: json['uploaded_date'],
      caption: json['caption'],
      id: json['id'],
      helpfulVotes: json['helpful_votes'],
      publishedDate: json['published_date'],
      user: json['user'],
    );
  }
}

class Images {
  Small small;
  Images({
    required this.small,
  });

  factory Images.fromJson(Map<String, dynamic> json) {
    return Images(
      small: Small.fromJson(json['small']),
    );
  }
}

class Small {
  String width;
  String url;
  String height;

  Small({required this.width, required this.url, required this.height});

  factory Small.fromJson(Map<String, dynamic> json) {
    return Small(width: json['width'], url: json['url'], height: json['height']);
  }
}

class Paging {
  String results;
  String totalResults;

  Paging({required this.results, required this.totalResults});

  factory Paging.fromJson(Map<String, dynamic> json) {
    return Paging(results: json['results'], totalResults: json['total_results']);
  }
}
