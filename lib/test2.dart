/*
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:http/http.dart' as http;
import 'package:wallpaper_app1/categoriespage.dart';
import 'categorylists.dart';

// ignore: camel_case_types
class homePage extends StatefulWidget {
  const homePage({super.key});

  @override
  State<homePage> createState() => _homePageState();
}

// ignore: camel_case_types
class _homePageState extends State<homePage> {
  List<dynamic> imageUrls = [];
  String searchText = ''; // Store search text
  bool isLoading = true;

  final String accessKey =
      'd0_EXYFzFzYZfsCmPREA7IOk_86JwsjT6NNPg13wXzc'; // Unsplash Access Key

  @override
  void initState() {
    super.initState();
    fetchImages();
  }

  // Function to fetch images from Unsplash API
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

  Color fav = Colors.white;
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
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: "Categories",
            
            
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: "Favorites",
          ),
        ],
        selectedItemColor: Colors.black,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator()) // Show loading spinner
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 340,
                        height: 180,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          image: const DecorationImage(
                            image: AssetImage("assets/images/nature.jpg"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(1),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "  Categories",
                        style: TextStyle(
                            fontSize: 26, fontWeight: FontWeight.w700),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            Get.to(CategoryPage());
                          });
                        },
                        child: const Text(
                          "View All   ",
                          style: TextStyle(fontSize: 18,color: Colors.blue)
                          ,
                        ),
                      )
                    ],
                  ),
                ),
                // ignore: sized_box_for_whitespace
                Container(
                  height: 110,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      const CategoryCard(
                          title: 'Abstract',
                          image: 'assets/images/abstract.jpeg'),
                      const CategoryCard(
                          title: 'Gaming', image: 'assets/images/gaming.jpeg'),
                      const CategoryCard(
                          title: 'Music', image: 'assets/images/music.jpeg'),
                      const CategoryCard(
                          title: 'Girl', image: 'assets/images/girl.jpeg'),
                      const CategoryCard(
                          title: 'Cars', image: 'assets/images/girl.jpeg'),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 35, top: 0, right: 35),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        FontAwesomeIcons.fireFlameCurved,
                        size: 32,
                      ),
                      Icon(
                        FontAwesomeIcons.clock,
                        size: 32,
                      ),
                      Icon(
                        FontAwesomeIcons.leaf,
                        size: 32,
                      )
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 32, right: 35),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Trending",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            height: 2),
                      ),
                      Text(
                        "Recent",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            height: 2),
                      ),
                      Text(
                        "     New",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            height: 2),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: GridView.builder(
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
*/