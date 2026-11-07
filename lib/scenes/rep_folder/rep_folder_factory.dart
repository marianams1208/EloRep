import 'package:flutter/widgets.dart';

import '../../app/app_controller.dart';
import '../../shared/scene_host.dart';
import 'rep_folder_view.dart';
import 'rep_folder_view_model.dart';
import 'rep_folder_coordinator.dart';
import 'server_rep_folder.dart';

abstract final class RepFolderFactory {
  static Widget make(
    AppController app, {
    Map<String, dynamic> args = const {},
  }) => SceneAssembly(
    builder: (context) => RepFolderView(
      viewModel: RepFolderViewModel(
        server: CoreServerRepFolder(app.repository),
        coordinator: DefaultRepFolderCoordinator(context, app),
        args: args,
      )..initialize(),
    ),
  );
}
