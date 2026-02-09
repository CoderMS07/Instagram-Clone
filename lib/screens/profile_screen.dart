import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagram_clone/resources/auth_methods.dart';
import 'package:instagram_clone/screens/login_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({super.key, required this.uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  int postLen = 0;
  int follower = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var usersnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      // get post length

      var postsnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: widget.uid)
          .get();
      postLen = postsnap.docs.length;
      follower = usersnap.data()!['followers'].length;
      following = usersnap.data()!['following'].length;
      isFollowing = usersnap.data()!['followers'].contains(
        FirebaseAuth.instance.currentUser!.uid,
      );
      userData = usersnap.data()!;
      setState(() {});
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    int postCount = postLen;
    int followersCount = follower;
    int followingCount = following;

    // final List<String> storyImages = [
    //   "https://images.unsplash.com/photo-1607746882042-944635dfe10e?w=900",
    //   "https://images.unsplash.com/photo-1503023345310-bd7c1de61c7d?w=900",
    //   "https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=900",
    //   "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=900",
    // ];

    // final List<String> postImages = [
    //   "https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=800",
    //   "https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?w=800",
    //   "https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=800",
    //   "https://images.unsplash.com/photo-1503023345310-bd7c1de61c7d?w=800",
    //   "https://images.unsplash.com/photo-1544723795-3fb6469f5b39?w=800",
    //   "https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=800",
    //   "https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=800",
    //   "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=800",
    //   "https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=800",
    // ];

    return isLoading
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
            backgroundColor: mobileBackgroundColor,
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              elevation: 0,
              title: SvgPicture.asset('assets/images/ic_instagram.svg', color: primaryColor,height: 32,),
              actions: const [
                Icon(Icons.add_box_outlined),
                SizedBox(width: 16),
                Icon(Icons.menu),
                SizedBox(width: 10),
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  //  Profile Info Section
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            CircleAvatar(
                              radius: 48,
                              backgroundImage: NetworkImage(
                                userData['photoUrl'],
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
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //  Username above stats
                              Text(
                                '    ${userData['username']}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 6),

                              //  Stats row aligned horizontally
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  _buildStat("Posts", postCount),
                                  _buildStat("Followers", followersCount),
                                  _buildStat("Following", followingCount),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  //  Username and Bio
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        userData['username'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        userData['bio'],
                        style: TextStyle(fontSize: 14, height: 1.4),
                      ),
                    ),
                  ),
                  // Edit / Follow / Unfollow Button
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child:
                              widget.uid ==
                                  FirebaseAuth.instance.currentUser!.uid
                              // Sign-out button
                              ? OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(
                                      color: secondaryColor,
                                    ),
                                  ),
                                  onPressed: () async {
                                    await AuthMethods().signout();
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (context) => LoginScreen(),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    "Sign Out",
                                    style: TextStyle(color: primaryColor),
                                  ),
                                )
                              : isFollowing
                              ? ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: mobileBackgroundColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      side: const BorderSide(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    minimumSize: const Size(
                                      double.infinity,
                                      40,
                                    ),
                                  ),
                                  onPressed: () async {
                                    // Unfollow logic
                                    await FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(
                                          FirebaseAuth
                                              .instance
                                              .currentUser!
                                              .uid,
                                        )
                                        .update({
                                          'following': FieldValue.arrayRemove([
                                            widget.uid,
                                          ]),
                                        });

                                    await FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(widget.uid)
                                        .update({
                                          'followers': FieldValue.arrayRemove([
                                            FirebaseAuth
                                                .instance
                                                .currentUser!
                                                .uid,
                                          ]),
                                        });

                                    setState(() {
                                      isFollowing = false;
                                      follower--;
                                    });
                                  },
                                  child: const Text(
                                    "Unfollow",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              : ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    minimumSize: const Size(
                                      double.infinity,
                                      40,
                                    ),
                                  ),
                                  onPressed: () async {
                                    // Follow logic
                                    await FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(
                                          FirebaseAuth
                                              .instance
                                              .currentUser!
                                              .uid,
                                        )
                                        .update({
                                          'following': FieldValue.arrayUnion([
                                            widget.uid,
                                          ]),
                                        });

                                    await FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(widget.uid)
                                        .update({
                                          'followers': FieldValue.arrayUnion([
                                            FirebaseAuth
                                                .instance
                                                .currentUser!
                                                .uid,
                                          ]),
                                        });

                                    setState(() {
                                      isFollowing = true;
                                      follower++;
                                    });
                                  },
                                  child: const Text(
                                    "Follow",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                        ),
                        const SizedBox(width: 8),
                        // Optional secondary button (for add person icon)
                        if (widget.uid ==
                            FirebaseAuth.instance.currentUser!.uid)
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: secondaryColor),
                              minimumSize: const Size(40, 40),
                            ),
                            onPressed: () {},
                            child: const Icon(
                              Icons.person_add,
                              color: primaryColor,
                            ),
                          ),
                      ],
                    ),
                  ),
                  const Divider(color: mobileBackgroundColor),

                  // Posts Grid
                  FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('posts')
                        .where('uid', isEqualTo: widget.uid)
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      return GridView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 3,
                              mainAxisSpacing: 3,
                              childAspectRatio: 1,
                            ),

                        itemBuilder: (context, index) {
                          DocumentSnapshot snap = snapshot.data!.docs[index];

                          return Container(
                            child: Image(
                              image: NetworkImage(snap['postUrl']),
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          );
  }

  Widget _buildStat(String label, int count) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          count.toString(),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        Text(label, style: const TextStyle(fontSize: 13)),
      ],
    );
  }
}
