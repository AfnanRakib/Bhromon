import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:bhromon/pages/login.dart';
import 'package:bhromon/pages/signup.dart';
import 'package:bhromon/helpers/const.dart';


class StartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  FadeInUp(duration: Duration(milliseconds: 1000), child:Text("Welcome", style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30
                  ),)),
                  SizedBox(height: 20,),
                  FadeInUp(duration: Duration(milliseconds: 1200), child: Text("Automatic identity verification which enables you to verify your identity",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 15
                    ),)),
                ],
              ),
              FadeInUp(duration: Duration(milliseconds: 1400), child: Container(
                height: MediaQuery.of(context).size.height / 3,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/Illustration.png')
                    )
                ),
              )),
              Column(
                children: <Widget>[
                  FadeInUp(duration: Duration(milliseconds: 1500), child: MaterialButton(
                    minWidth: double.infinity,
                    height: 60,
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                    shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color: Colors.black
                        ),
                        borderRadius: BorderRadius.circular(50)
                    ),
                    child: Text("Login", style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18
                    ),),
                  )),
                  SizedBox(height: 20,),
                  FadeInUp(duration: Duration(milliseconds: 1600), child: Container(
                    //padding: EdgeInsets.only(top: 3, left: 3),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border(
                          bottom: BorderSide(color: Colors.black),
                          top: BorderSide(color: Colors.black),
                          left: BorderSide(color: Colors.black),
                          right: BorderSide(color: Colors.black),
                        )
                    ),
                    child: MaterialButton(
                      minWidth: double.infinity,
                      height: 60,
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => SignupPage()));
                      },
                      color: ColorSys.secoundryLight,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)
                      ),
                      child: Text("Sign up", style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18
                      ),),
                    ),
                  ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class IntroPage extends StatefulWidget {
  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  late PageController _pageController;
  int currentIndex = 0;

  @override
  void initState() {
    _pageController = PageController(
        initialPage: 0
    );
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20, top: 20),
            child: TextButton(
              onPressed: (){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> StartPage()),);
              },
              child: Text(
                 'Skip', style: TextStyle(
                   color: ColorSys.secoundry,
                   fontSize: 18,
                   fontWeight: FontWeight.w600
                ),
               ),
            ),
          )
        ],
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          PageView(
            onPageChanged: (int page) {
              setState(() {
                currentIndex = page;
              });
            },
            controller: _pageController,
            children: <Widget>[
              makePage(
                  image: 'assets/step-one.png',
                  title: Strings.stepOneTitle,
                  content: Strings.stepOneContent
              ),
              makePage(
                  reverse: true,
                  image: 'assets/step-two.png',
                  title: Strings.stepTwoTitle,
                  content: Strings.stepTwoContent
              ),
              makePage(
                  image: 'assets/step-three.png',
                  title: Strings.stepThreeTitle,
                  content: Strings.stepThreeContent
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(bottom: 60),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _buildIndicator(),
            ),
          )
        ],
      ),
    );
  }

  Widget makePage({image, title, content, reverse = false}) {
    return Container(
      padding: EdgeInsets.only(left: 50, right: 50, bottom: 60),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          !reverse ?
          Column(
            children: <Widget>[
              FadeInUp(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Image.asset(image),
                ),
              ),
              SizedBox(height: 30,),
            ],
          ) : SizedBox(),
          FadeInUp(
              duration: Duration(milliseconds: 900),
              child: Text(title, style: TextStyle(
                  color: ColorSys.primary,
                  fontSize: 30,
                  fontWeight: FontWeight.bold
              ),)),
          SizedBox(height: 20,),
          FadeInUp(
              duration: Duration(milliseconds: 1200),
              child: Text(content, textAlign: TextAlign.center, style: TextStyle(
                  color: ColorSys.gray,
                  fontSize: 20,
                  fontWeight: FontWeight.w400
              ),)),
          reverse ?
          Column(
            children: <Widget>[
              SizedBox(height: 30,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Image.asset(image),
              ),
            ],
          ) : SizedBox(),
        ],
      ),
    );
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: 6,
      width: isActive ? 30 : 6,
      margin: EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
          color: ColorSys.secoundry,
          borderRadius: BorderRadius.circular(5)
      ),
    );
  }

  List<Widget> _buildIndicator() {
    List<Widget> indicators = [];
    for (int i = 0; i<3; i++) {
      if (currentIndex == i) {
        indicators.add(_indicator(true));
      } else {
        indicators.add(_indicator(false));
      }
    }

    return indicators;
  }

}
