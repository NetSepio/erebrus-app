import 'package:flutter/material.dart';

class ProFeaturesScreen extends StatelessWidget {
  const ProFeaturesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  Icon(
                    Icons.precision_manufacturing,
                    size: 60,
                    color: Color(0xff0162FF),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'PRO Features',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FeatureCard(
                  color: Colors.red.shade900,
                  icon: Icons.visibility_off,
                  title: 'Anonymous',
                  description: 'Hide your ip with\nanonymous surfing',
                ),
                FeatureCard(
                  color: Colors.purpleAccent.shade700,
                  icon: Icons.rocket_launch,
                  title: 'Fast',
                  description: 'Up to 1000 Mb/s\nbandwidth to explore',
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FeatureCard(
                  color: Colors.blue.shade700,
                  icon: Icons.remove_circle_outline,
                  title: 'Remove Ads',
                  description: 'Enjoy the app\nwithout annoying ads',
                ),
                FeatureCard(
                  color: Colors.green.shade500,
                  icon: Icons.security,
                  title: 'Secure',
                  description: 'Transfer traffic via\nencrypted tunnel',
                ),
              ],
            ),
            const Spacer(),
            SubscriptionCard(),
            const SizedBox(height: 16),
            const FreeTrialButton(),
          ],
        ),
      ),
    );
  }
}

class FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color? color;
  final String description;

  const FeatureCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.description,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          size: 36,
          color: color,
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          description,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white54),
        ),
      ],
    );
  }
}

class SubscriptionCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Column(
        children: [
          SubscriptionOption(
            label: '1 MONTH',
            price: '5.99 \$/Month',
            gradient: LinearGradient(
              colors: [
                Colors.blueAccent.shade700,
                Colors.deepPurpleAccent.shade700,
              ],
            ),
          ),
          const SizedBox(height: 16),
          SubscriptionOption(
            label: '1 YEAR',
            price: '3.00 \$/Month',
            discount: '50% OFF',
            gradient: LinearGradient(
              colors: [
                Colors.blueAccent.shade700,
                Colors.deepPurpleAccent.shade700,
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SubscriptionOption extends StatelessWidget {
  final String label;
  final String price;
  final String? discount;
  final Gradient gradient;

  const SubscriptionOption({
    Key? key,
    required this.label,
    required this.price,
    this.discount,
    required this.gradient,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              if (discount != null)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    discount!,
                    style: const TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ),
              const SizedBox(width: 8),
              Text(
                price,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class FreeTrialButton extends StatelessWidget {
  const FreeTrialButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xff0162FF),
            padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32),
            ),
          ),
          child: const Text(
            'TRY FOR FREE',
            style: TextStyle(
                fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          '7-Day Free Trial. Then 5.99 \$/Month',
          style: TextStyle(color: Colors.white54),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
