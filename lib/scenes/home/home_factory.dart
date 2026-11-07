import 'package:flutter/widgets.dart';

import '../../app/app_controller.dart';
import '../../shared/scene_host.dart';
import 'home_view.dart';
import 'home_view_model.dart';
import 'home_coordinator.dart';
import 'server_home.dart';

abstract final class HomeFactory {
  static Widget make(
    AppController app, {
    Map<String, dynamic> args = const {},
  }) => SceneAssembly(
    builder: (context) => HomeView(
      viewModel: HomeViewModel(
        server: CoreServerHome(app.repository),
        coordinator: DefaultHomeCoordinator(context, app),
        args: args,
      )..initialize(),
    ),
  );
}
