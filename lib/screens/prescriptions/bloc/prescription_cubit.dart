import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../model/prescription_model.dart';
import '../repo/prescription_repo.dart';

class PrescriptionState extends Equatable {
  final bool loading;
  final bool uploading;
  final List<PrescriptionModel> items;
  final String? error;

  /// Prescriptions chosen to be attached to the order currently being placed.
  final Set<int> selectedIds;

  const PrescriptionState({
    this.loading = false,
    this.uploading = false,
    this.items = const [],
    this.error,
    this.selectedIds = const {},
  });

  PrescriptionState copyWith({
    bool? loading,
    bool? uploading,
    List<PrescriptionModel>? items,
    String? error,
    bool clearError = false,
    Set<int>? selectedIds,
  }) =>
      PrescriptionState(
        loading: loading ?? this.loading,
        uploading: uploading ?? this.uploading,
        items: items ?? this.items,
        error: clearError ? null : (error ?? this.error),
        selectedIds: selectedIds ?? this.selectedIds,
      );

  @override
  List<Object?> get props => [loading, uploading, items, error, selectedIds];
}

class PrescriptionCubit extends Cubit<PrescriptionState> {
  PrescriptionCubit() : super(const PrescriptionState());
  final PrescriptionRepository _repo = PrescriptionRepository();

  Future<void> load() async {
    emit(state.copyWith(loading: true, clearError: true));
    try {
      final list = await _repo.fetchPrescriptions();
      // Drop selections that are no longer usable.
      final usable = list.where((e) => e.isUsable).map((e) => e.id).toSet();
      emit(state.copyWith(
        loading: false,
        items: list,
        selectedIds: state.selectedIds.where(usable.contains).toSet(),
      ));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  /// Returns the created prescription, or null on failure (error is in state).
  Future<PrescriptionModel?> upload({
    required List<XFile> images,
    String patientName = '',
    String doctorName = '',
    String notes = '',
  }) async {
    emit(state.copyWith(uploading: true, clearError: true));
    try {
      final created = await _repo.uploadPrescription(
        images: images,
        patientName: patientName,
        doctorName: doctorName,
        notes: notes,
      );
      emit(state.copyWith(
        uploading: false,
        items: [created, ...state.items],
        selectedIds: {...state.selectedIds, created.id},
      ));
      return created;
    } catch (e) {
      emit(state.copyWith(uploading: false, error: e.toString()));
      return null;
    }
  }

  Future<void> delete(int id) async {
    try {
      await _repo.deletePrescription(id);
      emit(state.copyWith(
        items: state.items.where((e) => e.id != id).toList(),
        selectedIds: {...state.selectedIds}..remove(id),
      ));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  void toggleSelected(int id) {
    final next = {...state.selectedIds};
    if (!next.add(id)) next.remove(id);
    emit(state.copyWith(selectedIds: next));
  }

  void clearSelection() => emit(state.copyWith(selectedIds: {}));
}
