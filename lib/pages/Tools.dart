import 'package:bhromon/helpers/const.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Tools extends StatefulWidget {
  const Tools({super.key});

  @override
  State<Tools> createState() => _ToolsState();
}

class _ToolsState extends State<Tools> {

  Future<void> _launchUrl(String s) async {
    Uri _url= Uri.parse(s);
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(20.0),
            child: MaterialButton(
              minWidth: double.infinity,
              height: 60,
              onPressed: () {
                _launchUrl('https://gozayaan.com/?search=flight');
              },
              color: ColorSys.secoundryLight,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)
              ),
              child: Text("Flight", style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18
              ),),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20.0),
            child: MaterialButton(
              minWidth: double.infinity,
              height: 60,
              onPressed: () {
                _launchUrl('https://gozayaan.com/?search=hotel');
              },
              color: ColorSys.secoundryLight,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)
              ),
              child: Text("Hotel", style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18
              ),),
            ),
          ),
        ],
      ),
    );
  }
}
