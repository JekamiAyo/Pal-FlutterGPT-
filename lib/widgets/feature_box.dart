import 'package:flutter/material.dart';
import 'package:pal/pallete.dart';

class FeatureBox extends StatelessWidget {
  const FeatureBox(
      {super.key,
      required this.color,
      required this.headerTxt,
      required this.descriptionTxt});
  final Color color;
  final String headerTxt;
  final String descriptionTxt;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 35,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(
          15,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20).copyWith(left: 15),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                headerTxt,
                style: const TextStyle(
                  color: Pallete.blackColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              height: 3,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Text(
                descriptionTxt,
                style: const TextStyle(
                  color: Pallete.blackColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
