import 'package:flutter/material.dart';
import 'package:elorep_design_system/elorep_design_system.dart';

import '../../shared/scene_host.dart';
import 'client_detail_view_model.dart';

class ClientDetailView extends StatelessWidget {
  const ClientDetailView({super.key, required this.viewModel});
  final ClientDetailViewModel viewModel;
  @override
  Widget build(BuildContext context) => SceneHost(
    model: viewModel,
    title: 'Detalhes do cliente',
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
      final c = m.client, d = m.data!;
      return page([
        Surface(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Initials(c['name'], size: 48),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    title(c['name']),
                    gap(8),
                    txt('${c['city']}, ${c['uf']}', size: 12, color: T.muted),
                    gap(5),
                    txt(c['phone'], size: 12, color: T.muted),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Editar cliente',
                onPressed: () =>
                    m.open('clientForm', args: {'editId': c['id']}),
                icon: const EloIcon('edit', color: T.blue, size: 19),
              ),
            ],
          ),
        ),
        gap(16),
        LayoutBuilder(
          builder: (context, constraints) {
            final buttons = [
              AppButton(
                'Novo pedido',
                icon: 'receipt',
                onPressed: () =>
                    m.open('orderForm', args: {'clientId': c['id']}),
              ),
              AppButton(
                'Planejar visita',
                variant: 'secondary',
                icon: 'calendar',
                onPressed: () =>
                    m.open('visitForm', args: {'clientId': c['id']}),
              ),
            ];
            return constraints.maxWidth < 340
                ? Column(children: [buttons[0], gap(8), buttons[1]])
                : Row(
                    children: [
                      Expanded(child: buttons[0]),
                      const SizedBox(width: 10),
                      Expanded(child: buttons[1]),
                    ],
                  );
          },
        ),
        gap(28),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  title('Pastas por representada'),
                  gap(4),
                  txt(
                    'Histórico comercial separado por empresa.',
                    size: 12,
                    color: T.muted,
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () async {
                final selected = Set<String>.from(c['reps']);
                final result = await showDialog<List<String>>(
                  context: context,
                  builder: (ctx) => StatefulBuilder(
                    builder: (ctx, setLocal) => AlertDialog(
                      title: const Text('Editar vínculos'),
                      content: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            for (final r in d.reps)
                              CheckboxListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text(r['name']),
                                value: selected.contains(r['id']),
                                onChanged: (v) => setLocal(
                                  () => v == true
                                      ? selected.add(r['id'])
                                      : selected.remove(r['id']),
                                ),
                              ),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('Cancelar'),
                        ),
                        TextButton(
                          onPressed: () =>
                              Navigator.pop(ctx, selected.toList()),
                          child: const Text('Salvar'),
                        ),
                      ],
                    ),
                  ),
                );
                if (result != null && !m.disposed) await m.saveLinks(result);
              },
              child: const Text(
                'Editar vínculos',
                style: TextStyle(fontSize: 11),
              ),
            ),
          ],
        ),
        gap(16),
        if ((c['reps'] as List).isEmpty)
          const StateView(
            title: 'Sem representadas vinculadas',
            message: 'Use Editar vínculos para organizar as pastas.',
          ),
        for (final id in c['reps'])
          space(
            Builder(
              builder: (context) {
                final r = d.rep(id),
                    orders = d.orders
                        .where(
                          (o) => o['clientId'] == c['id'] && o['repId'] == id,
                        )
                        .toList();
                return Surface(
                  padding: 14,
                  child: InkWell(
                    onTap: () => m.open(
                      'repFolder',
                      args: {'clientId': c['id'], 'repId': id},
                    ),
                    child: Row(
                      children: [
                        const IconBox('folder'),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              txt(r['name'], weight: FontWeight.w700),
                              gap(5),
                              txt(
                                orders.isEmpty
                                    ? 'Nenhum pedido registrado'
                                    : '${orders.length} pedidos • Último em ${orders.first['date']}',
                                size: 11,
                                color: T.muted,
                              ),
                            ],
                          ),
                        ),
                        const EloIcon('chevron', size: 18, color: T.muted),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
      ]);
    },
  );
}
