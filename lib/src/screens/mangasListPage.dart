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
    return Scaffold(
      appBar: AppBar(
        title: Text("Mangas"),
      ),
      body: Center(
        child: loading ? CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.amber), backgroundColor: Colors.white) : null,
    ),
    );
  }
}
