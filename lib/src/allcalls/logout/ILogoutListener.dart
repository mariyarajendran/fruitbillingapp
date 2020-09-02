import 'package:IGO/src/models/responsemodel/calllogresponsemodel/CallLogResponseModel.dart';
import 'package:IGO/src/models/responsemodel/logoutresponsemodel/LogoutResponseModel.dart';

abstract class ILogoutListener {


  void onSuccessResponseUserLogout(LogoutResponseModel logoutResponseModel);

  void onFailureResponseGetUserLogout(String statusCode);

  int getUserId();
}
