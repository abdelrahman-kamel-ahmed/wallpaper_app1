import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'categoriespage.dart';
import 'settingspage.dart';
import 'categorylists.dart';
import 'searchrespage.dart';

// HomePage Class
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

// HomePage State Class
class _HomePageState extends State<HomePage> {
  List<dynamic> imageUrls = [];
  bool isLoading = true;
  bool isCategoryLoading = true;

  final String accessKey =
      'd0_EXYFzFzYZfsCmPREA7IOk_86JwsjT6NNPg13wXzc'; // Replace with your Unsplash API Key

  String abstractImageUrl = '';
  String musicImageUrl = '';
  String girlImageUrl = '';
  String carImageUrl = '';

  @override
  void initState() {
    super.initState();
    fetchImages();
    fetchCategoryImages(); // Fetch category images
  }

  // Fetch images for the home screen
  Future<void> fetchImages() async {
    try {
      final response = await http.get(Uri.parse(
          'https://api.unsplash.com/photos/?client_id=$accessKey&per_page=30'));

      if (response.statusCode == 200) {
        setState(() {
          imageUrls = json.decode(response.body);
          isLoading = false;
        });
      } else {
        print('Failed to load images: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to load images');
      }
    } catch (e) {
      print('Error occurred: $e');
      throw Exception('Failed to load images');
    }
  }

  // Fetch images for the categories
  Future<void> fetchCategoryImages() async {
    try {
      final abstractImage = await fetchImageForCategory('abstract');
      final musicImage = await fetchImageForCategory('music');
      final girlImage = await fetchImageForCategory('girl');
      final carImage = await fetchImageForCategory('cars');

      setState(() {
        abstractImageUrl = abstractImage;
        musicImageUrl = musicImage;
        girlImageUrl = girlImage;
        carImageUrl = carImage;
        isCategoryLoading = false;
      });
    } catch (e) {
      print('Error fetching category images: $e');
    }
  }

  // Fetch a single image for a specific category
  Future<String> fetchImageForCategory(String query) async {
    final response = await http.get(Uri.parse(
        'https://api.unsplash.com/search/photos?query=$query&client_id=$accessKey&per_page=1'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['results'].isNotEmpty) {
        return data['results'][0]['urls']['small'];
      } else {
        throw Exception('No images found for category $query');
      }
    } else {
      throw Exception('Failed to load image for category $query');
    }
  }

  // Handle search functionality
  void _handleSearch(String value) {
    if (value.isNotEmpty) {
      Get.to(SearchResultsPage(
          title: value,
          searchQuery: value)); // Pass the query to both title and searchQuery
    }
  }

  // Build the search bar widget
  Widget buildSearchBar() {
    return Container(
      margin: const EdgeInsets.all(15),
      width: 300,
      height: 40,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 234, 231, 231),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const SizedBox(width: 10),
          const Icon(Icons.search, size: 25),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              decoration: const InputDecoration(
                hintText: "Find a wallpaper...",
                border: InputBorder.none,
              ),
              onSubmitted: _handleSearch,
            ),
          ),
        ],
      ),
    );
  }

  // Build the home screen layout
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF9F9F9),
      appBar: AppBar(
        title: buildSearchBar(),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: Icon(Icons.notifications, size: 40),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              onPressed: () {
                Get.to(CategoryPage()); // Remove searchQuery parameter
              },
              icon: const Icon(Icons.category_sharp),
            ),
            label: "Categories",
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              onPressed: () {
                Get.to(SettingsPage());
              },
              icon: const Icon(Icons.settings),
            ),
            label: "Settings",
          ),
        ],
        selectedItemColor: Colors.black,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 340,
                  height: 180,
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: const DecorationImage(
                            image: AssetImage("assets/images/coal.jpg"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.center,
                              colors: [
                                Colors.black.withOpacity(0.7),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                      const Positioned(
                        bottom: 70,
                        left: 10,
                        right: 10,
                        child: Text(
                          "COAL BLACK",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w400,
                            shadows: [
                              Shadow(
                                color: Colors.black,
                                blurRadius: 5,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Category",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                    ),
                    TextButton(
                      onPressed: () {
                        Get.to(() => CategoryPage());
                      },
                      child: const Text(
                        "View All   ",
                        style: TextStyle(fontSize: 18, color: Colors.blue),
                      ),
                    )
                  ],
                ),
              ),
              // Category wheel with dynamic API images
              Container(
                height: 70,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  children: [
                    CategoryCard(
                      title: 'Abstract',
                      imageUrl: isCategoryLoading
                          ? 'assets/images/loading.png'
                          : abstractImageUrl,
                    ),
                    CategoryCard(
                      title: 'Music',
                      imageUrl: isCategoryLoading
                          ? 'assets/images/loading.png'
                          : musicImageUrl,
                    ),
                    CategoryCard(
                      title: 'Girl',
                      imageUrl: isCategoryLoading
                          ? 'assets/images/loading.png'
                          : girlImageUrl,
                    ),
                    CategoryCard(
                      title: 'Cars',
                      imageUrl: isCategoryLoading
                          ? 'assets/images/loading.png'
                          : carImageUrl,
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                width: 330,
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 139, 172, 232),
                    border: Border.all(
                        color: const Color.fromRGBO(203, 218, 245, 1)),
                    borderRadius: BorderRadius.circular(30)),
                padding: const EdgeInsets.only(left: 35, top: 10, right: 35),
                child: const Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          FontAwesomeIcons.fireFlameCurved,
                          size: 32,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                        Icon(
                          FontAwesomeIcons.clock,
                          size: 32,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                        Icon(
                          FontAwesomeIcons.leaf,
                          size: 32,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Trending",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            height: 2,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                        Text(
                          "Recent",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            height: 2,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                        Text(
                          "New  ",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            height: 2,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(0),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.55,
                    ),
                    itemCount: imageUrls.length, // Use fetched images count
                    itemBuilder: (context, index) {
                      final image = imageUrls[index];

                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          image: DecorationImage(
                            image: NetworkImage(
                                image['urls']['small']), // Image from API
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: IconButton(
                              icon: const Icon(Icons.favorite_border,
                                  color: Colors.red), // Default icon
                              onPressed: () {
                                setState(() {
                                  // Handle favorite toggle here
                                });
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ]),
    );
  }
}
