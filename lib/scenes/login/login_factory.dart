import 'package:flutter/widgets.dart';

import '../../app/app_controller.dart';
import '../../shared/scene_host.dart';
import 'login_view.dart';
import 'login_view_model.dart';
import 'login_coordinator.dart';
import 'server_login.dart';

abstract final class LoginFactory {
  static Widget make(
    AppController app, {
    Map<String, dynamic> args = const {},
  }) => SceneAssembly(
    builder: (context) => LoginView(
      viewModel: LoginViewModel(
        server: CoreServerLogin(app.repository),
        coordinator: DefaultLoginCoordinator(context, app),
        args: args,
      )..initialize(),
    ),
  );
}
