import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoder_buddy/geocoder_buddy.dart';
import 'package:latlong2/latlong.dart';

List<String> cities = [
  "Amman",
  "Bucharest",
  "Paris",
  "Mumbai",
  "Dubai",
  "London",
  "New York"
];

class MapProvider extends ChangeNotifier {
  TextEditingController searchTerm = TextEditingController();
  bool isLoading = true;
  List<GBSearchData> results = [];
  bool isLoadingSearch = false;
  final MapController controller = MapController();
  MapProvider() {
    init();
  }

  // setController(GoogleMapController controller) {
  //   mapController = controller;
  //   notifyListeners();
  // }

  setSearchTerm(dynamic) async {
    EasyDebounce.debounce("search debounce", Duration(milliseconds: 500),
        () async {
      isLoadingSearch = true;
      print("term is ${searchTerm.value.text}");
      await performSearch();
      isLoadingSearch = false;
    });
  }

  performSearch() async {
    List<GBSearchData> data = await GeocoderBuddy.query(searchTerm.value.text);
    results = data;
    data.forEach((element) {
      print("res ${element.displayName}");
    });
    notifyListeners();
  }

  moveCameratoPWC() async {
    controller.move(LatLng(31.954436, 35.908686), 12);
  }

  void init() async {
    await Future.delayed(Duration(seconds: 2)).then((value) {
      isLoading = false;
      notifyListeners();
    });
  }

  void moveToLocation(GBSearchData e) {
    controller.move(LatLng(double.parse(e.lat), double.parse(e.lon)), 11.05);
    clear();
  }

  clear() {
    searchTerm.clear();
    results.clear();
    notifyListeners();
  }
}
