import 'package:flutter/widgets.dart';

import '../../app/app_controller.dart';
import '../../shared/scene_host.dart';
import 'reps_view.dart';
import 'reps_view_model.dart';
import 'reps_coordinator.dart';
import 'server_reps.dart';

abstract final class RepsFactory {
  static Widget make(
    AppController app, {
    Map<String, dynamic> args = const {},
  }) => SceneAssembly(
    builder: (context) => RepsView(
      viewModel: RepsViewModel(
        server: CoreServerReps(app.repository),
        coordinator: DefaultRepsCoordinator(context, app),
        args: args,
      )..initialize(),
    ),
  );
}
