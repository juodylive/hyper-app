import 'package:dio/dio.dart';
import 'package:dwaay/config/api_base_helper.dart';
import 'package:dwaay/config/api_routes.dart';
import 'package:dwaay/config/constant.dart';
import 'package:image_picker/image_picker.dart';

import '../model/prescription_model.dart';

class PrescriptionRepository {
  Future<List<PrescriptionModel>> fetchPrescriptions() async {
    try {
      final response = await AppConstant.apiBaseHelper
          .getAPICall(ApiRoutes.prescriptionsApi, {});
      if (response.statusCode == 200 && response.data['success'] == true) {
        final data = response.data['data'];
        final list = data is Map ? data['data'] : data;
        if (list is List) {
          return list
              .map((e) => PrescriptionModel.fromJson(e as Map<String, dynamic>))
              .toList();
        }
      }
      return [];
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  /// Uploads a prescription (1..n images). Returns the created prescription.
  Future<PrescriptionModel> uploadPrescription({
    required List<XFile> images,
    String patientName = '',
    String doctorName = '',
    String notes = '',
  }) async {
    try {
      final form = FormData();
      form.fields.addAll([
        MapEntry('patient_name', patientName),
        MapEntry('doctor_name', doctorName),
        MapEntry('notes', notes),
      ]);
      for (final img in images) {
        form.files.add(MapEntry(
          'images[]',
          await MultipartFile.fromFile(img.path, filename: img.name),
        ));
      }
      final response = await AppConstant.apiBaseHelper
          .postAPICall(ApiRoutes.prescriptionsApi, form);
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data['success'] == true) {
          return PrescriptionModel.fromJson(
              response.data['data'] as Map<String, dynamic>);
        }
        throw ApiException('${response.data['message']}');
      }
      throw ApiException('Failed to upload prescription');
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<void> deletePrescription(int id) async {
    try {
      final response = await AppConstant.apiBaseHelper
          .deleteAPICall('${ApiRoutes.prescriptionsApi}/$id', {});
      if (response.statusCode != 200) {
        throw ApiException('Failed to delete prescription');
      }
    } catch (e) {
      throw ApiException(e.toString());
    }
  }
}
