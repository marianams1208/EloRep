import 'package:flutter/material.dart';
import 'package:elorep_design_system/elorep_design_system.dart';

import '../../shared/scene_host.dart';
import 'reps_view_model.dart';

class RepsView extends StatelessWidget {
  const RepsView({super.key, required this.viewModel});
  final RepsViewModel viewModel;
  @override
  Widget build(BuildContext context) => SceneHost(
    model: viewModel,
    title: 'Representadas',
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
      final reps = m.data!.reps
          .where(
            (r) => r['name'].toString().toLowerCase().contains(
              m.query.toLowerCase(),
            ),
          )
          .toList();
      return page([
        searchBox('Buscar representada', (v) {
          m.query = v;
          m.changed();
        }),
        meta('${reps.length} empresas', 'Dados de demonstração'),
        Surface(
          padding: 14,
          child: Column(
            children: [
              for (var i = 0; i < reps.length; i++) ...[
                InkWell(
                  onTap: () =>
                      m.open('repDetail', args: {'repId': reps[i]['id']}),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    child: Row(
                      children: [
                        Initials(reps[i]['name'], index: i, size: 48),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              txt(reps[i]['name'], weight: FontWeight.w800),
                              gap(5),
                              txt(
                                reps[i]['description'],
                                size: 11,
                                color: T.muted,
                              ),
                              gap(8),
                              txt(
                                reps[i]['bps'] == null
                                    ? 'Regra não configurada'
                                    : '${(reps[i]['bps'] / 100).toString().replaceAll('.0', '').replaceAll('.', ',')}% sobre faturado',
                                size: 10,
                                weight: FontWeight.w700,
                                color: reps[i]['bps'] == null
                                    ? T.muted
                                    : T.green,
                              ),
                            ],
                          ),
                        ),
                        const EloIcon('chevron', size: 19, color: T.muted),
                      ],
                    ),
                  ),
                ),
                if (i < reps.length - 1)
                  const Divider(height: 1, color: T.line),
              ],
            ],
          ),
        ),
        if (reps.isEmpty)
          const StateView(title: 'Nenhuma representada encontrada'),
        gap(16),
        const AppNote(
          'Regras e valores são exemplos de demonstração, sem vínculo com condições comerciais reais.',
        ),
      ]);
    },
  );
}
