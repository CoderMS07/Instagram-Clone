import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/widgets/posts_card.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Different story images
    final List<String> storyImages = [
      'https://images.unsplash.com/photo-1607746882042-944635dfe10e?w=900',
      'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?w=900',
      'https://images.unsplash.com/photo-1503023345310-bd7c1de61c7d?w=900',
      'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=900',
      'https://images.unsplash.com/photo-1520813792240-56fc4a3765a7?w=900',
      'https://images.unsplash.com/photo-1544723795-3fb6469f5b39?w=900',
      'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=900',
      'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=900',
      'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?w=900',
      'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=900',
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        centerTitle: false,
        title: SvgPicture.asset(
          'assets/images/ic_instagram.svg',
          color: primaryColor,
          height: 32,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.favorite_border_outlined),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.message_outlined),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              itemCount: storyImages.length + 1, // +1 for "Your story"
              itemBuilder: (context, index) {
                if (index == 0) {
                  // "Your story" section
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      children: [
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            const CircleAvatar(
                              radius: 48,
                              backgroundImage: NetworkImage(
                                'https://images.unsplash.com/photo-1761839258044-e59f324b5a7f?ixlib=rb-4.1.0&auto=format&fit=crop&q=60&w=900',
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 2,
                              child: Container(
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                padding: const EdgeInsets.all(3),
                                child: const Icon(
                                  Icons.add,
                                  color: Colors.black,
                                  size: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          "Your story",
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        ),
                      ],
                    ),
                  );
                } else {
                  final imageUrl = storyImages[index - 1]; // adjust index
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [
                                Color.fromARGB(255, 228, 71, 189),
                                Color.fromARGB(255, 245, 73, 118),
                                Color.fromARGB(255, 243, 188, 35),
                              ],
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                            ),
                          ),
                          padding: const EdgeInsets.all(3),
                          child: CircleAvatar(
                            radius: 48,
                            backgroundImage: NetworkImage(imageUrl),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "user$index",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
          // Post section
          // const Expanded(child: PostSection()),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('posts')
                  .orderBy('datePublished', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) => PostSection(
                    snap: snapshot.data!.docs[index],
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
