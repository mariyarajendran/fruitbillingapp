import 'package:IGO/src/allcalls/logout/PresenterLogout.dart';
import 'package:IGO/src/data/AllApiRepository.dart';
import 'package:IGO/src/data/FetchDataException.dart';
import 'package:IGO/src/di/di.dart';

class IntractorLogout {
  PresenterLogout _presenterLogout;
  AllApiRepository _allApiRepository;

  IntractorLogout(PresenterLogout _presenterLogout) {
    _allApiRepository = new Injector().allApiRepository;
    this._presenterLogout = _presenterLogout;
  }

  void logoutUser(int userID) {
    _allApiRepository.logoutUser(userID,0).then((data) {
      _presenterLogout.onSuccessResponseUserLogout(data);
    }).catchError((error) {
      _presenterLogout.onFailureResponseGetUserLogout(
          new FetchDataException(error.toString()).toString());
    });
  }
}
