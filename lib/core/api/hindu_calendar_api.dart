import 'api_client.dart';

class HinduCalendarApi {
  final ApiClient _apiClient;

  HinduCalendarApi(this._apiClient);

  Future<List<dynamic>> getFestivals(int month, int year) async {
    try {
      final response = await _apiClient.get(
        '/calendar/festivals',
        queryParameters: {'month': month, 'year': year},
      );
      return response.data['data'] as List;
    } catch (e) {
      throw Exception('Failed to fetch festivals: $e');
    }
  }
}

