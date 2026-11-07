import '../../shared/commercial_widgets.dart';

import 'package:flutter/material.dart';
import 'package:elorep_core/elorep_core.dart';
import 'package:elorep_design_system/elorep_design_system.dart';

import '../../shared/scene_host.dart';
import 'orders_view_model.dart';

class OrdersView extends StatelessWidget {
  const OrdersView({super.key, required this.viewModel});
  final OrdersViewModel viewModel;
  @override
  Widget build(BuildContext context) => SceneHost(
    model: viewModel,
    title: 'Pedidos',
    active: 'orders',
    action: TextButton(
      onPressed: () => viewModel.open('orderForm'),
      child: const Text('+ Novo'),
    ),
    fab: () => viewModel.open('orderForm'),
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
      final d = m.data!, orders = m.filteredOrders;
      return page([
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ActionChip(
                label: const Text('Todos'),
                onPressed: () {
                  m.repFilter = '';
                  m.statusFilter = '';
                  m.changed();
                },
              ),
              const SizedBox(width: 8),
              ActionChip(
                label: Text(
                  m.repFilter.isEmpty
                      ? 'Representada'
                      : d.rep(m.repFilter)['name'],
                ),
                onPressed: () async {
                  final v = await selectValue(context, 'Representada', {
                    '': 'Todas',
                    ...m.repOptions,
                  }, m.repFilter);
                  if (v != null && !m.disposed) {
                    m.repFilter = v;
                    m.changed();
                  }
                },
              ),
              const SizedBox(width: 8),
              ActionChip(
                label: Text(m.statusFilter.isEmpty ? 'Status' : m.statusFilter),
                onPressed: () async {
                  final v = await selectValue(context, 'Status', {
                    '': 'Todos',
                    for (final s in statuses) s: s,
                  }, m.statusFilter);
                  if (v != null && !m.disposed) {
                    m.statusFilter = v;
                    m.changed();
                  }
                },
              ),
            ],
          ),
        ),
        meta('${orders.length} pedidos', 'Dados de demonstração'),
        if (orders.isEmpty)
          const StateView(
            title: 'Nenhum pedido encontrado',
            message: 'Ajuste os filtros ou registre um pedido.',
          ),
        for (final o in orders)
          space(
            orderCard(
              d,
              o,
              () => m.open('orderDetail', args: {'orderId': o['id']}),
            ),
          ),
        gap(70),
      ]);
    },
  );
}
