import 'package:erebrus_app/config/colors.dart';
import 'package:erebrus_app/config/common.dart';
import 'package:erebrus_app/view/Onboarding/OnboardingScreen.dart';
import 'package:erebrus_app/view/inAppPurchase/ProFeaturesScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class PrivacyConsentScreen extends StatelessWidget {
  const PrivacyConsentScreen({Key? key}) : super(key: key);

  final _storage = const FlutterSecureStorage();

  Future<void> _storeConsent(bool consentGiven) async {
    await _storage.write(
        key: 'privacy_consent_given', value: consentGiven.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy & Consent'),
        automaticallyImplyLeading: false, // No back button
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  privacyPolicyContent,
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'By clicking "Agree and Continue", you confirm that you have read, understood, and agree to our Privacy Policy and consent to the collection and use of your data as described.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await _storeConsent(true);

                box!.containsKey("token")
                    ? box!.get("token") != ""
                        ? Get.offAll(() => ProFeaturesScreen(fromLogin: true))
                        : Get.offAll(() => const OnboardingScreen())
                    : Get.offAll(() => const OnboardingScreen());
              },
              child: const Text('Agree and Continue'),
              style: ElevatedButton.styleFrom(
                backgroundColor: blue,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 15),
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: blue,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Get.snackbar(
                  'Consent Required',
                  'You must agree to the Privacy Policy to use Erebrus.',
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
              child: const Text('Decline'),
            ),
          ],
        ),
      ),
    );
  }
}

const String privacyPolicyContent = """
Privacy Policy for Erebrus

Last Updated: July 23, 2025

Thank you for choosing Erebrus ("we," "us," or "our"). Your privacy is important to us. This Privacy Policy outlines how we collect, use, and protect your information when you use our mobile application (the "Service"), which includes a virtual private network (VPN) and AI chatbot features.

By using Erebrus, you agree to the practices described in this policy. If you do not agree, you may stop using the app at any time.

---

1. No Required Account or Login

You can use Erebrus without creating an account or providing any personal information. However, if you choose to sign in, we may collect your email address for support, subscription management, and syncing purposes.

---

2. Information We Collect

- Optional Email Address: Only collected if you sign in. Used for account support and syncing subscriptions across devices.
- AI Chat Inputs: When using the AI chatbot, your input is securely processed in real-time to generate responses. These inputs are not stored or linked to your identity.
- VPN Metadata: We may collect anonymous VPN session data (e.g., connection duration, server location, protocol, and timestamps) to monitor server performance and prevent abuse.
- Device Data: Information like device type, OS version, and app version may be collected to diagnose issues and improve service quality.

---

3. What We Do NOT Collect

- We do not log your VPN browsing activity, websites visited, DNS queries, or IP addresses.
- We do not store any personally identifiable AI chatbot data.
- We do not sell or share your data for advertising purposes.

---

4. How We Use Your Information

- To operate and maintain the VPN and AI chatbot services
- To improve performance, fix bugs, and enhance user experience
- To provide optional subscription or login features
- To prevent fraud or abuse of the service

---

5. AI Chatbot Privacy

Our AI chatbot feature processes text input to generate replies using trusted third-party AI infrastructure. We do not use your conversations to train AI models or identify users. Data is handled securely and deleted after processing.

---

6. Data Sharing

We may work with third-party service providers (e.g., hosting, AI processing, customer support) under strict confidentiality agreements. These providers do not have access to your private browsing or identity data.

---

7. Security

We take your privacy seriously and implement industry-standard measures such as encryption, secure transmission, and local storage protections. However, no system is 100% secure, and users should take caution when sharing sensitive information.

---

8. Your Rights

As a user, you have the right to:

- Use Erebrus without providing personal data
- Delete your optional account or data at any time
- Contact us to inquire about data handling or request deletion

To exercise any of these rights, email us at: support@erebrus.app

---

9. Children’s Privacy

Erebrus is not intended for children under 13. We do not knowingly collect personal information from children.

---

10. Changes to This Policy

We may update this Privacy Policy as needed. Updates will be posted in the app with the updated "Last Updated" date.

---

11. Contact Us

If you have any questions about this Privacy Policy, please contact:

Email: support@erebrus.app  
Website: https://erebrus.io/

""";
