import 'package:dio/src/form_data.dart';
import 'package:injectable/injectable.dart';
import 'package:zoom_provider/feature/home/data/model/all_requests_model.dart';
import 'package:zoom_provider/feature/home/data/model/complete_order_model.dart';
import 'package:zoom_provider/feature/home/data/model/completed_paid_model.dart';
import 'package:zoom_provider/feature/home/data/model/get_received_requests_model.dart';
import 'package:zoom_provider/feature/home/data/model/products_in_orders.dart';
import 'package:zoom_provider/feature/home/data/model/receive_order_model.dart';
import 'package:zoom_provider/feature/home/data/model/requests_details_model.dart';
import 'package:zoom_provider/feature/home/data/model/start_order_model.dart';
import 'package:zoom_provider/feature/home/data/model/suspend_order_model.dart';
import 'package:zoom_provider/feature/home/data/model/suspend_with_goods_returned.dart';
import 'package:zoom_provider/feature/home/data/model/unsuspend_model.dart';
import 'package:zoom_provider/feature/home/data/model/installation_not_done_model.dart';

import '../../../../core/constants/app_values.dart';
import '../../../../core/network/common/api_result.dart';
import '../../../../core/network/remote/api_manager.dart';
import '../../../../core/utils/app_shared_preference.dart';
import '../api/home_retrofit_client.dart';
import '../model/home_model.dart';
import 'home_data_sources.dart';
@Injectable( as: HomeDataSources )
class HomeDataSourcesImp implements HomeDataSources {
  final HomeRetrofitClient _apiService;
  final ApiManager _apiManager;

  HomeDataSourcesImp(this._apiService, this._apiManager);

  @override
  Future<Result<HomeModel>> getHomeData() async {
    final result = await _apiManager.execute<HomeModel>(() async {
      final token = await SharedPreferencesUtils.getString(AppValues.token);
      final auth = 'Bearer $token';
      return await _apiService.getHomeData(auth);
    });

    switch (result) {
      case SuccessResult<HomeModel>():
        return SuccessResult<HomeModel>(result.data);

      case FailureResult<HomeModel>():
        return FailureResult<HomeModel>(
          exception: result.exception,
          apiError: result.apiError,
        );
    }
  }

  @override
  Future<Result<AllRequestsModel>> getAllRequests()async {
    final result = await _apiManager.execute<AllRequestsModel>(() async {
      final token = await SharedPreferencesUtils.getString(AppValues.token);
      final auth = 'Bearer $token';
      return await _apiService.getAllRequests(auth);
    });

    switch (result) {
      case SuccessResult<AllRequestsModel>():
        return SuccessResult<AllRequestsModel>(result.data);

      case FailureResult<AllRequestsModel>():
        return FailureResult<AllRequestsModel>(
          exception: result.exception,
          apiError: result.apiError,
        );
    }
  }

  @override
  Future<Result<RequestsDetailsModel>> getRequestsDetails(int requestsId)async {
    final result = await _apiManager.execute<RequestsDetailsModel>(() async {
      final token = await SharedPreferencesUtils.getString(AppValues.token);
      final auth = 'Bearer $token';
      return await _apiService.getRequestsDetails(requestsId,auth);
    });

    switch (result) {
      case SuccessResult<RequestsDetailsModel>():
        return SuccessResult<RequestsDetailsModel>(result.data);

      case FailureResult<RequestsDetailsModel>():
        return FailureResult<RequestsDetailsModel>(
          exception: result.exception,
          apiError: result.apiError,
        );
    }
  }

  @override
  Future<Result<CompleteOrderModel>> completeOrder(int orderId)async {
    final result = await _apiManager.execute<CompleteOrderModel>(() async {
      final token = await SharedPreferencesUtils.getString(AppValues.token);
      final auth = 'Bearer $token';
      return await _apiService.completeOrder(orderId,auth);
    });

    switch (result) {
      case SuccessResult<CompleteOrderModel>():
        return SuccessResult<CompleteOrderModel>(result.data);

      case FailureResult<CompleteOrderModel>():
        return FailureResult<CompleteOrderModel>(
          exception: result.exception,
          apiError: result.apiError,
        );
    }
  }

  @override
  Future<Result<ReceiveOrderModel>> receiveOrder(int orderId)async {
    final result = await _apiManager.execute<ReceiveOrderModel>(() async {
      final token = await SharedPreferencesUtils.getString(AppValues.token);
      final auth = 'Bearer $token';
      return await _apiService.receiveOrder(orderId,auth);
    });

    switch (result) {
      case SuccessResult<ReceiveOrderModel>():
        return SuccessResult<ReceiveOrderModel>(result.data);

      case FailureResult<ReceiveOrderModel>():
        return FailureResult<ReceiveOrderModel>(
          exception: result.exception,
          apiError: result.apiError,
        );
    }
  }

  @override
  Future<Result<StartOrderModel>> startOrder(int orderId) async{
    final result = await _apiManager.execute<StartOrderModel>(() async {
      final token = await SharedPreferencesUtils.getString(AppValues.token);
      final auth = 'Bearer $token';
      return await _apiService.startOrder(orderId,auth);
    });

    switch (result) {
      case SuccessResult<StartOrderModel>():
        return SuccessResult<StartOrderModel>(result.data);

      case FailureResult<StartOrderModel>():
        return FailureResult<StartOrderModel>(
          exception: result.exception,
          apiError: result.apiError,
        );
    }
  }

  @override
  Future<Result<SuspendOrderModel>> suspendOrder(int orderId, String notes)async {
    final result = await _apiManager.execute<SuspendOrderModel>(() async {
      final token = await SharedPreferencesUtils.getString(AppValues.token);
      final auth = 'Bearer $token';
      return await _apiService.suspendOrder(orderId,notes,auth);
    });

    switch (result) {
      case SuccessResult<SuspendOrderModel>():
        return SuccessResult<SuspendOrderModel>(result.data);

      case FailureResult<SuspendOrderModel>():
        return FailureResult<SuspendOrderModel>(
          exception: result.exception,
          apiError: result.apiError,
        );
    }
  }

  @override
  Future<Result<UnsuspendOrderModel>> unsuspendOrder(int orderId)async {
    final result = await _apiManager.execute<UnsuspendOrderModel>(() async {
      final token = await SharedPreferencesUtils.getString(AppValues.token);
      final auth = 'Bearer $token';
      return await _apiService.unsuspendOrder(orderId,auth);
    });

    switch (result) {
      case SuccessResult<UnsuspendOrderModel>():
        return SuccessResult<UnsuspendOrderModel>(result.data);

      case FailureResult<UnsuspendOrderModel>():
        return FailureResult<UnsuspendOrderModel>(
          exception: result.exception,
          apiError: result.apiError,
        );
    }
  }

  @override
  Future<Result<CompletedPaidModel>> completedPaid(int orderId, FormData body) async{
    final result = await _apiManager.execute<CompletedPaidModel>(() async {
      final token = await SharedPreferencesUtils.getString(AppValues.token);
      final auth = 'Bearer $token';
      return await _apiService.completedPaid(orderId,body,auth);
    });

    switch (result) {
      case SuccessResult<CompletedPaidModel>():
        return SuccessResult<CompletedPaidModel>(result.data);

      case FailureResult<CompletedPaidModel>():
        return FailureResult<CompletedPaidModel>(
          exception: result.exception,
          apiError: result.apiError,
        );
    }
  }

  @override
  Future<Result<ProductsInOrders>> productsInOrders(int orderId) async{
    final result = await _apiManager.execute<ProductsInOrders>(() async {
      final token = await SharedPreferencesUtils.getString(AppValues.token);
      final auth = 'Bearer $token';
      return await _apiService.productsInOrders(orderId,auth);
    });

    switch (result) {
      case SuccessResult<ProductsInOrders>():
        return SuccessResult<ProductsInOrders>(result.data);

      case FailureResult<ProductsInOrders>():
        return FailureResult<ProductsInOrders>(
          exception: result.exception,
          apiError: result.apiError,
        );
    }
  }

  @override
  Future<Result<SuspendWithGoodsReturnedModel>> suspendWithGoodsReturned(int orderId, FormData body) async{
    final result = await _apiManager.execute<SuspendWithGoodsReturnedModel>(() async {
      final token = await SharedPreferencesUtils.getString(AppValues.token);
      final auth = 'Bearer $token';
      return await _apiService.suspendWithGoodsReturned(orderId,body,auth);
    });

    switch (result) {
      case SuccessResult<SuspendWithGoodsReturnedModel>():
        return SuccessResult<SuspendWithGoodsReturnedModel>(result.data);

      case FailureResult<SuspendWithGoodsReturnedModel>():
        return FailureResult<SuspendWithGoodsReturnedModel>(
          exception: result.exception,
          apiError: result.apiError,
        );
    }
  }

  @override
  Future<Result<InstallationNotDoneModel>> installationNotDone(int orderId, String notes) async{
    final result = await _apiManager.execute<InstallationNotDoneModel>(() async {
      final token = await SharedPreferencesUtils.getString(AppValues.token);
      final auth = 'Bearer $token';
      return await _apiService.installationNotDone(orderId,notes,auth);
    });

    switch (result) {
      case SuccessResult<InstallationNotDoneModel>():
        return SuccessResult<InstallationNotDoneModel>(result.data);

      case FailureResult<InstallationNotDoneModel>():
        return FailureResult<InstallationNotDoneModel>(
          exception: result.exception,
          apiError: result.apiError,
        );
    }
  }

  @override
  Future<Result<GetReceivedRequestsModel>> getReceivedRequests()async {
    final result = await _apiManager.execute<GetReceivedRequestsModel>(() async {
      final token = await SharedPreferencesUtils.getString(AppValues.token);
      final auth = 'Bearer $token';
      return await _apiService.getReceivedRequests(auth);
    });

    switch (result) {
      case SuccessResult<GetReceivedRequestsModel>():
        return SuccessResult<GetReceivedRequestsModel>(result.data);

      case FailureResult<GetReceivedRequestsModel>():
        return FailureResult<GetReceivedRequestsModel>(
          exception: result.exception,
          apiError: result.apiError,
        );
    }
  }
}
