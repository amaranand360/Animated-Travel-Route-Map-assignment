import 'package:flutter/material.dart';
import 'package:travel_app/components/fancy_card.dart';
import 'package:travel_app/components/trending_place_card.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Travel App',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SearchBar(),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(
                  "India's Trending Places",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              const SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    TrendingPlaceCard(
                        title: 'Punjab',
                        imagePath: 'assets/images/Panjab.jpeg'),
                    TrendingPlaceCard(
                        title: 'Mumbai', imagePath: 'assets/images/Mumbai.jpg'),
                    TrendingPlaceCard(
                        title: 'Rajasthan',
                        imagePath: 'assets/images/Rajasthan.jpg'),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: FancyCard(
                  title: "Modern Structures",
                  label: "Singapore",
                  description:
                      "One of the most beautiful countries, Singapore has a lot to offer in terms of nature, culture and cuisine, modern structures and architecture, monuments and beaches. A small country and populated, you will get a slightly 'Indian' feel here.",
                  price: "Rs. 115,898",
                  imageUrl:
                      "https://im.indiatimes.in/media/content/2015/Jan/singapore-marhsall-university_1421316697_725x725.jpg",
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: FancyCard(
                  title: "Largest tropical forests",
                  label: "Indonesia",
                  description:
                      "The land of volcanoes, Indonesia also has some of the largest tropical forests and flora and fauna that will stun you. The Indonesian beaches are clear and the blue waters are a treat. Apart from natural scenes, Indonesia also offers a lot of Hindu monuments and temples for the religious.",
                  price: "Rs.72,999",
                  imageUrl:
                      "https://im.indiatimes.in/media/content/2015/Jan/indonesia-exploring-tourism_1421318041_725x725.jpg",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: "Search for places...",
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: Colors.grey.shade200,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        suffixIcon: const Icon(Icons.filter_list),
      ),
    );
  }
}
