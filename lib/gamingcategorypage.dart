import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class GamingCategoryPage extends StatefulWidget {
  const GamingCategoryPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _GamingCategoryPageState createState() => _GamingCategoryPageState();
}

class _GamingCategoryPageState extends State<GamingCategoryPage> {
  final String accessKey = 'd0_EXYFzFzYZfsCmPREA7IOk_86JwsjT6NNPg13wXzc'; // Unsplash API Key
  List<String> gamingImages = []; // List to hold gaming images
  bool isLoading = true; // Loading state

  @override
  void initState() {
    super.initState();
    fetchGamingImages(); // Fetch gaming images when the page initializes
  }

  // Function to fetch gaming images from Unsplash API
  Future<void> fetchGamingImages() async {
    final response = await http.get(Uri.parse(
        'https://api.unsplash.com/search/photos?query=gaming&per_page=30&client_id=$accessKey'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      List<String> fetchedGamingImages = []; // List to hold fetched images
      for (var result in data['results']) {
        String imageUrl = result['urls']['small'];
        fetchedGamingImages.add(imageUrl); // Add each image URL to the list
      }
      setState(() {
        gamingImages = fetchedGamingImages; // Update state with fetched images
        isLoading = false; // Set loading to false
      });
    } else {
      throw Exception('Failed to load gaming images');
    }
  }

  // Function to download image and save it locally using Dio
  Future<String> downloadImage(String url) async {
    try {
      Dio dio = Dio();
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String savePath = '${appDocDir.path}/${url.split('/').last}';
      await dio.download(url, savePath); // Download the image
      return savePath; // Return the local file path
    } catch (e) {
      print('Error downloading image: $e');
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Gaming Wallpapers",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : GridView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.6,
              ),
              itemCount: gamingImages.length, // Use gamingImages
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                          image: NetworkImage(gamingImages[index]), // Display image from URL
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: IconButton(
                        icon: const Icon(
                          Icons.download,
                          color: Colors.white,
                          size: 24,
                        ),
                        onPressed: () async {
                          String imagePath = await downloadImage(gamingImages[index]);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  imagePath.isNotEmpty
                                      ? 'Downloaded to $imagePath'
                                      : 'Download failed',
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }
}
