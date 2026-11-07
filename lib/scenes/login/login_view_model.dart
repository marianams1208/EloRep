import '../../shared/scene_view_model.dart';
import 'server_login.dart';
import 'login_coordinator.dart';

class LoginViewModel extends SceneViewModel {
  LoginViewModel({
    required ServerLogin server,
    required LoginCoordinator coordinator,
    super.args,
  }) : super(server: server, coordinator: coordinator);
  Future<void> initialize() async {
    fields = {'email': 'mariana@elorep.demo', 'password': '123456'};
    changed();
  }
}
