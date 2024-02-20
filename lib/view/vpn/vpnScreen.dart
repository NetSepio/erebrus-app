import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wireguard_vpn/wireguard_vpn.dart';

class VpnScreen extends StatefulWidget {
  const VpnScreen({super.key});

  @override
  State<VpnScreen> createState() => _VpnScreenState();
}

class _VpnScreenState extends State<VpnScreen> {
  final _wireguardFlutterPlugin = WireguardVpn();
  bool vpnActivate = false;
  Stats stats = Stats(totalDownload: 0, totalUpload: 0);
  final String initName = 'MyWireguardVPN';
  final String initAddress = "10.0.0.2/32";
  final String initPort = "51820";
  final String initDnsServer = "1.1.1.1";
  final String initPrivateKey = "MOyClJNU4kYlE3WN/YrFjMKroDslcsq8VtmYPG/q/Hg=";
  final String initAllowedIp = "0.0.0.0/0, ::/0";
  final String initPublicKey = "ZG4Sw9hOsyzx6aNwp40zawfAQPMviGvRONMoQIb8sTo=";
  final String initEndpoint = "hk02.erebrus.io:51820";
  final String presharedKey = 'SXFImP4JPUeoAVpwhOoGCUunVVKuFRMrCrAGFC5n7C4=';

  @override
  void initState() {
    super.initState();
    vpnActivate ? _obtainStats() : null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Wireguard-VPN Example'),
          ),
          body: Column(
            children: [
              Text(
                  'Active VPN: ${stats.totalDownload} D -- ${stats.totalUpload} U'),
              SwitchListTile(
                value: vpnActivate,
                onChanged: _activateVpn,
                title: Text(initName),
                subtitle: Text(initEndpoint),
              ),
            ],
          )),
    );
  }

  void _obtainStats() {
    Timer.periodic(const Duration(seconds: 1), (timer) async {
      final results = await _wireguardFlutterPlugin.tunnelGetStats(initName);
      setState(() {
        stats = results ?? Stats(totalDownload: 0, totalUpload: 0);
      });
    });
  }

  void _activateVpn(bool value) async {
    final results =
        await _wireguardFlutterPlugin.changeStateParams(SetStateParams(
      state: !vpnActivate,
      tunnel: Tunnel(
          name: initName,
          address: initAddress,
          dnsServer: initDnsServer,
          listenPort: initPort,
          peerAllowedIp: initAllowedIp,
          peerEndpoint: initEndpoint,
          peerPublicKey: initPublicKey,
          privateKey: initPrivateKey,
          peerPresharedKey: presharedKey),
    ));
    setState(() {
      vpnActivate = results ?? false;
      vpnActivate ? _obtainStats() : null;
    });
  }
}
