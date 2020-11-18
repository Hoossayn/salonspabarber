

import 'package:flutter/cupertino.dart';
import 'package:salonspabarber/state/app_state.dart';
import 'package:salonspabarber/ui/profile/model/profile_response.dart';
import 'package:salonspabarber/ui/profile/repository/profile_repository.dart';

class ProfSettingsState extends AppState {
  final ProfSettingsRepository _profSettingsRepository = ProfSettingsRepository();
  Future<ProfileResponse> updateProfile({@required String path, @required Map body}) async {
    return await _profSettingsRepository.updateProf(url: path, body: body);
  }
}
