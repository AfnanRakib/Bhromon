import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:bhromon/helpers/AttractionModel.dart';
import 'package:bhromon/helpers/horizontal_place_item.dart';
import 'package:bhromon/helpers/vertical_place_item.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _searchControl = TextEditingController();

  List<Attraction> attractions = [];
  String latitude = '12.235588';
  String longitude = '109.19553';

  @override
  void initState() {
    super.initState();
    _readAttractionsFromFile();
    //_fetchAttractions();
  }

  Future<void> _fetchAttractions() async {
    try {
      final Uri uri = Uri.parse('https://travel-advisor.p.rapidapi.com/attractions/list-by-latlng').replace(queryParameters: {
        'longitude': longitude,
        'latitude': latitude,
        'lunit': 'km',
        'currency': 'BDT',
        'limit': '8',
        'lang': 'en_US',
      });

      final Map<String, String> headers = {
        'X-RapidAPI-Key': '58db07e382mshb0ba8bdce54360ap16822djsnd7382ff19b11',
        'X-RapidAPI-Host': 'travel-advisor.p.rapidapi.com',
      };

      final http.Response response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonMap = json.decode(response.body);

        List<Attraction> fetchedAttractions = [];
        for (var data in jsonMap['data']) {
          Attraction attraction = Attraction.fromJson(data);
          fetchedAttractions.add(attraction);
        }

        _writeAttractionsToFile(response.body);

        setState(() {
          attractions = fetchedAttractions;
        });
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  void _writeAttractionsToFile(String data) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      File file = File('${directory.path}/attractions.txt');
      file.writeAsStringSync(data);
    } catch (error) {
      print('Error writing file: $error');
    }
  }

  void _readAttractionsFromFile() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      File file = File('${directory.path}/attractions.txt');
      if (file.existsSync()) {
        String data = file.readAsStringSync();
        Map<String, dynamic> jsonMap = json.decode(data);

        List<Attraction> savedAttractions = [];
        for (var data in jsonMap['data']) {
          Attraction attraction = Attraction.fromJson(data);
          savedAttractions.add(attraction);
        }

        setState(() {
          attractions = savedAttractions;
        });
      }
    } catch (error) {
      print('Error reading file: $error');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.logout,
              size: 30,
              color: Colors.white,
            ),
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          Container(
            color: Colors.greenAccent,
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "Where are you going?",
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.white
                ),
              ),
            ),
          ),
          Container(
            color: Colors.greenAccent,
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Container(

                decoration: BoxDecoration(
                  color: Colors.blueGrey[50],
                  borderRadius: BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                ),
                child: TextField(
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.blueGrey[300],
                  ),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    hintText:  "E.g: Dhaka, Bangladesh",
                    prefixIcon: Icon(
                      Icons.location_on,
                      color: Colors.blueGrey[300],
                    ),
                    hintStyle: TextStyle(
                      fontSize: 15.0,
                      color: Colors.blueGrey[300],
                    ),
                  ),
                  maxLines: 1,
                  controller: _searchControl,
                ),
              ),
            ),
          ),
          buildHorizontalList(context),
          buildVerticalList(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){_fetchAttractions();},
      ),
    );
  }

  Widget buildHorizontalList(BuildContext context) {
    return Container(
      color: Colors.greenAccent,
      padding: EdgeInsets.only(top: 10.0, left: 20.0),
      height: 250.0,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        primary: false,
        itemCount: attractions.length,
        itemBuilder: (BuildContext context, int index) {
          Attraction attraction = attractions[index];
          return HorizontalPlaceItem(attraction: attraction);
        },
      ),
    );
  }

  Widget buildVerticalList() {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: ListView.builder(
        primary: false,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: attractions.length,
        itemBuilder: (BuildContext context, int index) {
          Attraction attraction = attractions[index];
          return VerticalPlaceItem(attraction: attraction);
        },
      ),
    );
  }
}
