import 'package:flutter/material.dart';
import '../models/post_model.dart';

class PostDetailScreen extends StatelessWidget {
  final Post post;

  PostDetailScreen({required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(post.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Price: \$${post.price}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Description: ${post.description}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            post.images.isNotEmpty
                ? SizedBox(
              height: 150,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: post.images
                    .map((url) => Image.network(url, height: 150))
                    .toList(),
              ),
            )
                : Text('No images available'),
          ],
        ),
      ),
    );
  }
}
