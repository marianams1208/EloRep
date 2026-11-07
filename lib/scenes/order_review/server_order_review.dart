import '../../shared/scene_server.dart';

abstract interface class ServerOrderReview implements SceneServer {}

class CoreServerOrderReview extends CoreSceneServer
    implements ServerOrderReview {
  CoreServerOrderReview(super.repository);
}
