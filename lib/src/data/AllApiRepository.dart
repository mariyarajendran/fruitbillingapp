import 'package:IGO/src/models/responsemodel/customer/addcustomerresponsedata/AddCustomerResponseModel.dart';
import 'package:IGO/src/models/responsemodel/customer/customerresponsemodel/CustomerListResponseModel.dart';
import 'package:IGO/src/models/responsemodel/product/addproductresponsemodel/AddProductResponseModel.dart';
import 'package:IGO/src/models/responsemodel/product/calllogresponsemodel/ProductListResponseModel.dart';


abstract class AllApiRepository {
  Future<AddProductResponseModel> postAddProductDatas(
      Map loginDatas, int event);

  Future<AddCustomerResponseModel> postAddCustomerDatas(
      Map customerDatas, int event);


  Future<ProductListResponseModel> getProductListData(
      Map requestData, int event);

  Future<CustomerListResponseModel> getCustomerListData(
      Map requestData, int event);

}
