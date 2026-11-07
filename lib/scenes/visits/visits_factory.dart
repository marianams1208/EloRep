import 'package:flutter/widgets.dart';

import '../../app/app_controller.dart';
import '../../shared/scene_host.dart';
import 'visits_view.dart';
import 'visits_view_model.dart';
import 'visits_coordinator.dart';
import 'server_visits.dart';

abstract final class VisitsFactory {
  static Widget make(
    AppController app, {
    Map<String, dynamic> args = const {},
  }) => SceneAssembly(
    builder: (context) => VisitsView(
      viewModel: VisitsViewModel(
        server: CoreServerVisits(app.repository),
        coordinator: DefaultVisitsCoordinator(context, app),
        args: args,
      )..initialize(),
    ),
  );
}
