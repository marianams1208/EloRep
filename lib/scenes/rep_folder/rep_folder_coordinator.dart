import '../../app/navigation.dart';

abstract interface class RepFolderCoordinator implements SceneCoordinator {}

class DefaultRepFolderCoordinator extends AppCoordinator
    implements RepFolderCoordinator {
  DefaultRepFolderCoordinator(super.context, super.app);
}
