import '../../shared/scene_server.dart';

abstract interface class ServerVisits implements SceneServer {}

class CoreServerVisits extends CoreSceneServer implements ServerVisits {
  CoreServerVisits(super.repository);
}
