// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:geocoding/geocoding.dart';

// class DinhViTrenBanDo extends StatefulWidget {
//   @override
//   _DinhViTrenBanDoState createState() => _DinhViTrenBanDoState();
// }

// class _DinhViTrenBanDoState extends State<DinhViTrenBanDo> {
//   String _currentAddress = 'Đang xác định vị trí...';

//   @override
//   void initState() {
//     super.initState();
//     _getLocation();
//   }

//   Future<void> _getLocation() async {
//     try {
//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//         if (permission == LocationPermission.denied) {
//           setState(() {
//             _currentAddress = 'Quyền bị từ chối';
//           });
//           return;
//         }
//       }

//       if (permission == LocationPermission.deniedForever) {
//         setState(() {
//           _currentAddress = 'Quyền bị từ chối vĩnh viễn';
//         });
//         return;
//       }

//       Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );

//       List<Placemark> placemarks = await placemarkFromCoordinates(
//         position.latitude,
//         position.longitude,
//       );

//       if (placemarks.isNotEmpty) {
//         final place = placemarks.first;
//         setState(() {
//           _currentAddress =
//               '${place.street}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.country}';
//         });
//       } else {
//         setState(() {
//           _currentAddress = 'Không xác định địa chỉ';
//         });
//       }
//     } catch (e) {
//       print('Lỗi định vị: $e');
//       setState(() {
//         _currentAddress = 'Lỗi lấy vị trí';
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Lấy địa chỉ từ GPS")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Text(
//               _currentAddress,
//               style: TextStyle(fontSize: 16),
//             ),
//             Spacer(),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.pop(context, _currentAddress);
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.pink,
//                 padding: EdgeInsets.symmetric(vertical: 16),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(30),
//                 ),
//               ),
//               child: Text('Xác nhận', style: TextStyle(fontSize: 18)),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
