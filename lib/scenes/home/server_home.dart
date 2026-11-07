import '../../shared/scene_server.dart';

abstract interface class ServerHome implements SceneServer {}

class CoreServerHome extends CoreSceneServer implements ServerHome {
  CoreServerHome(super.repository);
}
