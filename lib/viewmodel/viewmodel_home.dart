import 'package:my_prayer/viewmodel/base_view_model.dart';

class ViewModelHome extends BaseViewModel{

  bool isOnline =false;

  void connectionChanged(dynamic hasConnection) {
    print("Connection Changed");
    if (!isOnline) {}
    isOnline = !isOnline;
  }

  ViewModelHome() {
    initConnection(connectionChanged);
  }

  int _position = 0;

  void setPosition(int pos) {
    this._position = pos;
    notifyListeners();
  }

  int get position => _position;




}