import 'package:shared_preferences/shared_preferences.dart';
import 'flutter_flow/lat_lng.dart';

class FFAppState {
  static final FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal() {
    initializePersistedState();
  }

  Future initializePersistedState() async {
    prefs = await SharedPreferences.getInstance();
    _imagetemporal = prefs.getString('ff_imagetemporal') ?? _imagetemporal;
  }

  late SharedPreferences prefs;

  String _imagetemporal = '';
  String get imagetemporal => _imagetemporal;
  set imagetemporal(String _value) {
    _imagetemporal = _value;
    prefs.setString('ff_imagetemporal', _value);
  }

  String imagen2 = '';
}

LatLng? _latLngFromString(String? val) {
  if (val == null) {
    return null;
  }
  final split = val.split(',');
  final lat = double.parse(split.first);
  final lng = double.parse(split.last);
  return LatLng(lat, lng);
}
