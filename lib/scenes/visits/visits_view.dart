import '../../shared/commercial_widgets.dart';

import 'package:flutter/material.dart';
import 'package:elorep_core/elorep_core.dart';
import 'package:elorep_design_system/elorep_design_system.dart';

import '../../shared/scene_host.dart';
import 'visits_view_model.dart';

class VisitsView extends StatelessWidget {
  const VisitsView({super.key, required this.viewModel});
  final VisitsViewModel viewModel;
  @override
  Widget build(BuildContext context) => SceneHost(
    model: viewModel,
    title: 'Visitas',
    active: 'visits',
    action: TextButton(
      onPressed: () => viewModel.open('visitForm'),
      child: const Text('+ Planejar'),
    ),
    fab: () => viewModel.open('visitForm'),
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
      final d = m.data!,
          start = DateTime(2025, 6, 16).add(Duration(days: m.weekOffset * 7)),
          end = DateTime(2025, 6, 16).add(Duration(days: m.weekOffset * 7 + 6));
      final visits =
          d.visits.where((v) {
            final date = DateTime.parse(v['date']);
            return !date.isBefore(start) && !date.isAfter(end);
          }).toList()..sort(
            (a, b) => '${a['date']} ${a['time']}'.compareTo(
              '${b['date']} ${b['time']}',
            ),
          );
      return page([
        Surface(
          radius: 16,
          padding: 8,
          child: Row(
            children: [
              IconButton(
                tooltip: 'Semana anterior',
                onPressed: () {
                  m.weekOffset--;
                  m.changed();
                },
                icon: const EloIcon('arrowLeft', size: 18),
              ),
              Expanded(
                child: Column(
                  children: [
                    txt(
                      '${dateLabel(start)} - ${dateLabel(end)}',
                      size: 13,
                      weight: FontWeight.w700,
                    ),
                    gap(4),
                    txt('Agenda de demonstração', size: 11, color: T.muted),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Próxima semana',
                onPressed: () {
                  m.weekOffset++;
                  m.changed();
                },
                icon: const EloIcon('chevron', size: 18),
              ),
            ],
          ),
        ),
        gap(22),
        if (visits.isEmpty)
          const StateView(
            title: 'Sem visitas nesta semana',
            message: 'Escolha outra semana ou planeje um atendimento.',
          ),
        for (final date in visits.map((v) => v['date'] as String).toSet()) ...[
          Row(
            children: [
              Surface(
                radius: 12,
                padding: 10,
                child: txt(
                  dateLabel(DateTime.parse(date)),
                  size: 12,
                  weight: FontWeight.w800,
                  color: T.blue,
                ),
              ),
              const SizedBox(width: 12),
              txt('Atendimentos', weight: FontWeight.w700),
            ],
          ),
          gap(14),
          for (final v in visits.where((v) => v['date'] == date))
            space(
              InkWell(
                onTap: () async {
                  final choice = await selectValue(context, 'Atendimento', {
                    'details': 'Ver detalhes',
                    if (v['status'] == 'Planejada')
                      'Concluída': 'Marcar como concluída',
                    if (v['status'] == 'Planejada')
                      'Cancelada': 'Cancelar visita',
                  }, 'details');
                  if (!context.mounted || choice == null) return;
                  if (choice == 'details') {
                    await showDialog<void>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text(d.client(v['clientId'])['name']),
                        content: Text(
                          '${v['objective']}\n${v['notes']}\n${dateLabel(DateTime.parse(v['date']))} às ${v['time']}',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text('Fechar'),
                          ),
                        ],
                      ),
                    );
                  } else if (await confirmAction(
                    context,
                    'Atualizar atendimento?',
                    'Alterar a visita para $choice?',
                  )) {
                    m.visitStatus(v['id'], choice);
                  }
                },
                child: Surface(
                  padding: 14,
                  radius: 18,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          txt(
                            v['time'],
                            size: 15,
                            weight: FontWeight.w800,
                            color: T.blue,
                          ),
                          const Spacer(),
                          AppStatus(v['status']),
                        ],
                      ),
                      gap(10),
                      txt(
                        d.client(v['clientId'])['name'],
                        size: 13,
                        weight: FontWeight.w700,
                      ),
                      gap(5),
                      txt(
                        '${d.client(v['clientId'])['city']} • ${v['objective']}',
                        size: 11,
                        color: T.muted,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          gap(8),
        ],
        AppButton(
          'Ir para a semana atual',
          variant: 'text',
          onPressed: () {
            m.weekOffset =
                DateTime.now().difference(DateTime(2025, 6, 16)).inDays ~/ 7;
            m.changed();
          },
        ),
        gap(70),
      ]);
    },
  );
}
