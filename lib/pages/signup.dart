import 'package:animate_do/animate_do.dart';
import 'package:bhromon/pages/login.dart';
import 'package:bhromon/pages/startpages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bhromon/helpers/const.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupPage extends StatefulWidget {
  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController countryController = TextEditingController();

  late User currentUser;
  Future addUserDetails(String email,String name,String country, String UID) async{
    await FirebaseFirestore.instance.collection('users').add(
      {
        'email':email,
        'name':name,
        'country':country,
        'uid':UID,
      }
    );
  }

  Future<void> signUp() async {
    if(passwordController.text==confirmPasswordController.text) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        currentUser = FirebaseAuth.instance.currentUser!;
        print(currentUser.uid);
        addUserDetails(emailController.text, nameController.text, countryController.text,currentUser.uid);
        showDialog(
          context: context,
          builder: (context){
            return AlertDialog(
              alignment: Alignment.center,
              title: Text("Account Created", style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18
              ),
                textAlign: TextAlign.center,
              ),
            );
          },
        );
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> StartPage()),);
      } on FirebaseAuthException catch (e) {
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
    else{
      showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            alignment: Alignment.center,
            title: Text("Confirmation Password didn't matched", style: TextStyle(
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
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 40),
          height: MediaQuery.of(context).size.height - 50,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: <Widget>[
                  FadeInUp(
                    duration: Duration(milliseconds: 1000),
                    child: Text(
                      "Sign up",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  FadeInUp(
                    duration: Duration(milliseconds: 1200),
                    child: Text(
                      "Create an account, It's free",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  FadeInUp(
                    duration: Duration(milliseconds: 1200),
                    child: makeInput(label: "Email", fieldController: emailController),
                  ),
                  FadeInUp(
                    duration: Duration(milliseconds: 1300),
                    child: makeInput(label: "Password", fieldController: passwordController, obscureText: true),
                  ),
                  FadeInUp(
                    duration: Duration(milliseconds: 1400),
                    child: makeInput(label: "Confirm Password", fieldController: confirmPasswordController, obscureText: true),
                  ),
                  FadeInUp(
                    duration: Duration(milliseconds: 1400),
                    child: makeInput(label: "Name", fieldController: nameController, obscureText: true),
                  ),
                  FadeInUp(
                    duration: Duration(milliseconds: 1400),
                    child: makeInput(label: "Country", fieldController: countryController, obscureText: true),
                  ),
                ],
              ),
              FadeInUp(
                duration: Duration(milliseconds: 1500),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: Colors.black),
                  ),
                  child: MaterialButton(
                    minWidth: double.infinity,
                    height: 60,
                    onPressed: signUp,
                    color: ColorSys.secoundryLight,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                    child: Text(
                      "Sign up",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
              FadeInUp(
                duration: Duration(milliseconds: 1600),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Already have an account?"),
                    GestureDetector(
                      onTap: (){
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> LoginPage()),);
                      },
                      child: Text(" Log In", style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 18
                      ),),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget makeInput({label, fieldController, obscureText = false}) {
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
          obscureText: obscureText,
          controller: fieldController,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
          ),
        ),
        SizedBox(height: 30),
      ],
    );
  }
}
