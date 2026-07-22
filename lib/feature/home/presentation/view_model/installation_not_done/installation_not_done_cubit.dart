import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/network/common/api_result.dart';
import '../../../data/data_sources/home_data_sources.dart';
import '../../../data/model/installation_not_done_model.dart';
import 'installation_not_done_state.dart';


@injectable
class InstallationNotDoneCubit extends Cubit<InstallationNotDoneState> {
  final HomeDataSources homeRepo;

  InstallationNotDoneCubit({required this.homeRepo}) : super(const InstallationNotDoneInitial());

  Future<void> installationNotDone(int orderId, String notes) async {
    emit(const InstallationNotDoneLoading());

    final result = await homeRepo.installationNotDone(orderId, notes);

    switch (result) {
      case SuccessResult<InstallationNotDoneModel>():
        emit(InstallationNotDoneSuccess(installationNotDoneModel: result.data));
        break;

      case FailureResult<InstallationNotDoneModel>():
        emit(
          InstallationNotDoneFailure(
            apiError: result.apiError,
            exception: result.exception,
          ),
        );
        break;
    }
  }
}
