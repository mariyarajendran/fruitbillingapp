import 'package:IGO/src/models/responsemodel/calllogresponsemodel/CallLogResponseModel.dart';
import 'package:IGO/src/models/responsemodel/calllogresponsemodel/ProductListResponseModel.dart';

abstract class IProductListListener {
  void onSuccessResponseGetProductList(
      ProductListResponseModel productListResponseModel);

  void onFailureResponseGetProductList(String statusCode);

  String getPageCount();

  String getSearchkeyword();

  Map parseGetProductDetailsRequestData();
}
