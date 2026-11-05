import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:dwaay/config/theme.dart';
import 'package:dwaay/utils/pharmacy_strings.dart';
import 'package:dwaay/utils/widgets/custom_toast.dart';
import 'package:image_picker/image_picker.dart';

import '../bloc/prescription_cubit.dart';

/// Upload a prescription (1..5 photos). Pops with `true` when uploaded.
class PrescriptionUploadPage extends StatefulWidget {
  const PrescriptionUploadPage({super.key});

  @override
  State<PrescriptionUploadPage> createState() => _PrescriptionUploadPageState();
}

class _PrescriptionUploadPageState extends State<PrescriptionUploadPage> {
  static const int _maxImages = 5;
  final ImagePicker _picker = ImagePicker();
  final List<XFile> _images = [];
  final _patient = TextEditingController();
  final _doctor = TextEditingController();
  final _notes = TextEditingController();

  @override
  void dispose() {
    _patient.dispose();
    _doctor.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _pick(ImageSource source) async {
    final s = PharmacyStrings.of(context);
    if (_images.length >= _maxImages) {
      ToastManager.show(context: context, message: s.maxImages, type: ToastType.error);
      return;
    }
    try {
      if (source == ImageSource.gallery) {
        final remaining = _maxImages - _images.length;
        if (remaining == 1) {
          // pickMultiImage requires limit >= 2
          final one = await _picker.pickImage(source: source, imageQuality: 85);
          if (one == null) return;
          setState(() => _images.add(one));
        } else {
          final picked = await _picker.pickMultiImage(imageQuality: 85, limit: remaining);
          if (picked.isEmpty) return;
          setState(() => _images.addAll(picked.take(remaining)));
        }
      } else {
        final picked = await _picker.pickImage(source: source, imageQuality: 85);
        if (picked == null) return;
        setState(() => _images.add(picked));
      }
    } catch (_) {
      // Permission denied / picker cancelled: nothing to do.
    }
  }

  Future<void> _submit() async {
    final s = PharmacyStrings.of(context);
    if (_images.isEmpty) {
      ToastManager.show(context: context, message: s.selectImages, type: ToastType.error);
      return;
    }
    final cubit = context.read<PrescriptionCubit>();
    final created = await cubit.upload(
      images: _images,
      patientName: _patient.text.trim(),
      doctorName: _doctor.text.trim(),
      notes: _notes.text.trim(),
    );
    if (!mounted) return;
    if (created != null) {
      ToastManager.show(context: context, message: s.uploadedOk, type: ToastType.success);
      context.pop(true);
    } else {
      ToastManager.show(
        context: context,
        message: cubit.state.error ?? 'Error',
        type: ToastType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = PharmacyStrings.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(s.uploadPrescription)),
      body: BlocBuilder<PrescriptionCubit, PrescriptionState>(
        builder: (context, state) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(s.noPrescriptionsHint,
                  style: TextStyle(color: Theme.of(context).hintColor, fontSize: 13)),
              const SizedBox(height: 16),
              SizedBox(
                height: 96,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    for (int i = 0; i < _images.length; i++)
                      Stack(
                        children: [
                          Container(
                            width: 96,
                            height: 96,
                            margin: const EdgeInsetsDirectional.only(end: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: FileImage(File(_images[i].path)),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          PositionedDirectional(
                            top: 2,
                            end: 10,
                            child: GestureDetector(
                              onTap: () => setState(() => _images.removeAt(i)),
                              child: const CircleAvatar(
                                radius: 11,
                                backgroundColor: Colors.black54,
                                child: Icon(Icons.close, size: 14, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    if (_images.length < _maxImages) ...[
                      _addTile(Icons.photo_camera_outlined, s.camera, () => _pick(ImageSource.camera)),
                      const SizedBox(width: 8),
                      _addTile(Icons.photo_library_outlined, s.gallery, () => _pick(ImageSource.gallery)),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _field(_patient, s.patientName),
              const SizedBox(height: 12),
              _field(_doctor, s.doctorName),
              const SizedBox(height: 12),
              _field(_notes, s.notes, lines: 3),
              const SizedBox(height: 24),
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: state.uploading ? null : _submit,
                  child: state.uploading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : Text(s.submit),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _addTile(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 96,
        height: 96,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Theme.of(context).colorScheme.outline),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppTheme.primaryColor),
            const SizedBox(height: 6),
            Text(label, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _field(TextEditingController c, String label, {int lines = 1}) {
    return TextField(
      controller: c,
      maxLines: lines,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
