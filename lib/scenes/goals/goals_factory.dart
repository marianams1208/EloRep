import 'package:flutter/widgets.dart';

import '../../app/app_controller.dart';
import '../../shared/scene_host.dart';
import 'goals_view.dart';
import 'goals_view_model.dart';
import 'goals_coordinator.dart';
import 'server_goals.dart';

abstract final class GoalsFactory {
  static Widget make(
    AppController app, {
    Map<String, dynamic> args = const {},
  }) => SceneAssembly(
    builder: (context) => GoalsView(
      viewModel: GoalsViewModel(
        server: CoreServerGoals(app.repository),
        coordinator: DefaultGoalsCoordinator(context, app),
        args: args,
      )..initialize(),
    ),
  );
}
