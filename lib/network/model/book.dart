class Book {
  final String? author,
      title,
      category,
      description,
      image,
      printType,
      publisher;
  final double? rating, amount;
  final int? pageCount;

  Book({
    this.author,
    this.title,
    this.category,
    this.description,
    this.image,
    this.printType,
    this.publisher,
    this.rating,
    this.amount,
    this.pageCount,
  });

  factory Book.fromJson(Map<dynamic, dynamic> json) {
    Map volumeInfo = json['volumeInfo'];
    String author = '';
    String category = '';

    if (volumeInfo['authors'] != null && volumeInfo['authors'].length >= 0) {
      author = volumeInfo['authors'][0];
    }
    if (volumeInfo['mainCategory'] != null) {
      category = volumeInfo['mainCategory'];
    } else if (volumeInfo['categories'] != null) {
      category = volumeInfo['categories'][0];
    }

    return Book(
        author: author,
        title: volumeInfo['title'],
        category: category,
        description: volumeInfo['description'],
        image: volumeInfo['imageLinks'] != null
            ? volumeInfo["imageLinks"]["smallThumbnail"]
            : "",
        printType: volumeInfo['printType'],
        publisher: volumeInfo['publisher'],
        rating: volumeInfo['averageRating'] != null
            ? volumeInfo['averageRating'][0]
            : 0,
        amount: volumeInfo['retailPrice'],
        pageCount: volumeInfo['pageCount']);
  }
}
