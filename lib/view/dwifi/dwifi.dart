import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'package:wire/config/assets.dart';
import 'package:wire/model/DWifiModel.dart';

class DWifiScreen extends StatefulWidget {
  final DWifiListData wifiData;
  const DWifiScreen({super.key, required this.wifiData});

  @override
  _DWifiScreenState createState() => _DWifiScreenState();
}

RxBool isConnected = false.obs;

class _DWifiScreenState extends State<DWifiScreen> {
  final RxString _ssid = 'Unknown'.obs;

  // final String ssid = 'Airtel_Sahil';
  // final String password = 'sahil8901';
  String ssid = "";
  String password = "";
  @override
  void initState() {
    super.initState();
    ssid = widget.wifiData.status!.first.hostSsid.toString();
    password = widget.wifiData.password.toString();
    setState(() {});
    _getCurrentWifiInfo();
  }

  Future<void> _getCurrentWifiInfo() async {
    try {
      String? ssid = await WiFiForIoTPlugin.getSSID();
      log("Ssid Get --- > $ssid");
      _ssid.value = ssid ?? 'Unknown';
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> connectToWifi() async {
    try {
      var v = await WiFiForIoTPlugin.isEnabled();
      log("wifi is on ==--$v");
      if (!v) {
        Get.defaultDialog(
            title: "WiFi IS OFF",
            content: const Text("Turn On WiFi"),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Get.back();
                  Get.back();
                },
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () async {
                  await WiFiForIoTPlugin.setEnabled(true,
                      shouldOpenSettings: true);
                },
                child: const Text("Enable"),
              ),
            ]);
      } else {
        // await WiFiForIoTPlugin.forceWifiUsage(true);
        await WiFiForIoTPlugin.connect(
          ssid,
          password: password,
          joinOnce: true,
          withInternet: true,
          security: NetworkSecurity.WPA,
        );

        log("Connect ----- ${isConnected.value}");
        EasyLoading.show();
        Timer(
          const Duration(seconds: 4),
          () async {
            EasyLoading.dismiss();
            var isCon = await WiFiForIoTPlugin.isConnected();
            log("isCon ----- $isCon");
            if (isCon) {
              isConnected.value = true;
              _getCurrentWifiInfo();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Connected to $ssid')),
              );
            } else {
              isConnected.value = false;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to connect to $ssid')),
              );
            }
          },
        );
      }
    } catch (e) {
      log("Error --- $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  disconnectToWifi() async {
    isConnected.value = false;
    await WiFiForIoTPlugin.disconnect().then((bool? b) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Disconnected from $ssid')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage(earthBackground))),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('ÐWi-Fi'),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Obx(
              () => Visibility(
                visible: isConnected.value,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Card(
                    child: ListTile(
                      title: Obx(() => Text("Current SSID: ${_ssid.value}")),
                      trailing:
                          const Icon(Icons.wifi, size: 20, color: Colors.green),
                      // onTap: () => Get.to(() => const DWifiScreen()),
                    ),
                  ),
                ),
              ),
            ),
            Card(
              margin: const EdgeInsets.all(8.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Gateway: ${widget.wifiData.gateway}',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text('Location: ${widget.wifiData.location}'),
                    Text('Price per min: ${widget.wifiData.pricePerMin}'),
                    const SizedBox(height: 16.0),
                    const Text('Statuses:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text('MAC Address')),
                          DataColumn(label: Text('IP Address')),
                          DataColumn(label: Text('Connected')),
                          DataColumn(label: Text('Manufacturer')),
                          DataColumn(label: Text('Host SSID')),
                        ],
                        rows: widget.wifiData.status!.map<DataRow>((status) {
                          return DataRow(
                            cells: [
                              DataCell(Text(status.macAddress ?? '')),
                              DataCell(Text(status.ipAddress ?? '')),
                              DataCell(Text(status.connected.toString())),
                              DataCell(Text(status.manufacturer ?? '')),
                              DataCell(Text(status.hostSsid ?? '')),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Obx(
              () => ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  onPressed: () {
                    if (isConnected.value) {
                      disconnectToWifi();
                    } else {
                      connectToWifi();
                    }
                    // Get.back();
                  },
                  child: Text(
                    isConnected.value ? "Disconnect" : "Connect",
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  )),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
