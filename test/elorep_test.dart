import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:elorep_core/elorep_core.dart';
import 'package:elorep_design_system/elorep_design_system.dart';
import 'package:elorep/app/app_controller.dart';
import 'package:elorep/scenes/scene_factory.dart';

class BrokenStorage implements SessionStorage {
  @override
  Future<String?> read() async => null;
  @override
  Future<void> write(String value) async => throw Exception('Disk unavailable');
  @override
  Future<void> clear() async {}
}

void main() {
  late MemoryStorage storage;
  late RepresentativesRepository repo;
  setUp(() async {
    storage = MemoryStorage();
    repo = RepresentativesRepository(storage);
    await repo.restore();
  });
  Future<void> login() async {
    expect(
      await repo.execute('login', {
        'email': 'mariana@elorep.demo',
        'password': '123456',
      }),
      isA<Ok<Object?>>(),
    );
  }

  test('dinheiro em centavos e formato brasileiro', () {
    expect(parseMoney('8.450,09'), 845009);
    expect(parseMoney('-1'), isNull);
    expect(parseMoney('NaN'), isNull);
    expect(money(845009), 'R\$ 8.450,09');
  });
  test('credenciais inválidas não criam sessão', () async {
    expect(
      await repo.execute('login', {'email': 'wrong', 'password': '123456'}),
      isA<Failure<Object?>>(),
    );
    expect(repo.signedIn, false);
  });
  test('dados e sessão restauram; logout limpa apenas sessão', () async {
    await login();
    await repo.execute('client', {
      'name': 'Teste',
      'city': 'Palmas',
      'uf': 'TO',
      'phone': '63999998888',
      'cnpj': '',
    });
    final next = RepresentativesRepository(storage);
    await next.restore();
    expect(next.signedIn, true);
    expect(next.clients.length, 5);
    await next.execute('logout', {});
    final another = RepresentativesRepository(storage);
    await another.restore();
    expect(another.signedIn, false);
    expect(another.clients.length, 5);
  });
  test('cliente valida UF, DDD e CNPJ opcional', () async {
    await login();
    expect(
      await repo.execute('client', {
        'name': 'Teste',
        'city': 'Palmas',
        'uf': 'XX',
        'phone': '63999998888',
        'cnpj': '',
      }),
      isA<Failure<Object?>>(),
    );
    expect(validCnpj('11222333000181'), true);
    expect(validCnpj('00000000000000'), false);
  });
  test(
    'pedido preserva referências, IDs únicos e histórico de status',
    () async {
      await login();
      final a = await repo.execute('order', {
        'clientId': 'c2',
        'repId': 'r3',
        'cents': 20000,
        'reference': 'Teste',
      });
      final b = await repo.execute('order', {
        'clientId': 'c1',
        'repId': 'r1',
        'cents': 10000,
        'reference': '',
      });
      expect(a, isA<Ok<Object?>>());
      expect((a as Ok<Object?>).value, isNot((b as Ok<Object?>).value));
      final id = a.value;
      expect(repo.orders.firstWhere((o) => o['id'] == id)['clientId'], 'c2');
      expect(
        await repo.execute('status', {'id': id, 'status': 'Entregue'}),
        isA<Failure<Object?>>(),
      );
      expect(
        await repo.execute('status', {'id': id, 'status': 'Enviado'}),
        isA<Ok<Object?>>(),
      );
      expect(repo.orders.firstWhere((o) => o['id'] == id)['history'].length, 2);
    },
  );
  test(
    'visita salva cliente, horário e objetivo; não pode concluir duas vezes',
    () async {
      await login();
      await repo.execute('visit', {
        'clientId': 'c2',
        'date': '2026-11-07',
        'time': '10:30',
        'objective': 'Retorno',
        'notes': 'Teste',
      });
      final v = repo.visits.last;
      expect(v['clientId'], 'c2');
      expect(
        await repo.execute('visitStatus', {
          'id': v['id'],
          'status': 'Concluída',
        }),
        isA<Ok<Object?>>(),
      );
      expect(
        await repo.execute('visitStatus', {
          'id': v['id'],
          'status': 'Cancelada',
        }),
        isA<Failure<Object?>>(),
      );
    },
  );
  test('falha de storage reverte a mutação e a sessão', () async {
    final r = RepresentativesRepository(BrokenStorage());
    await r.restore();
    expect(
      await r.execute('login', {
        'email': 'mariana@elorep.demo',
        'password': '123456',
      }),
      isA<Failure<Object?>>(),
    );
    expect(r.signedIn, false);
  });
  const scenes = [
    'login',
    'home',
    'clients',
    'clientForm',
    'clientDetail',
    'repFolder',
    'orders',
    'orderForm',
    'orderReview',
    'orderDetail',
    'visits',
    'visitForm',
    'reps',
    'repDetail',
    'goals',
    'cities',
  ];
  for (final width in [390.0, 320.0]) {
    for (final scene in scenes) {
      testWidgets('$scene renderiza em ${width.toInt()}px sem overflow', (
        tester,
      ) async {
        tester.view.physicalSize = Size(width, 844);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        await login();
        final app = AppController(repo);
        final key = GlobalKey();
        final loader = FontLoader('packages/elorep_design_system/Roboto')
          ..addFont(
            rootBundle.load(
              'packages/elorep_design_system/assets/fonts/Roboto.ttf',
            ),
          );
        await loader.load();
        await tester.pumpWidget(
          MaterialApp(
            theme: T.theme(),
            home: RepaintBoundary(
              key: key,
              child: SceneFactory.make(
                scene,
                app,
                args: {
                  'clientId': 'c1',
                  'repId': 'r1',
                  'orderId': '#1048',
                  'draft': {
                    'clientId': 'c2',
                    'repId': 'r3',
                    'cents': 328000,
                    'reference': 'Reposição',
                  },
                },
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        if (width == 390 &&
            ['home', 'login', 'clients', 'orderDetail'].contains(scene)) {
          await tester.runAsync(() async {
            final boundary =
                key.currentContext!.findRenderObject() as RenderRepaintBoundary;
            final image = await boundary.toImage(pixelRatio: 1);
            final bytes = await image.toByteData(
              format: ui.ImageByteFormat.png,
            );
            await Directory('qa_previews').create();
            await File('qa_previews/$scene.png')
                .writeAsBytes(bytes!.buffer.asUint8List());
            image.dispose();
          });
        }
      });
    }
  }
  testWidgets('novo cliente aparece na lista depois de salvar', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await login();
    await tester.pumpWidget(
      MaterialApp(
        theme: T.theme(),
        home: SceneFactory.make('clients', AppController(repo)),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('+ Novo'));
    await tester.pumpAndSettle();
    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'Cliente teste');
    await tester.enterText(fields.at(1), 'Palmas');
    await tester.enterText(fields.at(2), 'TO');
    await tester.enterText(fields.at(3), '63999998888');
    await tester.ensureVisible(find.text('Salvar cliente'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Salvar cliente'));
    await tester.pumpAndSettle();
    expect(repo.clients.length, 5);
    expect(find.text('Clientes'), findsWidgets);
    expect(find.byType(TextFormField), findsNothing);
    expect(find.text('Cliente teste'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  testWidgets('pedido completo: valida, revisa, salva e registra envio', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await login();
    await tester.pumpWidget(
      MaterialApp(
        theme: T.theme(),
        home: SceneFactory.make('orders', AppController(repo)),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('+ Novo'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).at(0), '-1');
    await tester.ensureVisible(find.text('Revisar pedido'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Revisar pedido'));
    await tester.pumpAndSettle();
    expect(find.text('Informe um valor positivo.'), findsOneWidget);
    await tester.enterText(find.byType(TextFormField).at(0), '225,90');
    await tester.enterText(find.byType(TextFormField).at(1), 'Pedido de teste');
    await tester.ensureVisible(find.text('Revisar pedido'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Revisar pedido'));
    await tester.pumpAndSettle();
    expect(find.text('Confira antes de salvar'), findsOneWidget);
    await tester.ensureVisible(find.text('Salvar como rascunho'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Salvar como rascunho'));
    await tester.pumpAndSettle();
    expect(repo.orders.first['cents'], 22590);
    expect(find.text('Pedido #1049'), findsOneWidget);
    expect(find.text('Pedido de teste'), findsOneWidget);
    await tester.ensureVisible(find.text('Marcar como enviado'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Marcar como enviado'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Confirmar'));
    await tester.pumpAndSettle();
    expect(repo.orders.first['status'], 'Enviado');
    expect(tester.takeException(), isNull);
  });
  testWidgets('planejar visita salva e retorna à agenda', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await login();
    await tester.pumpWidget(
      MaterialApp(
        theme: T.theme(),
        home: SceneFactory.make('visits', AppController(repo)),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('+ Planejar'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).at(2), 'Visita de teste');
    await tester.ensureVisible(find.text('Salvar planejamento'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Salvar planejamento'));
    await tester.pumpAndSettle();
    expect(repo.visits.length, 4);
    expect(repo.visits.last['objective'], 'Visita de teste');
    expect(find.textContaining('Visita de teste'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
