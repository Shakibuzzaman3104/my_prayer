import 'package:my_prayer/local_database/sharedpreferences.dart';
import 'package:my_prayer/utils/utils.dart';
import 'package:my_prayer/viewmodel/base_view_model.dart';

class ViewModelNavigation extends BaseViewModel {
  bool isOnline = false;
  PERMISSIONS _permission = PERMISSIONS.APPROVED;
  bool _isCustomLocation=false;
MySharedPreferences sharedPreferences;
  void connectionChanged(dynamic hasConnection) {
    print("Connection Changed");
    if (!isOnline) {}
    isOnline = !isOnline;
  }

  bool get isCustomLocation => _isCustomLocation;

  double _offset = 0.0;

  PERMISSIONS get permission => _permission;

  double get offset => _offset;

  ViewModelNavigation() {
    initConnection(connectionChanged);
    sharedPreferences = MySharedPreferences.getInstance();
  }

  Future checkPermission() async {
   _isCustomLocation = await sharedPreferences.getIsCustomLocation();
    _permission = await determinePermission();
    setBusy(false);
  }
}
