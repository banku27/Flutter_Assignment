class Quotes {
  List<Results>? results;

  Quotes({
    this.results,
  });

  Quotes.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = <Results>[];
      json['results'].forEach((v) {
        results!.add(Results.fromJson(v));
      });
    }
  }
}

class Results {
  String? content;
  String? author;
  String? id;

  Results({
    this.content,
    this.author,
    this.id,
  });

  Results.fromJson(Map<String, dynamic> json) {
    content = json['content'];
    author = json['author'];
    id = json['id'];
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'content': content,
      'author': author,
      'id': id,
    };
  }
}
