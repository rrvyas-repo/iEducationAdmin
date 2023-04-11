import 'package:admin_app/common/url_model.dart';
import 'package:http/http.dart' as http;

class NetworkApi{
   static Future<String> getShortLink(String longUrl) async {
    final result = await http.post(Uri.parse("https://cleanuri.com/api/v1/shorten"), body: {"url" : longUrl});
    if(result.statusCode == 200){
      final response = urlShortnerResponseFromJson(result.body);
      return response.resultUrl;
    }else{
      return "There is some in shortening the url";
    }
  }
}