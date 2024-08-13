import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // For launching PDF files

class ElibHome extends StatelessWidget {
  // Simulated data
  final List<Map<String, dynamic>> _featuredBooks = [
    {'pdfUrl': 'https://example.com/book1.pdf'},
    {'pdfUrl': 'https://example.com/book2.pdf'},
    {'pdfUrl': 'https://example.com/book3.pdf'},
  ];

  // Updated categories with icons
  final List<Map<String, dynamic>> _categories = [
    {'name': 'Engineering', 'icon': Icons.build},
    {'name': 'Science', 'icon': Icons.science},
    {'name': 'Mathematics', 'icon': Icons.calculate},
    {'name': 'Computer Science', 'icon': Icons.computer},
    {'name': 'Physics', 'icon': Icons.grain},
    {'name': 'Chemistry', 'icon': Icons.emoji_objects},
  ];

  Future<void> _openPdf(String url) async {
    print('Attempting to open PDF URL: $url');
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to E-Library'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Implement search functionality
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          HeaderSection(),
          const SizedBox(height: 10),
          FeaturedBooksSection(
            featuredBooks: _featuredBooks,
            openPdf: _openPdf,
          ),
          const SizedBox(height: 20),
          CategoriesSection(categories: _categories),
        ],
      ),
    );
  }
}

class HeaderSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          const Text(
            'Explore the best resources for your BTech studies.',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: const Text(
              '“The only way to do great work is to love what you do.” — Steve Jobs',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class FeaturedBooksSection extends StatelessWidget {
  final List<Map<String, dynamic>> featuredBooks;
  final Future<void> Function(String url) openPdf;

  FeaturedBooksSection({
    required this.featuredBooks,
    required this.openPdf,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Featured Books',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: featuredBooks.length,
              itemBuilder: (context, index) {
                final book = featuredBooks[index];
                final pdfUrl = book['pdfUrl'] ?? '';
                return GestureDetector(
                  onTap: () => openPdf(pdfUrl),
                  child: Container(
                    width: 150,
                    margin: const EdgeInsets.only(right: 8.0),
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.grey[200],
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        'Open PDF',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CategoriesSection extends StatelessWidget {
  final List<Map<String, dynamic>> categories;

  CategoriesSection({required this.categories});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 16.0),
          child: Text(
            'Categories',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
            shrinkWrap: true, // To avoid scrolling issues
            physics:
                const NeverScrollableScrollPhysics(), // Disable GridView scrolling
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final String categoryName = category['name'];
              final IconData categoryIcon = category['icon'];
              return CategoryCard(title: categoryName, icon: categoryIcon);
            },
          ),
        ),
      ],
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String title;
  final IconData icon;

  CategoryCard({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 50, color: Colors.blue),
          const SizedBox(height: 8.0),
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
