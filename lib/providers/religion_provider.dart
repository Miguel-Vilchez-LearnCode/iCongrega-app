import 'package:flutter/material.dart';
import 'package:icongrega/domain/models/religion.dart';
import 'package:icongrega/domain/repositories/religion_repository.dart';

class ReligionProvider with ChangeNotifier {
  final ReligionRepository repo = ReligionRepository();

  List<Religion> religions = [];
  bool isLoading = false;

  Future<void> loadReligions() async {
    isLoading = true;
    notifyListeners();

    religions = await repo.getAll();

    isLoading = false;
    notifyListeners();
  }
}
