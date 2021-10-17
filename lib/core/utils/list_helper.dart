class ListHelper<T> {
  List<List<T>> chunk(List<T> list, int chunkSize) {
    final List<List<T>> chunks = <List<T>>[];
    final int len = list.length;
    for (int i = 0; i < len; i += chunkSize) {
      final int size = i+chunkSize;
      chunks.add(list.sublist(i, size > len ? len : size));
    }
    return chunks;
  }
}
