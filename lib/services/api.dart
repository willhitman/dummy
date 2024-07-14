import'package:http/http.dart' as http;

const String baseUrl = "http://enlightenedminds.pythonanywhere.com/";

class BaseClient{
  var client = http.Client();

//  post
Future<dynamic> post(String email,String phone) async{
  var url = Uri.parse("${baseUrl}pay");
  var headers = {
    "mobile": "18c82a7d35f6ddff4d770eb2a2846b5a37d413eced80b547dadfbfb1192e3fc2",

  };
  var response = await  client.post(url, headers: headers,
      body: {
      "email": "email", "phone": "phone"
    });
  if(response.statusCode == 200){
    print(response.body);
    return response.body;
  } else {
  //  throw exception
  }
}
}