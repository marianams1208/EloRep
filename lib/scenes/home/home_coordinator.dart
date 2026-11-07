import '../../app/navigation.dart';

abstract interface class HomeCoordinator implements SceneCoordinator {}

class DefaultHomeCoordinator extends AppCoordinator implements HomeCoordinator {
  DefaultHomeCoordinator(super.context, super.app);
}
