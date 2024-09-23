import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CarCategoryPage extends StatefulWidget {
  @override
  _CarCategoryPageState createState() => _CarCategoryPageState();
}

class _CarCategoryPageState extends State<CarCategoryPage> {
  final String accessKey =
      'd0_EXYFzFzYZfsCmPREA7IOk_86JwsjT6NNPg13wXzc'; // Unsplash API Key
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
        fetchedCarImages.add(result['urls']['small']);
      }
      setState(() {
        carImages = fetchedCarImages;
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load car images');
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
              physics: BouncingScrollPhysics(),
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.6,
              ),
              itemCount: carImages.length,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: NetworkImage(carImages[index]),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
    );
  }
}
