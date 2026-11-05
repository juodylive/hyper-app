import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dwaay/config/theme.dart';
import 'package:dwaay/screens/cart_page/model/get_cart_model.dart';
import 'package:dwaay/screens/prescriptions/bloc/prescription_cubit.dart';
import 'package:dwaay/screens/prescriptions/widgets/prescription_picker_sheet.dart';
import 'package:dwaay/screens/prescriptions/widgets/rx_badge.dart';
import 'package:dwaay/utils/pharmacy_strings.dart';

/// Shown in the cart when it contains prescription-only or controlled medicines.
class PrescriptionRequirementCard extends StatelessWidget {
  final CartData cart;
  const PrescriptionRequirementCard({super.key, required this.cart});

  @override
  Widget build(BuildContext context) {
    final s = PharmacyStrings.of(context);
    final controlled = cart.controlledItems;
    final rxItems = cart.prescriptionItems;
    if (controlled.isEmpty && rxItems.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
      child: Column(
        children: [
          if (controlled.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Icon(Icons.block, size: 18, color: Colors.red.shade700),
                    const SizedBox(width: 6),
                    Text(s.controlledTitle,
                        style: TextStyle(fontWeight: FontWeight.w700, color: Colors.red.shade700)),
                  ]),
                  const SizedBox(height: 6),
                  Text(s.controlledHint,
                      style: TextStyle(fontSize: 12, color: Colors.red.shade900)),
                  const SizedBox(height: 6),
                  for (final i in controlled)
                    Text('• ${i.product?.name ?? ''}',
                        style: TextStyle(fontSize: 12, color: Colors.red.shade900)),
                ],
              ),
            ),
          if (rxItems.isNotEmpty)
            BlocBuilder<PrescriptionCubit, PrescriptionState>(
              builder: (context, state) {
                final count = state.selectedIds.length;
                final ok = count > 0;
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: ok ? Colors.green.shade300 : Colors.orange.shade300,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        const RxBadge(),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(s.cartNeedsRx,
                              style: const TextStyle(fontWeight: FontWeight.w700)),
                        ),
                      ]),
                      const SizedBox(height: 6),
                      Text(s.cartNeedsRxHint,
                          style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor)),
                      const SizedBox(height: 6),
                      for (final i in rxItems)
                        Text('• ${i.product?.name ?? ''}', style: const TextStyle(fontSize: 12)),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => showPrescriptionPicker(context),
                              icon: Icon(ok ? Icons.check_circle : Icons.attach_file,
                                  size: 18, color: ok ? Colors.green : AppTheme.primaryColor),
                              label: Text(ok
                                  ? '${s.attachPrescription} ($count ${s.attachedCount})'
                                  : s.attachPrescription),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
