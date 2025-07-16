import 'package:cached_network_image/cached_network_image.dart';
import 'package:erebrus_app/api/api.dart';
import 'package:erebrus_app/config/strings.dart';
import 'package:erebrus_app/view/cyreneAi/agentModel.dart';
import 'package:erebrus_app/view/cyreneAi/cyreneAi.dart';
import 'package:erebrus_app/view/settings/SettingPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class AgentSelect extends StatefulWidget {
  const AgentSelect({super.key});

  @override
  State<AgentSelect> createState() => _AgentSelectState();
}

class _AgentSelectState extends State<AgentSelect> {
  AgentModel? data;
  getAgent() async {
    EasyLoading.show();
    try {
      var res = await dio
          .get(
            "https://gateway.erebrus.io/api/v1.0/agents/12D3KooWSMjGonLZ6rWnStWwFwyfQiynzECroXSPgSShcJwq8DTX"
            // "https://gateway.erebrus.io/api/v1.0/agents/us01.erebrus.io",
          );
      data = AgentModel.fromJson(res.data);
      setState(() {});
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
    }
  }

  @override
  void initState() {
    getAgent();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.black,
      //   elevation: 0,
      //   centerTitle: true,
      //   title: Text(
      //     'EREBRUS',
      //     style: Theme.of(context)
      //         .textTheme
      //         .titleLarge!
      //         .copyWith(fontWeight: FontWeight.w600),
      //   ),
      //   actions: [
      //     InkWell(
      //       onTap: () {
      //         Get.to(() => const SettingPage())!.whenComplete(
      //           () {
      //             setState(() {});
      //           },
      //         );
      //       },
      //       child: const Padding(
      //         padding: EdgeInsets.all(8.0),
      //         child: Icon(Icons.settings),
      //       ),
      //     )
      //   ],
      // ),
      
      body: SafeArea(
        child: Column(
          children: [
                 Padding(
                   padding: const EdgeInsets.all(10),
                   child: Row(
                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                   children: [
                        Image.asset(
                          'assets/erebrus_mobile_app_icon.png',
                          height: 28,
                        ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        const SizedBox(width: 10),
                        Text(
                          'EREBRUS',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            letterSpacing: 1.2,
                          ),
                        ),
                        Text(
                          'VPN',
                          style: TextStyle(
                            color: Color(0xFF1E90FF),
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () {
                        Get.to(() => SettingPage());
                      },
                      icon: Icon(Icons.settings),
                    ),
                                   ],
                                 ),
                 ),
         
            if (data != null && data!.agents != null)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ListView.builder(
                    itemCount: data!.agents!.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      var d = data!.agents![index];
                      return InkWell(
                        onTap: () {
                          Get.to(() => CyreneAi(data: d));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey.shade700,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                SizedBox(height: 10),
                                CachedNetworkImage(
                                  imageUrl: "https://ipfs.io/ipfs/" +
                                      d.coverImg.toString(),
                                  height: 220,
                                  fit: BoxFit.cover,
                                  errorWidget: (context, url, error) =>
                                      Image.asset(
                                    "assets/Erebrus_AI_Cyrene.png",
                                    height: 220,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                ListTile(
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: CachedNetworkImage(
                                      imageUrl: "https://ipfs.io/ipfs/" +
                                          d.avatarImg.toString(),
                                      height: 40,
                                      width: 40,
                                      fit: BoxFit.cover,
                                      errorWidget: (context, url, error) =>
                                          Image.asset(
                                        "assets/Erebrus_AI_Cyrene.png",
                                        height: 40,
                                        width: 40,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    d.name.toString().toTitleCase(),
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
