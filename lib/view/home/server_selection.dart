import 'package:erebrus_app/view/inAppPurchase/ProFeaturesScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:erebrus_app/view/home/home_controller.dart';
import 'package:erebrus_app/config/common.dart';
import 'package:erebrus_app/model/DVPNNodesModel.dart';

class ServerSelectionScreen extends StatelessWidget {
  final HomeController homeController = Get.find();
  final ValueNotifier<String> expandedCountry = ValueNotifier<String>('');

  ServerSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isPro = box!.get("appMode") == "pro";
    // Sort all servers by downloadSpeed descending
    final allEntries = (homeController.countryMap?.entries.toList() ?? [])
      ..sort((a, b) {
        final aSpeed = a.value.first.downloadSpeed ?? 0.0;
        final bSpeed = b.value.first.downloadSpeed ?? 0.0;
        return bSpeed.compareTo(aSpeed);
      });
    final fastServers = allEntries.take(3).toList();
    final otherServers = allEntries.skip(3).toList();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: ElevatedButton.icon(
              onPressed: () {
                Get.to(() => ProFeaturesScreen(fromLogin: false));
              },
              icon: Icon(Icons.star, color: Colors.white, size: 18),
              label: Text('Go Premium', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF23242A),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: StadiumBorder(),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: isPro
            ? ValueListenableBuilder<String>(
                valueListenable: expandedCountry,
                builder: (context, expanded, _) {
                  Widget expandableCard(
                      String countryCode, List<dynamic> nodes) {
                    final isExpanded = expanded == countryCode;
                    final nodeTiles = isExpanded
                        ? nodes
                            .map((node) => Padding(
                                  padding: const EdgeInsets.only(left: 24.0),
                                  child:
                                      _serverTile(countryCode, node, context),
                                ))
                            .toList()
                        : [];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            expandedCountry.value =
                                isExpanded ? '' : countryCode;
                          },
                          child: Card(
                            color: Color(0xFF181A20),
                            margin: EdgeInsets.symmetric(vertical: 6),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            child: ListTile(
                              leading: Text(
                                countryCodeToEmoji(countryCode),
                                style: TextStyle(fontSize: 28),
                              ),
                              title: Text(
                                homeController.countryCodes[
                                        countryCode.toUpperCase()] ??
                                    countryCode.toUpperCase(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: nodes.isNotEmpty &&
                                      nodes.first.downloadSpeed != null
                                  ? Text(
                                      '↓ ${nodes.first.downloadSpeed!.toStringAsFixed(1)} Mbps',
                                      style: TextStyle(
                                          color: Colors.greenAccent,
                                          fontSize: 13))
                                  : null,
                              trailing: Icon(
                                  isExpanded
                                      ? Icons.expand_less
                                      : Icons.expand_more,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                        ...nodeTiles,
                      ],
                    );
                  }

                  return ListView(
                    children: [
                      _sectionHeader('Fast Servers'),
                      ...fastServers.map(
                          (entry) => expandableCard(entry.key, entry.value)),
                      SizedBox(height: 16),
                      _sectionHeader('Other Service'),
                      ...otherServers.map(
                          (entry) => expandableCard(entry.key, entry.value)),
                    ],
                  );
                },
              )
            : ListView(
                children: [
                  _sectionHeader('Fast Servers'),
                  ...fastServers.map((entry) =>
                      _countryTile(entry.key, entry.value.first, context)),
                  SizedBox(height: 16),
                  _sectionHeader('Other Service'),
                  ...otherServers.map((entry) =>
                      _countryTile(entry.key, entry.value.first, context)),
                ],
              ),
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18)),
          // Text('See All', style: TextStyle(color: Color(0xFF1E90FF), fontSize: 15)),
        ],
      ),
    );
  }

  Widget _seeAllButton() {
    return SizedBox(height: 8);
  }

  Widget _expandableCountryCard(String countryCode, List<dynamic> nodes) {
    return Obx(() {
      final isExpanded = expandedCountry.value == countryCode;
      final nodeTiles = isExpanded
          ? nodes
              .map((node) => Padding(
                    padding: const EdgeInsets.only(left: 24.0),
                    child: _serverTile(countryCode, node, null),
                  ))
              .toList()
          : [];
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              expandedCountry.value = isExpanded ? '' : countryCode;
            },
            child: Card(
              color: Color(0xFF181A20),
              margin: EdgeInsets.symmetric(vertical: 6),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: Text(
                  countryCodeToEmoji(countryCode),
                  style: TextStyle(fontSize: 28),
                ),
                title: Text(
                  homeController.countryCodes[countryCode.toUpperCase()] ??
                      countryCode.toUpperCase(),
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                subtitle: nodes.isNotEmpty && nodes.first.downloadSpeed != null
                    ? Text(
                        '↓ ${nodes.first.downloadSpeed!.toStringAsFixed(1)} Mbps',
                        style:
                            TextStyle(color: Colors.greenAccent, fontSize: 13))
                    : null,
                trailing: Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: Colors.white),
              ),
            ),
          ),
          ...nodeTiles,
        ],
      );
    });
  }

  Widget _serverTile(
      String countryCode, AllNPayload node, BuildContext? context) {
    final isSelected = homeController.selectedNode?.value == countryCode;
    final double? downloadSpeed = node.downloadSpeed;
    final double? uploadSpeed = node.uploadSpeed;
    final int? ping = node.lastPingedTimeStamp; // If available, use as ms
    return Obx(() => Card(
          color: Color(0xFF181A20),
          margin: EdgeInsets.symmetric(vertical: 6),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            leading: Text(
              countryCodeToEmoji(countryCode),
              style: TextStyle(fontSize: 28),
            ),
            title: Text(
              node.chainName ?? "",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            subtitle: Text('${node.id}',
                style: TextStyle(color: Colors.greenAccent, fontSize: 13)),
            trailing: Radio<AllNPayload>(
              value: node,
              groupValue: homeController.selectedPayload.value,
              onChanged: (val) {
                homeController.selectedNode?.value = countryCode;
                homeController.selectedPayload.value = node;
                Get.back();
              },
              activeColor: Color(0xFF1E90FF),
            ),
            onTap: () {
              homeController.selectedNode?.value = countryCode;
              homeController.selectedPayload.value = node;
              Get.back();
            },
          ),
        ));
  }

  // For basic mode: country-level tile
  Widget _countryTile(String countryCode, dynamic node, BuildContext context) {
    final isSelected = homeController.selectedNode?.value == countryCode;
    final double? downloadSpeed = node.downloadSpeed;
    final double? uploadSpeed = node.uploadSpeed;
    final int? ping = node.lastPingedTimeStamp;
    return Card(
      color: Color(0xFF181A20),
      margin: EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Text(
          countryCodeToEmoji(countryCode),
          style: TextStyle(fontSize: 28),
        ),
        title: Text(
          homeController.countryCodes[countryCode.toUpperCase()] ??
              countryCode.toUpperCase(),
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        subtitle: Row(
          children: [
            if (downloadSpeed != null)
              Text('↓ ${downloadSpeed.toStringAsFixed(1)} Mbps',
                  style: TextStyle(color: Colors.greenAccent, fontSize: 13)),
            if (uploadSpeed != null) ...[
              SizedBox(width: 8),
              Text('↑ ${uploadSpeed.toStringAsFixed(1)} Mbps',
                  style: TextStyle(color: Colors.blueAccent, fontSize: 13)),
            ],
          ],
        ),
        trailing: Radio<String>(
          value: countryCode,
          groupValue: homeController.selectedNode?.value,
          onChanged: (val) {
            homeController.selectedNode?.value = countryCode;
            homeController.selectedPayload.value = node;
            Get.back();
          },
          activeColor: Color(0xFF1E90FF),
        ),
        onTap: () {
          homeController.selectedNode?.value = countryCode;
          homeController.selectedPayload.value = node;
          Get.back();
        },
      ),
    );
  }
}
