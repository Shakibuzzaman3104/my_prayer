import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:my_prayer/local_database/sharedpreferences.dart';
import 'package:my_prayer/repository/repository.dart';
import 'package:my_prayer/viewmodel/base_view_model.dart';

class ViewModelSettings extends BaseViewModel {
  MySharedPreferences sharedPreferences;
  PrayerRepository _repository;
  String _location;
  List<Address> _addresses=[];

  List<String> _modes = [
    "Shia Ithna-Ansari",
    "University of Islamic Sciences, Karachi",
    "Islamic Society of North America",
    "Muslim World League",
    "Umm Al-Qura University, Makkah",
    "Egyptian General Authority of Survey",
    "Institute of Geophysics, University of Tehran",
    "Gulf Region",
    "Kuwait",
    "Qatar",
    "Majlis Ugama Islam Singapura, Singapore",
    "Union Organization islamic de France",
    "Diyanet İşleri Başkanlığı, Turkey",
    "Spiritual Administration of Muslims of Russia",
  ];


  fetchCoordinateFromName(String query)async{
     _addresses = await Geocoder.local.findAddressesFromQuery(query);
     notifyListeners();
  }

  List<String> get modes => _modes;
  int _position = 2;

  int get position => _position;
  String get location => _location;
  List<Address> get addresses => _addresses;

  ViewModelSettings() {
    _repository = PrayerRepository();
    sharedPreferences = MySharedPreferences.getInstance();
  }

  Future fetchPosition() async {
    _position = await sharedPreferences.getMethod();
    _location =  await sharedPreferences.getAddress();
    notifyListeners();
  }

  int getPositionFromString(String data) {
    return _modes.indexOf(data);
  }

  Future changeMethod(String data) async {
    _position = getPositionFromString(data);
    await sharedPreferences.setMethod(_position);
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);
   return await _repository.fetchAndInsertData(position).catchError((error){}).catchError((e){});
  }
}
