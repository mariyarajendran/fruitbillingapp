import 'package:IGO/src/models/responsemodel/customer/addcustomer/AddCustomerResponseModel.dart';
import 'package:IGO/src/models/responsemodel/customer/customerlist/CustomerListResponseModel.dart';
import 'package:IGO/src/models/responsemodel/product/addproduct/AddProductResponseModel.dart';
import 'package:IGO/src/models/responsemodel/product/productlist/ProductListResponseModel.dart';



abstract class AllApiRepository {


  //////////////////////////////////////////////////////////////////////product

  Future<AddProductResponseModel> postAddProductDatas(
      Map loginDatas, int event);

  Future<AddCustomerResponseModel> postAddCustomerDatas(
      Map customerDatas, int event);

  Future<ProductListResponseModel> getProductListData(
      Map requestData, int event);


  /////////////////////////////////////////////////////////////////////product

  Future<CustomerListResponseModel> getCustomerListData(
      Map requestData, int event);

}
