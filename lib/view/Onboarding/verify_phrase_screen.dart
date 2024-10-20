import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wire/config/common.dart';
import 'package:wire/config/theme.dart';
import 'package:wire/controller/auth_controller.dart';
import 'package:wire/view/Onboarding/auth_complete_screen.dart';

class VerifyPhraseScreen extends StatefulWidget {
  final List? words;
  const VerifyPhraseScreen({
    super.key,
    this.words,
  });

  @override
  State<VerifyPhraseScreen> createState() => _VerifyPhraseScreenState();
}

class _VerifyPhraseScreenState extends State<VerifyPhraseScreen> {
  int selectedWord = 1;
  AuthController controller = Get.find<AuthController>();
  List orgMem = [];
  @override
  void initState() {
    widget.words!.shuffle();
    getMem();
    super.initState();
  }

  getMem() async {
    var s = await controller.getMnemonic;
    orgMem = s.toString().split(" ");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blackRussion,
      appBar: AppBar(
        backgroundColor: blackRussion,
        actions: [
          // ElevatedButton(
          //     onPressed: () async {
          //       log("message--$orgMem");
          //     },
          //     child: const Text("data"))
        ],
        title: const Text(
          "Back Up Mnemonics",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Backup quiz",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              height(10),
              const Text(
                "Select the matching words for the serial numbers.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              height(30),
              SizedBox(
                width: Get.width,
                child: Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        controller.word4.clear();
                        selectedWord = 1;
                        setState(() {});
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: selectedWord == 1
                                  ? pupalDark
                                  : blueGray.withOpacity(0.3)),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        width: Get.width * .28,
                        alignment: Alignment.center,
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        padding: const EdgeInsets.only(
                            left: 10, top: 10, bottom: 10, right: 6),
                        child: Text(
                          controller.word4.text.isEmpty
                              ? "No. 4th"
                              : controller.word4.text,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        controller.word8.clear();
                        selectedWord = 2;
                        setState(() {});
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: selectedWord == 2
                                  ? pupalDark
                                  : blueGray.withOpacity(0.3)),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        width: Get.width * .28,
                        alignment: Alignment.center,
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        padding: const EdgeInsets.only(
                            left: 10, top: 10, bottom: 10, right: 6),
                        child: Text(
                          controller.word8.text.isEmpty
                              ? "No. 8th"
                              : controller.word8.text,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        controller.word1.clear();
                        selectedWord = 3;
                        setState(() {});
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: selectedWord == 3
                                  ? pupalDark
                                  : blueGray.withOpacity(0.3)),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        width: Get.width * .28,
                        alignment: Alignment.center,
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        padding: const EdgeInsets.only(
                            left: 10, top: 10, bottom: 10, right: 6),
                        child: Text(
                          controller.word1.text.isEmpty
                              ? "No. 1st"
                              : controller.word1.text,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              height(30),
              GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, childAspectRatio: 16 / 10),
                itemCount: 12,
                itemBuilder: (_, index) => InkWell(
                  onTap: () {
                    switch (selectedWord) {
                      case 1:
                        controller.word4.text = widget.words![index].toString();
                        break;
                      case 2:
                        controller.word8.text = widget.words![index].toString();
                        break;
                      case 3:
                        controller.word1.text = widget.words![index].toString();
                        break;
                      default:
                    }
                    setState(() {});
                  },
                  child: Container(
                    width: Get.width / 4,
                    decoration: BoxDecoration(
                      border: Border.all(color: blueGray.withOpacity(0.3)),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    alignment: Alignment.center,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    padding: const EdgeInsets.only(
                        left: 10, top: 6, bottom: 6, right: 6),
                    child: Text(
                      widget.words![index],
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
              ),
              height(20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                  onPressed: () {
                    if (orgMem[0] == controller.word1.text.trim() &&
                        orgMem[3] == controller.word4.text.trim() &&
                        orgMem[7] == controller.word8.text.trim()) {
                      Get.to(() => const AuthCompleteScreen());
                    } else {
                      Get.showSnackbar(const GetSnackBar(
                        duration: Duration(seconds: 3),
                        title: "Word Not match",
                        message: "Enter in correct order",
                        barBlur: 10,
                        overlayBlur: 4,
                        borderRadius: 20,
                        margin: EdgeInsets.all(30),
                      ));
                    }
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      "Confirm",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
