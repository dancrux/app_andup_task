class Book {
  final String? author,
      title,
      category,
      description,
      image,
      printType,
      publisher;
  final int? rating, amount, pageCount;

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
    String description = '';
    int rating = 0;
    int amount = 0;

    if (volumeInfo['authors'] != null && volumeInfo['authors'].length >= 0) {
      author = volumeInfo['authors'][0];
    } else {
      author = '';
    }
    if (volumeInfo['mainCategory'] != null) {
      category = volumeInfo['mainCategory'];
    } else if (volumeInfo['categories'] != null) {
      category = volumeInfo['categories'][0];
    } else {
      category = '';
    }
    if (volumeInfo['description'] != null) {
      description = volumeInfo['description'];
    } else {
      description = '';
    }
    if (volumeInfo['rating'] != null) {
      rating = volumeInfo['rating'];
    } else {
      rating = 0;
    }
    if (volumeInfo['listPrice'] != null) {
      amount = volumeInfo['listPrice']['amount'];
    } else if (volumeInfo['retailPrice'] != null) {
      volumeInfo['retailPrice']['amount'];
    } else {
      amount = 0;
    }

    return Book(
        author: author,
        title: volumeInfo['title'],
        category: category,
        description: description,
        image: volumeInfo['imageLinks'] != null
            ? volumeInfo["imageLinks"]["smallThumbnail"]
            : "",
        printType: volumeInfo['printType'],
        publisher: volumeInfo['publisher'],
        rating: rating,
        amount: amount,
        pageCount: volumeInfo['pageCount']);
  }
  factory Book.fromMap(Map snapshot) {
    return Book(
        author: snapshot['author'],
        title: snapshot['title'],
        category: snapshot['category'],
        description: snapshot['description'],
        image: snapshot['image'],
        printType: snapshot['printType'],
        publisher: snapshot['publisher'],
        rating: snapshot['rating'],
        amount: snapshot['amount'],
        pageCount: snapshot['pageCount']);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'author': author,
        'title': title,
        'category': category,
        'description': description,
        'image': image,
        'printType': printType,
        'publisher': publisher,
        'rating': rating,
        'amount': amount,
        'pageCount': pageCount,
      };
}
