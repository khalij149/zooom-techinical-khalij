// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:flutter/material.dart' as _i409;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:logger/logger.dart' as _i974;
import 'package:pretty_dio_logger/pretty_dio_logger.dart' as _i528;
import 'package:zoom_provider/core/di/service_locator.dart' as _i366;
import 'package:zoom_provider/core/logger/logger_module.dart' as _i853;
import 'package:zoom_provider/core/network/remote/api_manager.dart' as _i238;
import 'package:zoom_provider/core/network/remote/dio_module.dart' as _i890;
import 'package:zoom_provider/core/serves/one_signal_service.dart' as _i289;
import 'package:zoom_provider/feature/about_us_screen/data/api/about_us_retrofit_client.dart'
    as _i1068;
import 'package:zoom_provider/feature/about_us_screen/data/data_sources_imp/remote/remote_about_us_data_source.dart'
    as _i966;
import 'package:zoom_provider/feature/about_us_screen/data/data_sources_imp/remote/remote_about_us_data_source_imp.dart'
    as _i416;
import 'package:zoom_provider/feature/about_us_screen/data/usecase/about_us_usecase.dart'
    as _i547;
import 'package:zoom_provider/feature/about_us_screen/presentation/view_model/about_us/about_us_cubit.dart'
    as _i431;
import 'package:zoom_provider/feature/auth/data/api/auth_retrofit_client.dart'
    as _i533;
import 'package:zoom_provider/feature/auth/data/data_sources_imp/remote/remote_auth_data_source.dart'
    as _i930;
import 'package:zoom_provider/feature/auth/data/data_sources_imp/remote/remote_auth_data_source_imp.dart'
    as _i481;
import 'package:zoom_provider/feature/auth/presentation/view_model/forget_password/forget_password_cubit.dart'
    as _i171;
import 'package:zoom_provider/feature/auth/presentation/view_model/login/login_cubit.dart'
    as _i610;
import 'package:zoom_provider/feature/auth/presentation/view_model/register/register_cubit.dart'
    as _i954;
import 'package:zoom_provider/feature/contact_us/data/api/contact_us_retrofit_client.dart'
    as _i520;
import 'package:zoom_provider/feature/contact_us/data/data_sources_imp/remote/remote_contact_us_data_source.dart'
    as _i368;
import 'package:zoom_provider/feature/contact_us/data/data_sources_imp/remote/remote_contact_us_data_source_imp.dart'
    as _i581;
import 'package:zoom_provider/feature/contact_us/presentation/view_model/contact_us_cubit/contact_us_cubit.dart'
    as _i1009;
import 'package:zoom_provider/feature/contact_us/presentation/view_model/services_faqs/services_faqs_cubit.dart'
    as _i411;
import 'package:zoom_provider/feature/home/data/api/home_retrofit_client.dart'
    as _i70;
import 'package:zoom_provider/feature/home/data/data_sources/home_data_sources.dart'
    as _i871;
import 'package:zoom_provider/feature/home/data/data_sources/home_data_sources_imp.dart'
    as _i128;
import 'package:zoom_provider/feature/home/presentation/view_model/all_requests/all_requests_cubit.dart'
    as _i196;
import 'package:zoom_provider/feature/home/presentation/view_model/complete_order/complete_order_cubit.dart'
    as _i282;
import 'package:zoom_provider/feature/home/presentation/view_model/completed_paid/completed_paid_cubit.dart'
    as _i1063;
import 'package:zoom_provider/feature/home/presentation/view_model/get_received_requests/get_received_requests_cubit.dart'
    as _i388;
import 'package:zoom_provider/feature/home/presentation/view_model/home/home_cubit.dart'
    as _i514;
import 'package:zoom_provider/feature/home/presentation/view_model/installation_not_done/installation_not_done_cubit.dart'
    as _i425;
import 'package:zoom_provider/feature/home/presentation/view_model/products_in_orders/products_in_orders_cubit.dart'
    as _i194;
import 'package:zoom_provider/feature/home/presentation/view_model/receive_order/receive_order_cubit.dart'
    as _i919;
import 'package:zoom_provider/feature/home/presentation/view_model/request_details/request_details_cubit.dart'
    as _i375;
import 'package:zoom_provider/feature/home/presentation/view_model/start_order/start_order_cubit.dart'
    as _i139;
import 'package:zoom_provider/feature/home/presentation/view_model/suspend_order/suspend_order_cubit.dart'
    as _i973;
import 'package:zoom_provider/feature/home/presentation/view_model/suspend_with_goods_returned/suspend_with_goods_returned_cubit.dart'
    as _i888;
import 'package:zoom_provider/feature/home/presentation/view_model/unsuspend_order/unsuspend_order_cubit.dart'
    as _i179;
import 'package:zoom_provider/feature/privacy_policy_screen/data/api/privacy_retrofit_client.dart'
    as _i24;
import 'package:zoom_provider/feature/privacy_policy_screen/data/data_sources_imp/remote/remote_privacy_data_source.dart'
    as _i498;
import 'package:zoom_provider/feature/privacy_policy_screen/data/data_sources_imp/remote/remote_privacy_data_source_imp.dart'
    as _i354;
import 'package:zoom_provider/feature/privacy_policy_screen/data/usecase/privacy_usecase.dart'
    as _i899;
import 'package:zoom_provider/feature/privacy_policy_screen/presentation/view_model/privacy/privacy_cubit.dart'
    as _i839;
import 'package:zoom_provider/feature/profile_screen/data/api/profile_update_retrofit_client.dart'
    as _i1004;
import 'package:zoom_provider/feature/profile_screen/data/data_sources_imp/profile_update_auth_data_source.dart'
    as _i457;
import 'package:zoom_provider/feature/profile_screen/data/data_sources_imp/profile_update_auth_data_source_imp.dart'
    as _i304;
import 'package:zoom_provider/feature/profile_screen/presentation/view_model/profile_update_cubit.dart'
    as _i1027;
import 'package:zoom_provider/feature/settings_screen/data/api/delete_retrofit_client.dart'
    as _i415;
import 'package:zoom_provider/feature/settings_screen/data/data_sources_imp/delete_account_data_sources.dart'
    as _i418;
import 'package:zoom_provider/feature/settings_screen/data/data_sources_imp/delete_account_data_sources_impl.dart'
    as _i276;
import 'package:zoom_provider/feature/settings_screen/presentation/view_model/delete_account_cubit.dart'
    as _i269;
import 'package:zoom_provider/feature/Terms_conditions_screen/data/api/terms_retrofit_client.dart'
    as _i236;
import 'package:zoom_provider/feature/Terms_conditions_screen/data/data_sources_imp/remote/remote_Terms_data_source.dart'
    as _i909;
import 'package:zoom_provider/feature/Terms_conditions_screen/data/data_sources_imp/remote/remote_Terms_data_source_imp.dart'
    as _i739;
import 'package:zoom_provider/feature/Terms_conditions_screen/data/usecase/terms-and-conditions_usecase.dart'
    as _i465;
import 'package:zoom_provider/feature/Terms_conditions_screen/presentation/view_model/terms-and-conditions/terms_and_conditions_cubit.dart'
    as _i939;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final appModule = _$AppModule();
    final loggerModule = _$LoggerModule();
    final dioModule = _$DioModule();
    gh.singleton<_i238.ApiManager>(() => _i238.ApiManager());
    gh.lazySingleton<_i409.GlobalKey<_i409.NavigatorState>>(
        () => appModule.navigatorKey);
    gh.lazySingleton<_i974.Logger>(() => loggerModule.loggerProvider);
    gh.lazySingleton<_i974.PrettyPrinter>(() => loggerModule.prettyPrinter);
    gh.lazySingleton<_i361.Dio>(() => dioModule.provideDio());
    gh.lazySingleton<_i528.PrettyDioLogger>(
        () => dioModule.providerInterceptor());
    gh.lazySingleton<_i236.TermsRetrofitClient>(
        () => _i236.TermsRetrofitClient(gh<_i361.Dio>()));
    gh.lazySingleton<_i1068.AboutUsRetrofitClient>(
        () => _i1068.AboutUsRetrofitClient(gh<_i361.Dio>()));
    gh.lazySingleton<_i533.AuthRetrofitClient>(
        () => _i533.AuthRetrofitClient(gh<_i361.Dio>()));
    gh.lazySingleton<_i520.ContactUsRetrofitClient>(
        () => _i520.ContactUsRetrofitClient(gh<_i361.Dio>()));
    gh.lazySingleton<_i70.HomeRetrofitClient>(
        () => _i70.HomeRetrofitClient(gh<_i361.Dio>()));
    gh.lazySingleton<_i24.PrivacyRetrofitClient>(
        () => _i24.PrivacyRetrofitClient(gh<_i361.Dio>()));
    gh.lazySingleton<_i1004.ProfileUpdateRetrofitClient>(
        () => _i1004.ProfileUpdateRetrofitClient(gh<_i361.Dio>()));
    gh.lazySingleton<_i415.DeleteRetrofitClient>(
        () => _i415.DeleteRetrofitClient(gh<_i361.Dio>()));
    gh.factory<_i498.RemotePrivacyDataSource>(
        () => _i354.RemotePrivacyDataSourceImp(
              gh<_i238.ApiManager>(),
              gh<_i24.PrivacyRetrofitClient>(),
            ));
    gh.factory<_i966.RemoteAboutUsDataSource>(
        () => _i416.RemoteAboutUsDataSourceImp(
              gh<_i238.ApiManager>(),
              gh<_i1068.AboutUsRetrofitClient>(),
            ));
    gh.factory<_i368.RemoteContactUsDataSource>(
        () => _i581.RemoteContactUsDataSourceImp(
              gh<_i238.ApiManager>(),
              gh<_i520.ContactUsRetrofitClient>(),
            ));
    gh.lazySingleton<_i289.OneSignalService>(() =>
        _i289.OneSignalService(gh<_i409.GlobalKey<_i409.NavigatorState>>()));
    gh.factory<_i899.PrivacyUseCase>(
        () => _i899.PrivacyUseCase(gh<_i498.RemotePrivacyDataSource>()));
    gh.factory<_i1009.ContactUsCubit>(
        () => _i1009.ContactUsCubit(gh<_i368.RemoteContactUsDataSource>()));
    gh.factory<_i418.DeleteDataSources>(() => _i276.DeleteDataSourcesImpl(
          gh<_i415.DeleteRetrofitClient>(),
          gh<_i238.ApiManager>(),
        ));
    gh.factory<_i547.AboutUsUseCase>(
        () => _i547.AboutUsUseCase(gh<_i966.RemoteAboutUsDataSource>()));
    gh.factory<_i457.RemoteProfileUpdateDataSource>(
        () => _i304.RemoteProfileUpdateDataSourceImp(
              gh<_i238.ApiManager>(),
              gh<_i1004.ProfileUpdateRetrofitClient>(),
            ));
    gh.factory<_i909.RemoteTermsDataSource>(
        () => _i739.RemoteTermsDataSourceImp(
              gh<_i238.ApiManager>(),
              gh<_i236.TermsRetrofitClient>(),
            ));
    gh.factory<_i930.RemoteAuthDataSource>(() => _i481.RemoteAuthDataSourceImp(
          gh<_i238.ApiManager>(),
          gh<_i533.AuthRetrofitClient>(),
        ));
    gh.factory<_i871.HomeDataSources>(() => _i128.HomeDataSourcesImp(
          gh<_i70.HomeRetrofitClient>(),
          gh<_i238.ApiManager>(),
        ));
    gh.factory<_i411.ServicesFaqsCubit>(
        () => _i411.ServicesFaqsCubit(gh<_i368.RemoteContactUsDataSource>()));
    gh.factory<_i465.termsAndConditionsUseCase>(() =>
        _i465.termsAndConditionsUseCase(gh<_i909.RemoteTermsDataSource>()));
    gh.factory<_i939.TermsAndConditionsCubit>(() =>
        _i939.TermsAndConditionsCubit(gh<_i465.termsAndConditionsUseCase>()));
    gh.factory<_i839.PrivacyCubit>(
        () => _i839.PrivacyCubit(gh<_i899.PrivacyUseCase>()));
    gh.factory<_i431.AboutUsCubit>(
        () => _i431.AboutUsCubit(gh<_i547.AboutUsUseCase>()));
    gh.factory<_i1027.ProfileUpdateCubit>(() =>
        _i1027.ProfileUpdateCubit(gh<_i457.RemoteProfileUpdateDataSource>()));
    gh.factory<_i1063.CompletedPaidCubit>(
        () => _i1063.CompletedPaidCubit(gh<_i871.HomeDataSources>()));
    gh.factory<_i196.AllRequestsCubit>(
        () => _i196.AllRequestsCubit(homeRepo: gh<_i871.HomeDataSources>()));
    gh.factory<_i282.CompleteOrderCubit>(
        () => _i282.CompleteOrderCubit(homeRepo: gh<_i871.HomeDataSources>()));
    gh.factory<_i388.GetReceivedRequestsCubit>(() =>
        _i388.GetReceivedRequestsCubit(homeRepo: gh<_i871.HomeDataSources>()));
    gh.factory<_i514.HomeCubit>(
        () => _i514.HomeCubit(homeRepo: gh<_i871.HomeDataSources>()));
    gh.factory<_i425.InstallationNotDoneCubit>(() =>
        _i425.InstallationNotDoneCubit(homeRepo: gh<_i871.HomeDataSources>()));
    gh.factory<_i194.ProductsInOrdersCubit>(() =>
        _i194.ProductsInOrdersCubit(homeRepo: gh<_i871.HomeDataSources>()));
    gh.factory<_i919.ReceiveOrderCubit>(
        () => _i919.ReceiveOrderCubit(homeRepo: gh<_i871.HomeDataSources>()));
    gh.factory<_i375.RequestDetailsCubit>(
        () => _i375.RequestDetailsCubit(homeRepo: gh<_i871.HomeDataSources>()));
    gh.factory<_i139.StartOrderCubit>(
        () => _i139.StartOrderCubit(homeRepo: gh<_i871.HomeDataSources>()));
    gh.factory<_i973.SuspendOrderCubit>(
        () => _i973.SuspendOrderCubit(homeRepo: gh<_i871.HomeDataSources>()));
    gh.factory<_i888.SuspendWithGoodsReturnedCubit>(() =>
        _i888.SuspendWithGoodsReturnedCubit(
            homeRepo: gh<_i871.HomeDataSources>()));
    gh.factory<_i179.UnsuspendOrderCubit>(
        () => _i179.UnsuspendOrderCubit(homeRepo: gh<_i871.HomeDataSources>()));
    gh.factory<_i610.LoginCubit>(() => _i610.LoginCubit(
          gh<_i930.RemoteAuthDataSource>(),
          gh<_i289.OneSignalService>(),
        ));
    gh.factory<_i269.DeleteCubit>(
        () => _i269.DeleteCubit(gh<_i418.DeleteDataSources>()));
    gh.factory<_i171.ForgetPasswordCubit>(
        () => _i171.ForgetPasswordCubit(gh<_i930.RemoteAuthDataSource>()));
    gh.factory<_i954.RegisterCubit>(
        () => _i954.RegisterCubit(gh<_i930.RemoteAuthDataSource>()));
    return this;
  }
}

class _$AppModule extends _i366.AppModule {}

class _$LoggerModule extends _i853.LoggerModule {}

class _$DioModule extends _i890.DioModule {}
