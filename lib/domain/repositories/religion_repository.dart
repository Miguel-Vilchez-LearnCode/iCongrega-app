import 'package:icongrega/data/data_source/remote/religion_api.dart';
import '../models/religion.dart';

class ReligionRepository {
  final ReligionAPI api = ReligionAPI();

  Future<List<Religion>> getAll() async {
    return await api.getReligions();
  }
}
