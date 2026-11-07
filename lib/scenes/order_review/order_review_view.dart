import '../../shared/commercial_widgets.dart';

import 'package:flutter/material.dart';
import 'package:elorep_core/elorep_core.dart';
import 'package:elorep_design_system/elorep_design_system.dart';

import '../../shared/scene_host.dart';
import 'order_review_view_model.dart';

class OrderReviewView extends StatelessWidget {
  const OrderReviewView({super.key, required this.viewModel});
  final OrderReviewViewModel viewModel;
  @override
  Widget build(BuildContext context) => SceneHost(
    model: viewModel,
    title: 'Revisar pedido',
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
      final draft = Json.from(m.args['draft']), d = m.data!;
      return page([
        space(orderSteps(true)),
        Surface(
          padding: 18,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const IconBox('receipt'),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        txt(
                          'NOVO PEDIDO',
                          size: 10,
                          color: T.muted,
                          weight: FontWeight.w700,
                        ),
                        gap(4),
                        txt('Confira antes de salvar', weight: FontWeight.w700),
                      ],
                    ),
                  ),
                ],
              ),
              gap(20),
              for (final row in [
                ('Cliente', d.client(draft['clientId'])['name'] as String),
                ('Representada', d.rep(draft['repId'])['name'] as String),
                ('Valor total', money(draft['cents'])),
                (
                  'Referência',
                  (draft['reference'] as String).isEmpty
                      ? 'Não informada'
                      : draft['reference'] as String,
                ),
              ]) ...[
                txt(row.$1, size: 12, color: T.muted),
                gap(6),
                txt(
                  row.$2,
                  size: row.$1 == 'Valor total' ? 26 : 14,
                  weight: FontWeight.w700,
                ),
                gap(20),
              ],
            ],
          ),
        ),
        gap(16),
        const AppNote('O pedido será salvo com o status Rascunho.'),
        gap(24),
        AppButton(
          'Salvar como rascunho',
          loading: m.busy,
          onPressed: m.saveOrder,
        ),
        gap(8),
        AppButton('Voltar e editar', variant: 'secondary', onPressed: m.back),
      ]);
    },
  );
}
