import '../../shared/scene_server.dart';

abstract interface class ServerCities implements SceneServer {}

class CoreServerCities extends CoreSceneServer implements ServerCities {
  CoreServerCities(super.repository);
}
