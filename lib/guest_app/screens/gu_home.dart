import 'package:flutter/material.dart';
import 'dart:ui';

class GuHome extends StatelessWidget {
  const GuHome({super.key});

  @override
  Widget build(BuildContext context) {
    final ScrollController _scrollController = ScrollController();
    Color _titleColor = Colors.white;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'DigiRes',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontFamily: 'Gabarito-Bold',
          ),
        ),
        centerTitle: true, // Ensure the title is centered
        toolbarHeight: kToolbarHeight, // Use default AppBar height
        backgroundColor:
            Colors.transparent, // Set background color to transparent
        elevation: 0, // Remove shadow
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xfff0256b), Color(0xffff9a68)], // Gradient colors
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            expandedHeight: 150.0, // Set the height of the expanded AppBar
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Main Dishes',
                style: TextStyle(
                  color: _titleColor,
                  fontFamily: 'Gabarito-Regular',
                  fontSize: 25,
                ),
              ),
              centerTitle: true,
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/images/demo/restobg.jpg', // Replace with your image path
                    fit: BoxFit.cover,
                  ),
                  BackdropFilter(
                    filter: ImageFilter.blur(
                        sigmaX: 2.0,
                        sigmaY: 2.0), // Adjust the blur strength as needed
                    child: Container(
                      color: Colors.black.withOpacity(
                          0), // Optional: Adds a translucent overlay
                    ),
                  ),
                ],
              ),
            ),
            pinned: true, // Makes the AppBar stick at the top
            floating: false, // Make it not float over the content
            snap: false, // Snap effect when scrolling
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                const SizedBox(height: 20), // Space between title and list

                const Center(
                  child: Text(
                    'Meat Options',
                    style: TextStyle(
                      fontFamily: 'Gabarito-Regular',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _buildPicture(
                    context,
                    'assets/images/demo/grilled steak.jpg',
                    'Grilled Steak',
                    '₱1649',
                    'Juicy, tender steak grilled to perfection and served with sides.'),
                _buildPicture(
                    context,
                    'assets/images/demo/roast chicken.jpg',
                    'Roast Chicken',
                    '₱849',
                    'Herb-seasoned roast chicken served with roasted potatoes and vegetables.'),
                _buildPicture(
                    context,
                    'assets/images/demo/lamb chops.jpg',
                    'Lamb Chops',
                    '₱1349',
                    'Tender lamb chops grilled and served with mint sauce.'),
                _buildPicture(
                    context,
                    'assets/images/demo/chicken wings.jpg',
                    'Chicken Wings',
                    '₱649',
                    'Crispy chicken wings tossed in your choice of sauce.'),
                _buildPicture(
                    context,
                    'assets/images/demo/Beef-Burgers.jpg',
                    'Beef Burgers',
                    '₱549',
                    'Classic beef burger with lettuce, tomato, and cheese.'),

                const SizedBox(height: 30), // Space between categories
                const Center(
                  child: Text(
                    'Sea Foods',
                    style: TextStyle(
                      fontFamily: 'Gabarito-Regular',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _buildPicture(
                    context,
                    'assets/images/demo/oysters.jpg',
                    'Oysters on the Half Shell',
                    '₱749',
                    'Fresh oysters served with lemon and cocktail sauce.'),
                _buildPicture(
                    context,
                    'assets/images/demo/grilled salmon.jpeg',
                    'Grilled Salmon',
                    '₱649',
                    'Grilled salmon fillet served with a side of vegetables.'),
                _buildPicture(
                    context,
                    'assets/images/demo/lobster-tail.jpg',
                    'Lobster Tail',
                    '₱629',
                    'Succulent lobster tail served with drawn butter.'),
                _buildPicture(
                    context,
                    'assets/images/demo/tuna_steak.jpg',
                    'Grilled Tuna Steak',
                    '₱729',
                    'Grilled tuna steak served rare with a side of greens.'),
                _buildPicture(
                    context,
                    'assets/images/demo/Calamari.jpg',
                    'Calamari',
                    '₱329',
                    'Crispy fried calamari served with marinara sauce.'),

                const SizedBox(height: 30), // Space between categories
                const Center(
                  child: Text(
                    'Veggie Meals',
                    style: TextStyle(
                      fontFamily: 'Gabarito-Regular',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _buildPicture(
                    context,
                    'assets/images/demo/cauliflower curry.jpg',
                    'Cauliflower Curry',
                    '₱449',
                    'Spicy cauliflower curry served with rice.'),
                _buildPicture(
                    context,
                    'assets/images/demo/eggplant-parmesan.jpg',
                    'Eggplant Parmesan',
                    '₱349',
                    'Breaded eggplant slices baked with marinara sauce and cheese.'),
                _buildPicture(
                    context,
                    'assets/images/demo/greeksalad.jpg',
                    'Greek Salad',
                    '₱649',
                    'Fresh salad with cucumbers, tomatoes, olives, and feta cheese.'),

                const SizedBox(height: 30), // Space between categories
                const Center(
                  child: Text(
                    'Pasta Dishes',
                    style: TextStyle(
                      fontFamily: 'Gabarito-Regular',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _buildPicture(
                    context,
                    'assets/images/demo/pizza ittaliano.png',
                    'Pizza Italiano',
                    '₱999',
                    'Classic Italian pizza with fresh tomatoes, mozzarella, and basil.'),
                _buildPicture(
                    context,
                    'assets/images/demo/Lasagna.jpg',
                    'Lasagna',
                    '₱799',
                    'Layers of pasta, meat sauce, ricotta, and mozzarella.'),
                _buildPicture(
                    context,
                    'assets/images/demo/Carbonara.jpg',
                    'Carbonara',
                    '₱449',
                    'Pasta with creamy egg sauce, pancetta, and Parmesan.'),
                _buildPicture(
                    context,
                    'assets/images/demo/Mac-Cheese.jpg',
                    'Mac and Cheese',
                    '₱349',
                    'Creamy macaroni and cheese baked to perfection.'),

                const SizedBox(height: 30), // Space before the end
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPicture(BuildContext context, String imagePath, String dishName,
      String price, String description) {
    return InkWell(
      onTap: () => _showPopup(context, imagePath, dishName, price, description),
      child: Container(
        width: 140, // Set a fixed width for each card
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8.0),
                  topRight: Radius.circular(8.0),
                ),
                child: Image.asset(
                  imagePath,
                  width: double
                      .infinity, // Make the image take up the card's width
                  height: 150, // Adjust height as needed
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dishName,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold),
                      maxLines: 1, // Limit to one line
                      overflow:
                          TextOverflow.ellipsis, // Add ellipsis if overflow
                    ),
                    Text(
                      price,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    Text(
                      description,
                      style: const TextStyle(
                          fontSize: 12,
                          fontFamily: 'Gabarito-Regular',
                          color: Colors.black),
                      maxLines: 2, // Limit to two lines
                      overflow:
                          TextOverflow.ellipsis, // Add ellipsis if overflow
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPopup(BuildContext context, String imagePath, String dishName,
      String price, String description) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(dishName),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(imagePath),
                const SizedBox(height: 10),
                Text(price),
                const SizedBox(height: 10),
                Text(description),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
