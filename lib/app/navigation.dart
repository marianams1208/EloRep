import 'package:flutter/material.dart';

import '../scenes/scene_factory.dart';
import 'app_controller.dart';

abstract interface class SceneCoordinator {
  Future<Object?> go(String scene, {Map<String, dynamic> args = const {}});
  void back([Object? result]);
  void root(String scene);
  void message(String text);
}

class AppCoordinator implements SceneCoordinator {
  AppCoordinator(this.context, this.app);
  final BuildContext context;
  final AppController app;
  @override
  Future<Object?> go(String scene, {Map<String, dynamic> args = const {}}) =>
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => SceneFactory.make(scene, app, args: args),
        ),
      );
  @override
  void back([Object? result]) => Navigator.of(context).pop(result);
  @override
  void root(String scene) => Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(builder: (_) => SceneFactory.make(scene, app)),
    (_) => false,
  );
  @override
  void message(String text) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
}
