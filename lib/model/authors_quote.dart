class AuthorsModel {
  int? count;
  int? totalCount;
  int? page;
  int? totalPages;

  List<Result>? results;

  AuthorsModel(
      {this.count, this.totalCount, this.page, this.totalPages, this.results});

  AuthorsModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    totalCount = json['totalCount'];
    page = json['page'];
    totalPages = json['totalPages'];

    if (json['results'] != null) {
      results = <Result>[];
      json['results'].forEach((v) {
        results!.add(Result.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['totalCount'] = this.totalCount;
    data['page'] = this.page;
    data['totalPages'] = this.totalPages;

    if (this.results != null) {
      data['results'] = this.results!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Result {
  String? sId;
  String? name;
  String? link;
  String? bio;
  String? description;
  int? quoteCount;
  String? slug;
  String? dateAdded;
  String? dateModified;

  Result(
      {this.sId,
      this.name,
      this.link,
      this.bio,
      this.description,
      this.quoteCount,
      this.slug,
      this.dateAdded,
      this.dateModified});

  Result.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    link = json['link'];
    bio = json['bio'];
    description = json['description'];
    quoteCount = json['quoteCount'];
    slug = json['slug'];
    dateAdded = json['dateAdded'];
    dateModified = json['dateModified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['link'] = this.link;
    data['bio'] = this.bio;
    data['description'] = this.description;
    data['quoteCount'] = this.quoteCount;
    data['slug'] = this.slug;
    data['dateAdded'] = this.dateAdded;
    data['dateModified'] = this.dateModified;
    return data;
  }
}
