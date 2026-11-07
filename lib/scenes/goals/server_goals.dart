import '../../shared/scene_server.dart';

abstract interface class ServerGoals implements SceneServer {}

class CoreServerGoals extends CoreSceneServer implements ServerGoals {
  CoreServerGoals(super.repository);
}
