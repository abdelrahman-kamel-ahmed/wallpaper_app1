import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class CarCategoryPage extends StatefulWidget {
  @override
  _CarCategoryPageState createState() => _CarCategoryPageState();
}

class _CarCategoryPageState extends State<CarCategoryPage> {
  final String accessKey = 'd0_EXYFzFzYZfsCmPREA7IOk_86JwsjT6NNPg13wXzc'; // Unsplash API Key
  List<String> carImages = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCarImages();
  }

  // Function to fetch car images from Unsplash API
  Future<void> fetchCarImages() async {
    final response = await http.get(Uri.parse(
        'https://api.unsplash.com/search/photos?query=car&per_page=30&client_id=$accessKey'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      List<String> fetchedCarImages = [];
      for (var result in data['results']) {
        String imageUrl = result['urls']['small'];
        fetchedCarImages.add(imageUrl);
      }
      setState(() {
        carImages = fetchedCarImages;
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load car images');
    }
  }

  // Function to download image and save it locally using Dio
  Future<String> downloadImage(String url) async {
    try {
      Dio dio = Dio();
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String savePath = '${appDocDir.path}/${url.split('/').last}';
      await dio.download(url, savePath);
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
          "Car Wallpapers",
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
              itemCount: carImages.length,
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                          image: NetworkImage(carImages[index]), // Display image from URL
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: IconButton(
                        icon: Icon(
                          Icons.download,
                          color: Colors.white,
                          size: 24,
                        ),
                        onPressed: () async {
                          String imagePath = await downloadImage(carImages[index]);
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
