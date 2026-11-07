import '../../shared/scene_view_model.dart';
import 'server_cities.dart';
import 'cities_coordinator.dart';

class CitiesViewModel extends SceneViewModel {
  CitiesViewModel({
    required ServerCities server,
    required CitiesCoordinator coordinator,
    super.args,
  }) : super(server: server, coordinator: coordinator);
  Future<void> initialize() async {
    await load();
    if (disposed || data == null) return;
    changed();
  }
}
