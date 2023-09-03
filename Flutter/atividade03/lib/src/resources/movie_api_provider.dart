import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/item_model.dart';

class MovieApiProvider {
  final _apiKey = '7204bf3a518825b385b085dbc0700817';

  Future<ItemModel> fetchMovieList(int page) async {
    final url = Uri.parse(
        "http://api.themoviedb.org/3/movie/popular?api_key=$_apiKey&page=$page");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return ItemModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }
}
