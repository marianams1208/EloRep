import 'package:flutter/material.dart';
import 'package:elorep_design_system/elorep_design_system.dart';

import '../../shared/scene_host.dart';
import 'home_view_model.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key, required this.viewModel});
  final HomeViewModel viewModel;
  @override
  Widget build(BuildContext context) => SceneHost(
    model: viewModel,
    active: 'home',
    back: true,
    builder: (context, m) {
      if (m.data == null) {
        return StateView(
          kind: m.error == null ? 'loading' : 'error',
          title: m.error == null
              ? 'Carregando informações'
              : 'Não foi possível carregar',
          message: m.error ?? 'Isso leva só alguns segundos.',
          onRetry: m.error == null ? null : m.load,
        );
      }
      final d = m.data!;
      final ongoing = d.orders
          .where((o) => !['Entregue', 'Cancelado'].contains(o['status']))
          .length;
      return ListView(
        padding: const EdgeInsets.only(bottom: 26),
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(20, 30, 20, 24),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      txt(
                        'SUA ROTINA COMERCIAL',
                        size: 10,
                        weight: FontWeight.w800,
                        color: T.blue,
                      ),
                      gap(5),
                      txt('Olá, Mariana', size: 25, weight: FontWeight.w800),
                      gap(4),
                      txt('O que vamos fazer hoje?', size: 13, color: T.muted),
                    ],
                  ),
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(17),
                  onTap: () async {
                    if (await confirmAction(
                      context,
                      'Sair da conta?',
                      'Os dados de demonstração permanecem neste dispositivo.',
                    )) {
                      m.logout();
                    }
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: T.soft,
                      borderRadius: BorderRadius.circular(17),
                    ),
                    alignment: Alignment.center,
                    child: txt('MS', color: T.blue, weight: FontWeight.w800),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [T.navy, Color(0xFF173D79)],
                ),
                borderRadius: BorderRadius.circular(26),
                boxShadow: [
                  BoxShadow(
                    color: T.navy.withValues(alpha: .2),
                    blurRadius: 25,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: txt(
                          'Pedidos registrados',
                          color: const Color(0xFFDCE7FF),
                          weight: FontWeight.w500,
                        ),
                      ),
                      const EloIcon('receipt', color: Colors.white),
                    ],
                  ),
                  gap(12),
                  txt(
                    '${d.orders.length}',
                    size: 42,
                    weight: FontWeight.w800,
                    color: Colors.white,
                  ),
                  gap(12),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: .12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: txt(
                          '$ongoing em andamento',
                          size: 12,
                          color: Colors.white,
                        ),
                      ),
                      const Spacer(),
                      txt(
                        'Registros internos',
                        size: 11,
                        color: const Color(0xFFB9C9E7),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: title('Acessos rápidos')),
                    txt('Rotina comercial', size: 11, color: T.muted),
                  ],
                ),
                gap(13),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final item in [
                      (
                        'clients',
                        'users',
                        'Clientes',
                        '${d.clients.length} cadastrados',
                        T.blue,
                        T.soft,
                      ),
                      (
                        'orders',
                        'receipt',
                        'Pedidos',
                        '$ongoing em andamento',
                        T.violet,
                        T.violetSoft,
                      ),
                      (
                        'visits',
                        'calendar',
                        'Visitas',
                        '${d.visits.where((v) => v['status'] == 'Planejada').length} planejadas',
                        T.green,
                        T.greenSoft,
                      ),
                    ])
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                            right: item.$1 == 'visits' ? 0 : 10,
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () => m.open(item.$1),
                            child: Surface(
                              radius: 20,
                              padding: 10,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  IconBox(
                                    item.$2,
                                    color: item.$5,
                                    background: item.$6,
                                  ),
                                  gap(10),
                                  txt(item.$3, weight: FontWeight.w700),
                                  gap(7),
                                  txt(
                                    item.$4,
                                    size: 10,
                                    color: T.muted,
                                    height: 1.3,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                gap(24),
                title('Gestão da carteira'),
                gap(13),
                Surface(
                  padding: 14,
                  child: Column(
                    children: [
                      linkRow(
                        'building',
                        'Representadas',
                        'Empresas e regras comerciais',
                        () => m.open('reps'),
                      ),
                      const Divider(height: 1, color: T.line),
                      linkRow(
                        'target',
                        'Metas e comissões',
                        'Acompanhe seu desempenho',
                        () => m.open('goals'),
                      ),
                      const Divider(height: 1, color: T.line),
                      linkRow(
                        'map',
                        'Carteira por cidade',
                        'Clientes agrupados por região',
                        () => m.open('cities'),
                      ),
                    ],
                  ),
                ),
                gap(18),
                const AppNote(
                  'Faturamento é diferente de pedidos. Consulte valores faturados em Metas e comissões.',
                ),
                gap(12),
                Center(
                  child: txt(
                    'Ambiente local • Dados fictícios',
                    size: 10,
                    color: T.muted,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    },
  );
}
