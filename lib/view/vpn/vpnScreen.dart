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
  final String initAddress = "10.0.0.5/32";
  final String initPort = "43913";
  final String initDnsServer = "172.30.0.2";
  final String initPrivateKey = "+KxkabF/Zz46PnHWwtDpzTnhMRS6B5crXrIpcEQwyFo=";
  final String initAllowedIp = "0.0.0.0/0, ::/0";
  final String initPublicKey = "xNtJC/MiZeasw8pMgxkrmZ8HyAdJqa/wrV3/nTPYfkY=";
  final String initEndpoint = "endereum-sotreus.us01.sotreus.com:43913";
  final String presharedKey = '9auFuIxN4+hlAjQ/oLSNgpZsGD3XfktmWwGngTXIlsA=';

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
