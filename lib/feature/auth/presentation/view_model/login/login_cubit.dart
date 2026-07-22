import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/network/common/api_result.dart';
import '../../../../../core/serves/one_signal_service.dart';
import '../../../data/data_sources_imp/remote/remote_auth_data_source.dart';
import '../../../../../core/constants/app_values.dart';
import '../../../../../core/utils/app_shared_preference.dart';
import '../../../../../core/models/api_error.dart';
import '../../../data/models/login_model.dart';
import 'login_state.dart';

@injectable
class LoginCubit extends Cubit<LoginState> {
  final RemoteAuthDataSource _remoteAuthDataSource;
  final OneSignalService _oneSignalService;

  LoginCubit(
      this._remoteAuthDataSource,
      this._oneSignalService,
      ) : super(LoginInitial());

  Future<void> login({
    required String phone,
    required String password,
  }) async {
    emit(LoginLoading());

    final result = await _remoteAuthDataSource.login(
      phone: phone,
      password: password,
    );

    if (result is SuccessResult<LoginModel>) {
      final loginModel = result.data;
      final userId = loginModel.user?.id;
      final accountType = loginModel.user?.accountType;

      if (accountType == 'user') {
        // Clear saved token/user data as they are invalid for the provider app
        await SharedPreferencesUtils.removeData(key: AppValues.token);
        await SharedPreferencesUtils.removeData(key: AppValues.user);
        await SharedPreferencesUtils.removeData(key: AppValues.loggedIn);

        emit(
          LoginFailure(
            apiError: ApiError(
              message: {
                'ar': 'برجاء ادخال حساب فني',
                'en': 'Please enter a technical account'
              },
            ),
          ),
        );
        return;
      }

      if (userId != null) {
        try {
          await _oneSignalService.loginUser(userId.toString() ,);
        } catch (_) {}
      }

      emit(LoginSuccess(loginModel));
    } else if (result is FailureResult<LoginModel>) {
      emit(
        LoginFailure(
          apiError: result.apiError,
          exception: result.exception,
        ),
      );
    }
  }
}