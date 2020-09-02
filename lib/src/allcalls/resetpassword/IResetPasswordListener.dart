import 'package:IGO/src/models/responsemodel/calllogresponsemodel/CallLogResponseModel.dart';
import 'package:IGO/src/models/responsemodel/logoutresponsemodel/LogoutResponseModel.dart';
import 'package:IGO/src/models/responsemodel/resetpasswordresponsemodel/ResetResponseModel.dart';

abstract class IResetPasswordListener {
  void onSuccessResponseResetPassword(ResetResponseModel resetResponseModel);

  void onFailureResponseResetPassword(String statusCode);

  Map parseResetMapData();

  void errorValidationMgs(String _msg);

  String getEmailId();

  String getNewPassword();

  void postResetPassword();
}
