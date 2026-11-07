import '../../shared/scene_view_model.dart';
import 'server_rep_folder.dart';
import 'rep_folder_coordinator.dart';

class RepFolderViewModel extends SceneViewModel {
  RepFolderViewModel({
    required ServerRepFolder server,
    required RepFolderCoordinator coordinator,
    super.args,
  }) : super(server: server, coordinator: coordinator);
  Future<void> initialize() async {
    await load();
    if (disposed || data == null) return;
    changed();
  }
}
