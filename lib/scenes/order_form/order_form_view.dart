import '../../shared/commercial_widgets.dart';

import 'package:flutter/material.dart';
import 'package:elorep_design_system/elorep_design_system.dart';

import '../../shared/scene_host.dart';
import 'order_form_view_model.dart';

class OrderFormView extends StatelessWidget {
  const OrderFormView({super.key, required this.viewModel});
  final OrderFormViewModel viewModel;
  @override
  Widget build(BuildContext context) => SceneHost(
    model: viewModel,
    title: 'Novo pedido',
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
        space(orderSteps(false)),
        space(
          AppSelect(
            'Cliente *',
            value: m.value('clientId'),
            items: m.clientOptions,
            onChanged: (v) => m.setField('clientId', v!),
          ),
        ),
        space(
          AppSelect(
            'Representada *',
            value: m.value('repId'),
            items: m.repOptions,
            onChanged: (v) => m.setField('repId', v!),
          ),
        ),
        space(
          AppField(
            'Valor total *',
            prefix: 'R\$ ',
            value: m.value('amount'),
            placeholder: '0,00',
            keyboard: const TextInputType.numberWithOptions(decimal: true),
            error: m.fieldErrors['amount'],
            onChanged: (v) => m.setField('amount', v),
          ),
        ),
        space(
          AppField(
            'Referência',
            optional: true,
            value: m.value('reference'),
            placeholder: 'Ex.: Pedido de reposição',
            onChanged: (v) => m.setField('reference', v),
          ),
        ),
        const AppNote(
          'Este pedido é um registro interno. Nenhum pedido será enviado automaticamente à representada.',
        ),
        gap(24),
        AppButton(
          'Revisar pedido',
          onPressed: m.value('amount').isEmpty ? null : m.reviewOrder,
        ),
        gap(8),
        AppButton('Cancelar', variant: 'text', onPressed: m.back),
      ]);
    },
  );
}
