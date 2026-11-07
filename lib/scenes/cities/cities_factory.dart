import 'package:flutter/widgets.dart';

import '../../app/app_controller.dart';
import '../../shared/scene_host.dart';
import 'cities_view.dart';
import 'cities_view_model.dart';
import 'cities_coordinator.dart';
import 'server_cities.dart';

abstract final class CitiesFactory {
  static Widget make(
    AppController app, {
    Map<String, dynamic> args = const {},
  }) => SceneAssembly(
    builder: (context) => CitiesView(
      viewModel: CitiesViewModel(
        server: CoreServerCities(app.repository),
        coordinator: DefaultCitiesCoordinator(context, app),
        args: args,
      )..initialize(),
    ),
  );
}
