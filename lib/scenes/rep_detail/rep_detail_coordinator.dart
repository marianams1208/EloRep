import '../../app/navigation.dart';

abstract interface class RepDetailCoordinator implements SceneCoordinator {}

class DefaultRepDetailCoordinator extends AppCoordinator
    implements RepDetailCoordinator {
  DefaultRepDetailCoordinator(super.context, super.app);
}
