import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/resources/auth_methods.dart' show AuthMethods;
import 'package:instagram_clone/responsive_layout/mobile_screen_layout.dart'
    show MobileScreen;
import 'package:instagram_clone/responsive_layout/responsive_page.dart'
    show ResponsivePage;
import 'package:instagram_clone/responsive_layout/web_screen_layout.dart'
    show WebScreen;
import 'package:instagram_clone/screens/Sign_up_screen.dart';
// import 'package:instagram_clone/screens/mobile_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/global_variable.dart';
import 'package:instagram_clone/utils/utils.dart' show showSnackBar;
import 'package:instagram_clone/widgets/text_field_input.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  bool _isLoading = false;

  void loginUser() async {
    setState(() {
      _isLoading = true;
    });

    String res = await AuthMethods().loginUser(
      email: _emailcontroller.text.trim(),
      password: _passwordcontroller.text.trim(),
    );

    if (!mounted) return;

    if (res == 'success') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const ResponsivePage(
            mobilescreenlayout: MobileScreen(),
            webscreenlayout: WebScreen(),
          ),
        ),
      );
    } else {
      showSnackBar(res, context);
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _emailcontroller.dispose();
    _passwordcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: MediaQuery.of(context).size.width > webscreensize
              ? EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width / 3,
                )
              : EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(flex: 2, child: Container()),
              // instagram logo
              SvgPicture.asset(
                'assets/images/ic_instagram.svg',
                color: primaryColor,
                height: 64,
              ),
              const SizedBox(height: 64),
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
                  // login user
                  loginUser();
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
                      ? Center(
                          child: CircularProgressIndicator(color: primaryColor),
                        )
                      : Text('Log in'),
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
                    child: Text("Don't have an account?"),
                  ),
                  SizedBox(width: 5),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpScreen()),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        "Sign up.",
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
