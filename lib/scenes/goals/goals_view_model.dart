import '../../shared/scene_view_model.dart';
import 'server_goals.dart';
import 'goals_coordinator.dart';

class GoalsViewModel extends SceneViewModel {
  GoalsViewModel({
    required ServerGoals server,
    required GoalsCoordinator coordinator,
    super.args,
  }) : super(server: server, coordinator: coordinator);
  Future<void> initialize() async {
    await load();
    if (disposed || data == null) return;
    changed();
  }
}
