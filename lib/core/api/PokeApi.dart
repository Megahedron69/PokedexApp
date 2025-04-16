import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PokeApi {
  static final String _baseURL = dotenv.env['API_URL']!;
  static Future<dynamic> fetchFromUrl(String url) async {
    final res = await http.get(Uri.parse(url));
    if (res.statusCode == 200) {
      return json.decode(res.body);
    } else {
      throw Exception('Failed to load data from $url');
    }
  }

  static Future<List> fetchMyPokemon({
    int? limit,
    required String apiName,
    int? offset = 0,
    String? pokemonName,
  }) async {
    try {
      final String url =
          pokemonName != null && pokemonName.isNotEmpty
              ? "$_baseURL/$apiName/$pokemonName"
              : "$_baseURL/$apiName?limit=$limit&offset=$offset";
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data is Map<String, dynamic> && data.containsKey('results')
            ? data['results']
            : [data];
      } else {
        throw Exception("Unable to load data:${response.statusCode}");
      }
    } catch (e) {
      throw FormatException("something went wrong due to $e");
    }
  }

  static Future<Map<String, dynamic>> fetchSinglePokemon(
    String pokemonName,
  ) async {
    final url = "$_baseURL/pokemon/${pokemonName.toLowerCase()}";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Pokémon not found with name or ID: $pokemonName");
    }
  }
}
