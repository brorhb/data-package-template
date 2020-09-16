import 'package:your_package_name_here/data-providers/api-provider.dart';
import 'package:your_package_name_here/data-providers/cache-provider.dart';

import 'models/Cache.dart';
import 'models/Source.dart';

class Repository {
  ApiProvider _apiProvider;
  List<Source> sources = [
    cacheProvider
  ];
  List<Cache> caches = [
    cacheProvider
  ];

  Repository() {
    _apiProvider = ApiProvider();
    sources.add(_apiProvider);
  }

  Future<List> fetch({bool refresh = false}) async {
    var source, cache;
    List items;
    if (refresh) {
      items = await _apiProvider.fetch();
    } else {
      for (source in sources) {
        items = await source.fetch();
        if (items != null) break;
      }
    }
    for (cache in caches) {
      if (cache != source) {
        cache.insert(items);
      }
    }
    return items;
  }

  Future delete({int itemId}) async {
    var cache;
    for (cache in caches) {
      await cache.delete(itemId: itemId);
    }
  }
}