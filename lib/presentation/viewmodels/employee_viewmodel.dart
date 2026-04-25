import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../providers/base_providers.dart';

part 'employee_viewmodel.g.dart';

@riverpod
class EmployeeViewModel extends _$EmployeeViewModel {
  @override
  FutureOr<List<dynamic>> build() async {
    return _fetchEmployees();
  }

  Future<List<dynamic>> _fetchEmployees() async {
    final api = ref.read(apiServiceProvider);
    final response = await api.get('/employees');
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Failed to load employees');
    }
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchEmployees());
  }
}
