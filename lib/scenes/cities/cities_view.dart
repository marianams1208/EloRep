import '../../shared/commercial_widgets.dart';

import 'package:flutter/material.dart';
import 'package:elorep_design_system/elorep_design_system.dart';

import '../../shared/scene_host.dart';
import 'cities_view_model.dart';

class CitiesView extends StatelessWidget {
  const CitiesView({super.key, required this.viewModel});
  final CitiesViewModel viewModel;
  @override
  Widget build(BuildContext context) => SceneHost(
    model: viewModel,
    title: 'Carteira por cidade',
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
      final cities =
          m.data!.clients.map((c) => c['city'] as String).toSet().toList()
            ..sort();
      final clients = m.filteredClients
          .where((c) => m.cityFilter.isEmpty || c['city'] == m.cityFilter)
          .toList();
      return page([
        searchBox('Buscar cliente ou cidade', (v) {
          m.query = v;
          m.changed();
        }),
        gap(12),
        Row(
          children: [
            ActionChip(
              label: Text(
                m.cityFilter.isEmpty ? 'Todas as cidades' : m.cityFilter,
              ),
              onPressed: () {
                m.cityFilter = '';
                m.changed();
              },
            ),
            const SizedBox(width: 10),
            ActionChip(
              avatar: const EloIcon('filter', size: 16),
              label: const Text('Filtrar'),
              onPressed: () async {
                final v = await selectValue(context, 'Cidade', {
                  '': 'Todas as cidades',
                  for (final c in cities) c: c,
                }, m.cityFilter);
                if (v != null && !m.disposed) {
                  m.cityFilter = v;
                  m.changed();
                }
              },
            ),
          ],
        ),
        gap(18),
        if (clients.isEmpty)
          const StateView(title: 'Nenhum cliente encontrado'),
        for (final city in cities.where(
          (city) => clients.any((c) => c['city'] == city),
        ))
          space(
            Surface(
              padding: 14,
              child: Column(
                children: [
                  Row(
                    children: [
                      const IconBox('pin'),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            txt(city, weight: FontWeight.w700),
                            gap(5),
                            txt(
                              '${clients.where((c) => c['city'] == city).length} clientes',
                              size: 11,
                              color: T.muted,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  gap(12),
                  for (final c in clients.where((c) => c['city'] == city))
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: txt(c['name'], size: 13),
                      trailing: const EloIcon('chevron', size: 18),
                      onTap: () =>
                          m.open('clientDetail', args: {'clientId': c['id']}),
                    ),
                ],
              ),
            ),
          ),
        const AppNote(
          'Agrupamento por cidade cadastrada. Este recurso não usa mapa nem localização em tempo real.',
        ),
      ]);
    },
  );
}
