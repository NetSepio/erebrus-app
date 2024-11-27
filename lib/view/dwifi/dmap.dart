// import 'dart:async';
// import 'dart:developer';

// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:wire/model/DWifiModel.dart';
// import 'package:wire/view/dwifi/dwifi.dart';
// import 'package:wire/view/setting/setting.dart';

// class MapSample extends StatefulWidget {
//   const MapSample({super.key});

//   @override
//   State<MapSample> createState() => MapSampleState();
// }

// class MapSampleState extends State<MapSample> {
//   Set<Marker> marker = {};
//   final Completer<GoogleMapController> _controller =
//       Completer<GoogleMapController>();

//   DWifiModel dWifiModel = DWifiModel();
//   late Position _currentPosition;
//   CameraPosition? _initialCameraPosition;
//   // = const CameraPosition(
//   //   target: LatLng(37.42796133580664, -122.085749655962),
//   //   zoom: 16.4746,
//   // );

//   @override
//   void initState() {
//     fetchData();
//     super.initState();
//   }

//   Future<void> _getCurrentLocation() async {
//     bool serviceEnabled;
//     LocationPermission permission;

//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       return Future.error('Location services are disabled.');
//     }

//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         return Future.error('Location permissions are denied.');
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       return Future.error(
//           'Location permissions are permanently denied, we cannot request permissions.');
//     }

//     _currentPosition = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);

//     setState(() {
//       _initialCameraPosition = CameraPosition(
//         target: LatLng(_currentPosition.latitude, _currentPosition.longitude),
//         zoom: 16.4746,
//       );
//     });
//   }

//   Future fetchData() async {
//     await Permission.locationWhenInUse.request();
//     await Permission.location.request();
//     const url = 'https://dev.gateway.erebrus.io/api/v1.0/nodedwifi/all';
//     try {
//       final response = await Dio().get(url);
//       if (response.statusCode == 200) {
//         _getCurrentLocation();
//         var s = DWifiModel.fromJson(response.data);
//         for (var i = 0; i < s.data!.length; i++) {
//           try {
//             List<Location> locations =
//                 await locationFromAddress(s.data![i].location.toString());
//             marker.add(Marker(
//               markerId: MarkerId(s.data![i].id.toString()),
//               position:
//                   LatLng(locations.first.latitude, locations.first.longitude),
//               // icon: AssetMapBitmap("assets/03.png"),
//               infoWindow: InfoWindow(
//                 title: "Price Per Min ${s.data![i].pricePerMin}",
//                 snippet: "${s.data![i].location}",
//                 onTap: () {
//                   log("Marker Tap");
//                   Get.to(() => DWifiScreen(wifiData: s.data![i]));
//                 },
//               ),
//             ));
//           } catch (e) {}
//         }
//         dWifiModel = s;
//         setState(() {});
//       } else {
//         throw Exception('Failed to load data');
//       }
//     } catch (e) {
//       log("Error --- $e");
//       throw Exception('Failed to load data: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//         elevation: 0,
//         centerTitle: true,
//         title: Text(
//           'EREBRUS',
//           style: Theme.of(context)
//               .textTheme
//               .titleLarge!
//               .copyWith(fontWeight: FontWeight.w600),
//         ),
//         actions: [
//           InkWell(
//             onTap: () {
//               Get.to(() => const SettingPage());
//             },
//             child: const Padding(
//               padding: EdgeInsets.all(8.0),
//               child: Icon(Icons.settings),
//             ),
//           )
//         ],
//       ),
//       body: _initialCameraPosition == null
//           ? const Center(child: CircularProgressIndicator())
//           : GoogleMap(
//               mapType: MapType.hybrid,
//               initialCameraPosition: _initialCameraPosition!,
//               onMapCreated: (GoogleMapController controller) {
//                 _controller.complete(controller);
//               },
//               zoomGesturesEnabled: true,
//               zoomControlsEnabled: true,
//               myLocationButtonEnabled: true,
//               myLocationEnabled: true,
//               markers: marker,
//             ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
//       // floatingActionButton: FloatingActionButton.extended(
//       //   onPressed: _goToTheLake,
//       //   label: const Text('Look Near By WiFi'),
//       //   icon: const Icon(Icons.wifi),
//       // ),
//     );
//   }
// }
