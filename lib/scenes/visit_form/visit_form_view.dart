import 'package:flutter/material.dart';
import 'package:elorep_core/elorep_core.dart';
import 'package:elorep_design_system/elorep_design_system.dart';

import '../../shared/scene_host.dart';
import 'visit_form_view_model.dart';

class VisitFormView extends StatelessWidget {
  const VisitFormView({super.key, required this.viewModel});
  final VisitFormViewModel viewModel;
  @override
  Widget build(BuildContext context) => SceneHost(
    model: viewModel,
    title: 'Planejar visita',
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
      return page([
        space(
          AppSelect(
            'Cliente *',
            value: m.value('clientId'),
            items: m.clientOptions,
            onChanged: (v) => m.setField('clientId', v!),
          ),
        ),
        space(
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: AppField(
                  'Data *',
                  key: ValueKey(m.value('date')),
                  value: dateLabel(DateTime.parse(m.value('date'))),
                  readOnly: true,
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.parse(m.value('date')),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2100),
                    );
                    if (date != null && !m.disposed) {
                      m.setField(
                        'date',
                        date.toIso8601String().split('T').first,
                      );
                    }
                  },
                  suffix: const Padding(
                    padding: EdgeInsets.all(14),
                    child: EloIcon('calendar', size: 19, color: T.muted),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppField(
                  'Horário *',
                  key: ValueKey(m.value('time')),
                  value: m.value('time'),
                  readOnly: true,
                  onTap: () async {
                    final parts = m.value('time').split(':');
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay(
                        hour: int.parse(parts[0]),
                        minute: int.parse(parts[1]),
                      ),
                    );
                    if (time != null && !m.disposed) {
                      m.setField(
                        'time',
                        '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
                      );
                    }
                  },
                  suffix: const Padding(
                    padding: EdgeInsets.all(14),
                    child: EloIcon('clock', size: 19, color: T.muted),
                  ),
                ),
              ),
            ],
          ),
        ),
        space(
          AppField(
            'Objetivo *',
            value: m.value('objective'),
            placeholder: 'Ex.: Apresentar lançamentos',
            error: m.fieldErrors['objective'],
            onChanged: (v) => m.setField('objective', v),
          ),
        ),
        space(
          AppField(
            'Observações',
            optional: true,
            value: m.value('notes'),
            lines: 4,
            placeholder: 'Informações úteis para a visita',
            onChanged: (v) => m.setField('notes', v),
          ),
        ),
        gap(12),
        AppButton(
          'Salvar planejamento',
          loading: m.busy,
          onPressed: m.value('objective').trim().isEmpty ? null : m.saveVisit,
        ),
        gap(8),
        AppButton('Cancelar', variant: 'text', onPressed: m.back),
      ]);
    },
  );
}
