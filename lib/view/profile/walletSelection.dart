import 'package:dio/dio.dart';
import 'package:erebrus_app/config/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';

class WalletDropdown extends StatefulWidget {
  final bool fromProfileScreen;

  const WalletDropdown({super.key, this.fromProfileScreen = false});
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
    if (box!.containsKey("selectedWalletName")) {
      selectedWallet = box!.get("selectedWalletName");
      if (box!.get("selectedWalletName") == "Solana") getNfts();
    }
    super.initState();
  }

  var nftDta;
  getNfts() async {
    var res = await Dio().get(dotenv.get("NFT_API") +
        // "/8bDudaBScd3qSiuE2VujZ5Pr29ruaLg25MhgPMRCjv5d/tokens"
        "/${box!.get("selectedWalletAddress")}/tokens");
    nftDta = res.data;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // log(box!.get("selectedWalletAddress").toString());
    return Column(
      children: [
        Container(
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
                    walletName == "Solana"
                        ? "assets/solana.png"
                        : walletName == "Eclipse"
                            ? "assets/download.png"
                            : "assets/soon.png",
                    height: 40,
                    width: 40,
                  ),
                  title: Text(
                    walletName,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
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
        ),
        if (widget.fromProfileScreen)
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Divider(),
              SizedBox(height: 20),
              ClipRRect(
                borderRadius: BorderRadius.circular(1000),
                child: Image.asset(
                  box!.get("selectedWalletName") == "Solana"
                      ? "assets/solana.png"
                      : box!.get("selectedWalletName") == "Eclipse"
                          ? "assets/download.png"
                          : "assets/soon.png",
                  height: 40,
                  width: 40,
                  fit: BoxFit.cover,
                ),
              ),
              ListTile(
                title: Text(
                  box!.get("selectedWalletAddress").toString(),
                  style: TextStyle(fontSize: 18),
                ),
                trailing: InkWell(
                    onTap: () async {
                      await Clipboard.setData(ClipboardData(
                          text: box!.get("selectedWalletAddress").toString()));
                      Fluttertoast.showToast(msg: "Wallet address copy");
                    },
                    child: Icon(Icons.copy)),
              ),
              Divider(),
              SizedBox(height: 10),
              if (nftDta != null && box!.get("selectedWalletName") == "Solana")
                ListView.separated(
                  itemCount: nftDta.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    var data = nftDta[index];
                    return ListTile(
                      leading: Image.network(
                        data["image"].toString(),
                        fit: BoxFit.cover,
                        width: 80,
                      ),
                      title: Text(data["name".toString()]),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return Divider(indent: 100, height: 20);
                  },
                )
            ],
          )
      ],
    );
  }
}
