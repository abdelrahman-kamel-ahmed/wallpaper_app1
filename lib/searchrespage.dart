import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class SearchResultsPage extends StatefulWidget {
  final String title; // Variable title for the page
  final String searchQuery; // Variable for search query

  const SearchResultsPage({
    Key? key,
    required this.title,
    required this.searchQuery,
  }) : super(key: key);

  @override
  _SearchResultsPageState createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  final String accessKey =
      'd0_EXYFzFzYZfsCmPREA7IOk_86JwsjT6NNPg13wXzc'; // Replace with your Unsplash API Key
  List<String> imageUrls = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchImages(); // Fetch images based on the search query
  }

  Future<void> fetchImages() async {
    if (widget.searchQuery.isEmpty) {
      print('Search query is empty.');
      throw Exception('Search query cannot be empty.');
    }

    // URL-encode the search query
    final encodedQuery = Uri.encodeComponent(widget.searchQuery);
    final response = await http.get(Uri.parse(
        'https://api.unsplash.com/search/photos?query=$encodedQuery&per_page=30&client_id=$accessKey'));

    print('Response Status Code: ${response.statusCode}');
    print('Response Headers: ${response.headers}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      List<String> fetchedImages = [];
      for (var result in data['results']) {
        String imageUrl = result['urls']['small'];
        fetchedImages.add(imageUrl);
      }
      setState(() {
        imageUrls = fetchedImages;
        isLoading = false;
      });
    } else {
      String errorMessage;
      switch (response.statusCode) {
        case 400:
          errorMessage = 'Bad Request: Check your query.';
          break;
        case 401:
          errorMessage = 'Unauthorized: Check your API key.';
          break;
        case 404:
          errorMessage = 'Not Found: No images found for this query.';
          break;
        case 500:
          errorMessage = 'Server Error: Try again later.';
          break;
        default:
          errorMessage = 'Unexpected error: ${response.statusCode}';
          break;
      }
      print('Error: $errorMessage');
      throw Exception(errorMessage);
    }
  }

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
        title: Text(
          "${widget.title}wallpapers",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ), // Display the dynamic title
        centerTitle: true,
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
              itemCount: imageUrls.length,
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                          image: NetworkImage(imageUrls[index]),
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
                          String imagePath =
                              await downloadImage(imageUrls[index]);
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
