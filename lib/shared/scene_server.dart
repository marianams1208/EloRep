import 'package:elorep_core/elorep_core.dart';

abstract interface class SceneServer {
  Future<Result<Snapshot>> fetch();
  Future<Result<Object?>> execute(String action, Json args);
}

class CoreSceneServer implements SceneServer {
  CoreSceneServer(this.repository);
  final RepresentativesRepository repository;
  @override
  Future<Result<Snapshot>> fetch() => repository.fetch();
  @override
  Future<Result<Object?>> execute(String action, Json args) =>
      repository.execute(action, args);
}
