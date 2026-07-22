import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:zoom_provider/generated/locale_keys.g.dart';

import '../../../../core/common/widget/empty_state_widget.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/common/widget/tools_pattern_painter.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/service_locator.dart';
import '../../../home/data/model/home_model.dart';
import '../../../home/data/model/request_card_data.dart';
import '../../../home/presentation/view/store_screen.dart';
import '../../../home/presentation/view_model/home/home_cubit.dart';
import '../../../home/presentation/view_model/home/home_state.dart';
import '../../../home/presentation/widgets/request_card.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<HomeCubit>()..getHomeData(),
      child: Scaffold(
        backgroundColor: AppColors.surface,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 20.h),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        LocaleKeys.notifications_title.tr(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const StoreScreen(),
                          ),
                        );
                      },
                      child: SvgPicture.asset(
                        'assets/svg/shopping_cart.svg',
                        colorFilter: const ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                        width: 24.w,
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

                        BlocBuilder<HomeCubit, HomeState>(
                          builder: (context, state) {
                            if (state is HomeLoading) {
                              return Skeletonizer(
                                enabled: true,
                                child: _buildNotificationContent(
                                  context,
                                  _getDummyHomeModel(),
                                ),
                              );
                            } else if (state is HomeFailure) {
                              return Center(
                                child: Text(
                                  state.apiError?.message?.toString() ??
                                      LocaleKeys.error_SomethingWentWrong.tr(),
                                ),
                              );
                            } else if (state is HomeSuccess) {
                              final orders = state.homeModel.data ?? [];

                              if (orders.isEmpty) {
                                return EmptyStateWidget(
                                  svgPath: SvgAsset.notification,
                                  text: LocaleKeys
                                      .notifications_no_notifications_found
                                      .tr(),
                                );
                              }

                              return RefreshIndicator(
                                onRefresh: () =>
                                    context.read<HomeCubit>().getHomeData(),
                                child: _buildNotificationContent(
                                  context,
                                  state.homeModel,
                                ),
                              );
                            }

                            return const SizedBox.shrink();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationContent(BuildContext context, HomeModel homeModel) {
    final orders = homeModel.data ?? [];

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

    return ListView.separated(
      padding: EdgeInsets.all(20.w),
      itemCount: orders.length,
      separatorBuilder: (_, __) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        return RequestCard(
          order: mapToRequestCardData(
            orders[index],
          ),
        );
      },
    );
  }

  HomeModel _getDummyHomeModel() {
    return HomeModel(
      data: List.generate(
        6,
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