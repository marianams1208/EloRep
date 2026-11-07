import 'dart:convert';

sealed class Result<T> {
  const Result();
}

class Ok<T> extends Result<T> {
  const Ok(this.value);
  final T value;
}

class Failure<T> extends Result<T> {
  const Failure(this.message);
  final String message;
}

abstract interface class SessionStorage {
  Future<String?> read();
  Future<void> write(String value);
  Future<void> clear();
}

class MemoryStorage implements SessionStorage {
  String? value;
  @override
  Future<String?> read() async => value;
  @override
  Future<void> write(String v) async {
    value = v;
  }

  @override
  Future<void> clear() async {
    value = null;
  }
}

typedef Json = Map<String, dynamic>;
String money(int cents) {
  final s = cents.toString().padLeft(3, '0');
  final n = s
      .substring(0, s.length - 2)
      .replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');
  return 'R\$ $n,${s.substring(s.length - 2)}';
}

int? parseMoney(String value) {
  final s = value.trim().replaceAll('R\$', '').trim();
  if (!RegExp(r'^(?:\d+|\d{1,3}(?:\.\d{3})+)(?:,\d{1,2})?$').hasMatch(s)) {
    return null;
  }
  final p = s.replaceAll('.', '').split(',');
  return int.parse(p[0]) * 100 +
      (p.length > 1 ? int.parse(p[1].padRight(2, '0')) : 0);
}

String dateLabel(DateTime d) =>
    '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
const statuses = [
  'Rascunho',
  'Enviado',
  'Aprovado',
  'Faturado',
  'Entregue',
  'Cancelado',
];

class Snapshot {
  Snapshot(this.clients, this.orders, this.visits, this.reps);
  final List<Json> clients, orders, visits, reps;
  Json client(String id) => clients.firstWhere((c) => c['id'] == id);
  Json order(String id) => orders.firstWhere((c) => c['id'] == id);
  Json rep(String id) => reps.firstWhere((c) => c['id'] == id);
}

/// Explicit local demo, not HTTP authentication or production authorization.
class RepresentativesRepository {
  RepresentativesRepository(this.storage);
  final SessionStorage storage;
  bool signedIn = false;
  int sequence = 1049;
  late List<Json> clients, orders, visits, reps;
  void seed() {
    clients = [
      {
        'id': 'c1',
        'name': 'Auto Peças Horizonte',
        'city': 'Curitiba',
        'uf': 'PR',
        'phone': '(41) 99999-0000',
        'cnpj': '',
        'reps': ['r1', 'r2'],
      },
      {
        'id': 'c2',
        'name': 'Comercial Avenida',
        'city': 'Ponta Grossa',
        'uf': 'PR',
        'phone': '(42) 99999-0000',
        'cnpj': '',
        'reps': ['r3', 'r4'],
      },
      {
        'id': 'c3',
        'name': 'Mecânica Dois Irmãos',
        'city': 'Londrina',
        'uf': 'PR',
        'phone': '(43) 99999-0000',
        'cnpj': '',
        'reps': ['r1'],
      },
      {
        'id': 'c4',
        'name': 'Paraná Moto Center',
        'city': 'Maringá',
        'uf': 'PR',
        'phone': '(44) 99999-0000',
        'cnpj': '',
        'reps': ['r2', 'r3'],
      },
    ];
    reps = [
      {
        'id': 'r1',
        'name': 'Vedamotors',
        'description': 'Vedação e componentes',
        'bps': 500,
      },
      {
        'id': 'r2',
        'name': 'Laquila',
        'description': 'Peças e acessórios',
        'bps': null,
      },
      {
        'id': 'r3',
        'name': 'Riffel',
        'description': 'Transmissão e performance',
        'bps': 450,
      },
      {
        'id': 'r4',
        'name': 'Darom',
        'description': 'Componentes automotivos',
        'bps': null,
      },
    ];
    final demo = [
      ['#1048', 'c1', 'r1', 845000, '18/06/2025', 'Aprovado'],
      ['#1047', 'c2', 'r3', 328000, '17/06/2025', 'Enviado'],
      ['#1046', 'c4', 'r2', 612000, '16/06/2025', 'Faturado'],
      ['#1045', 'c3', 'r1', 189000, '14/06/2025', 'Rascunho'],
    ];
    orders = [
      for (final row in demo)
        {
          'id': row[0],
          'clientId': row[1],
          'repId': row[2],
          'cents': row[3],
          'date': row[4],
          'status': row[5],
          'reference': '',
          'history': [
            {'label': row[5], 'date': row[4]},
          ],
        },
    ];
    visits = [
      {
        'id': 'v1',
        'clientId': 'c1',
        'date': '2025-06-18',
        'time': '14:30',
        'objective': 'Apresentar lançamentos',
        'notes': '',
        'status': 'Planejada',
      },
      {
        'id': 'v2',
        'clientId': 'c2',
        'date': '2025-06-20',
        'time': '10:00',
        'objective': 'Pós-venda',
        'notes': '',
        'status': 'Planejada',
      },
      {
        'id': 'v3',
        'clientId': 'c4',
        'date': '2025-06-16',
        'time': '09:00',
        'objective': 'Negociação',
        'notes': '',
        'status': 'Concluída',
      },
    ];
  }

  Future<void> restore() async {
    seed();
    final raw = await storage.read();
    if (raw == null) return;
    try {
      final m = jsonDecode(raw) as Map;
      clients = (m['clients'] as List).map((v) => Json.from(v)).toList();
      orders = (m['orders'] as List).map((v) => Json.from(v)).toList();
      visits = (m['visits'] as List).map((v) => Json.from(v)).toList();
      reps = (m['reps'] as List).map((v) => Json.from(v)).toList();
      sequence = m['sequence'] as int;
      signedIn = m['signedIn'] == true;
    } on Object {
      seed();
      signedIn = false;
      sequence = 1049;
      await storage.clear();
    }
  }

  Future<void> persist() => storage.write(
    jsonEncode({
      'version': 1,
      'clients': clients,
      'orders': orders,
      'visits': visits,
      'reps': reps,
      'sequence': sequence,
      'signedIn': signedIn,
    }),
  );
  Future<Result<Snapshot>> fetch() async => signedIn
      ? Ok(Snapshot(clients, orders, visits, reps))
      : const Failure('Entre para continuar.');
  Future<Result<Object?>> execute(String action, Json args) async {
    final backup = jsonEncode({
      'clients': clients,
      'orders': orders,
      'visits': visits,
      'signedIn': signedIn,
      'sequence': sequence,
    });
    try {
      Object? result = true;
      if (action == 'login') {
        if ((args['email'] as String).trim().toLowerCase() !=
                'mariana@elorep.demo' ||
            args['password'] != '123456') {
          return const Failure(
            'E-mail ou senha inválidos. Verifique e tente novamente.',
          );
        }
        signedIn = true;
      } else if (action == 'logout') {
        signedIn = false;
      } else {
        if (!signedIn) return const Failure('Entre para continuar.');
        if (action == 'client') {
          if ([
            'name',
            'city',
            'uf',
            'phone',
          ].any((k) => (args[k] ?? '').toString().trim().isEmpty)) {
            return const Failure('Preencha os campos obrigatórios.');
          }
          final uf = (args['uf'] as String).toUpperCase();
          if (!ufs.contains(uf)) return const Failure('Informe uma UF válida.');
          if ((args['phone'] as String).replaceAll(RegExp(r'\D'), '').length <
              10) {
            return const Failure('Informe telefone com DDD.');
          }
          final cnpj = (args['cnpj'] ?? '').toString().replaceAll(
            RegExp(r'\D'),
            '',
          );
          if (cnpj.isNotEmpty && !validCnpj(cnpj)) {
            return const Failure('Informe um CNPJ válido ou deixe vazio.');
          }
          final id = args['id'] ?? 'c${sequence++}';
          final i = clients.indexWhere((c) => c['id'] == id);
          final c = {
            ...args,
            'id': id,
            'uf': uf,
            'reps': i < 0 ? <String>[] : clients[i]['reps'],
          };
          if (i < 0) {
            clients.insert(0, c);
          } else {
            clients[i] = c;
          }
          result = id;
        } else if (action == 'links') {
          final i = clients.indexWhere((c) => c['id'] == args['id']);
          if (i < 0) return const Failure('Cliente não encontrado.');
          clients[i] = {...clients[i], 'reps': List<String>.from(args['reps'])};
        } else if (action == 'order') {
          final cents = args['cents'];
          if (cents is! int || cents <= 0) {
            return const Failure('Informe um valor total positivo.');
          }
          if (!clients.any((c) => c['id'] == args['clientId']) ||
              !reps.any((r) => r['id'] == args['repId'])) {
            return const Failure('Selecione cliente e representada.');
          }
          final id = '#${sequence++}';
          final date = dateLabel(DateTime.now());
          orders.insert(0, {
            ...args,
            'id': id,
            'status': 'Rascunho',
            'date': date,
            'history': [
              {'label': 'Rascunho criado', 'date': date},
            ],
          });
          result = id;
        } else if (action == 'status') {
          final i = orders.indexWhere((o) => o['id'] == args['id']);
          if (i < 0) return const Failure('Pedido não encontrado.');
          final o = orders[i], old = o['status'];
          final next = args['status'];
          final allowed = {
            'Rascunho': ['Enviado', 'Cancelado'],
            'Enviado': ['Aprovado', 'Cancelado'],
            'Aprovado': ['Faturado', 'Cancelado'],
            'Faturado': ['Entregue'],
            'Entregue': <String>[],
            'Cancelado': <String>[],
          };
          if (!(allowed[old] ?? []).contains(next)) {
            return const Failure('Transição de status inválida.');
          }
          orders[i] = {
            ...o,
            'status': next,
            'history': [
              ...o['history'],
              {'label': next, 'date': dateLabel(DateTime.now())},
            ],
          };
        } else if (action == 'visit') {
          if (!clients.any((c) => c['id'] == args['clientId']) ||
              (args['objective'] ?? '').toString().trim().isEmpty) {
            return const Failure('Informe cliente e objetivo da visita.');
          }
          final d = DateTime.tryParse(args['date'] ?? '');
          if (d == null ||
              !RegExp(r'^([01]\d|2[0-3]):[0-5]\d$')
                  .hasMatch(args['time'] ?? '')) {
            return const Failure('Informe data e horário válidos.');
          }
          visits.add({...args, 'id': 'v${sequence++}', 'status': 'Planejada'});
        } else if (action == 'visitStatus') {
          final i = visits.indexWhere((v) => v['id'] == args['id']);
          if (i < 0) return const Failure('Visita não encontrada.');
          if (visits[i]['status'] != 'Planejada' ||
              !['Concluída', 'Cancelada'].contains(args['status'])) {
            return const Failure('A visita já foi encerrada.');
          }
          visits[i] = {...visits[i], 'status': args['status']};
        } else {
          return const Failure('Ação desconhecida.');
        }
      }
      await persist();
      return Ok(result);
    } on Object {
      final b = jsonDecode(backup) as Map;
      clients = (b['clients'] as List).map((x) => Json.from(x)).toList();
      orders = (b['orders'] as List).map((x) => Json.from(x)).toList();
      visits = (b['visits'] as List).map((x) => Json.from(x)).toList();
      signedIn = b['signedIn'];
      sequence = b['sequence'];
      return const Failure(
        'Não foi possível salvar os dados neste dispositivo. Tente novamente.',
      );
    }
  }
}

const ufs = [
  'AC',
  'AL',
  'AP',
  'AM',
  'BA',
  'CE',
  'DF',
  'ES',
  'GO',
  'MA',
  'MT',
  'MS',
  'MG',
  'PA',
  'PB',
  'PR',
  'PE',
  'PI',
  'RJ',
  'RN',
  'RS',
  'RO',
  'RR',
  'SC',
  'SP',
  'SE',
  'TO',
];
bool validCnpj(String s) {
  if (s.length != 14 || RegExp(r'^(\d)\1+$').hasMatch(s)) return false;
  int digit(String v) {
    var sum = 0, weight = v.length - 7;
    for (var i = 0; i < v.length; i++) {
      sum += int.parse(v[i]) * weight;
      weight--;
      if (weight < 2) weight = 9;
    }
    final r = sum % 11;
    return r < 2 ? 0 : 11 - r;
  }

  return digit(s.substring(0, 12)) == int.parse(s[12]) &&
      digit(s.substring(0, 13)) == int.parse(s[13]);
}
