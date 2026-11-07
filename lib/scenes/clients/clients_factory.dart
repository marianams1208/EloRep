import 'package:flutter/widgets.dart';

import '../../app/app_controller.dart';
import '../../shared/scene_host.dart';
import 'clients_view.dart';
import 'clients_view_model.dart';
import 'clients_coordinator.dart';
import 'server_clients.dart';

abstract final class ClientsFactory {
  static Widget make(
    AppController app, {
    Map<String, dynamic> args = const {},
  }) => SceneAssembly(
    builder: (context) => ClientsView(
      viewModel: ClientsViewModel(
        server: CoreServerClients(app.repository),
        coordinator: DefaultClientsCoordinator(context, app),
        args: args,
      )..initialize(),
    ),
  );
}
