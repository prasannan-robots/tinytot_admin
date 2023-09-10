import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class AdminHomePage extends StatefulWidget {
  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageTagController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController searchController = TextEditingController();

  late Stream<QuerySnapshot> productsStream;

  @override
  void initState() {
    super.initState();
    productsStream =
        FirebaseFirestore.instance.collection('products').snapshots();
  }

  Future<String> uploadImage(String imagePath, String storagePath) async {
    try {
      File imageFile = File(imagePath);

      Reference storageReference =
          FirebaseStorage.instance.ref().child(storagePath);

      UploadTask uploadTask = storageReference.putFile(imageFile);

      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);

      String downloadURL = await taskSnapshot.ref.getDownloadURL();

      return downloadURL;
    } catch (e) {
      print('Error uploading image: $e');
      return "error"; // Handle the error gracefully
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.image, // You can specify other file types if needed
    );

    if (pickedFile != null) {
      final fileName = pickedFile.files.first.name;
      final filePath = pickedFile.files.single.path.toString();
      // Use the filePath to upload the image
      // You can also display the selected image to the user
      print('Selected image path: $filePath');
      uploadImage(filePath, fileName);
      // Now, you can pass `filePath` to your image upload function.
      // Example: await uploadProductImage(name, filePath);
    }
  }

  Future<void> addProduct() async {
    final String name = nameController.text.trim();
    final String ageTag = ageTagController.text.trim();
    final double price = double.tryParse(priceController.text.trim()) ?? 0.0;
    final String type = typeController.text.trim();

    await FirebaseFirestore.instance.collection('products').add({
      'name': name,
      'agetag': ageTag,
      'price': price,
      'type': type,
    });

    // Clear text fields after adding a product
    nameController.clear();
    ageTagController.clear();
    priceController.clear();
    typeController.clear();
  }

  Future<void> editProduct(String productId) async {
    final String name = nameController.text.trim();
    final String ageTag = ageTagController.text.trim();
    final double price = double.tryParse(priceController.text.trim()) ?? 0.0;
    final String type = typeController.text.trim();

    await FirebaseFirestore.instance
        .collection('products')
        .doc(productId)
        .update({
      'name': name,
      'agetag': ageTag,
      'price': price,
      'type': type,
    });

    // Clear text fields after editing a product
    nameController.clear();
    ageTagController.clear();
    priceController.clear();
    typeController.clear();
  }

  Future<void> deleteProduct(String productId) async {
    await FirebaseFirestore.instance
        .collection('products')
        .doc(productId)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin App'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  // Update the stream with filtered products
                  productsStream = FirebaseFirestore.instance
                      .collection('products')
                      .where('name', isGreaterThanOrEqualTo: value)
                      .where('name', isLessThan: value + 'z')
                      .snapshots();
                });
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: productsStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No products available.'));
                }

                final products = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    final productId = product.id;
                    final name = product['name'];
                    final ageTag = product['agetag'];
                    final price = product['price'];
                    final type = product['type'];
                    final imageurl = product['image'];
                    return ListTile(
                      leading: Image.network(
                        imageurl,
                        width: 100, // Adjust the width as needed
                        height: 100, // Adjust the height as needed
                      ),
                      title: Text(name),
                      subtitle:
                          Text('Age Tag: $ageTag, Price: $price, Type: $type'),
                      trailing: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          // Fill text fields with product details for editing
                          nameController.text = name;
                          ageTagController.text = ageTag;
                          priceController.text = price.toString();
                          typeController.text = type;

                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Edit Product'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextField(
                                      controller: nameController,
                                      decoration:
                                          InputDecoration(labelText: 'Name'),
                                    ),
                                    TextField(
                                      controller: ageTagController,
                                      decoration:
                                          InputDecoration(labelText: 'Age Tag'),
                                    ),
                                    TextField(
                                      controller: priceController,
                                      decoration:
                                          InputDecoration(labelText: 'Price'),
                                    ),
                                    TextField(
                                      controller: typeController,
                                      decoration:
                                          InputDecoration(labelText: 'Type'),
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      editProduct(productId);
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Save'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                      onLongPress: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Delete Product'),
                              content: Text(
                                  'Are you sure you want to delete this product?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    deleteProduct(productId);
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Delete'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Add Product'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                      onPressed: _pickImage,
                      child: Text('Pick Image'),
                    ),
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(labelText: 'Name'),
                    ),
                    TextField(
                      controller: ageTagController,
                      decoration: InputDecoration(labelText: 'Age Tag'),
                    ),
                    TextField(
                      controller: priceController,
                      decoration: InputDecoration(labelText: 'Price'),
                    ),
                    TextField(
                      controller: typeController,
                      decoration: InputDecoration(labelText: 'Type'),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      addProduct();
                      Navigator.of(context).pop();
                    },
                    child: Text('Add'),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
