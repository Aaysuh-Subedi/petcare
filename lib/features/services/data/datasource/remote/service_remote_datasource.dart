import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:petcare/core/api/api_client.dart';
import 'package:petcare/core/api/api_endpoints.dart';
import 'package:petcare/features/services/data/models/service_model.dart';

abstract interface class IServiceRemoteDataSource {
  Future<List<ServiceModel>> getServices({int page, int limit});
  Future<ServiceModel?> getServiceById(String serviceId);
  Future<List<ServiceModel>> getServicesByProvider(
    String providerId, {
    int page,
    int limit,
  });
}

final serviceRemoteDatasourceProvider = Provider<IServiceRemoteDataSource>((
  ref,
) {
  return ServiceRemoteDataSource(apiClient: ref.read(apiClientProvider));
});

class ServiceRemoteDataSource implements IServiceRemoteDataSource {
  final ApiClient _apiClient;

  ServiceRemoteDataSource({required ApiClient apiClient})
    : _apiClient = apiClient;

  @override
  Future<List<ServiceModel>> getServices({int page = 1, int limit = 20}) async {
    final response = await _apiClient.get(
      ApiEndpoints.serviceList,
      queryParameters: {'page': page, 'limit': limit},
    );
    final data = response.data;
    List<dynamic> list = [];
    if (data is Map<String, dynamic>) {
      list = data['services'] ?? data['data'] ?? [];
    } else if (data is List) {
      list = data;
    }
    return list
        .map((item) => ServiceModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<ServiceModel?> getServiceById(String serviceId) async {
    final response = await _apiClient.get(
      '${ApiEndpoints.serviceById}/$serviceId',
    );
    final data = response.data;
    if (data is Map<String, dynamic>) {
      final inner = data['data'] ?? data;
      if (inner is Map<String, dynamic>) {
        return ServiceModel.fromJson(inner);
      }
    }
    return null;
  }

  @override
  Future<List<ServiceModel>> getServicesByProvider(
    String providerId, {
    int page = 1,
    int limit = 20,
  }) async {
    final response = await _apiClient.get(
      '${ApiEndpoints.serviceByProvider}/$providerId',
      queryParameters: {'page': page, 'limit': limit},
    );
    final data = response.data;
    List<dynamic> list = [];
    if (data is Map<String, dynamic>) {
      list = data['services'] ?? data['data'] ?? [];
    } else if (data is List) {
      list = data;
    }
    return list
        .map((item) => ServiceModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
