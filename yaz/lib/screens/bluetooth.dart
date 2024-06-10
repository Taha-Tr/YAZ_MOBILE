import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:yaz/bat_data_provider.dart';
import 'package:yaz/ble_left_data_provider.dart';
import 'package:yaz/ble_right_data_provider.dart';
import 'package:yaz/bluetooth_data_provider.dart';
import 'package:yaz/screens/dashboard.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:yaz/screens/parametres.dart';
import 'package:yaz/screens/rapport.dart';

class BluetoothScreen extends StatefulWidget {
  const BluetoothScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BluetoothScreenState createState() => _BluetoothScreenState();
}

class _BluetoothScreenState extends State<BluetoothScreen> {
  final FlutterBlue flutterBlue = FlutterBlue.instance;
  final List<BluetoothDevice> devicesList = <BluetoothDevice>[];
  List<BluetoothService> _services = [];
  bool scanning = false;
  BluetoothDevice? _connectedDevice;

  @override
  void initState() {
    super.initState();
    _checkFirstTime();
    _getConnectedDevices();
  }

  Future<void> _getConnectedDevices() async {
    List<BluetoothDevice> connectedDevices = await flutterBlue.connectedDevices;
    if (mounted) {
      setState(() {
        _connectedDevice =
            connectedDevices.isNotEmpty ? connectedDevices.first : null;
      });
    }
  }

  Future scanDevices() async {
    setState(() {
      scanning = true;
    });

    await Permission.bluetoothScan.request().isGranted;
    await Permission.bluetoothConnect.request().isGranted;

    flutterBlue.startScan(timeout: const Duration(seconds: 3)).then((_) {
      setState(() {
        scanning = false;
      });
      _showNoDevicesSnackBar(); // Call the method to show the snackbar after scan completion
    });

    flutterBlue.scanResults.listen((List<ScanResult> results) {
      for (ScanResult result in results) {
        _addDeviceTolist(result);
      }
    });
  }

  void _showNoDevicesSnackBar() {
    if (devicesList.isEmpty) {
      const snackBar = SnackBar(
          content: Center(child: Text('Aucun appareil detecté',style: TextStyle(color: Colors.white),)),
          backgroundColor:  Color.fromARGB(255, 7, 100, 143));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  void _addDeviceTolist(final ScanResult result) {
    if (!devicesList.contains(result.device)) {
      setState(() {
        devicesList.add(result.device);
      });
    }
  }

Future<void> _connectToDevice(BluetoothDevice device) async {
  try {
    await device.connect();
    _listenToNotifications(device);
    setState(() {
      _connectedDevice = device;
    });
  } catch (e) {
    //print('Error connecting: $e');
    const snackBar = SnackBar(content: Text('Impossible de se connecter',style: TextStyle(color: Colors.white),),backgroundColor: Colors.red);
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}


  Future<void> _disconnectFromDevice() async {
    try {
      await _connectedDevice?.disconnect();
      setState(() {
        _connectedDevice = null;
      });
    } catch (e) {
      // ignore: avoid_print
      print('Error disconnecting: $e');
    }
  }

  void _listenToNotifications(BluetoothDevice device) {
    device.state.listen((state) async {
      if (state == BluetoothDeviceState.connected) {
        _services = await device.discoverServices();
        setState(() {});
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Center(
                child: Text(
                  'Appareil Connectée ',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              backgroundColor: Colors.green),
        );
        
        for (BluetoothService service in _services) {
          for (BluetoothCharacteristic characteristic
              in service.characteristics) {
                // temperature ///////////////////////////////////////////
            if (characteristic.uuid.toString() ==
                "beb5483e-36e1-4688-b7f5-ea07361b26a9") {
              if (characteristic.properties.notify) {
                await characteristic.setNotifyValue(true);
                characteristic.value.listen((value) {
                  // Convert the received value to a string
                  String stringValue = utf8.decode(value);
                  // Access the BluetoothDataProvider
                  final bluetoothDataProvider =
                      Provider.of<BluetoothDataProvider>(context,
                          listen: false);
                  // Update data provider with received data
                  bluetoothDataProvider.updateData(stringValue);
                });
              }
            } ///////////////////////////////////////////////////////////////
    
             /// left /////////////////////////////////////////////////////
             if (characteristic.uuid.toString() ==
                "3f20ae4a-e0d1-497f-8327-7c23bc96b4b8") {
              if (characteristic.properties.notify) {
                await characteristic.setNotifyValue(true);
                characteristic.value.listen((value) {
                  // Convert the received value to a string
                  String stringValue = utf8.decode(value);
                  // Access the BluetoothDataProvider
                  final leftDataProvider =
                      Provider.of<BLEleftDataProvider>(context,
                          listen: false);
                  // Update data provider with received data
                  leftDataProvider.updateData(stringValue);
                });
              }
            }
            /////////////////////////////////////////////////////////////
            
            /// right /////////////////////////////////////////////////////
             if (characteristic.uuid.toString() ==
                "8a50f26c-9e6d-47b6-89a1-c8943c2de65d") {
              if (characteristic.properties.notify) {
                await characteristic.setNotifyValue(true);
                characteristic.value.listen((value) {
                  // Convert the received value to a string
                  String stringValue = utf8.decode(value);
                  // Access the BluetoothDataProvider
                  final rightDataProvider =
                      Provider.of<BLErightDataProvider>(context,
                          listen: false);
                  // Update data provider with received data
                  rightDataProvider.updateData(stringValue);
                });
              }
            }
            /////////////////////////////////////////////////////////////
            
            ////Battery//////////////////////////////////////////////////
                        if (characteristic.uuid.toString() ==
                "17d60c3e-8dbd-4c97-ba2f-05ec56b433df") {
              if (characteristic.properties.notify) {
                await characteristic.setNotifyValue(true);
                characteristic.value.listen((value) {
                  // Convert the received value to a string
                  String stringValue = utf8.decode(value);
                  // Access the BluetoothDataProvider
                  final batDataProvider =
                      Provider.of<BLEbatdataprovider>(context,
                          listen: false);
                  // Update data provider with received data
                  batDataProvider.updateData(stringValue);
                });
              }
            }
            ////////////////////////////////////////////////////////////
            
          }
        } 
      } else if (state == BluetoothDeviceState.disconnected) {
        setState(() {
          _connectedDevice = null;
                            final bluetoothDataProvider =
                      Provider.of<BluetoothDataProvider>(context,
                          listen: false);
                  // Update data provider with received data
                  bluetoothDataProvider.updateData("- - -");
                  //////////////////////////////////////////
                      final batDataProvider =
                      Provider.of<BLEbatdataprovider>(context,
                          listen: false);
                  // Update data provider with received data
                  batDataProvider.updateData("- - -");
        
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Center(
                child: Text(
                  'Appareil Déconnectée ',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              backgroundColor: Colors.red),
        );
      }
    });
  }

  Future<void> _checkFirstTime() async {}

  ListView _buildListViewOfDevices() {
    List<BluetoothDevice> allDevices = List.from(devicesList);
    if (_connectedDevice != null && !allDevices.contains(_connectedDevice!)) {
      allDevices.insert(0, _connectedDevice!);
    }

    return ListView.builder(
      itemCount: allDevices.length,
      itemBuilder: (context, index) {
        BluetoothDevice device = allDevices[index];
        return ListTile(
          title:
              Text(device.name == '' ? '(Périphérique inconnu)' : device.name),
          subtitle: Text(device.id.toString()),
          trailing: _connectedDevice == device
              ? ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: _disconnectFromDevice,
                  child: const Text('Déconnecter',
                      style: TextStyle(color: Colors.white)),
                )
              : ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: () => _connectToDevice(device),
                  child: const Text('Connecter',
                      style: TextStyle(color: Colors.white)),
                ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color.fromARGB(255, 7, 100, 143),
        title: const Text('Bluetooth', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            onPressed: () {
              // Start scanning when the button is pressed
              scanDevices();
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: const Color.fromARGB(255, 7, 100, 143),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            buildHeader(context),
            buildMenuItems(context),
          ],
        ),
      ),
      body: scanning ? _buildLoadingScreen() : _buildListViewOfDevices(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 7, 100, 143),
        onPressed: () {
          // Start scanning when the FAB is pressed
          scanDevices();
        },
        child: const Icon(
          Icons.search,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget buildHeader(BuildContext context) => Container(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      );

  Widget buildMenuItems(BuildContext context) => Column(
        children: [
          ListTile(
            leading: const Icon(
              Icons.dashboard,
              color: Colors.white,
            ),
            title: const Text(
              'Dashboard',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onTap: () async {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Dashboard()));
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.bluetooth,
              color: Colors.white,
            ),
            title: const Text(
              'Appareil',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const BluetoothScreen()));
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.settings_accessibility_rounded,
              color: Colors.white,
            ),
            title: const Text(
              'Paramétres',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Parametres()),
              );
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.chat_rounded,
              color: Colors.white,
            ),
            title: const Text(
              'Rapport',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const RapportScreen()));
            },
          ),
        ],
      );

  Widget _buildLoadingScreen() {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
      ),
    );
  }
}
