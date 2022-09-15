import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:place_app/providers/great_places.dart';
import 'package:place_app/screens/map_screen.dart';
import 'package:provider/provider.dart';

class PlaceDetailScreen extends StatelessWidget {
  static const String routeName = '/place_detail';
  const PlaceDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String? id = ModalRoute.of(context)!.settings.arguments as String?;
    final selectedPlace =
        Provider.of<GreatPlaces>(context, listen: false).findById(id!);
    return Scaffold(
      appBar: AppBar(title: Text(selectedPlace.title)),
      body: Column(children: [
        Container(
          height: 250,
          width: double.infinity,
          child: Image.file(
            selectedPlace.image,
            fit: BoxFit.cover,
            width: double.infinity,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          selectedPlace.location!.address!,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, color: Colors.grey),
        ),
        SizedBox(
          height: 10,
        ),
        TextButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                fullscreenDialog: true,
                  builder: (context) => MapScreen(
                        initialLocation: selectedPlace.location!,
                      )));
            },
            child: Text('View on Map')),
      ]),
    );
  }
}
