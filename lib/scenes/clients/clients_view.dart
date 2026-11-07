import 'package:flutter/material.dart';
import 'package:elorep_design_system/elorep_design_system.dart';

import '../../shared/scene_host.dart';
import 'clients_view_model.dart';

class ClientsView extends StatelessWidget {
  const ClientsView({super.key, required this.viewModel});
  final ClientsViewModel viewModel;
  @override
  Widget build(BuildContext context) => SceneHost(
    model: viewModel,
    title: 'Clientes',
    active: 'clients',
    action: TextButton(
      onPressed: () => viewModel.open('clientForm'),
      child: const Text('+ Novo'),
    ),
    fab: () => viewModel.open('clientForm'),
    back: false,
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
      final items = m.filteredClients;
      return page([
        searchBox('Buscar por nome ou cidade', (v) {
          m.query = v;
          m.changed();
        }),
        meta('${items.length} clientes', 'Dados de demonstração'),
        if (items.isEmpty)
          const StateView(
            title: 'Nenhum cliente encontrado',
            message: 'Tente buscar por outro nome ou cidade.',
          )
        else
          Surface(
            padding: 14,
            child: Column(
              children: [
                for (var i = 0; i < items.length; i++) ...[
                  InkWell(
                    onTap: () => m.open(
                      'clientDetail',
                      args: {'clientId': items[i]['id']},
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Row(
                        children: [
                          Initials(items[i]['name'], index: i),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                txt(
                                  items[i]['name'],
                                  size: 13,
                                  weight: FontWeight.w700,
                                  maxLines: 2,
                                ),
                                gap(5),
                                txt(
                                  '${items[i]['city']}, ${items[i]['uf']}',
                                  size: 11,
                                  color: T.muted,
                                ),
                                gap(5),
                                Wrap(
                                  spacing: 4,
                                  runSpacing: 4,
                                  children: [
                                    for (final id in items[i]['reps'])
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 3,
                                        ),
                                        decoration: BoxDecoration(
                                          color: T.bg,
                                          borderRadius: BorderRadius.circular(
                                            5,
                                          ),
                                        ),
                                        child: txt(
                                          m.data!.rep(id)['name'],
                                          size: 9,
                                          color: T.muted,
                                        ),
                                      ),
                                    if ((items[i]['reps'] as List).isEmpty)
                                      txt(
                                        'Sem vínculos',
                                        size: 9,
                                        color: T.muted,
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const EloIcon('chevron', size: 19, color: T.muted),
                        ],
                      ),
                    ),
                  ),
                  if (i < items.length - 1)
                    const Divider(height: 1, color: T.line),
                ],
              ],
            ),
          ),
        gap(70),
      ]);
    },
  );
}
