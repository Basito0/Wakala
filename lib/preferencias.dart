import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  late final SharedPreferences sharedPrefs;
  Future<void> init() async {
    sharedPrefs = await SharedPreferences.getInstance();
  }

  String getLink() {
    String link = (sharedPrefs.getString('link') ?? "localhost:4000");
    return link;
  }

  void setLink(String newLink) {
    sharedPrefs.setString('link', newLink);
  }
}

final sharedPrefs = SharedPrefs();
