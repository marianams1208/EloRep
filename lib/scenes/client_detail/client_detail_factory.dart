import 'package:flutter/widgets.dart';

import '../../app/app_controller.dart';
import '../../shared/scene_host.dart';
import 'client_detail_view.dart';
import 'client_detail_view_model.dart';
import 'client_detail_coordinator.dart';
import 'server_client_detail.dart';

abstract final class ClientDetailFactory {
  static Widget make(
    AppController app, {
    Map<String, dynamic> args = const {},
  }) => SceneAssembly(
    builder: (context) => ClientDetailView(
      viewModel: ClientDetailViewModel(
        server: CoreServerClientDetail(app.repository),
        coordinator: DefaultClientDetailCoordinator(context, app),
        args: args,
      )..initialize(),
    ),
  );
}
