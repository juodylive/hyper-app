import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:dwaay/config/theme.dart';
import 'package:dwaay/router/app_routes.dart';
import 'package:dwaay/utils/pharmacy_strings.dart';

import '../bloc/prescription_cubit.dart';
import '../model/prescription_model.dart';
import '../widgets/prescription_status_chip.dart';

class PrescriptionsPage extends StatefulWidget {
  const PrescriptionsPage({super.key});

  @override
  State<PrescriptionsPage> createState() => _PrescriptionsPageState();
}

class _PrescriptionsPageState extends State<PrescriptionsPage> {
  @override
  void initState() {
    super.initState();
    context.read<PrescriptionCubit>().load();
  }

  Future<void> _confirmDelete(PrescriptionModel p) async {
    final s = PharmacyStrings.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        content: Text(s.deleteConfirm),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(s.cancel)),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(s.delete, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (ok == true && mounted) context.read<PrescriptionCubit>().delete(p.id);
  }

  @override
  Widget build(BuildContext context) {
    final s = PharmacyStrings.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(s.myPrescriptions)),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        onPressed: () => context.push(AppRoutes.prescriptionUpload),
        icon: const Icon(Icons.add),
        label: Text(s.addPrescription),
      ),
      body: BlocBuilder<PrescriptionCubit, PrescriptionState>(
        builder: (context, state) {
          if (state.loading && state.items.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.items.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.description_outlined, size: 64, color: Theme.of(context).hintColor),
                    const SizedBox(height: 12),
                    Text(s.noPrescriptions,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    Text(s.noPrescriptionsHint,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Theme.of(context).hintColor)),
                  ],
                ),
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () => context.read<PrescriptionCubit>().load(),
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
              itemCount: state.items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, i) => PrescriptionCard(
                prescription: state.items[i],
                onDelete: () => _confirmDelete(state.items[i]),
              ),
            ),
          );
        },
      ),
    );
  }
}

class PrescriptionCard extends StatelessWidget {
  final PrescriptionModel prescription;
  final VoidCallback? onDelete;
  final bool selectable;
  final bool selected;
  final VoidCallback? onTap;

  const PrescriptionCard({
    super.key,
    required this.prescription,
    this.onDelete,
    this.selectable = false,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final s = PharmacyStrings.of(context);
    final p = prescription;
    final title = p.patientName.isNotEmpty ? p.patientName : '${s.prescription} #${p.id}';
    final enabled = !selectable || p.isUsable;
    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? AppTheme.primaryColor : Theme.of(context).colorScheme.outline,
              width: selected ? 1.6 : 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 64,
                  height: 64,
                  child: p.images.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: p.images.first,
                          fit: BoxFit.cover,
                          errorWidget: (_, __, ___) => const Icon(Icons.broken_image_outlined),
                        )
                      : const Icon(Icons.description_outlined),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontWeight: FontWeight.w600)),
                        ),
                        PrescriptionStatusChip(prescription: p),
                      ],
                    ),
                    if (p.doctorName.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(p.doctorName,
                            style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor)),
                      ),
                    if (p.isRejected && p.rejectionReason.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text('${s.reason}: ${p.rejectionReason}',
                            style: const TextStyle(fontSize: 12, color: Colors.red)),
                      ),
                    if (p.createdAt.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(p.createdAt.split('T').first,
                            style: TextStyle(fontSize: 11, color: Theme.of(context).hintColor)),
                      ),
                  ],
                ),
              ),
              if (selectable)
                Padding(
                  padding: const EdgeInsetsDirectional.only(start: 8),
                  child: Icon(
                    selected ? Icons.check_circle : Icons.circle_outlined,
                    color: selected ? AppTheme.primaryColor : Theme.of(context).hintColor,
                  ),
                )
              else if (onDelete != null)
                IconButton(
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(Icons.delete_outline, size: 20),
                  onPressed: onDelete,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
