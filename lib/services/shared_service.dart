import 'dart:convert';
import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

import '../model/quote_model.dart';

class SharedServices {
  //get
  Future<List<Results>> getFavourites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Results> res = [];

    if (prefs.getString('FavQuotes') == null) {
      return [];
    }

    var json = jsonDecode(prefs.getString('FavQuotes')!);

    var list = json?['quotes'] as List;

    res = List.from(
      list.map((e) => Results.fromJson(e)),
    );

    return res;
  }

  Future<void> addToFavourites(Results quote) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<Results> res = [];

    res = await getFavourites();

    res.add(quote);
    log(res.map((e) => e.toMap()).toList().runtimeType.toString());
    var json = jsonEncode({'quotes': res.map((e) => e.toMap()).toList()});
    await prefs.setString('FavQuotes', json);
  }

  deleteFavourites(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<Results> res = [];

    res = await getFavourites();

    for (var i = 0; i < res.length; i++) {
      if (res[i].id == id) {
        res.removeAt(i);
      }
    }

    var json = jsonEncode({'quotes': res.map((e) => e.toMap()).toList()});
    await prefs.setString('FavQuotes', json);
  }
}
