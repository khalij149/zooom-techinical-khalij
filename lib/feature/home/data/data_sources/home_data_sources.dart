import 'package:dio/dio.dart';

import '../../../../core/network/common/api_result.dart';
import '../model/all_requests_model.dart';
import '../model/complete_order_model.dart';
import '../model/completed_paid_model.dart';
import '../model/get_received_requests_model.dart';
import '../model/home_model.dart';
import '../model/products_in_orders.dart';
import '../model/receive_order_model.dart';
import '../model/requests_details_model.dart';
import '../model/start_order_model.dart';
import '../model/suspend_order_model.dart';
import '../model/suspend_with_goods_returned.dart';
import '../model/unsuspend_model.dart';
import '../model/installation_not_done_model.dart';
abstract class HomeDataSources {
  Future<Result<HomeModel>> getHomeData();
  Future<Result<AllRequestsModel>> getAllRequests();
  Future<Result<RequestsDetailsModel>> getRequestsDetails(int requestsId);
  Future<Result<ReceiveOrderModel>> receiveOrder(int orderId);
  Future<Result<StartOrderModel>> startOrder(int orderId);
  Future<Result<SuspendOrderModel>> suspendOrder(int orderId, String notes);
  Future<Result<UnsuspendOrderModel>> unsuspendOrder(int orderId);
  Future<Result<CompleteOrderModel>> completeOrder(int orderId);
  Future<Result<CompletedPaidModel>> completedPaid(int orderId, FormData body);
  Future<Result<SuspendWithGoodsReturnedModel>> suspendWithGoodsReturned(int orderId, FormData body);
  Future<Result<InstallationNotDoneModel>> installationNotDone(int orderId, String notes);
  Future<Result<ProductsInOrders>> productsInOrders(int orderId,);
  Future<Result<GetReceivedRequestsModel>> getReceivedRequests();


}
