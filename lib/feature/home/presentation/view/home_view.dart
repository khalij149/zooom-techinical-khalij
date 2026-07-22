import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/common/widget/empty_state_widget.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../core/di/service_locator.dart';
import '../../data/model/home_model.dart';
import '../../data/model/request_card_data.dart';
import '../view_model/home/home_cubit.dart';
import '../view_model/home/home_state.dart';
import '../widgets/request_card.dart';
import '../widgets/statistics_section.dart';
import 'store_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<HomeCubit>()..getHomeData(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: AppColors.surface,
            body: SafeArea(

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 20.h),
                    child: Row(
                      crossAxisAlignment:CrossAxisAlignment.center  ,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          LocaleKeys.Home_welcome.tr(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Text('👋', style: TextStyle(fontSize: 24.sp)),
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const StoreScreen(),
                              ),
                            );
                          },
                          child: SvgPicture.asset(
                            'assets/svg/shopping_cart.svg',
                            colorFilter: const ColorFilter.mode(
                              Colors.white,
                              BlendMode.srcIn,
                            ),
                            width: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.scaffoldBackground,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.r),
                          topRight: Radius.circular(30.r),
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.r),
                          topRight: Radius.circular(30.r),
                        ),
                        child: Stack(
                          children: [
                            RefreshIndicator(
                              onRefresh: () =>
                                  context.read<HomeCubit>().getHomeData(),
                              child: BlocBuilder<HomeCubit, HomeState>(
                                builder: (context, state) {
                                  if (state is HomeLoading) {
                                    return Skeletonizer(
                                      enabled: true,
                                      child: _buildHomeContent(
                                        context,
                                        _getDummyHomeModel(),
                                      ),
                                    );
                                  } else if (state is HomeFailure) {
                                    return SingleChildScrollView(
                                      physics: const AlwaysScrollableScrollPhysics(),
                                      child: Container(
                                        height: MediaQuery.of(context).size.height * 0.7,
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                                        child: Text(
                                          state.apiError?.getLocalizedMessage(context) ??
                                              state.exception?.toString() ??
                                              LocaleKeys.error_SomethingWentWrong.tr(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            color: Colors.grey.shade700,
                                          ),
                                        ),
                                      ),
                                    );
                                  } else if (state is HomeSuccess) {
                                    return _buildHomeContent(context, state.homeModel);
                                  }

                                  return const SizedBox.shrink();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHomeContent(BuildContext context, HomeModel homeModel) {
    final orders = homeModel.data ?? [];

    final newOrders =
    orders.where((o) => o.status?.value != 'completed').toList();

    final completedOrders =
    orders.where((o) => o.status?.value == 'completed').toList();

    RequestCardData mapToRequestCardData(OrderModel order) {
      return RequestCardData(
        id: order.id,
        code: (order.code ?? order.id ?? '').toString(),
        customerName: order.customer?.name ?? 'Unknown Customer',
        address: order.address ?? '',
        date: order.customerDate ?? order.createdAt ?? '',
        note: order.customerNotes ??
            (order.products?.isNotEmpty == true
                ? order.products!.first.name ?? ''
                : ''),
        statusValue: order.status?.value ?? '',
        statusLabel: order.status?.label ?? '',
      );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 25.h),
          StatisticsSection(
            stats: homeModel.stats,
          ),
          SizedBox(height: 25.h),
          if (newOrders.isNotEmpty) ...[
            Text(
              LocaleKeys.Home_new_requests.tr(),
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: 10.h),
            ...newOrders.map(
                  (order) => RequestCard(
                order: mapToRequestCardData(order),
              ),
            ),
          ],
          if (completedOrders.isNotEmpty) ...[
            SizedBox(height: 20.h),
            Text(
              LocaleKeys.Home_completed_today.tr(),
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.h),
            ...completedOrders.map(
                  (order) => RequestCard(
                order: mapToRequestCardData(order),
              ),
            ),
          ],
          if (orders.isEmpty)
            Padding(
              padding: EdgeInsets.only(top: 100.h),
              child: EmptyStateWidget(
                icon: Icons.receipt_long,
                text: LocaleKeys.Home_no_requests_found.tr(),
              ),
            ),
        ],
      ),
    );
  }

  HomeModel _getDummyHomeModel() {
    return HomeModel(
      stats: StatsModel(total: 0, canceled: 0, completed: 0, pending: 0),
      data: List.generate(
        3,
            (index) => OrderModel(
          id: index,
          code: 12345,
          customer: CustomerModel(name: 'Customer Name ' * 2),
          address: 'Address Details ' * 3,
          customerDate: '2023-01-01',
          customerNotes: 'Order notes go here ' * 5,
          status: OrderStatusModel(label: 'Status', value: 'new'),
        ),
      ),
    );
  }
}