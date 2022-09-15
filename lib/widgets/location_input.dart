import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:place_app/helpers/location_helper.dart';
import 'package:place_app/screens/map_screen.dart';

class LocationInput extends StatefulWidget {
  LocationInput(this.onSelectPlace);
  final Function onSelectPlace;
  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String? _previewImageUrl;

  void _showPreviewImage(double lat, double lng) {
    String staticMapUrl = LocationHelper.generateLocationPreviewImage(lat, lng);
    setState(() {
      _previewImageUrl = staticMapUrl;
    });
    widget.onSelectPlace(lat, lng);
  }

  Future<void> _getCurrentUserLocation() async {
    try {
      final locData = await Location().getLocation();
      _showPreviewImage(locData.latitude!, locData.longitude!);
    } catch (error) {
      return;
    }
  }

  Future<void> _selectOnMap() async {
    final selectedLocation = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => MapScreen(
          isSelecting: true,
        ),
      ),
    );
    if (selectedLocation == null) {
      return;
    }
    _showPreviewImage(selectedLocation.latitude, selectedLocation.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          decoration:
              BoxDecoration(border: Border.all(width: 1, color: Colors.grey)),
          child: _previewImageUrl == null
              ? const Text(
                  'No location chosen',
                  textAlign: TextAlign.center,
                )
              : Image.network(
                  _previewImageUrl!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
                onPressed: _getCurrentUserLocation,
                icon: Icon(Icons.location_on),
                label: Text('Current Locaiton')),
            TextButton.icon(
                onPressed: _selectOnMap,
                icon: Icon(Icons.location_on),
                label: Text('Select on Map')),
          ],
        ),
      ],
    );
  }
}
