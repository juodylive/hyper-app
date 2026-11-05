import 'package:flutter/widgets.dart';

/// Pharmacy-specific UI strings (English + Arabic).
/// Kept outside the .arb files so the app compiles without regenerating
/// localizations; can be migrated into the .arb files later.
class PharmacyStrings {
  final bool _ar;
  const PharmacyStrings._(this._ar);

  static PharmacyStrings of(BuildContext context) {
    final code = Localizations.maybeLocaleOf(context)?.languageCode ?? 'en';
    return PharmacyStrings._(code == 'ar');
  }

  String _t(String en, String ar) => _ar ? ar : en;

  // Badges / product
  String get rxBadge => _t('Rx', 'وصفة');
  String get rxRequired => _t('Prescription required', 'يتطلب وصفة طبية');
  String get rxRequiredHint => _t(
      'This medicine can only be dispensed with a valid prescription.',
      'لا يُصرف هذا الدواء إلا بوصفة طبية سارية.');
  String get controlledTitle => _t('Not available online', 'غير متاح للطلب عبر التطبيق');
  String get controlledHint => _t(
      'This is a controlled medicine and cannot be ordered through the app. Please visit the pharmacy.',
      'هذا دواء خاضع للرقابة ولا يمكن طلبه عبر التطبيق. يرجى زيارة الصيدلية.');
  String get medicineInfo => _t('Medicine information', 'معلومات الدواء');
  String get genericName => _t('Generic name', 'الاسم العلمي');
  String get activeIngredient => _t('Active ingredient', 'المادة الفعالة');
  String get dosageForm => _t('Dosage form', 'الشكل الدوائي');
  String get strength => _t('Strength', 'التركيز');
  String get packSize => _t('Pack size', 'حجم العبوة');
  String get manufacturer => _t('Manufacturer', 'الشركة المصنّعة');
  String get expiryDate => _t('Expiry date', 'تاريخ الانتهاء');
  String get usageDirections => _t('Directions for use', 'طريقة الاستخدام');
  String get sideEffects => _t('Side effects', 'الآثار الجانبية');
  String get warnings => _t('Warnings', 'تحذيرات');
  String get storage => _t('Storage', 'التخزين');
  String get consultDoctor => _t(
      'Always read the leaflet and consult your doctor or pharmacist before use.',
      'اقرأ النشرة الداخلية دائماً واستشر الطبيب أو الصيدلي قبل الاستخدام.');

  // Prescriptions
  String get myPrescriptions => _t('My prescriptions', 'وصفاتي الطبية');
  String get uploadPrescription => _t('Upload prescription', 'رفع وصفة طبية');
  String get addPrescription => _t('Add prescription', 'إضافة وصفة');
  String get noPrescriptions => _t('No prescriptions yet', 'لا توجد وصفات بعد');
  String get noPrescriptionsHint => _t(
      'Upload a clear photo of your prescription to order prescription medicines.',
      'ارفع صورة واضحة للوصفة لتتمكن من طلب الأدوية التي تتطلب وصفة.');
  String get camera => _t('Camera', 'الكاميرا');
  String get gallery => _t('Gallery', 'المعرض');
  String get patientName => _t('Patient name', 'اسم المريض');
  String get doctorName => _t('Doctor name (optional)', 'اسم الطبيب (اختياري)');
  String get notes => _t('Notes (optional)', 'ملاحظات (اختياري)');
  String get selectImages => _t('Add at least one prescription photo', 'أضف صورة واحدة على الأقل للوصفة');
  String get maxImages => _t('You can add up to 5 photos', 'يمكنك إضافة 5 صور كحد أقصى');
  String get submit => _t('Submit', 'إرسال');
  String get uploadedOk => _t('Prescription uploaded', 'تم رفع الوصفة');
  String get delete => _t('Delete', 'حذف');
  String get deleteConfirm => _t('Delete this prescription?', 'حذف هذه الوصفة؟');
  String get cancel => _t('Cancel', 'إلغاء');
  String get statusPending => _t('Under review', 'قيد المراجعة');
  String get statusApproved => _t('Approved', 'تمت الموافقة');
  String get statusRejected => _t('Rejected', 'مرفوضة');
  String get statusExpired => _t('Expired', 'منتهية');
  String get reason => _t('Reason', 'السبب');

  // Cart / checkout
  String get cartNeedsRx => _t('Prescription needed for some items', 'بعض المنتجات تحتاج وصفة طبية');
  String get cartNeedsRxHint => _t(
      'Attach a prescription. The pharmacist will verify it before dispensing.',
      'أرفق وصفة طبية. سيتحقق الصيدلي منها قبل صرف الدواء.');
  String get attachPrescription => _t('Attach prescription', 'إرفاق وصفة');
  String get attachedCount => _t('attached', 'مرفقة');
  String get prescriptionRequiredToCheckout =>
      _t('Please attach a prescription to continue', 'يرجى إرفاق وصفة طبية للمتابعة');
  String get removeControlledToCheckout => _t(
      'Remove controlled medicines from the cart to continue',
      'أزل الأدوية الخاضعة للرقابة من السلة للمتابعة');
  String get selectPrescriptions => _t('Select prescriptions', 'اختر الوصفات');
  String get done => _t('Done', 'تم');

  // Orders
  String get awaitingPrescriptionReview =>
      _t('Awaiting prescription review', 'بانتظار مراجعة الوصفة');
  String get prescriptionRejectedOrder => _t('Prescription rejected', 'تم رفض الوصفة');
  String get prescription => _t('Prescription', 'الوصفة الطبية');

  /// Localized label for pharmacy-specific order statuses, else null.
  String? orderStatusLabel(String status) {
    switch (status.toLowerCase()) {
      case 'awaiting_prescription_review':
      case 'prescription_pending':
        return awaitingPrescriptionReview;
      case 'prescription_rejected':
        return prescriptionRejectedOrder;
      default:
        return null;
    }
  }

  // Search / stores
  String get searchMedicines =>
      _t('Search medicine, generic name or ingredient', 'ابحث عن دواء أو اسم علمي أو مادة فعالة');
  String get open24h => _t('Open 24h', 'مفتوحة 24 ساعة');
  String get openNow => _t('Open now', 'مفتوحة الآن');
}
