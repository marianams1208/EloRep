import '../../shared/scene_server.dart';

abstract interface class ServerReps implements SceneServer {}

class CoreServerReps extends CoreSceneServer implements ServerReps {
  CoreServerReps(super.repository);
}
