import '../../app/navigation.dart';

abstract interface class GoalsCoordinator implements SceneCoordinator {}

class DefaultGoalsCoordinator extends AppCoordinator
    implements GoalsCoordinator {
  DefaultGoalsCoordinator(super.context, super.app);
}
