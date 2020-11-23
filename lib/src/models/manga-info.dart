class MangaInfo {
  String _author;
  String _imgUrl;
  String _key;
  String _lastChapter;
  String _name;
  String _release;
  String _status;
  String _url;

  MangaInfo(
      String author, String imgUrl,
      String key, String lastChapter,
      String name, String release,
      String status, String url,
  ) {
    this._author = author;
    this._imgUrl = imgUrl;
    this._key = key;
    this._lastChapter = lastChapter;
    this._name = name;
    this._release = release;
    this._status = status;
    this._url = url;
  }

  String get author => _author;

  String get imgUrl => _imgUrl;

  String get key => _key;

  String get lastChapter => _lastChapter;

  String get name => _name;

  String get release => _release;

  String get status => _status;

  String get url => _url;
}