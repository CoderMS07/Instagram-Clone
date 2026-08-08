
import 'dart:typed_data';
import 'package:instagram_clone/models/User.dart' as model;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_clone/resources/storage_methods.dart' show StorageMethods;

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User currentUser=_auth.currentUser!;
    DocumentSnapshot snap = await _firestore.collection('users').doc(currentUser.uid).get();
    return model.User.fromSnap(snap);
  }

  // sign up
  Future<String> SignUpUser({
  required String email,
  required String password,
  required String username,
  required String bio,
  required Uint8List file,
}) async {
  String res = "Some error occured";
  try {
    if (email.isNotEmpty && password.isNotEmpty && username.isNotEmpty && bio.isNotEmpty) {
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print("Auth user created: ${cred.user!.uid}");

      try {
        final StorageMethods _storageMethods = StorageMethods();
        final String imageUrl = await _storageMethods.uploadImageToStorage(
          'insta-images',
          file,
          false,
        );
        print("Image uploaded: $imageUrl");

        model.User user = model.User(
          username: username,
          uid: cred.user!.uid,
          photoUrl: imageUrl,
          email: email,
          bio: bio,
          followers: [],
          following: [],
        );

        await _firestore.collection('users').doc(cred.user!.uid).set(user.toJson());
        print("Firestore doc created for: ${cred.user!.uid}");
        res = "success";
      } catch (innerErr) {
        // Something failed after the auth account was created — roll it back
        // so we don't leave an orphaned account behind.
        print("Signup failed after auth creation, rolling back: $innerErr");
        await cred.user!.delete();
        res = "Signup failed: $innerErr";
      }
    } else {
      res = "Please fill all the fields";
    }
  } catch (err) {
    print("SignUp error: $err");
    res = err.toString();
  }
  return res;
}

  Future<String> loginUser({
    required String email,
    required String password,
  }) async{
    String res = "Some error occured";
    try{
      if(email.isNotEmpty && password.isNotEmpty){
        // login user
        await _auth.signInWithEmailAndPassword(email: email, password: password);
        res="success";
      }else{
        res = "Please enter all the fields";
      }
    }catch(err){
      res = err.toString();
    }
    return res;
  }

  Future<void> signout() async{
    await _auth.signOut();
  }
}
