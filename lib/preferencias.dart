import 'package:shared_preferences/shared_preferences.dart';
import 'funciones_api.dart';

class SharedPrefs {
  late final SharedPreferences sharedPrefs;
  Future<void> init() async {
    sharedPrefs = await SharedPreferences.getInstance();

  }

  String getLink(){
    String link = (sharedPrefs.getString('link') ?? "cb61-138-84-33-95.ngrok-free.app");
    return link;
  }


  void setLink(String newLink){
    sharedPrefs.setString('link', newLink);
    fetchUsers(getLink());
  }

  Uri getUrl(String pathSegment){
    if (getLink().contains('localhost')){
      return Uri.http(getLink(), pathSegment);  
    }else{
      return Uri.https(getLink(), pathSegment); 
    }
  } 

}

final sharedPrefs = SharedPrefs();