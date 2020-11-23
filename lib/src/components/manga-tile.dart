import 'package:fangapp/src/models/manga-info.dart';
import 'package:flutter/material.dart';

class MangaTile extends StatelessWidget {
  MangaInfo manga;

  MangaTile({Key key, this.manga}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.only(left: 5, top: 5, right: 10, bottom: 5),
        child: Row(
          children: <Widget>[
            Image.network('https://s4.mangareader.net/cover/one-piece/one-piece-l1.jpg', height: 80, width: 55),
            Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(manga.name),
                      Text(manga.status),
                      Text(manga.lastChapter)
                    ],
                  ),
                ),
            ),
            Icon(Icons.favorite),
          ],
        ),
      )
    );
  }
}
