import 'dart:convert';
import 'package:http/http.dart' as http;

class FbHttpNotificationRequest {


  void sendNotification(String title , String body , List<dynamic> listName) async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization':
          'key=AAAAWyjdB8w:APA91bFW-sDAfM6i_CxSqRNrPopssNQgmskMeC_eOUn9hPDt3gS_ks2naFqL5i8NSfP8XGeelbNinGEnOnjr89h6QGne2ujfFMG7kRUk6EBKbBoa3L2FHfehQlEDUxhnWMq-sRMAIVtu'
    };
    var request =
        http.Request('POST', Uri.parse('https://fcm.googleapis.com/fcm/send'));
    request.body = json.encode({
      "notification": {
        "title": title,
        "body": body,
        "click_action": "OPEN_ACTIVITY_1"
      },
      "data": {"keyname": "any value "},
      "registration_ids": listName
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }
}
