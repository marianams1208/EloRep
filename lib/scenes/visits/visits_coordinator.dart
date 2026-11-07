import '../../app/navigation.dart';

abstract interface class VisitsCoordinator implements SceneCoordinator {}

class DefaultVisitsCoordinator extends AppCoordinator
    implements VisitsCoordinator {
  DefaultVisitsCoordinator(super.context, super.app);
}
