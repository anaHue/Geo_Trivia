import 'package:flutter/material.dart';

import 'package:geo_trivia/constants/app_strings.dart';

class FlagCard extends StatelessWidget {
  const FlagCard({super.key, required this.country, required this.flag});

  final String country;
  final String flag;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              AppStrings.findCapitalPrompt(country),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 18),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                flag,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 82),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
