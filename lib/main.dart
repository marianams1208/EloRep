import 'package:flutter/material.dart';
import 'package:elorep_core/elorep_core.dart';
import 'package:elorep_design_system/elorep_design_system.dart';

import 'data/secure_storage.dart';
import 'app/app_controller.dart';
import 'scenes/scene_factory.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    EloRepApp(repository: RepresentativesRepository(SecureSessionStorage())),
  );
}

class EloRepApp extends StatefulWidget {
  const EloRepApp({super.key, required this.repository});
  final RepresentativesRepository repository;
  @override
  State<EloRepApp> createState() => _EloRepAppState();
}

class _EloRepAppState extends State<EloRepApp> {
  late final Future<void> ready = widget.repository.restore();
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'EloRep',
    theme: T.theme(),
    builder: (context, child) => ColoredBox(
      color: const Color(0xFFE8EDF5),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 430),
          child: child,
        ),
      ),
    ),
    home: FutureBuilder(
      future: ready,
      builder: (context, s) {
        if (s.hasError) {
          return Scaffold(
            body: StateView(
              kind: 'error',
              title: 'Não foi possível abrir o armazenamento',
              message: 'Feche o app e tente novamente.',
            ),
          );
        }
        if (s.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return SceneFactory.make(
          widget.repository.signedIn ? 'home' : 'login',
          AppController(widget.repository),
        );
      },
    ),
  );
}
