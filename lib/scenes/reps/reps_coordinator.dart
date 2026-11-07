import '../../app/navigation.dart';

abstract interface class RepsCoordinator implements SceneCoordinator {}

class DefaultRepsCoordinator extends AppCoordinator implements RepsCoordinator {
  DefaultRepsCoordinator(super.context, super.app);
}
