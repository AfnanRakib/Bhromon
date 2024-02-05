import 'package:flutter/material.dart';
import 'package:bhromon/pages/details.dart';
import '../helpers/AttractionModel.dart';

class HorizontalPlaceItem extends StatelessWidget {
  final Attraction attraction;

  HorizontalPlaceItem({required this.attraction});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20.0),
      child: InkWell(
        child: Container(
          height: 220.0,
          width: 155.0,
          child: Column(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  attraction.smallPhotoUrl,
                  height: 178.0,
                  width: 170.0,
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                child: Text(
                  attraction.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0,
                    color: Colors.black
                  ),
                  maxLines: 2,
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(height: 5),
              Expanded(
                child: Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    attraction.locationString,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13.0,
                      color: Colors.black,
                    ),
                    maxLines: 1,
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              //SizedBox(height: 1.0),
            ],
          ),
        ),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) {
                return Details(attraction: attraction,);
              },
            ),
          );
        },
      ),
    );
  }
}
