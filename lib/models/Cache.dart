abstract class Cache {
  Future<int> insert({List items});
  Future<int> delete({int itemId});
  Future clear();
}