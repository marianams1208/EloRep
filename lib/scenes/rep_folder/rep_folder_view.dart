import 'package:flutter/material.dart';
import 'package:elorep_core/elorep_core.dart';
import 'package:elorep_design_system/elorep_design_system.dart';

import '../../shared/scene_host.dart';
import 'rep_folder_view_model.dart';

class RepFolderView extends StatelessWidget {
  const RepFolderView({super.key, required this.viewModel});
  final RepFolderViewModel viewModel;
  @override
  Widget build(BuildContext context) => SceneHost(
    model: viewModel,
    titleBuilder: () => viewModel.data == null
        ? 'Pasta da representada'
        : viewModel.rep['name'],
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
      final d = m.data!, c = m.client, r = m.rep;
      final orders = d.orders
          .where((o) => o['clientId'] == c['id'] && o['repId'] == r['id'])
          .toList();
      return page([
        Surface(
          color: T.soft,
          border: false,
          child: Row(
            children: [
              Initials(c['name']),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    txt('CLIENTE', size: 10, color: T.muted),
                    gap(4),
                    txt(c['name'], weight: FontWeight.w700),
                  ],
                ),
              ),
            ],
          ),
        ),
        meta('Histórico comercial', '${orders.length} registros'),
        for (final o in orders)
          space(
            InkWell(
              onTap: () => m.open('orderDetail', args: {'orderId': o['id']}),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 8, right: 18),
                    child: CircleAvatar(radius: 5, backgroundColor: T.blue),
                  ),
                  Expanded(
                    child: Surface(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          txt(o['date'], size: 11, color: T.muted),
                          gap(6),
                          txt('Pedido ${o['id']}', weight: FontWeight.w700),
                          gap(6),
                          txt(money(o['cents']), size: 13),
                          gap(8),
                          AppStatus(o['status']),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        const StateView(
          title: 'Fim do histórico',
          message: 'Os registros mais recentes aparecem primeiro.',
        ),
      ]);
    },
  );
}
