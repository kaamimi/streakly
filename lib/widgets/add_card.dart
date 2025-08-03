import 'package:flutter/material.dart';

class AddCard extends StatelessWidget {
  const AddCard({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 24),
          alignment: Alignment.center,
          child: const Icon(Icons.add, size: 32, color: Colors.white70),
        ),
      ),
    );
  }
}
