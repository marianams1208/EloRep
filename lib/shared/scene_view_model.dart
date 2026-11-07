import 'package:flutter/foundation.dart';
import 'package:elorep_core/elorep_core.dart';

import '../app/navigation.dart';
import 'scene_server.dart';

class SceneViewModel extends ChangeNotifier {
  SceneViewModel({
    required this.server,
    required this.coordinator,
    this.args = const {},
  });
  final SceneServer server;
  final SceneCoordinator coordinator;
  final Map<String, dynamic> args;
  Snapshot? data;
  bool busy = false, disposed = false, showPassword = false;
  String? error;
  String query = '',
      repFilter = '',
      statusFilter = '',
      cityFilter = '',
      month = '2025-06',
      selectedRep = 'r1';
  int weekOffset = 0;
  Map<String, String> fields = {};
  Map<String, String> fieldErrors = {};
  Set<String> links = {};
  void changed() {
    if (!disposed) notifyListeners();
  }

  void setField(String key, String value) {
    fields[key] = value;
    fieldErrors.remove(key);
    error = null;
    changed();
  }

  String value(String key) => fields[key] ?? '';
  Future<void> load() async {
    if (disposed) return;
    busy = true;
    error = null;
    changed();
    try {
      final r = await server.fetch();
      if (disposed) return;
      switch (r) {
        case Ok<Snapshot>(:final value):
          data = value;
        case Failure<Snapshot>(:final message):
          error = message;
      }
    } on Object {
      if (!disposed) error = 'Não foi possível carregar. Tente novamente.';
    } finally {
      if (!disposed) {
        busy = false;
        changed();
      }
    }
  }

  Future<Object?> command(String action, Json values) async {
    if (busy || disposed) return null;
    busy = true;
    error = null;
    changed();
    try {
      final r = await server.execute(action, values);
      if (disposed) return null;
      switch (r) {
        case Ok<Object?>(:final value):
          return value;
        case Failure<Object?>(:final message):
          error = message;
          return null;
      }
    } on Object {
      if (!disposed) error = 'Não foi possível concluir. Tente novamente.';
      return null;
    } finally {
      if (!disposed) {
        busy = false;
        changed();
      }
    }
  }

  Future<void> open(
    String screen, {
    Map<String, dynamic> args = const {},
  }) async {
    await coordinator.go(screen, args: args);
    if (!disposed) await load();
  }

  void back() => coordinator.back();
  Future<void> logout() async {
    if (await command('logout', {}) != null && !disposed) {
      coordinator.root('login');
    }
  }

  Json get client =>
      data!.client(args['clientId'] ?? data!.clients.first['id']);
  Json get rep => data!.rep(args['repId'] ?? selectedRep);
  Json get order => data!.order(args['orderId']);
  Map<String, String> get clientOptions => {
    for (final c in data!.clients) c['id'] as String: c['name'] as String,
  };
  Map<String, String> get repOptions => {
    for (final r in data!.reps) r['id'] as String: r['name'] as String,
  };
  List<Json> get filteredClients => data!.clients
      .where(
        (c) => '${c['name']} ${c['city']}'.toLowerCase().contains(
          query.toLowerCase(),
        ),
      )
      .toList();
  List<Json> get filteredOrders => data!.orders
      .where(
        (o) =>
            (repFilter.isEmpty || o['repId'] == repFilter) &&
            (statusFilter.isEmpty || o['status'] == statusFilter),
      )
      .toList();
  Future<void> login() async {
    if (value('email').isEmpty || value('password').isEmpty) {
      error = 'Informe e-mail e senha.';
      changed();
      return;
    }
    if (await command('login', {
              'email': value('email'),
              'password': value('password'),
            }) !=
            null &&
        !disposed) {
      coordinator.root('home');
    }
  }

  Future<void> saveClient() async {
    fieldErrors = {
      for (final k in ['name', 'city', 'uf', 'phone'])
        if (value(k).trim().isEmpty) k: 'Campo obrigatório.',
    };
    if (fieldErrors.isNotEmpty) {
      changed();
      return;
    }
    final result = await command('client', {
      ...fields,
      if (args['editId'] != null) 'id': args['editId'],
    });
    if (result != null && !disposed) {
      coordinator.message('Cliente salvo com sucesso.');
      coordinator.back(result);
    }
  }

  Future<void> reviewOrder() async {
    final cents = parseMoney(value('amount'));
    if (cents == null || cents <= 0) {
      fieldErrors['amount'] = 'Informe um valor positivo.';
      changed();
      return;
    }
    await open(
      'orderReview',
      args: {
        'draft': {
          'clientId': value('clientId'),
          'repId': value('repId'),
          'cents': cents,
          'reference': value('reference'),
        },
      },
    );
  }

  Future<void> saveOrder() async {
    final id = await command('order', Json.from(args['draft']));
    if (id != null && !disposed) {
      coordinator.root('orders');
      coordinator.go('orderDetail', args: {'orderId': id});
      coordinator.message('Pedido salvo como rascunho.');
    }
  }

  Future<void> changeOrderStatus(String status) async {
    if (await command('status', {'id': order['id'], 'status': status}) !=
            null &&
        !disposed) {
      await load();
      coordinator.message('Status atualizado.');
    }
  }

  Future<void> saveVisit() async {
    if (value('objective').trim().isEmpty) {
      fieldErrors['objective'] = 'Informe o objetivo.';
      changed();
      return;
    }
    if (await command('visit', fields) != null && !disposed) {
      coordinator.message('Visita planejada com sucesso.');
      coordinator.back(true);
    }
  }

  Future<void> visitStatus(String id, String status) async {
    if (await command('visitStatus', {'id': id, 'status': status}) != null &&
        !disposed) {
      await load();
    }
  }

  Future<void> saveLinks(List<String> values) async {
    if (await command('links', {'id': client['id'], 'reps': values}) != null &&
        !disposed) {
      await load();
      coordinator.message('Vínculos atualizados.');
    }
  }

  @override
  void dispose() {
    disposed = true;
    super.dispose();
  }
}
