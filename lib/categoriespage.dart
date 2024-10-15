import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:wallpaper_app1/carcategorypage.dart';
import 'package:wallpaper_app1/gamingcategorypage.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final String accessKey = 'd0_EXYFzFzYZfsCmPREA7IOk_86JwsjT6NNPg13wXzc';
  Map<String, List<String>> categoryImages = {};
  bool isLoading = true;

  List<Map<String, String>> categories = [
    {'title': 'Abstract', 'query': 'abstract'},
    {'title': 'Art', 'query': 'art'},
    {'title': 'Beach', 'query': 'beach'},
    {'title': 'Bicycle', 'query': 'bicycle'},
    {'title': 'Bike', 'query': 'motorcycle'},
    {'title': 'Car', 'query': 'car'},
    {'title': 'Food', 'query': 'food'},
    {'title': 'Gaming', 'query': 'gaming'},
    {'title': 'Girl', 'query': 'girl'},
    {'title': 'God', 'query': 'god'},
    {'title': 'Music', 'query': 'music'},
    {'title': 'Nature', 'query': 'nature'},
    {'title': 'Plane', 'query': 'airplane'},
    {'title': 'Plant', 'query': 'plant'},
    {'title': 'Rain', 'query': 'rain'},
    {'title': 'Space', 'query': 'space'},
    {'title': 'Travel', 'query': 'travel'},
    {'title': 'Wildlife', 'query': 'wildlife'},
  ];

  @override
  void initState() {
    super.initState();
    fetchCategoryImages();
  }

  Future<void> fetchCategoryImages() async {
    for (var category in categories) {
      final photos = await fetchImagesForCategory(category['query']!);
      setState(() {
        categoryImages[category['title']!] = photos;
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<List<String>> fetchImagesForCategory(String query) async {
    final url = Uri.parse(
        'https://api.unsplash.com/search/photos?query=$query&per_page=1&client_id=$accessKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      List<String> imageUrls = [];
      for (var result in data['results']) {
        imageUrls.add(result['urls']['small']);
      }
      return imageUrls;
    } else {
      throw Exception('Failed to load images');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Category",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(12.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  String title = categories[index]['title']!;
                  List<String> images = categoryImages[title] ?? [];

                  return GestureDetector(
                    onTap: () {
                      if (title == 'Car') {
                        Get.to(() => CarCategoryPage());
                      } else if (title == 'Gaming') {
                        Get.to(() => GamingCategoryPage());
                      }
                      // Add more navigation cases if needed
                    },
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: images.isNotEmpty
                                ? DecorationImage(
                                    image: NetworkImage(images[0]),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                            color: Colors.grey[300],
                          ),
                          child: Center(
                            child: Text(
                              title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                shadows: [
                                  Shadow(
                                    offset: Offset(0, 0),
                                    blurRadius: 5.0,
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
    );
  }
}
