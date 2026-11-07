import '../../shared/scene_view_model.dart';
import 'server_reps.dart';
import 'reps_coordinator.dart';

class RepsViewModel extends SceneViewModel {
  RepsViewModel({
    required ServerReps server,
    required RepsCoordinator coordinator,
    super.args,
  }) : super(server: server, coordinator: coordinator);
  Future<void> initialize() async {
    await load();
    if (disposed || data == null) return;
    changed();
  }
}
