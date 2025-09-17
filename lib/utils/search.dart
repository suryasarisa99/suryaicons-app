import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fuzzy/fuzzy.dart';

// singleton class
// store the searchIndexes
class SearchManager {
  static final SearchManager _instance = SearchManager._internal();
  static Fuzzy<Map<String, dynamic>>? fuse;
  static List<Map<String, dynamic>>? dataset;

  factory SearchManager() {
    if (fuse == null) {
      loadSearchIndexes();
    }
    return _instance;
  }
  SearchManager._internal();

  static List<int> search(String query) {
    if (fuse == null) return [];
    final result = fuse!.search(query);
    debugPrint(result.toString());
    return result.map((r) => r.matches.first.arrayIndex).toList();
  }

  static List<int> normalSearch(String query) {
    if (fuse == null) return [];
    // use dataset to find indexes that contains the query
    // final lowerQuery = query.toLowerCase();
    final results = <int>[];
    // for (var i = 0; i < dataset!.length; i++) {
    //   if (dataset![i].contains(lowerQuery)) {
    //     results.add(i);
    //   }
    // }
    return results;
  }

  static void loadSearchIndexes() async {
    final indexes = await loadFiles();
    dataset = indexes;
    fuse = Fuzzy(
      indexes,
      options: FuzzyOptions(
        isCaseSensitive: false,
        threshold: 0.25,

        keys: [
          WeightedKey(
            name: 'name',
            weight: 0.7,
            getter: (item) => item['n'] as String,
          ),
          WeightedKey(
            name: 'tags',
            weight: 0.3,
            getter: (item) => (item['t'] as String),
          ),
        ],
      ),
    );
  }

  // static Future<({List<String> names, List<String> tags})> loadFiles() async {
  //   final namesFuture = rootBundle.loadString('assets/names.json');
  //   final tagsFuture = rootBundle.loadString('assets/tags.json');
  //   final results = await Future.wait([namesFuture, tagsFuture]);
  //   final names = (jsonDecode(results[0]) as List).cast<String>();
  //   final tags = (jsonDecode(results[1]) as List).cast<String>();
  //   return (names: names, tags: tags);
  // }

  static Future<List<Map<String, dynamic>>> loadFiles() async {
    final indexes = await rootBundle.loadString('assets/searchIndexes.json');
    final decoded = jsonDecode(indexes) as List;
    return decoded.cast<Map<String, dynamic>>();
  }
}
