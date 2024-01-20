import 'package:animate_do/animate_do.dart';
import 'package:bhromon/gptMain/gpt_Main.dart';
import 'package:bhromon/pages/Tools.dart';
import 'package:bhromon/pages/maps.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:bhromon/pages/home.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late PageController _pageController;
  int _page = 0;
  final user=FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeInUp(duration: Duration(milliseconds: 1000), child: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        onPageChanged: onPageChanged,
        children: List.generate(4, (index) => getPage(index)),
      ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SizedBox(width: 7.0),
            barIcon(icon: Icons.home, page: 0),
            barIcon(icon: Icons.explore, page: 1),
            barIcon(icon: Icons.messenger, page: 2,),
            barIcon(icon: Icons.window, page: 3),
            SizedBox(width: 7.0),
          ],
        ),
        color: Theme.of(context).primaryColor,
      ),
    );
  }

  Widget getPage(int index) {
    switch (index) {
      case 0:
        return Home();
      case 1:
        return Container();//Maps();
      case 2:
        return Container();//bhromon_gpt();
      case 3:
        return Tools();
      default:
        return Container();
    }
  }

  void navigationTapped(int page) {
    _pageController.jumpToPage(page);
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  void onPageChanged(int page) {
    setState(() {
      this._page = page;
    });
  }

  Widget barIcon({IconData icon = Icons.home, int page = 0,}) {
    return IconButton(
      icon: Icon(icon, size: 24.0),
      color: _page == page ? Color.fromRGBO(90, 185, 141, 1): Colors.blueGrey,
      onPressed: () {
        _pageController.jumpToPage(page);
      },
    );
  }
}
