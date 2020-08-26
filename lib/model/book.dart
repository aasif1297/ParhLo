

class BookModel  {
  String imgAssetPath;
  String bookName;
  String category;
  String author ;
  int views;
  int readers;
  int downloads ;
  String description;
  String bookpdfUrl;
  String publishDate;
  bool isFavorite;

  BookModel({
    this.imgAssetPath,
    this.bookName,
    this.category,
    this.author,
    this.description,
    this.bookpdfUrl,
    this.downloads,
    this.readers,
    this.views,
    this.publishDate,
    this.isFavorite,
  });

  Map toMap(BookModel bookModel) {
    var data = Map<String, dynamic>();
    data['bookName'] = bookModel.bookName;
    data['bookImage'] = bookModel.imgAssetPath;
    data['author'] = bookModel.author;
    data['description'] = bookModel.description;
    data["bookpdfUrl"] = bookModel.bookpdfUrl;
    data["category"] = bookModel.category;
    data["publishDate"] = bookModel.publishDate;
    data["views"] = bookModel.views;
    data["readers"] = bookModel.readers;
    data["downloads"] = bookModel.downloads;

    return data;
  }

}

List<BookModel> singleeBooks = [
  BookModel(
      bookName: "The little mermaid",
      category: "Fairy Tailes",
      imgAssetPath: "mermaid.png",
      author: "Michel"),
  BookModel(
      bookName: "The little mermaid",
      category: "Fairy Tailes",
      imgAssetPath: "mermaid.png",
      author: "Michel"),
  BookModel(
      bookName: "The little mermaid",
      category: "Fairy Tailes",
      imgAssetPath: "mermaid.png",
      author: "Michel"),
  BookModel(
      bookName: "The little mermaid",
      category: "Fairy Tailes",
      imgAssetPath: "mermaid.png",
      author: ""),
  BookModel(
      bookName: "The little mermaid",
      category: "Fairy Tailes",
      imgAssetPath: "mermaid.png",
      author: "Michel"),
  BookModel(
      bookName: "The little mermaid",
      category: "Fairy Tailes",
      imgAssetPath: "mermaid.png",
      author: "Michel"),
  BookModel(
      bookName: "The little mermaid",
      category: "Fairy Tailes",
      imgAssetPath: "mermaid.png",
      author: "Michel")
];
