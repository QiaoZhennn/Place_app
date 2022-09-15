import 'dart:io';

import 'package:flutter/material.dart';
import 'package:place_app/helpers/dp_helper.dart';
import 'package:place_app/helpers/location_helper.dart';
import 'package:place_app/models/place.dart';

class GreatPlaces with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items {
    return [..._items];
  }

  void addPlace(String pickedTitle, File pickedImage,
      PlaceLocation pickedLocation) async {
    final address = await LocationHelper.getPlaceAddress(
        pickedLocation.latitude, pickedLocation.longitude);
    final updatedLocation = PlaceLocation(
        latitude: pickedLocation.latitude,
        longitude: pickedLocation.longitude,
        address: address);
    final newPlace = Place(
        id: DateTime.now().toString(),
        image: pickedImage,
        title: pickedTitle,
        location: updatedLocation);
    _items.add(newPlace);
    notifyListeners();
    DbHelper.insert('places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,
      'loc_lat': newPlace.location!.latitude,
      'loc_lng': newPlace.location!.longitude,
      'address': newPlace.location!.address as Object
    });
  }

  Future<void> fetchAndSetPlaces() async {
    final dataList = await DbHelper.getData('places');
    _items = dataList
        .map((e) => Place(
            id: e['id'],
            title: e['title'],
            location: PlaceLocation(
                latitude: e['loc_lat'],
                longitude: e['loc_lng'],
                address: e['address']),
            image: File(e['image'])))
        .toList();
    notifyListeners();
  }

  Place findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }
}
