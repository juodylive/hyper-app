import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:dwaay/config/theme.dart';
import 'package:dwaay/router/app_routes.dart';
import 'package:dwaay/utils/pharmacy_strings.dart';

import '../bloc/prescription_cubit.dart';
import '../view/prescriptions_page.dart';

/// Bottom sheet used at checkout to pick (or upload) prescriptions.
Future<void> showPrescriptionPicker(BuildContext context) async {
  final cubit = context.read<PrescriptionCubit>();
  cubit.load();
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (sheetContext) => BlocProvider.value(
      value: cubit,
      child: const _PickerBody(),
    ),
  );
}

class _PickerBody extends StatelessWidget {
  const _PickerBody();

  @override
  Widget build(BuildContext context) {
    final s = PharmacyStrings.of(context);
    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.75),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: BlocBuilder<PrescriptionCubit, PrescriptionState>(
            builder: (context, state) {
              final cubit = context.read<PrescriptionCubit>();
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(s.selectPrescriptions,
                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 12),
                  Flexible(
                    child: state.loading && state.items.isEmpty
                        ? const Center(child: CircularProgressIndicator())
                        : state.items.isEmpty
                            ? Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 24),
                                  child: Text(s.noPrescriptionsHint, textAlign: TextAlign.center),
                                ),
                              )
                            : ListView.separated(
                                shrinkWrap: true,
                                itemCount: state.items.length,
                                separatorBuilder: (_, __) => const SizedBox(height: 10),
                                itemBuilder: (_, i) {
                                  final p = state.items[i];
                                  return PrescriptionCard(
                                    prescription: p,
                                    selectable: true,
                                    selected: state.selectedIds.contains(p.id),
                                    onTap: () => cubit.toggleSelected(p.id),
                                  );
                                },
                              ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            await context.push(AppRoutes.prescriptionUpload);
                          },
                          icon: const Icon(Icons.upload_file),
                          label: Text(s.uploadPrescription),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryColor,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () => Navigator.pop(context),
                          child: Text(s.done),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
