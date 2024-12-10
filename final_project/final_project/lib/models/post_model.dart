class Post {
  final String id;
  final String title;
  final String price;
  final String description;
  final List<String> images;

  Post({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.images,
  });

  factory Post.fromFirestore(Map<String, dynamic> data, String id) {
    return Post(
      id: id,
      title: data['title'],
      price: data['price'],
      description: data['description'],
      images: List<String>.from(data['images'] ?? []),
    );
  }
}
