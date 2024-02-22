import 'package:http/http.dart' as http;

class TokenService {
  static const TARGET_URL = "localhost:8080";
  static void sendToken(String targetURl, String token) async {
    print("http://$targetURl/api/token/$token");
    http.get(Uri.parse("http://$targetURl/api/token/$token"),
        headers: {"Content-Type": "application/json"});
  }
}
