import 'package:erebrus_app/config/common.dart';
import 'package:flutter/material.dart';

class WalletDropdown extends StatefulWidget {
  @override
  _WalletDropdownState createState() => _WalletDropdownState();
}

class _WalletDropdownState extends State<WalletDropdown> {
  String? selectedWallet; // Stores the selected wallet key (e.g., wallet name)

  Map<String, String> networkList = {
    if (box!.get("solanaAddress") != null) "Solana": box!.get("solanaAddress"),
    if (box!.get("EclipseAddress") != null)
      "Eclipse": box!.get("EclipseAddress"),
    // if (box!.get("SoonAddress") != null) "Soon": box!.get("SoonAddress"),
  };
  @override
  void initState() {
    if (box!.containsKey("selectedWalletName"))
      selectedWallet = box!.get("selectedWalletName");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // log(box!.get("solanaAddress"));
    return Container(
      height: 80,
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Colors.grey,
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(10),
      child: DropdownButton<String>(
        isExpanded: true,
        underline: Container(),
        hint: Text(
          "Select Your Network",
        ),
        value: selectedWallet,
        itemHeight: 70,
        onChanged: (String? newValue) {
          setState(() {
            selectedWallet = newValue;
            box!.put("selectedWalletAddress", networkList[newValue!]);
            box!.put("selectedWalletName", newValue);
          });
        },
        items: networkList.entries.map((entry) {
          String walletName = entry.key;
          String walletAddress = entry.value;
          return DropdownMenuItem<String>(
            value: walletName,
            child: ListTile(
              dense: true,
              leading: Image.asset(
                walletName == "Sui"
                    ? "assets/sui.png"
                    : walletName == "Solana"
                        ? "assets/solana.png"
                        : walletName == "Peaq"
                            ? "assets/peaq.png"
                            : walletName == "Aptos"
                                ? "assets/aptos.png"
                                : walletName == "Eclipse"
                                    ? "assets/download.png"
                                    : "assets/soon.png",
                height: 40,
                width: 40,
              ),
              title: Text(
                walletName,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                walletAddress,
                // maxLines: 3,
                style: TextStyle(color: Colors.white),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
