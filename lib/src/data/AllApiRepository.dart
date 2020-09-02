import 'package:IGO/src/models/responsemodel/addproductresponsemodel/AddProductResponseModel.dart';
import 'package:IGO/src/models/responsemodel/calllogresponsemodel/ProductListResponseModel.dart';
import 'package:IGO/src/models/responsemodel/logoutresponsemodel/LogoutResponseModel.dart';
import 'package:IGO/src/models/responsemodel/resetpasswordresponsemodel/ResetResponseModel.dart';

abstract class AllApiRepository {
  Future<AddProductResponseModel> postAddProductDatas(Map loginDatas, int event);

  Future<ResetResponseModel> postResetPasswordDatas(Map resetDatas, int event);

  Future<ProductListResponseModel> getProductListData(
      Map requestData, int event);

  Future<LogoutResponseModel> logoutUser(int userID, int event);
}
