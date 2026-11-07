import '../../app/navigation.dart';

abstract interface class CitiesCoordinator implements SceneCoordinator {}

class DefaultCitiesCoordinator extends AppCoordinator
    implements CitiesCoordinator {
  DefaultCitiesCoordinator(super.context, super.app);
}
