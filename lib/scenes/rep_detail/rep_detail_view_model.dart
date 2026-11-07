import '../../shared/scene_view_model.dart';
import 'server_rep_detail.dart';
import 'rep_detail_coordinator.dart';

class RepDetailViewModel extends SceneViewModel {
  RepDetailViewModel({
    required ServerRepDetail server,
    required RepDetailCoordinator coordinator,
    super.args,
  }) : super(server: server, coordinator: coordinator);
  Future<void> initialize() async {
    await load();
    if (disposed || data == null) return;
    changed();
  }
}
