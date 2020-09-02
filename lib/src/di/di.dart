import './../data/AllApiRepository.dart';
import './../data/ServiceRequest.dart';

class Injector {
  static final Injector _singleton = new Injector._internal();

  factory Injector() {
    return _singleton;
  }

  Injector._internal();

  AllApiRepository get allApiRepository => new ServiceRequest();
}
