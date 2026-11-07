import '../../app/navigation.dart';

abstract interface class VisitFormCoordinator implements SceneCoordinator {}

class DefaultVisitFormCoordinator extends AppCoordinator
    implements VisitFormCoordinator {
  DefaultVisitFormCoordinator(super.context, super.app);
}
