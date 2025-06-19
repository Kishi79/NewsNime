import 'package:flutter/material.dart';
import '../utils/helper.dart';

class PrimaryButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;

  const PrimaryButton({
    super.key,
    required this.onPressed,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: cPrimary,
          padding: const EdgeInsets.symmetric(vertical: 13),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          title,
          style: subtitle1.copyWith(color: cWhite, fontWeight: semibold),
        ),
      ),
    );
  }
}