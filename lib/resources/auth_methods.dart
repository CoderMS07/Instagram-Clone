
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
  }) async{
    String res = "Some error occured";
    try{
      if(email.isNotEmpty && password.isNotEmpty && username.isNotEmpty && bio.isNotEmpty){
        
        UserCredential cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
        print(cred.user!.uid);

        
        final StorageMethods _storageMethods = StorageMethods();

        final String imageUrl = await _storageMethods.uploadImageToStorage(
          'insta-images', 
          file,           
          false,          
        );

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
        res="success";
      }
    }catch(err){
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
