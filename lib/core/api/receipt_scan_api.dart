import 'dart:io';
import 'package:dio/dio.dart';
import 'api_client.dart';

class ReceiptScanApi {
  final ApiClient _apiClient;

  ReceiptScanApi(this._apiClient);

  Future<Map<String, dynamic>> scanReceipt(File imageFile) async {
    try {
      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(imageFile.path),
      });

      final response = await _apiClient.post('/receipt/scan', data: formData);
      return response.data['data'] as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to scan receipt: $e');
    }
  }
}

