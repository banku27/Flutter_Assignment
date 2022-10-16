import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:quote_app/model/authors_quote.dart';
import 'package:quote_app/model/quote_model.dart';

const baseUrl = 'https://api.quotable.io/search/quotes?query=life%20happiness';

Future<Quotes> getQuote({bool isNormal = true, String authorName = ''}) async {
  final url = isNormal
      ? '$baseUrl'
      : 'https://api.quotable.io/quotes?author=$authorName';

  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    log('success');
    return Quotes.fromJson(jsonDecode(response.body));
  }
  throw Exception('failed to load upcoming movies');
}

Future<AuthorsModel> quoteSearch(String query) async {
  final searchUrl = 'https://api.quotable.io/search/authors?query=$query';
  // final url = '$searchUrl?query=$query';

  final response = await http.get(
    Uri.parse(searchUrl),
  );
  if (response.statusCode == 200) {
    return AuthorsModel.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('not found');
  }
}
