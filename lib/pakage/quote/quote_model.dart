class QuoteModel {
  String? id;
  String? content;
  String? author;
  String? authorId;
  String? quote;
  List? tag;
  int? length;

  QuoteModel({
    this.id,
    this.content,
    this.author,
    this.authorId,
    this.quote,
    this.tag,
    this.length,
  });
  QuoteModel.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      content = json['content'],
      author = json['author'],
      authorId = json['author_id'],
      quote = json['quote'],
      tag = json['tag'],
      length = json['length'];

  String? getId() {
    return id;
  }
}
