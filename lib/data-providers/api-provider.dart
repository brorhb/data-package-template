import 'package:your_package_name_here/models/Source.dart';
import 'package:dio/dio.dart';

class ApiProvider implements Source {
  String url = "https://example.com";
  // Dio is just a example... If you use another fetch method, use that instead
  Dio dio = Dio();

  @override
  Future<List> fetch() async {
    Response response = await dio.get(url);
    return response.data;
  }
}