import 'package:flutter/material.dart';
import 'package:dwaay/utils/pharmacy_strings.dart';

import '../model/prescription_model.dart';

class PrescriptionStatusChip extends StatelessWidget {
  final PrescriptionModel prescription;
  const PrescriptionStatusChip({super.key, required this.prescription});

  @override
  Widget build(BuildContext context) {
    final s = PharmacyStrings.of(context);
    late final Color color;
    late final String label;
    if (prescription.isApproved) {
      color = Colors.green;
      label = s.statusApproved;
    } else if (prescription.isRejected) {
      color = Colors.red;
      label = s.statusRejected;
    } else if (prescription.isExpired) {
      color = Colors.grey;
      label = s.statusExpired;
    } else {
      color = Colors.orange;
      label = s.statusPending;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label,
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color)),
    );
  }
}
