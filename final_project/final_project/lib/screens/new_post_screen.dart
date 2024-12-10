import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewPostScreen extends StatefulWidget {
  @override
  _NewPostScreenState createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  List<File> selectedImages = [];

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();
    if (pickedFiles != null) {
      setState(() {
        selectedImages = pickedFiles.map((file) => File(file.path)).toList();
      });
    }
  }

  Future<void> _savePost() async {
    final post = {
      'title': titleController.text,
      'price': priceController.text,
      'description': descriptionController.text,
      'timestamp': FieldValue.serverTimestamp(),
    };

    final postsCollection = FirebaseFirestore.instance.collection('posts');
    final docRef = await postsCollection.add(post);

    final imageUrls = <String>[];
    for (var image in selectedImages) {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('post_images/${docRef.id}_${DateTime.now().millisecondsSinceEpoch}.jpg');
      await storageRef.putFile(image);
      final imageUrl = await storageRef.getDownloadURL();
      imageUrls.add(imageUrl);
    }

    await docRef.update({'images': imageUrls});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Post added successfully!')),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('New Post')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: priceController,
              decoration: InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
            ElevatedButton(
              onPressed: _pickImages,
              child: Text('Pick Images'),
            ),
            selectedImages.isNotEmpty
                ? SizedBox(
              height: 150,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: selectedImages
                    .map((image) => Image.file(image, height: 150))
                    .toList(),
              ),
            )
                : Text('No images selected'),
            Spacer(),
            ElevatedButton(
              onPressed: _savePost,
              child: Text('Post'),
            ),
          ],
        ),
      ),
    );
  }
}
