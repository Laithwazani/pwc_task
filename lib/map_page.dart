import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:pwc_task/providers/map_provider.dart';
import 'package:searchbar_animation/searchbar_animation.dart';
import 'package:url_launcher/url_launcher.dart';

class MapPage extends StatelessWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ChangeNotifierProvider<MapProvider>(
      create: (context) => MapProvider(),
      builder: (__, _) => Consumer<MapProvider>(builder: (_, prov, child) {
        if (prov.isLoading) {
          return Center(
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.40,
                ),
                CircularProgressIndicator(),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Text("Loading Map..please wait"),
                )
              ],
            ),
          );
        } else {
          return Stack(
            children: [
              FlutterMap(
                mapController: prov.controller,
                options: MapOptions(
                    center: LatLng(31.94595, 34.91979),
                    onMapReady: () {
                      prov.moveCameratoPWC();
                    },
                    zoom: 16),
                nonRotatedChildren: [
                  AttributionWidget.defaultWidget(
                    source: 'Map tiles by Mapbox',
                    onSourceTapped: () async {
                      await launchUrl(Uri.parse("https://mapbox.com"));
                    },
                  ),
                ],
                children: [
                  TileLayer(
                    urlTemplate:
                        "https://api.mapbox.com/styles/v1/simlol12/clcesquj5000y14mrdi2j6d5r/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1Ijoic2ltbG9sMTIiLCJhIjoiY2xjZXNsM2phMDQweTNubnhyY2V2eG1udyJ9.KFYZBXieZDlj6_JSZVJs6w",
                    additionalOptions: {
                      "access_token":
                          "pk.eyJ1Ijoic2ltbG9sMTIiLCJhIjoiY2xjZXNsM2phMDQweTNubnhyY2V2eG1udyJ9.KFYZBXieZDlj6_JSZVJs6w",
                    },
                    userAgentPackageName: 'com.example.app',
                  ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SearchBarAnimation(
                    textEditingController: prov.searchTerm,
                    isOriginalAnimation: false,
                    buttonColour: Colors.blue,
                    trailingWidget: prov.isLoadingSearch
                        ? const Center(child: CircularProgressIndicator())
                        : Container(),
                    textInputType: TextInputType.text,
                    hintText:
                        "Search a city.... perhaps ${cities[Random(DateTime.now().millisecondsSinceEpoch).nextInt(cities.length)]}",
                    onPressButton: (isOpen) {
                      prov.clear();
                    },
                    enableKeyboardFocus: true,
                    onEditingComplete: prov.setSearchTerm,
                    onChanged: prov.setSearchTerm,
                    secondaryButtonWidget: Icon(
                      Icons.clear,
                      color: Colors.black,
                    ),
                    buttonWidget: Icon(Icons.search),
                  ),
                  Center(
                    child: AnimatedContainer(
                        duration: Duration(seconds: 2),
                        curve: Curves.fastOutSlowIn,
                        color: Colors.white,
                        child: ListView(
                          shrinkWrap: true,
                          children: prov.results
                              .map((e) => TextButton(
                                    child: Text(e.displayName),
                                    onPressed: () {
                                      prov.moveToLocation(e);
                                    },
                                  ))
                              .toList(),
                        )),
                  )
                ],
              ),
            ],
          );
        }
      }),
    ));
  }
}
