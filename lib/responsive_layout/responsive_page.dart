import 'package:flutter/material.dart';
import 'package:instagram_clone/provider/user_provider.dart';
// import 'package:instagram_clone/responsive_layout/mobile_screen_layout.dart';
// import 'package:instagram_clone/responsive_layout/web_screen_layout.dart';
import 'package:instagram_clone/utils/global_variable.dart';
import 'package:provider/provider.dart';

class ResponsivePage extends StatefulWidget {
  final Widget webscreenlayout;
  final Widget mobilescreenlayout;
  const ResponsivePage({
    Key? key,
    required this.mobilescreenlayout,
    required this.webscreenlayout,
  }) : super(key: key);

  @override
  State<ResponsivePage> createState() => _ResponsivePageState();
}

class _ResponsivePageState extends State<ResponsivePage> {

  @override
  void initState() {
    super.initState();
    addData();
  }

    addData() async{
      UserProvider _userProvider = Provider.of(context, listen: false);
      await _userProvider.refreshUser();
    }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context,constraints){
      if(constraints.maxWidth>webscreensize){
        return widget.webscreenlayout;
      }else{
        return widget.mobilescreenlayout;
      }
    },);
  }
}