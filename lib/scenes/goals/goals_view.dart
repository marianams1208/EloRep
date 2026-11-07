import 'package:flutter/material.dart';
import 'package:elorep_core/elorep_core.dart';
import 'package:elorep_design_system/elorep_design_system.dart';

import '../../shared/scene_host.dart';
import 'goals_view_model.dart';

class GoalsView extends StatelessWidget {
  const GoalsView({super.key, required this.viewModel});
  final GoalsViewModel viewModel;
  @override
  Widget build(BuildContext context) => SceneHost(
    model: viewModel,
    title: 'Metas e comissões',
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
      final r = m.data!.rep(m.selectedRep);
      final configured = r['bps'] != null && m.month == '2025-06';
      final rate = (r['bps'] ?? 0) as int;
      final actual = m.selectedRep == 'r1' ? 5440000 : 3600000,
          target = m.selectedRep == 'r1' ? 8000000 : 6000000;
      return page([
        space(
          AppSelect(
            'PERÍODO',
            value: m.month,
            items: {
              '2025-06': 'Junho de 2025',
              '2025-07': 'Julho de 2025',
              '2026-11': 'Novembro de 2026',
            },
            onChanged: (v) {
              m.month = v!;
              m.changed();
            },
          ),
        ),
        space(
          AppSelect(
            'REPRESENTADA',
            value: m.selectedRep,
            items: m.repOptions,
            onChanged: (v) {
              m.selectedRep = v!;
              m.changed();
            },
          ),
        ),
        if (!configured) ...[
          const StateView(
            title: 'A definir',
            message: 'Não há meta ou regra de comissão configurada para esta seleção.',
          ),
          const AppNote('Nenhuma estimativa é criada sem regra cadastrada.'),
        ] else ...[
          Surface(
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          txt(
                            'META DO MÊS',
                            size: 10,
                            weight: FontWeight.w700,
                            color: T.muted,
                          ),
                          gap(8),
                          txt(
                            money(target),
                            size: 26,
                            weight: FontWeight.w800,
                            color: T.navy,
                          ),
                        ],
                      ),
                    ),
                    AppStatus('${(actual / target * 100).round()}%'),
                  ],
                ),
                gap(20),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: actual / target,
                    minHeight: 8,
                    backgroundColor: T.soft,
                    color: T.blue,
                  ),
                ),
                gap(18),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          txt('Realizado', size: 11, color: T.muted),
                          gap(5),
                          txt(money(actual), weight: FontWeight.w700),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        txt('Faltam', size: 11, color: T.muted),
                        gap(5),
                        txt(money(target - actual), weight: FontWeight.w700),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          gap(24),
          title('Comissões'),
          gap(4),
          txt('Valores do período selecionado.', size: 13, color: T.muted),
          gap(16),
          Surface(
            padding: 16,
            child: Column(
              children: [
                for (final item in [
                  (
                    'trend',
                    'ESTIMADA',
                    money((actual * rate / 10000).round()),
                    'Sobre pedidos faturados',
                    T.blue,
                    T.soft,
                  ),
                  (
                    'check',
                    'APURADA',
                    money(m.selectedRep == 'r1' ? 184000 : 120000),
                    'Confirmada pela representada',
                    T.violet,
                    T.violetSoft,
                  ),
                  (
                    'wallet',
                    'RECEBIDA',
                    money(m.selectedRep == 'r1' ? 92000 : 60000),
                    'Pagamento registrado',
                    T.green,
                    T.greenSoft,
                  ),
                ]) ...[
                  Row(
                    children: [
                      IconBox(item.$1, color: item.$5, background: item.$6),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            txt(
                              item.$2,
                              size: 10,
                              weight: FontWeight.w700,
                              color: T.muted,
                            ),
                            gap(6),
                            txt(
                              item.$3,
                              size: 23,
                              weight: FontWeight.w800,
                              color: T.navy,
                            ),
                            gap(5),
                            txt(item.$4, size: 11, color: T.muted),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (item.$1 != 'wallet') ...[
                    gap(16),
                    const Divider(height: 1, color: T.line),
                    gap(16),
                  ],
                ],
              ],
            ),
          ),
          gap(18),
          const AppNote(
            'Dados de demonstração do protótipo. Os indicadores desta tela não representam apuração real nem são recalculados pelos pedidos cadastrados.',
          ),
        ],
      ]);
    },
  );
}
