import 'package:flutter/material.dart';
import 'package:elorep_core/elorep_core.dart';
import 'package:elorep_design_system/elorep_design_system.dart';

import '../../shared/scene_host.dart';
import 'order_detail_view_model.dart';

class OrderDetailView extends StatelessWidget {
  const OrderDetailView({super.key, required this.viewModel});
  final OrderDetailViewModel viewModel;
  @override
  Widget build(BuildContext context) => SceneHost(
    model: viewModel,
    titleBuilder: () =>
        viewModel.data == null ? 'Pedido' : 'Pedido ${viewModel.order['id']}',
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
      final o = m.order, d = m.data!;
      final next = {
        'Rascunho': 'Enviado',
        'Enviado': 'Aprovado',
        'Aprovado': 'Faturado',
        'Faturado': 'Entregue',
      }[o['status']];
      return page([
        Surface(
          padding: 20,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    txt(
                      'VALOR TOTAL',
                      size: 10,
                      color: T.muted,
                      weight: FontWeight.w700,
                    ),
                    gap(8),
                    txt(
                      money(o['cents']),
                      size: 28,
                      weight: FontWeight.w800,
                      color: T.navy,
                    ),
                  ],
                ),
              ),
              AppStatus(o['status']),
            ],
          ),
        ),
        gap(16),
        detailRows([
          ('Cliente', d.client(o['clientId'])['name']),
          ('Representada', d.rep(o['repId'])['name']),
          ('Data de registro', o['date']),
          (
            'Referência',
            (o['reference'] as String).isEmpty
                ? 'Não informada'
                : o['reference'],
          ),
        ]),
        gap(26),
        title('Histórico de status'),
        gap(16),
        for (final h in o['history'])
          space(
            Row(
              children: [
                const IconBox(
                  'check',
                  color: T.green,
                  background: T.greenSoft,
                  size: 32,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      txt(h['label'], size: 13, weight: FontWeight.w700),
                      gap(4),
                      txt(h['date'], size: 11, color: T.muted),
                    ],
                  ),
                ),
              ],
            ),
          ),
        if (next != null) ...[
          gap(8),
          txt('Próximo: $next', size: 13, color: T.muted),
          gap(20),
          AppButton(
            'Marcar como ${next.toLowerCase()}',
            loading: m.busy,
            onPressed: () async {
              if (await confirmAction(
                context,
                'Atualizar pedido?',
                'Alterar o status para $next? Esta ação será registrada no histórico.',
              )) {
                m.changeOrderStatus(next);
              }
            },
          ),
        ],
        if (['Rascunho', 'Enviado', 'Aprovado'].contains(o['status'])) ...[
          gap(8),
          AppButton(
            'Cancelar pedido',
            variant: 'danger',
            onPressed: () async {
              if (await confirmAction(
                context,
                'Cancelar este pedido?',
                'Esta ação será registrada no histórico.',
              )) {
                m.changeOrderStatus('Cancelado');
              }
            },
          ),
        ],
      ]);
    },
  );
}
