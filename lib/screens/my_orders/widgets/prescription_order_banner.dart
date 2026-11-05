import 'package:flutter/material.dart';
import 'package:dwaay/screens/prescriptions/widgets/rx_badge.dart';
import 'package:dwaay/utils/pharmacy_strings.dart';

/// Shows the prescription verification state of an order (hidden when the
/// order has no prescription medicines).
class PrescriptionOrderBanner extends StatelessWidget {
  final bool requiresPrescription;
  final String status; // pending | approved | rejected
  final String rejectionReason;

  const PrescriptionOrderBanner({
    super.key,
    required this.requiresPrescription,
    required this.status,
    this.rejectionReason = '',
  });

  @override
  Widget build(BuildContext context) {
    if (!requiresPrescription) return const SizedBox.shrink();
    final s = PharmacyStrings.of(context);
    late final MaterialColor color;
    late final String label;
    switch (status) {
      case 'approved':
        color = Colors.green;
        label = s.statusApproved;
        break;
      case 'rejected':
        color = Colors.red;
        label = s.prescriptionRejectedOrder;
        break;
      default:
        color = Colors.orange;
        label = s.awaitingPrescriptionReview;
    }
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const RxBadge(),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${s.prescription}: $label',
                    style: TextStyle(fontWeight: FontWeight.w700, color: color.shade900)),
                if (status == 'rejected' && rejectionReason.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: Text('${s.reason}: $rejectionReason',
                        style: TextStyle(fontSize: 12, color: color.shade900)),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
