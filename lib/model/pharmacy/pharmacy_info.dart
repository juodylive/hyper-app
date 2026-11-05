/// Pharmacy-specific product data.
/// Read from the product JSON (product detail, product list, cart item.product).
/// Every field is optional so the app keeps working with non-pharmacy payloads.
class PharmacyInfo {
  final bool requiresPrescription;
  final bool isControlled;
  final String genericName;
  final String activeIngredient;
  final String dosageForm;
  final String strength;
  final String packSize;
  final String manufacturer;
  final String expiryDate;
  final String usageDirections;
  final String sideEffects;
  final String warnings;
  final String storageInstructions;

  const PharmacyInfo({
    this.requiresPrescription = false,
    this.isControlled = false,
    this.genericName = '',
    this.activeIngredient = '',
    this.dosageForm = '',
    this.strength = '',
    this.packSize = '',
    this.manufacturer = '',
    this.expiryDate = '',
    this.usageDirections = '',
    this.sideEffects = '',
    this.warnings = '',
    this.storageInstructions = '',
  });

  static const PharmacyInfo empty = PharmacyInfo();

  static bool _b(dynamic v) {
    if (v is bool) return v;
    if (v is num) return v != 0;
    if (v is String) return v == '1' || v.toLowerCase() == 'true';
    return false;
  }

  static String _s(dynamic v) => v == null ? '' : v.toString();

  factory PharmacyInfo.fromJson(Map<String, dynamic>? json) {
    if (json == null) return empty;
    return PharmacyInfo(
      requiresPrescription: _b(json['requires_prescription']),
      isControlled: _b(json['is_controlled']),
      genericName: _s(json['generic_name']),
      activeIngredient: _s(json['active_ingredient']),
      dosageForm: _s(json['dosage_form']),
      strength: _s(json['strength']),
      packSize: _s(json['pack_size']),
      manufacturer: _s(json['manufacturer']),
      expiryDate: _s(json['expiry_date']),
      usageDirections: _s(json['usage_directions']),
      sideEffects: _s(json['side_effects']),
      warnings: _s(json['warnings']),
      storageInstructions: _s(json['storage_instructions']),
    );
  }

  Map<String, dynamic> toJson() => {
        'requires_prescription': requiresPrescription,
        'is_controlled': isControlled,
        'generic_name': genericName,
        'active_ingredient': activeIngredient,
        'dosage_form': dosageForm,
        'strength': strength,
        'pack_size': packSize,
        'manufacturer': manufacturer,
        'expiry_date': expiryDate,
        'usage_directions': usageDirections,
        'side_effects': sideEffects,
        'warnings': warnings,
        'storage_instructions': storageInstructions,
      };

  bool get hasDetails =>
      genericName.isNotEmpty ||
      activeIngredient.isNotEmpty ||
      dosageForm.isNotEmpty ||
      strength.isNotEmpty ||
      packSize.isNotEmpty ||
      manufacturer.isNotEmpty ||
      expiryDate.isNotEmpty ||
      usageDirections.isNotEmpty ||
      sideEffects.isNotEmpty ||
      warnings.isNotEmpty ||
      storageInstructions.isNotEmpty;

  /// Short one-line label for product cards, e.g. "500mg • Tablet".
  String get shortLabel => [strength, dosageForm].where((e) => e.isNotEmpty).join(' • ');
}
