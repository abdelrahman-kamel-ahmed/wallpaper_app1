import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:http/http.dart' as http;
import 'package:wallpaper_app1/categorylists.dart';
import 'package:wallpaper_app1/settingspage.dart';
import 'categoriespage.dart';

// ignore: camel_case_types
class homePage extends StatefulWidget {
  const homePage({super.key});

  @override
  State<homePage> createState() => _homePageState();
}

// ignore: camel_case_types
class _homePageState extends State<homePage> {
  List<dynamic> imageUrls = [];
  bool isLoading = true;
  bool isCategoryLoading = true;

  final String accessKey = 'd0_EXYFzFzYZfsCmPREA7IOk_86JwsjT6NNPg13wXzc';

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

  Future<void> fetchImages() async {
    final response = await http.get(Uri.parse(
        'https://api.unsplash.com/photos/?client_id=$accessKey&per_page=30'));

    if (response.statusCode == 200) {
      setState(() {
        imageUrls = json.decode(response.body);
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load images');
    }
  }

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

  Color fav = Colors.white;
  String searchText = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF9F9F9),
      appBar: AppBar(
        title: Container(
          margin: const EdgeInsets.all(15),
          width: 300,
          height: 40,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 234, 231, 231),
            border: Border.all(
              color: const Color.fromARGB(255, 234, 231, 231),
            ),
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
                  onChanged: (value) {
                    setState(() {
                      searchText = value; // Store the search query
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: Icon(Icons.notifications, size: 40),
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 245, 244, 243),
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: IconButton(
                onPressed: () {
                  Get.to(const CategoryPage());
                },
                icon: const Icon(Icons.category_sharp)),
            label: "Categories",
          ),
          BottomNavigationBarItem(
            icon: IconButton(
                onPressed: () {
                  Get.to(SettingsPage());
                },
                icon: Icon(Icons.settings)),
            label: "Settings",
          ),
        ],
        selectedItemColor: Colors.black,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: 3, bottom: 3, left: 3, right: 3),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 340,
                        height: 180,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: const DecorationImage(
                            image: AssetImage("assets/images/coal.jpg"),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Stack(
                          children: [
                            // Overlay with semi-transparent background to improve text visibility
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
                            // Title positioned at the center or bottom
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
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "  Category",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w700),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            Get.to(const CategoryPage());
                          });
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
                            color: Color.fromARGB(255, 22, 150, 254),
                          ),
                          Icon(
                            FontAwesomeIcons.clock,
                            size: 32,
                            color: Color.fromARGB(255, 22, 150, 254),
                          ),
                          Icon(
                            FontAwesomeIcons.leaf,
                            size: 32,
                            color: Color.fromARGB(255, 22, 150, 254),
                          ),
                        ],
                      ), // Add spacing between rows
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Trending",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              height: 2,
                              color: Color.fromARGB(255, 255, 254, 254),
                            ),
                          ),
                          Text(
                            "Recent",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              height: 2,
                              color: Color.fromARGB(255, 250, 253, 255),
                            ),
                          ),
                          Text(
                            "     New",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              height: 2,
                              color: Color.fromARGB(255, 255, 255, 255),
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
                                icon: Icon(
                                  Icons.favorite_border,
                                  color: fav,
                                ),
                                onPressed: () {
                                  fav = Colors.red;
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
