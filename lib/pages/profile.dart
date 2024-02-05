import 'package:bhromon/helpers/const.dart';
import 'package:bhromon/pages/Tools.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final countryController = TextEditingController();

  Future<void> getUserDetails() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('uid', isEqualTo: currentUser.currentUser!.uid)
          .get();

      if (snapshot.docs.isNotEmpty) {
        var data = snapshot.docs[0].data() as Map<String, dynamic>?;

        if (data != null && data.containsKey('email') && data.containsKey('name')) {
          setState(() {
            emailController.text = data['email'].toString();
            nameController.text = data['name'].toString();
            countryController.text = data['country'].toString() ?? '';
          });
        } else {
          print('Error: Missing or invalid data keys');
        }
      } else {
        print('Error: No data available');
      }
    } catch (e) {
      print('Error fetching user details: $e');
    }
  }

  void passReset() async{
    try{
      await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text.trim(),);
      showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            alignment: Alignment.center,
            title: Text("Password Reset Email Sent", style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18
            ),
              textAlign: TextAlign.center,
            ),
          );
        },
      );
    }on FirebaseAuthException catch(e){
      showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            alignment: Alignment.center,
            title: Text(e.message.toString(), style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18
            ),
              textAlign: TextAlign.center,
            ),
          );
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    getUserDetails();
  }

  final currentUser = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Tools(),
      appBar: AppBar(),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height / 3,
                    width: MediaQuery.of(context).size.width / 2,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/profile.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      children: <Widget>[
                        makeInput(
                            label: "Email",
                            fieldController: emailController,
                            readOnly: true),
                        makeInput(
                            label: "Name",
                            fieldController: nameController,
                            readOnly: true),
                        makeInput(
                            label: "Country",
                            fieldController: countryController,
                            readOnly: true),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: passReset,
                    child: Text("Reset Password", style: TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 18
                    ),),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget makeInput(
      {label, fieldController, obscureText = false, readOnly = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 5),
        TextField(
          readOnly: readOnly,
          obscureText: obscureText,
          controller: fieldController,
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
          ),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          ),
        ),
        SizedBox(height: 30),
      ],
    );
  }
}
