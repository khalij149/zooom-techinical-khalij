import '../../../../../core/models/api_error.dart';
import '../../../data/model/installation_not_done_model.dart';

abstract class InstallationNotDoneState {
  const InstallationNotDoneState();
}

class InstallationNotDoneInitial extends InstallationNotDoneState {
  const InstallationNotDoneInitial();
}

class InstallationNotDoneLoading extends InstallationNotDoneState {
  const InstallationNotDoneLoading();
}

class InstallationNotDoneSuccess extends InstallationNotDoneState {
  final InstallationNotDoneModel installationNotDoneModel;

  const InstallationNotDoneSuccess({required this.installationNotDoneModel});
}

class InstallationNotDoneFailure extends InstallationNotDoneState {
  final ApiError? apiError;
  final Object? exception;

  const InstallationNotDoneFailure({this.apiError, this.exception});
}
