// // import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
// import 'package:esc_pos_bluetooth_updated/esc_pos_bluetooth_updated.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:freshice/backend/api.dart';
// import 'package:permission_handler/permission_handler.dart';

// class BluetoothScannerPage extends StatefulWidget {
//   const BluetoothScannerPage({super.key});

//   @override
//   State<BluetoothScannerPage> createState() => _BluetoothScannerPageState();
// }

// class _BluetoothScannerPageState extends State<BluetoothScannerPage> {
//   PrinterBluetoothManager printerManager = PrinterBluetoothManager();
//   List<PrinterBluetooth> _devices = [];
//   Map<String, dynamic> selecteddevice = {};

//   bool loading = false;

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((timestamp) async {
//       await scanDevices();
//       await getSelectedPrinter();
//     });
//   }

//   Future<void> scanDevices() async {
//     await [
//       Permission.location,
//       Permission.bluetooth,
//       Permission.bluetoothConnect,
//       Permission.bluetoothScan,
//     ].request();
//     setState(() {
//       loading = true;
//       _devices = [];
//     });
//     printerManager.startScan(const Duration(seconds: 4));
//     printerManager.scanResults.listen((devices) async {
//       setState(() {
//         _devices = devices;
//         loading = false;
//       });
//     });
//   }

//   Future<void> getSelectedPrinter() async {
//     final dynamic response = await API.getPrinterDetails();
//     setState(() {
//       selecteddevice = response["status"] == "success" ? response : {};
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.white,
//         leading: IconButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             icon: FaIcon(
//               FontAwesomeIcons.arrowLeft,
//               color: API.buttoncolor,
//               size: 20,
//             )),
//         centerTitle: true,
//         title: Text(
//           "Printers",
//           style: TextStyle(
//               color: API.buttoncolor,
//               fontSize: 16,
//               fontWeight: FontWeight.w300),
//         ),
//       ),
//       body: Container(
//         height: MediaQuery.of(context).size.height,
//         width: MediaQuery.of(context).size.width,
//         color: Colors.white,
//         child: loading
//             ? API.loadingScreen(context)
//             : ListView.builder(
//                 itemCount: _devices.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   return InkWell(
//                     onTap: () async {
//                       await API
//                           .addPrinterDetails(_devices[index].name.toString(),
//                               _devices[index].address.toString())
//                           .then((value) {
//                         API.showSnackBar("success", "Printer added", context);
//                         Navigator.pop(context);
//                       });
//                     },
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 7),
//                       child: Container(
//                         height: 70,
//                         color: Colors.white,
//                         width: MediaQuery.of(context).size.width,
//                         alignment: Alignment.centerLeft,
//                         child: Card(
//                           elevation: 5,
//                           color: Colors.white,
//                           surfaceTintColor: Colors.white,
//                           semanticContainer: true,
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(3)),
//                           child: Row(
//                             children: <Widget>[
//                               const SizedBox(width: 10),
//                               Icon(
//                                 Icons.print,
//                                 color: API.appcolor,
//                               ),
//                               const SizedBox(width: 10),
//                               Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: <Widget>[
//                                     Text(
//                                       _devices[index].name ?? '',
//                                       style: TextStyle(
//                                           color: API.appcolor,
//                                           fontSize: 16,
//                                           fontWeight: FontWeight.w500),
//                                     ),
//                                     Text(
//                                       _devices[index].address!,
//                                       style: TextStyle(
//                                           color: API.appcolor,
//                                           fontSize: 13,
//                                           fontWeight: FontWeight.w300),
//                                     ),
//                                     Text(
//                                       'Click to select the device',
//                                       style: TextStyle(
//                                           color: Colors.grey[700],
//                                           fontSize: 13,
//                                           fontWeight: FontWeight.w300),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               selecteddevice["btaddress"].toString() ==
//                                       _devices[index].address.toString()
//                                   ? const Padding(
//                                       padding: EdgeInsets.only(right: 10),
//                                       child: Icon(
//                                         Icons.check_box,
//                                         color: Colors.green,
//                                         size: 20,
//                                       ),
//                                     )
//                                   : const SizedBox(
//                                       width: 0,
//                                     )
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   );
//                 }),
//       ),
//     );
//   }
// }
import 'package:esc_pos_bluetooth_updated/esc_pos_bluetooth_updated.dart' as esp;

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart' as fbs;
import 'package:freshice/backend/api.dart';
import 'package:permission_handler/permission_handler.dart';

class BluetoothScannerPage extends StatefulWidget {
  const BluetoothScannerPage({super.key});

  @override
  State<BluetoothScannerPage> createState() => _BluetoothScannerPageState();
}

class _BluetoothScannerPageState extends State<BluetoothScannerPage> {
  esp.PrinterBluetoothManager printerManager = esp.PrinterBluetoothManager();
  List<fbs.BluetoothDevice> _devices = [];
  Map<String, dynamic> selecteddevice = {};

  bool loading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timestamp) async {
      await ensureBluetoothPermissions();
      await loadPairedDevices();
      await getSelectedPrinter();
    });
  }

  Future<void> ensureBluetoothPermissions() async {
  if (await Permission.bluetoothConnect.isGranted &&
      await Permission.bluetoothScan.isGranted) {
    return; 
  }

  await [
    Permission.bluetoothScan,
    Permission.bluetoothConnect,
    Permission.location,
  ].request();

  if (await Permission.bluetoothConnect.isDenied) {
    throw Exception('Bluetooth permission is required to connect printer.');
  }
}

Future<void> loadPairedDevices() async {
  setState(() {
    loading = true;
  });
  final devices = await fbs. FlutterBluetoothSerial.instance.getBondedDevices();
  setState(() {
    _devices =devices;
    loading = false;
  });
}
  

  // Future<void> scanDevices() async {
  //   await [
  //     Permission.location,
  //     Permission.bluetooth,
  //     Permission.bluetoothConnect,
  //     Permission.bluetoothScan,
  //   ].request();
  //   setState(() {
  //     loading = true;
  //     _devices = [];
  //   });
  //   printerManager.startScan(const Duration(seconds: 4));
  //   printerManager.scanResults.listen((devices) async {
  //     setState(() {
  //       _devices = devices;
  //       loading = false;
  //     });
  //   });
  // }

  Future<void> getSelectedPrinter() async {
    final dynamic response = await API.getPrinterDetails();
    setState(() {
      selecteddevice = response["status"] == "success" ? response : {};
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: API.appcolor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Printer",
          style: TextStyle(
              color:Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w500),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
              size: 30,
            )),
      ),
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: loading
              ? API.loadingScreen(context)
              : ListView.builder(
                  itemCount: _devices.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () async {
                        await API
                            .addPrinterDetails(_devices[index].name.toString(),
                                _devices[index].address.toString())
                            .then((value) {
                          API.showSnackBar("success", "Printer added",context);
                          Navigator.pop(context);
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 7),
                        child: Container(
                          height: 70,
                          color: Colors.white,
                          width: MediaQuery.of(context).size.width,
                          alignment: Alignment.centerLeft,
                          child: Card(
                            elevation: 5,
                            color: Colors.white,
                            surfaceTintColor: Colors.white,
                            semanticContainer: true,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(3)),
                            child: Row(
                              children: <Widget>[
                                const SizedBox(width: 10),
                                Icon(
                                  Icons.print,
                                  color: API.appcolor,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        _devices[index].name ?? '',
                                        style: TextStyle(
                                            color: API.appcolor,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        _devices[index].address!,
                                        style: TextStyle(
                                            color: API.appcolor,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w300),
                                      ),
                                      Text(
                                        'Click to select the device',
                                        style: TextStyle(
                                            color: Colors.grey[700],
                                            fontSize: 13,
                                            fontWeight: FontWeight.w300),
                                      ),
                                    ],
                                  ),
                                ),
                                selecteddevice["btaddress"].toString() ==
                                        _devices[index].address.toString()
                                    ? const Padding(
                                        padding: EdgeInsets.only(right: 10),
                                        child: Icon(
                                          Icons.check_box,
                                          color: Colors.green,
                                          size: 20,
                                        ),
                                      )
                                    : const SizedBox(
                                        width: 0,
                                      )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
        ),
      ),
    );
  }
}
