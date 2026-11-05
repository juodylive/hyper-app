class PrescriptionModel {
  final int id;
  final String patientName;
  final String doctorName;
  final String notes;
  final String status; // pending | approved | rejected | expired
  final String rejectionReason;
  final List<String> images;
  final String createdAt;
  final String expiresAt;

  const PrescriptionModel({
    required this.id,
    this.patientName = '',
    this.doctorName = '',
    this.notes = '',
    this.status = 'pending',
    this.rejectionReason = '',
    this.images = const [],
    this.createdAt = '',
    this.expiresAt = '',
  });

  bool get isApproved => status == 'approved';
  bool get isRejected => status == 'rejected';
  bool get isExpired => status == 'expired';
  bool get isPending => status == 'pending';

  /// Can be attached to a new order (not rejected / expired).
  bool get isUsable => !isRejected && !isExpired;

  factory PrescriptionModel.fromJson(Map<String, dynamic> json) {
    final imgs = json['images'];
    return PrescriptionModel(
      id: json['id'] is int ? json['id'] : int.tryParse('${json['id']}') ?? 0,
      patientName: (json['patient_name'] ?? '').toString(),
      doctorName: (json['doctor_name'] ?? '').toString(),
      notes: (json['notes'] ?? '').toString(),
      status: (json['status'] ?? 'pending').toString(),
      rejectionReason: (json['rejection_reason'] ?? '').toString(),
      images: imgs is List ? imgs.map((e) => e.toString()).toList() : <String>[],
      createdAt: (json['created_at'] ?? '').toString(),
      expiresAt: (json['expires_at'] ?? '').toString(),
    );
  }
}
