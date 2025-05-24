import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart'; // Import url_launcher

class ProductShowcaseScreen extends StatefulWidget {
  const ProductShowcaseScreen({Key? key}) : super(key: key);

  @override
  _ProductShowcaseScreenState createState() => _ProductShowcaseScreenState();
}

class _ProductShowcaseScreenState extends State<ProductShowcaseScreen> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;    // Gives the width
double height = MediaQuery.of(context).size.height;  // Gives the height
    return Scaffold(
      // Removed AppBar for a full-screen look
      // appBar: AppBar(
      //   title: const Text('Product Showcase'),
      //   backgroundColor: const Color(0xFF9D84FF),
      // ),
      body: SafeArea( // Use SafeArea for full-screen layout
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Product Showcase', // Main title
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Explore our featured products', // Subtitle
                    style: TextStyle(
                      fontSize: 27,
                      color: Colors.grey,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('feature').snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No products found.'));
                  }

                  return ListView(
                    children: snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                      print("image data:${data['image_path']}");
                      return Row(
                        children: [
                          _buildProductCard(data['title'],data['image_path'], data['description'],data['link'],width,height),
                        ]
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

Widget _buildProductCard(String title,String imagePath, String description,String link,double width,double height) {
      return Container(
        height:height/2.5 ,
        width: width,
        child: Card(
        
                          color:  Color.fromARGB(255, 216, 212, 212), // Changed background color
                          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          elevation: 4.0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (imagePath != null)
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12.0)), // Rounded top corners for image
                                  child: Image.asset(
                                    imagePath,
                                    width: double.infinity,
                                    height: 180.0, // Adjusted height for images
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 100),
                                  ),
                                ),
                              Padding(
                                padding: const EdgeInsets.all(16.0), // Padding for text content
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      title?? 'No Title',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87, // Adjusted text color
                                      ),
                                    ),
                                
                                    const SizedBox(height: 8), // Adjusted spacing
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                         Text(
                                     description ?? '', // Assuming a subtitle field exists or using description as subtitle
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black54, // Adjusted text color
                                      ),
                                    ),
                                      
                                        if (link != null)
                                          ElevatedButton(
                                            onPressed: () async {
                                              final url = Uri.parse(link);
                                              if (await canLaunchUrl(url)) {
                                                await launchUrl(url);
                                              } else {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    content: Text('Could not launch ${link}'),
                                                  ),
                                                );
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: const Color(0xFF673AB7), // Button color (Purple)
                                              foregroundColor: Colors.white, // Text color
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Adjusted padding
                                            ),
                                            child: const Icon(Icons.arrow_forward_ios, size: 18), // Changed button icon
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
      );
    }

}