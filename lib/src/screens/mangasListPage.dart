import 'package:fangapp/src/components/manga-tile.dart';
import 'package:fangapp/src/models/manga-info.dart';
import 'package:fangapp/src/utils/mangas-service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MangasListPage extends StatefulWidget {
  @override
  _MangasListPageState createState() => _MangasListPageState();
}

class _MangasListPageState extends State<MangasListPage> {

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 250), () => context.read<MangasService>().updateMangasList());
  }

  @override
  Widget build(BuildContext context) {
    bool loading = context.watch<MangasService>().loading;
    List<MangaInfo> mangasList= context.watch<MangasService>().mangasList;
    return Scaffold(
      appBar: AppBar(
        title: Text("Mangas"),
      ),
      body: loading
          ? Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.amber), backgroundColor: Colors.white))
          : ListView.builder(
              itemCount: mangasList.length,
              itemBuilder: (context, index) {
                return MangaTile(manga: mangasList[index]);
              },
            ),
    );
  }
}
