import 'package:flutter/widgets.dart';

import '../../app/app_controller.dart';
import '../../shared/scene_host.dart';
import 'visit_form_view.dart';
import 'visit_form_view_model.dart';
import 'visit_form_coordinator.dart';
import 'server_visit_form.dart';

abstract final class VisitFormFactory {
  static Widget make(
    AppController app, {
    Map<String, dynamic> args = const {},
  }) => SceneAssembly(
    builder: (context) => VisitFormView(
      viewModel: VisitFormViewModel(
        server: CoreServerVisitForm(app.repository),
        coordinator: DefaultVisitFormCoordinator(context, app),
        args: args,
      )..initialize(),
    ),
  );
}
