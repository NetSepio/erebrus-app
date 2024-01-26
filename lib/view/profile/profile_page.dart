import 'package:flutter/material.dart';
import 'package:wire/api/api.dart';
import 'package:wire/view/profile/edit_profile.dart';
import 'package:wire/view/profile/profile_model.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  ProfileModel? profileModel;
  @override
  void initState() {
    apiCall();
    super.initState();
  }

  apiCall() async {
    profileModel = await ApiController().getProfile();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EditProfilePage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: profileModel == null
            ? const Center(child: CircularProgressIndicator())
            : profileModel!.payload == null
                ? const SizedBox()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (profileModel!.payload!.walletAddress != null)
                        TextField(
                          readOnly: true,
                          maxLines: 3,
                          decoration: InputDecoration(
                            hintText:
                                profileModel!.payload!.walletAddress.toString(),
                            hintMaxLines: 3,
                            border: const OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 1,
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(height: 20),
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
