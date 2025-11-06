import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/firebase_options.dart' show DefaultFirebaseOptions;
import 'package:instagram_clone/provider/user_provider.dart';
import 'package:instagram_clone/responsive_layout/mobile_screen_layout.dart';
import 'package:instagram_clone/responsive_layout/responsive_page.dart';
import 'package:instagram_clone/responsive_layout/web_screen_layout.dart';
import 'package:instagram_clone/screens/login_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
   await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize Supabase
  await Supabase.initialize(
    url: 'https://bhnclrxtbiuonfntxcpy.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJobmNscnh0Yml1b25mbnR4Y3B5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjEzMTgyNDEsImV4cCI6MjA3Njg5NDI0MX0.1D2aaWkt7ZZBEdp5fZX1Nd-TsreGPEBEMgbR4Ic2_j8',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider())
      ],
      child: MaterialApp(
        title: 'Instagram Clone',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: mobileBackgroundColor,
        ),
        home: const AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Show loading while checking auth state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: primaryColor),
          );
        }

        // If user is logged in
        if (snapshot.hasData) {
          return const ResponsivePage(
            mobilescreenlayout: MobileScreen(),
            webscreenlayout: WebScreen(),
          );
        }

        // If user is NOT logged in
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        return const LoginScreen();
      },
    );
  }
}
