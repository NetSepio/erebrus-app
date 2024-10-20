import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'package:wifi_scan/wifi_scan.dart';

/// Example app for wifi_scan plugin.
class WifiScanP extends StatefulWidget {
  /// Default constructor for [WifiScanP] widget.
  const WifiScanP({super.key});

  @override
  State<WifiScanP> createState() => _WifiScanPState();
}

class _WifiScanPState extends State<WifiScanP> {
  List<WiFiAccessPoint> accessPoints = <WiFiAccessPoint>[];
  StreamSubscription<List<WiFiAccessPoint>>? subscription;
  bool shouldCheckCan = true;

  bool get isStreaming => subscription != null;

  Future<void> _startScan(BuildContext context) async {
    // check if "can" startScan
    if (shouldCheckCan) {
      // check if can-startScan
      final can = await WiFiScan.instance.canStartScan();
      // if can-not, then show error
      if (can == CanStartScan.noLocationPermissionDenied ||
          can == CanStartScan.noLocationPermissionRequired ||
          can == CanStartScan.noLocationPermissionUpgradeAccuracy ||
          can == CanStartScan.noLocationServiceDisabled) {
        if (mounted) kShowSnackBar(context, "Turn On Location Permission");
        return;
      }
      if (can != CanStartScan.yes) {
        if (mounted) kShowSnackBar(context, "$can");
        return;
      }
    }

    // call startScan API
    final result = await WiFiScan.instance.startScan();
    _getScannedResults(context);
    if (mounted) kShowSnackBar(context, "startScan: $result");
    // reset access points.
    setState(() => accessPoints = <WiFiAccessPoint>[]);
  }

  Future<bool> _canGetScannedResults(BuildContext context) async {
    if (shouldCheckCan) {
      // check if can-getScannedResults
      final can = await WiFiScan.instance.canGetScannedResults();
      // if can-not, then show error
      if (can != CanGetScannedResults.yes) {
        if (mounted) kShowSnackBar(context, "Cannot get scanned results: $can");
        accessPoints = <WiFiAccessPoint>[];
        return false;
      }
    }
    return true;
  }

  Future<void> _getScannedResults(BuildContext context) async {
    if (await _canGetScannedResults(context)) {
      // get scanned results
      final results = await WiFiScan.instance.getScannedResults();
      setState(() => accessPoints = results);
    }
  }

  Future<void> _startListeningToScanResults(BuildContext context) async {
    if (await _canGetScannedResults(context)) {
      subscription = WiFiScan.instance.onScannedResultsAvailable
          .listen((result) => setState(() => accessPoints = result));
    }
  }

  void _stopListeningToScanResults() {
    subscription?.cancel();
    setState(() => subscription = null);
  }

  @override
  void dispose() {
    super.dispose();
    // stop subscription for scanned results
    _stopListeningToScanResults();
  }

  // build toggle with label
  Widget _buildToggle({
    String? label,
    bool value = false,
    ValueChanged<bool>? onChanged,
    Color? activeColor,
  }) =>
      Row(
        children: [
          if (label != null) Text(label),
          Switch(value: value, onChanged: onChanged, activeColor: activeColor),
        ],
      );
  @override
  void initState() {
    _startScan(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Discover WiFi'),
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.arrow_back_ios),
          ),
        ),
      ),
      body: Builder(
        builder: (context) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //   children: [
              //     _buildToggle(
              //       label: "STREAM",
              //       value: isStreaming,
              //       onChanged: (shouldStream) async => shouldStream
              //           ? await _startListeningToScanResults(context)
              //           : _stopListeningToScanResults(),
              //     ),
              //   ],
              // ),
              // const Divider(),
              Flexible(
                child: Center(
                  child: accessPoints.isEmpty
                      ? const Text("NO RESULTS")
                      : ListView.builder(
                          itemCount: accessPoints.length,
                          itemBuilder: (context, i) =>
                              _AccessPointTile(accessPoint: accessPoints[i])),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Show tile for AccessPoint.
///
/// Can see details when tapped.
class _AccessPointTile extends StatelessWidget {
  final WiFiAccessPoint accessPoint;

  const _AccessPointTile({required this.accessPoint});

  // build row that can display info, based on label: value pair.
  Widget _buildInfo(String label, dynamic value) => Container(
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey)),
        ),
        child: Row(
          children: [
            Text(
              "$label: ",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Expanded(child: Text(value.toString()))
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    final title = accessPoint.ssid.isNotEmpty ? accessPoint.ssid : "**EMPTY**";
    final signalIcon = accessPoint.level >= -80
        ? Icons.signal_wifi_4_bar
        : Icons.signal_wifi_0_bar;
    return ListTile(
      visualDensity: VisualDensity.compact,
      leading: Icon(signalIcon),
      title: Text(title),
      subtitle: Text(accessPoint.capabilities),
      onTap: () async {
        TextEditingController passwordCnt = TextEditingController();
        showDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: const Text("Password"),
              content: CupertinoTextField(
                controller: passwordCnt,
                placeholder: "Password",
              ),
              actions: [
                CupertinoDialogAction(
                  child: const Text("Connect"),
                  onPressed: () async {
                    await WiFiForIoTPlugin.connect(
                      accessPoint.ssid,
                      password: passwordCnt.text,
                      withInternet: true,
                      bssid: accessPoint.bssid,
                      security: NetworkSecurity.WPA,
                    ).then((value) {
                      log("Connect :- $value");
                      if (value) {
                        Fluttertoast.showToast(msg: "Connected");
                      } else {
                        Fluttertoast.showToast(msg: "Connection Failed");
                      }
                    }).catchError((e) {
                      log("Erro -  $e");
                    });
                    Navigator.pop(context);
                  },
                )
              ],
            );
          },
        );
        // await WiFiForIoTPlugin.getFrequency();

        // await WiFiForIoTPlugin.getWiFiAPSSID();
        // showDialog(
        //   context: context,
        //   builder: (context) => AlertDialog(
        //     title: Text(title),
        //     content: Column(
        //       mainAxisSize: MainAxisSize.min,
        //       children: [
        //         _buildInfo("BSSDI", accessPoint.bssid),
        //         _buildInfo("Capability", accessPoint.capabilities),
        //         _buildInfo("frequency", "${accessPoint.frequency}MHz"),
        //         _buildInfo("level", accessPoint.level),
        //         _buildInfo("standard", accessPoint.standard),
        //         _buildInfo(
        //             "centerFrequency0", "${accessPoint.centerFrequency0}MHz"),
        //         _buildInfo(
        //             "centerFrequency1", "${accessPoint.centerFrequency1}MHz"),
        //         _buildInfo("channelWidth", accessPoint.channelWidth),
        //         _buildInfo("isPasspoint", accessPoint.isPasspoint),
        //         _buildInfo(
        //             "operatorFriendlyName", accessPoint.operatorFriendlyName),
        //         _buildInfo("venueName", accessPoint.venueName),
        //         _buildInfo(
        //             "is80211mcResponder", accessPoint.is80211mcResponder),
        //       ],
        //     ),
        //   ),
        // );
      },
    );
  }
}

/// Show snackbar.
void kShowSnackBar(BuildContext context, String message) {
  if (kDebugMode) print(message);
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}
