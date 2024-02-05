import 'package:bhromon/helpers/const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Tools extends StatefulWidget {
  const Tools({Key? key});

  @override
  State<Tools> createState() => _ToolsState();
}

class _ToolsState extends State<Tools> {
  Future<void> _launchUrl(String s) async {
    Uri _url = Uri.parse(s);
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  final currentUser = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .where('uid', isEqualTo: currentUser.currentUser!.uid)
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                var data = snapshot.data!.docs[0].data() as Map<String, dynamic>?;

                if (data != null &&
                    data.containsKey('email') &&
                    data.containsKey('name')) {
                  return UserAccountsDrawerHeader(
                    accountName: Stack(
                      children: <Widget>[
                        // Stroked text as border.
                        Text(
                          data['name'].toString(),
                          style: TextStyle(
                            fontFamily: 'Open Sans',
                            fontSize: 40,
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 6
                              ..color = Colors.black12,
                          ),
                        ),
                        // Solid text as fill.
                        Text(
                          data['name'].toString(),
                          style: TextStyle(
                            fontFamily: 'Open Sans',
                            fontSize: 40,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    accountEmail: Stack(
                      children: <Widget>[
                        // Stroked text as border.
                        Text(
                          data['email'].toString(),
                          style: TextStyle(
                            fontSize: 20,
                            fontStyle: FontStyle.italic,
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 2
                              ..color = Colors.black12,
                          ),
                        ),
                        // Solid text as fill.
                        Text(
                          data['email'].toString(),
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(
                      color: ColorSys.secoundryLight,
                    ),
                  );
                } else {
                  return Text('Error: Missing or invalid data keys');
                }
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return LinearProgressIndicator();
              } else {
                return Text('Error: No data available');
              }
            },
          ),
          Expanded(
            child: Center(
              child: Column(
                children: <Widget>[
                  buildCard(
                    title: "Flight Booking",
                    icon: Icons.flight,
                    color: ColorSys.secoundryLight,
                    url: 'https://gozayaan.com/?search=flight',
                  ),
                  buildCard(
                    title: "Hotel Booking",
                    icon: Icons.hotel,
                    color: ColorSys.secoundryLight,
                    url: 'https://gozayaan.com/?search=hotel',
                  ),
                  buildCard(
                    title: "Google Translator",
                    icon: Icons.translate,
                    color: ColorSys.secoundryLight,
                    url: 'https://translate.google.com/',
                  ),
                  buildCard(
                    title: "Sign Out",
                    icon: Icons.logout,
                    color: ColorSys.secoundryLight,
                    url: "",
                    onTap: () {
                      FirebaseAuth.instance.signOut();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCard({
    required String title,
    required IconData icon,
    required Color color,
    required String url,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Card(
        elevation: 5,
        child: ListTile(
          onTap: onTap != null ? () => onTap() : () => _launchUrl(url),
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          leading: Icon(
            icon,
            color: color,
            size: 40,
          ),
        ),
      ),
    );
  }
}
