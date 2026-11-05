import 'package:flutter/material.dart';
import 'package:dwaay/utils/pharmacy_strings.dart';

/// Small red "Rx" pill shown on products that require a prescription.
class RxBadge extends StatelessWidget {
  final bool compact;
  const RxBadge({super.key, this.compact = true});

  @override
  Widget build(BuildContext context) {
    final s = PharmacyStrings.of(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: compact ? 6 : 10, vertical: compact ? 2 : 4),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        border: Border.all(color: Colors.red.shade300),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.medical_services_outlined, size: compact ? 11 : 14, color: Colors.red.shade700),
          const SizedBox(width: 3),
          Text(
            compact ? s.rxBadge : s.rxRequired,
            style: TextStyle(
              fontSize: compact ? 10 : 12,
              fontWeight: FontWeight.w600,
              color: Colors.red.shade700,
            ),
          ),
        ],
      ),
    );
  }
}
