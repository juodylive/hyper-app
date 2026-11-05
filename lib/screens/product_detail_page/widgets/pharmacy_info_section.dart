import 'package:flutter/material.dart';
import 'package:dwaay/model/pharmacy/pharmacy_info.dart';
import 'package:dwaay/screens/prescriptions/widgets/rx_badge.dart';
import 'package:dwaay/utils/pharmacy_strings.dart';

import 'specification_row_widget.dart';

/// Prescription / controlled banners + medicine information for the product page.
/// Renders nothing for products without pharmacy data.
class PharmacyInfoSection extends StatelessWidget {
  final PharmacyInfo info;
  const PharmacyInfoSection({super.key, required this.info});

  @override
  Widget build(BuildContext context) {
    final s = PharmacyStrings.of(context);
    if (!info.requiresPrescription && !info.isControlled && !info.hasDetails) {
      return const SizedBox.shrink();
    }
    final scheme = Theme.of(context).colorScheme;

    Widget longText(String title, String body) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: scheme.tertiary.withValues(alpha: 0.9))),
              const SizedBox(height: 4),
              Text(body,
                  style: TextStyle(fontSize: 13, color: scheme.tertiary.withValues(alpha: 0.8))),
            ],
          ),
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (info.isControlled)
          _banner(
            color: Colors.red,
            icon: Icons.block,
            title: s.controlledTitle,
            body: s.controlledHint,
          )
        else if (info.requiresPrescription)
          _banner(
            color: Colors.orange,
            icon: Icons.medical_services_outlined,
            title: s.rxRequired,
            body: s.rxRequiredHint,
            leading: const RxBadge(),
          ),
        if (info.hasDetails)
          ExpansionTile(
            title: Text(s.medicineInfo,
                style: TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w600, color: scheme.tertiary)),
            initiallyExpanded: true,
            tilePadding: EdgeInsets.zero,
            shape: const Border(),
            collapsedShape: const Border(),
            collapsedIconColor: scheme.tertiary,
            iconColor: scheme.tertiary,
            children: [
              if (info.genericName.isNotEmpty)
                SpecificationRowWidget(label: s.genericName, value: info.genericName),
              if (info.activeIngredient.isNotEmpty)
                SpecificationRowWidget(label: s.activeIngredient, value: info.activeIngredient),
              if (info.dosageForm.isNotEmpty)
                SpecificationRowWidget(label: s.dosageForm, value: info.dosageForm),
              if (info.strength.isNotEmpty)
                SpecificationRowWidget(label: s.strength, value: info.strength),
              if (info.packSize.isNotEmpty)
                SpecificationRowWidget(label: s.packSize, value: info.packSize),
              if (info.manufacturer.isNotEmpty)
                SpecificationRowWidget(label: s.manufacturer, value: info.manufacturer),
              if (info.expiryDate.isNotEmpty)
                SpecificationRowWidget(label: s.expiryDate, value: info.expiryDate),
              if (info.usageDirections.isNotEmpty) longText(s.usageDirections, info.usageDirections),
              if (info.sideEffects.isNotEmpty) longText(s.sideEffects, info.sideEffects),
              if (info.warnings.isNotEmpty) longText(s.warnings, info.warnings),
              if (info.storageInstructions.isNotEmpty) longText(s.storage, info.storageInstructions),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(s.consultDoctor,
                    style: TextStyle(fontSize: 11, color: Theme.of(context).hintColor)),
              ),
            ],
          ),
      ],
    );
  }

  Widget _banner({
    required MaterialColor color,
    required IconData icon,
    required String title,
    required String body,
    Widget? leading,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          leading ?? Icon(icon, size: 20, color: color.shade800),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(fontWeight: FontWeight.w700, color: color.shade900)),
                const SizedBox(height: 3),
                Text(body, style: TextStyle(fontSize: 12, color: color.shade900)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
