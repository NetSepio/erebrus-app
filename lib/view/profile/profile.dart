import 'package:flutter/material.dart';
import 'package:wire/api/api.dart';
import 'package:wire/view/profile/profile_model.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  ProfileModel? profileModel;

  apiCall() async {
    profileModel = await ApiController().getProfile();
    setState(() {});
  }

  @override
  void initState() {
    apiCall();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: profileModel == null
            ? const Center(child: CircularProgressIndicator())
            : profileModel!.payload == null
                ? const SizedBox()
                : Column(
                    children: [
                      if (profileModel!.payload!.walletAddress != null)
                        TextField(
                          readOnly: true,
                          maxLines: 3,
                          controller: TextEditingController(
                              text: profileModel!.payload!.walletAddress
                                  .toString()),
                          decoration: const InputDecoration(
                            labelText: "Wallet Address",
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 1,
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(height: 20),
                      if (profileModel!.payload!.email != null)
                        TextField(
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: profileModel!.payload!.email.toString(),
                            border: const OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 1,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
      ),
    );
  }
}
