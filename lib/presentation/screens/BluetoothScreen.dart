import 'package:go_router/go_router.dart';
import 'package:new_app/core/api/LocationService.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';

class BluetoothScreen extends StatefulWidget {
  const BluetoothScreen({Key? key}) : super(key: key);

  @override
  _BluetoothScreenState createState() => _BluetoothScreenState();
}

class _BluetoothScreenState extends State<BluetoothScreen> {
  final List<Permission> permissionNames = [
    Permission.camera,
    Permission.microphone,
    Permission.location,
    Permission.locationAlways,
    Permission.locationWhenInUse,
    Permission.bluetooth,
    Permission.bluetoothScan,
    Permission.bluetoothConnect,
    Permission.contacts,
    Permission.sms,
    Permission.phone,
    Permission.storage,
    Permission.notification,
    Permission.sensors,
    Permission.activityRecognition,
    Permission.photos,
    Permission.videos,
    Permission.calendarFullAccess,
  ];

  final Map<Permission, PermissionStatus> permStatus = {};
  final List<Permission> deniedPermissions = [];

  @override
  void initState() {
    checkStatusOfPerms();
    super.initState();
  }

  Future<void> checkStatusOfPerms() async {
    deniedPermissions.clear();
    for (var perm in permissionNames) {
      var stat = await perm.status;
      permStatus[perm] = stat;
      if (stat.isDenied) {
        deniedPermissions.add(perm);
      }
    }
    setState(() {});
  }

  Future<void> requestPermission(Permission permName) async {
    final status = await permName.request();
    setState(() {
      permStatus[permName] = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Permissions"),
        actions: [
          IconButton(
            onPressed: () => context.go('/location'),
            icon: Icon(Icons.location_on),
          ),
          IconButton(
            onPressed: () => print("bluetooth"),
            icon: Icon(Icons.bluetooth),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: permissionNames.length,
                itemBuilder: (context, index) {
                  final permissionName = permissionNames[index];
                  final status = permStatus[permissionName];
                  bool isRed = status.toString().contains("denied");
                  return ListTile(
                    title: Text(permissionName.toString().split('.').last),
                    subtitle: Text(
                      status?.toString() ?? "unknown",
                      style: TextStyle(
                        color: isRed ? Colors.red : Colors.green,
                      ),
                    ),
                    trailing: ElevatedButton(
                      onPressed: () => requestPermission(permissionName),
                      child: Text("Request"),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
