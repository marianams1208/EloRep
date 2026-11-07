import '../../shared/scene_view_model.dart';
import 'server_home.dart';
import 'home_coordinator.dart';

class HomeViewModel extends SceneViewModel {
  HomeViewModel({
    required ServerHome server,
    required HomeCoordinator coordinator,
    super.args,
  }) : super(server: server, coordinator: coordinator);
  Future<void> initialize() async {
    await load();
    if (disposed || data == null) return;
    changed();
  }
}
