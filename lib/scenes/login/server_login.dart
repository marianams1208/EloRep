import '../../shared/scene_server.dart';

abstract interface class ServerLogin implements SceneServer {}

class CoreServerLogin extends CoreSceneServer implements ServerLogin {
  CoreServerLogin(super.repository);
}
