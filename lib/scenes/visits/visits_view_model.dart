import '../../shared/scene_view_model.dart';
import 'server_visits.dart';
import 'visits_coordinator.dart';

class VisitsViewModel extends SceneViewModel {
  VisitsViewModel({
    required ServerVisits server,
    required VisitsCoordinator coordinator,
    super.args,
  }) : super(server: server, coordinator: coordinator);
  Future<void> initialize() async {
    await load();
    if (disposed || data == null) return;
    changed();
  }
}
