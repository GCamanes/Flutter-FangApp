import 'package:fangapp/src/models/manga-info.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MangasService extends ChangeNotifier {
  List<MangaInfo> _mangasList = [];
  List<MangaInfo> get mangasList => _mangasList;

  bool _loading = false;
  bool get loading => _loading;

  Future<DocumentSnapshot> getMangasList() {
    CollectionReference mangasCollection = FirebaseFirestore.instance.collection('mangasList');
    return mangasCollection.doc('mangas').get();
  }

  void updateMangasList() async {
    _loading = true;
    _mangasList.clear();
    notifyListeners();

    try {
      DocumentSnapshot mangasDoc = await getMangasList();
      for (var manga in mangasDoc.data()['list']) {
        _mangasList.add(MangaInfo(
            manga['author'], manga['imgUrl'],
            manga['key'], manga['lastChapter'],
            manga['name'], manga['release'],
            manga['status'], manga['url'])
        );
      }
    } catch(e) {
      print(e);
    }

    _loading = false;
    notifyListeners();
  }
}