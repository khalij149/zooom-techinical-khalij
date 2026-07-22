import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:zoom_provider/core/di/service_locator.dart';
import 'package:zoom_provider/feature/home/presentation/view_model/get_received_requests/get_received_requests_cubit.dart';
import 'package:zoom_provider/feature/home/presentation/view_model/get_received_requests/get_received_requests_state.dart';
import '../../../../core/common/widget/empty_state_widget.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../data/model/get_received_requests_model.dart' as received;
import '../../data/model/home_model.dart' as home;
import '../view_model/home/home_cubit.dart';
import '../view_model/home/home_state.dart';
import '../widgets/authorization_header.dart';
import '../widgets/store_item.dart';
import 'order_details_screen.dart';

class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => serviceLocator<HomeCubit>()..getHomeData(),
        ),
        BlocProvider(
          create: (context) =>
          serviceLocator<GetReceivedRequestsCubit>()..getReceivedRequests(),
        ),
      ],
      child: const StoreView(),
    );
  }
}

class StoreView extends StatelessWidget {
  const StoreView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  Expanded(
                    child: Text(
                      LocaleKeys.Home_store_title.tr(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: AppColors.scaffoldBackground,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  child: RefreshIndicator(
                    onRefresh: () async {
                      await Future.wait([
                        context.read<HomeCubit>().getHomeData(),
                        context
                            .read<GetReceivedRequestsCubit>()
                            .getReceivedRequests(),
                      ]);
                    },
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              LocaleKeys.Home_approved_disbursement_requests
                                  .tr(
                                args: [
                                  DateFormat('EEEE, MMMM d', context.locale.languageCode)
                                      .format(DateTime.now()),
                                ],
                              ),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          const _StoreContent(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StoreContent extends StatelessWidget {
  const _StoreContent();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, homeState) {
        return BlocBuilder<GetReceivedRequestsCubit, GetReceivedRequestsState>(
          builder: (context, receivedState) {
            final isLoading = homeState is HomeLoading ||
                receivedState is GetReceivedRequestsLoading;

            if (isLoading) {
              return Skeletonizer(
                enabled: true,
                child: Column(
                  children: [
                    _buildHomeList(context, [_getDummyOrder()]),
                    const SizedBox(height: 24),
                    _buildReceivedList(context, [_getDummyRequestData()]),
                  ],
                ),
              );
            }

            final homeOrders = (homeState is HomeSuccess)
                ? homeState.homeModel.data ?? []
                : <home.OrderModel>[];

            final receivedRequests =
            (receivedState is GetReceivedRequestsSuccess)
                ? receivedState.receivedRequestsModel.data ?? []
                : <received.RequestData>[];

            if (homeOrders.isEmpty && receivedRequests.isEmpty) {
              return EmptyStateWidget(
                icon: Icons.store_mall_directory_outlined,
                text: LocaleKeys.Home_no_requests_found.tr(),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (homeOrders.isNotEmpty) ...[
                  _buildHomeList(context, homeOrders),
                  const SizedBox(height: 24),
                ],
                if (receivedRequests.isNotEmpty) ...[
                  _buildReceivedList(context, receivedRequests),
                  const SizedBox(height: 40),
                ],
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildHomeList(BuildContext context, List<home.OrderModel> orders) {
    return Column(
      children: orders.map((order) {
        return Column(
          children: [
            AuthorizationHeader(
              id: '#${order.code ?? order.id}',
              status: LocaleKeys.Home_certified.tr(),
            ),
            const SizedBox(height: 12),
            ...(order.products ?? []).map(
                  (product) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => OrderDetailsScreen(
                          requestId: order.id??0,
                        ),
                      ),
                    );
                  },
                  child: StoreItem(
                    title: product.name ?? '',
                    code: '${order.code} | ${product.type ?? ''}',
                    quantity:
                    '${product.quantity ?? 0} ${LocaleKeys.Home_pcs.tr()}',
                    status: 'ready',
                    statusColor: AppColors.paleGreen,
                    statusTextColor: const Color(0xFF27AE60),
                  ),
                ),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildReceivedList(
      BuildContext context,
      List<received.RequestData> requests,
      ) {
    return Column(
      children: requests.map((request) {
        return Column(
          children: [
            AuthorizationHeader(
              id: '#${request.code ?? request.id}',
              status: LocaleKeys.Home_recipient.tr(),
              headerColor: AppColors.palePurple,
              textColor: AppColors.darkrose,
            ),
            const SizedBox(height: 12),
            ...(request.products ?? []).map(
                  (product) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => OrderDetailsScreen(
                          requestId: request.id??0,
                        ),
                      ),
                    );
                  },
                  child: StoreItem(
                    title: product.name ?? '',
                    code:
                    '${request.code} | ${LocaleKeys.Home_recipient.tr()} by ${request.customer ?? ''}',
                    quantity:
                    '${product.quantity ?? 0} ${LocaleKeys.Home_pcs.tr()}',
                    status: 'recipient',
                    statusColor: AppColors.palePurple,
                    statusTextColor: AppColors.darkrose,
                  ),
                ),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  home.OrderModel _getDummyOrder() {
    return home.OrderModel(
      id: 1,
      code: 12345,
      status: home.OrderStatusModel(label: 'Certified', value: 'certified'),
      products: [
        home.ProductModel(name: 'Product Name', quantity: 1, type: 'Type'),
      ],
    );
  }

  received.RequestData _getDummyRequestData() {
    return received.RequestData(
      id: 1,
      code: 12345,
      customer: 'Customer',
      products: [
        received.ProductModel(name: 'Product Name', quantity: 1, type: 'Type'),
      ],
    );
  }
}