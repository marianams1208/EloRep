import '../../shared/scene_server.dart';

abstract interface class ServerRepFolder implements SceneServer {}

class CoreServerRepFolder extends CoreSceneServer implements ServerRepFolder {
  CoreServerRepFolder(super.repository);
}
