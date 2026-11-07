import 'package:flutter/widgets.dart';

import '../../app/app_controller.dart';
import '../../shared/scene_host.dart';
import 'rep_detail_view.dart';
import 'rep_detail_view_model.dart';
import 'rep_detail_coordinator.dart';
import 'server_rep_detail.dart';

abstract final class RepDetailFactory {
  static Widget make(
    AppController app, {
    Map<String, dynamic> args = const {},
  }) => SceneAssembly(
    builder: (context) => RepDetailView(
      viewModel: RepDetailViewModel(
        server: CoreServerRepDetail(app.repository),
        coordinator: DefaultRepDetailCoordinator(context, app),
        args: args,
      )..initialize(),
    ),
  );
}
