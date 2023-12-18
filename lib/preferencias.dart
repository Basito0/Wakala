import 'package:shared_preferences/shared_preferences.dart';
class SharedPrefs {
  late final SharedPreferences sharedPrefs;
  Future<void> init() async {
    sharedPrefs = await SharedPreferences.getInstance();

  }

  String getLink(){
    String link = (sharedPrefs.getString('link') ?? "70d2-138-84-33-95.ngrok-free.app");
    return link;
  }


  void setLink(String newLink){
    sharedPrefs.setString('link', newLink);
  }

}

final sharedPrefs = SharedPrefs();