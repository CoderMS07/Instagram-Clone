import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/resources/auth_methods.dart';
import 'package:instagram_clone/screens/login_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:instagram_clone/widgets/text_field_input.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreen();
}

class _SignUpScreen extends State<SignUpScreen> {
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  final TextEditingController _biocontroller = TextEditingController();
  final TextEditingController _usernamecontroller = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;
  @override
  void dispose() {
    super.dispose();
    _emailcontroller.dispose();
    _passwordcontroller.dispose();
    _usernamecontroller.dispose();
    _biocontroller.dispose();
  }

  void signupuser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().SignUpUser(
      email: _emailcontroller.text,
      password: _passwordcontroller.text,
      username: _usernamecontroller.text,
      bio: _biocontroller.text,
      file: _image!,
    );
    setState(() {
      _isLoading = false;
    });

    if (res != "success") {
      showSnackBar(res, context);
    }
  }

  void selectimagefromgallery() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.arrow_back, color: Colors.white),
                  ),
                ],
              ),
              Flexible(flex: 2, child: Container()),
              // instagram logo
              SvgPicture.asset(
                'assets/images/ic_instagram.svg',
                color: primaryColor,
                height: 64,
              ),
              const SizedBox(height: 32),
              // circular widget to accept avatar
              Stack(
                children: [
                  _image != null
                      ? CircleAvatar(
                          radius: 48,
                          backgroundImage: MemoryImage(_image!),
                        )
                      : const CircleAvatar(
                          radius: 48,
                          backgroundImage: NetworkImage(
                            'https://i.pinimg.com/736x/82/85/96/828596ef925a10e8c1a76d3a3be1d3e5.jpg',
                          ),
                        ),
                  Positioned(
                    left: 60,
                    bottom: -10,
                    child: IconButton(
                      onPressed: () {
                        selectimagefromgallery();
                      },
                      icon: Icon(Icons.add_a_photo),
                      color: blueColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              // text field for usename
              TextFieldInput(
                hintText: 'Enter your username',
                textEditingController: _usernamecontroller,
                textInputType: TextInputType.text,
              ),
              const SizedBox(height: 24),
              // text field for bio
              TextFieldInput(
                hintText: 'Enter your bio',
                textEditingController: _biocontroller,
                textInputType: TextInputType.text,
              ),
              const SizedBox(height: 24),
              // text field for email
              TextFieldInput(
                hintText: 'Enter your email',
                textEditingController: _emailcontroller,
                textInputType: TextInputType.emailAddress,
              ),
              // text field for password
              const SizedBox(height: 24),
              TextFieldInput(
                hintText: 'Enter your password',
                textEditingController: _passwordcontroller,
                textInputType: TextInputType.text,
                isPass: true,
              ),
              const SizedBox(height: 24),
              // login button
              InkWell(
                onTap: () {
                  signupuser();
                },
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    color: blueColor,
                  ),
                  child: _isLoading
                      ? Center(child: CircularProgressIndicator(color: primaryColor))
                      : Text('Sign up'),
                ),
              ),
              const SizedBox(height: 12),
              Flexible(flex: 2, child: Container()),
              // signup method
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text("Already have an account?"),
                  ),
                  SizedBox(width: 5),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        "Sign in.",
                        style: TextStyle(
                          color: blueColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
