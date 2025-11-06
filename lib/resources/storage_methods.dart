import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class StorageMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Upload image to Supabase Storage
  Future<String> uploadImageToStorage(String bucketName, Uint8List file, bool isPost) async {
    try {
      // Get current user ID from Firebase Auth
      final String uid = _auth.currentUser!.uid;
      final String id = const Uuid().v1(); // Unique ID for each upload
      final String path = isPost ? '$uid/posts/$id.jpg' : '$uid/profile.jpg';

      // Upload to Supabase Storage
      final response = await _supabase.storage
          .from(bucketName)
          .uploadBinary(path, file, fileOptions: const FileOptions(upsert: true));

      if (response.isEmpty) {
        throw Exception('Failed to upload image.');
      }

      // Get public URL of uploaded image
      final String publicUrl = _supabase.storage.from(bucketName).getPublicUrl(path);

      return publicUrl;
    } catch (e) {
      print('Error uploading to Supabase: $e');
      rethrow;
    }
  }
}
