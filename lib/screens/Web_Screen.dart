import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/utils/colors.dart';

class WebHomeScreen extends StatefulWidget {
  const WebHomeScreen({super.key});

  @override
  State<WebHomeScreen> createState() => _WebHomeScreenState();
}

class _WebHomeScreenState extends State<WebHomeScreen> {
  // Dummy post data
  final List<Map<String, String>> posts = [
    {
      "username": "flutter_dev",
      "profilePic":
          "https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?w=900",
      "imageUrl":
          "https://images.unsplash.com/photo-1606787366850-de6330128bfc?w=900",
      "caption": "Building cool UIs with Flutter ",
    },
    {
      "username": "tech_girl",
      "profilePic":
          "https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=900",
      "imageUrl":
          "https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=900",
      "caption": "Exploring Dart and Flutter ",
    },
    {
      "username": "code_master",
      "profilePic":
          "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=900",
      "imageUrl":
          "https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=900",
      "caption": "Design. Code. Repeat ",
    },
  ];

  // Track which sidebar item is selected
  int selectedIndex = 0;

  // Sidebar items
  final List<Map<String, dynamic>> navItems = [
    {"icon": Icons.home_filled, "label": "Home"},
    {"icon": Icons.search, "label": "Search"},
    {"icon": Icons.explore_outlined, "label": "Explore"},
    {"icon": Icons.movie_outlined, "label": "Reels"},
    {"icon": Icons.message_outlined, "label": "Messages"},
    {"icon": Icons.favorite_border, "label": "Notifications"},
    {"icon": Icons.add_box_outlined, "label": "Create"},
    {"icon": Icons.person_outline, "label": "Profile"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mobileBackgroundColor,
      body: Row(
        children: [
          // 🔹 Left Sidebar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
            width: 250,
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(color: Colors.grey.withOpacity(0.3)),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  'assets/images/ic_instagram.svg',
                  color: primaryColor,
                  height: 35,
                ),
                const SizedBox(height: 30),

                // Navigation Items (Clickable)
                ...List.generate(
                  navItems.length,
                  (index) {
                    final item = navItems[index];
                    final isSelected = selectedIndex == index;
                    return _buildNavItem(
                      item["icon"],
                      item["label"],
                      isSelected,
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                    );
                  },
                ),

                const Spacer(),
                const Divider(color: mobileBackgroundColor),
                _buildNavItem(Icons.more_horiz_outlined, "More", false),
                _buildNavItem(Icons.new_label_rounded, "Also from Meta", false)
              ],
            ),
          ),

          //  Center Feed Section with Stories
          Expanded(
            flex: 2,
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
              children: [
                // Story Section
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF9B2282),
                                    Color(0xFFEEA863),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: CircleAvatar(
                                radius: 36,
                                backgroundImage: NetworkImage(
                                  'https://images.unsplash.com/photo-${index + 1500000000000}-bd7c1de61c7d?w=200',
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              index == 0 ? "Your Story" : "user_$index",
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 30),

                // Feed Section
                ...posts.map((post) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 40),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.withOpacity(0.3)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Post Header
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundImage:
                                    NetworkImage(post["profilePic"]!),
                                radius: 20,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                post["username"]!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const Spacer(),
                              const Icon(Icons.more_vert),
                            ],
                          ),
                        ),

                        // Post Image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Image.network(
                            post["imageUrl"]!,
                            width: double.infinity,
                            height: 400,
                            fit: BoxFit.cover,
                          ),
                        ),

                        // Post Actions
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          child: Row(
                            children: const [
                              Icon(Icons.favorite_border_outlined, size: 28),
                              SizedBox(width: 12),
                              Icon(Icons.mode_comment_outlined, size: 26),
                              SizedBox(width: 12),
                              Icon(Icons.send_outlined, size: 26),
                              Spacer(),
                              Icon(Icons.bookmark_border, size: 28),
                            ],
                          ),
                        ),

                        // Post Caption
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: RichText(
                            text: TextSpan(
                              style: const TextStyle(color: Colors.white),
                              children: [
                                TextSpan(
                                  text: post["username"]! + " ",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                TextSpan(
                                  text: post["caption"]!,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          ),

          // Right Sidebar (Suggestions)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Summary
                  Row(
                    children: const [
                      CircleAvatar(
                        radius: 25,
                        backgroundImage: NetworkImage(
                          'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?w=900',
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        "flutter_dev",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Suggested for you",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildSuggestionTile("tech_girl"),
                  _buildSuggestionTile("code_master"),
                  _buildSuggestionTile("ui_designer"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Sidebar item widget (clickable)
  Widget _buildNavItem(IconData icon, String label, bool selected,
      {VoidCallback? onTap}) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(
              icon,
              color: selected ? Colors.white : Colors.grey[400],
              size: 28,
            ),
            const SizedBox(width: 20),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: selected ? Colors.white : Colors.grey[400],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //  Suggestion tile on right sidebar
  Widget _buildSuggestionTile(String username) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 18,
            backgroundImage: NetworkImage(
              'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=900',
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              username,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          TextButton(
            onPressed: () {},
            child: const Text(
              "Follow",
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }
}
