import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:instagram_clone/models/post.dart';
import 'package:instagram_clone/resources/storage_methods.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Upload post to Firestore with image in Supabase
  Future<String> uploadPost(
    String description,
    Uint8List file,
    String uid,
    String username,
    String profImage,
  ) async {
    String res = "Some error occurred";
    try {
      // Upload image to Supabase
      String photoUrl = await StorageMethods().uploadImageToStorage(
        'insta-images',
        file,
        true,
      );
      String postId = const Uuid().v1();
      Post post = Post(
        username: username,
        uid: uid,
        postId: postId,
        description: description,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profImage: profImage,
        likes: [],
      );

      await _firestore.collection('posts').doc(postId).set(post.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
  // like post
  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
  // post comment
  Future<void> postComment(
  String text,
  String postId,
  String uid,
  String name,
  String profilepic,
) async {
  try {
    if (text.isNotEmpty) {
      String commentId = const Uuid().v1();

      // Add comment document
      await _firestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .doc(commentId)
          .set({
        'profile pic': profilepic,
        'name': name,
        'uid': uid,
        'text': text,
        'commentId': commentId,
        'datePublished': DateTime.now(),
      });

      // Update comment count in the post document
      await _firestore.collection('posts').doc(postId).update({
        'commentCount': FieldValue.increment(1),
      });

    } else {
      print('Text is Empty');
    }
  } catch (e) {
    print(e.toString());
  }
}


  // delete post
  Future<void> deletePost(String postId) async{
    try{
     await _firestore.collection('posts').doc(postId).delete();
    }catch(e){
      print(e.toString());
    }
  }

  
}
