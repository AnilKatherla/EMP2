import 'package:flutter/material.dart';
import '../../data/models/visit_models.dart';
import '../../data/repositories/visit_repository.dart';

class FollowUpViewModel extends ChangeNotifier {
  final VisitRepository _repository;
  
  List<FollowUpResponse> _followUps = [];
  bool _isLoading = false;
  String? _errorMessage;

  FollowUpViewModel({required VisitRepository repository}) : _repository = repository;

  List<FollowUpResponse> get followUps => _followUps;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchFollowUps() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _followUps = await _repository.getFollowUps();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Optional: filtering or searching
  List<FollowUpResponse> get pendingFollowUps => 
      _followUps.where((f) => f.status.toLowerCase() == 'pending').toList();
}
