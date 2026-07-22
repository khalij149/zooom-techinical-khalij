import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zoom_provider/feature/home/presentation/view/status_update_screen.dart';

import '../../../../core/di/service_locator.dart';
import '../view_model/complete_order/complete_order_cubit.dart';
import '../view_model/completed_paid/completed_paid_cubit.dart';
import '../view_model/products_in_orders/products_in_orders_cubit.dart';
import '../view_model/suspend_order/suspend_order_cubit.dart';
import '../view_model/suspend_with_goods_returned/suspend_with_goods_returned_cubit.dart';
import '../view_model/installation_not_done/installation_not_done_cubit.dart';

class StatusUpdateScreenWrapper extends StatelessWidget {
  final int orderId;
  final String customerName;
  final List<int> servicesIds;

  const StatusUpdateScreenWrapper({
    super.key,
    required this.orderId,
    required this.customerName,
    required this.servicesIds,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => serviceLocator<CompleteOrderCubit>()),
        BlocProvider(create: (_) => serviceLocator<SuspendOrderCubit>()),
        BlocProvider(create: (_) => serviceLocator<CompletedPaidCubit>()),
        BlocProvider(create: (_) => serviceLocator<ProductsInOrdersCubit>()),
        BlocProvider(
            create: (_) => serviceLocator<SuspendWithGoodsReturnedCubit>()),
        BlocProvider(
            create: (_) => serviceLocator<InstallationNotDoneCubit>()),
      ],
      child: StatusUpdateScreen(
        orderId: orderId,
        customerName: customerName,
        servicesIds: servicesIds,
      ),
    );
  }
}
