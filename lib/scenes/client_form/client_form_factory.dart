import 'package:flutter/widgets.dart';

import '../../app/app_controller.dart';
import '../../shared/scene_host.dart';
import 'client_form_view.dart';
import 'client_form_view_model.dart';
import 'client_form_coordinator.dart';
import 'server_client_form.dart';

abstract final class ClientFormFactory {
  static Widget make(
    AppController app, {
    Map<String, dynamic> args = const {},
  }) => SceneAssembly(
    builder: (context) => ClientFormView(
      viewModel: ClientFormViewModel(
        server: CoreServerClientForm(app.repository),
        coordinator: DefaultClientFormCoordinator(context, app),
        args: args,
      )..initialize(),
    ),
  );
}
