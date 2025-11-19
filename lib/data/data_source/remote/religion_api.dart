import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:icongrega/domain/models/religion.dart';

class ReligionAPI {
  Future<List<Religion>> getReligions() async {
    final baseUrl = dotenv.env['API_BASE_URL'];
    if (baseUrl == null || baseUrl.isEmpty) {
      throw Exception('API_BASE_URL no está configurado');
    }

    final version = dotenv.env['API_VERSION'] ?? 'v1';
    final url = Uri.parse('$baseUrl/api/$version/auth/religions');

    final appApiKey = dotenv.env['APP_API_KEY'];
    final headers = <String, String>{
      'Accept': 'application/json',
      if (appApiKey != null && appApiKey.isNotEmpty) 'app-api-key': appApiKey,
    };

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final items = data['religions'] as List<dynamic>;
      return items.map((e) => Religion.fromJson(e)).toList();
    }

    throw Exception('Error al obtener religiones: ${response.statusCode} ${response.body}');
  }
}


























//       throw Exception("Error al obtener religiones");
//     }
//   }
// }
