import 'package:flutter/material.dart';
import 'package:elorep_design_system/elorep_design_system.dart';

import '../../shared/scene_host.dart';
import 'client_form_view_model.dart';

class ClientFormView extends StatelessWidget {
  const ClientFormView({super.key, required this.viewModel});
  final ClientFormViewModel viewModel;
  @override
  Widget build(BuildContext context) => SceneHost(
    model: viewModel,
    title: viewModel.args['editId'] == null ? 'Novo cliente' : 'Editar cliente',
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
        title(m.args['editId'] == null ? 'Dados do cliente' : 'Editar dados'),
        gap(4),
        txt(
          'Os campos marcados com * são obrigatórios.',
          size: 13,
          color: T.muted,
        ),
        gap(20),
        space(
          AppField(
            'Nome ou razão social *',
            value: m.value('name'),
            placeholder: 'Ex.: Auto Peças Central',
            error: m.fieldErrors['name'],
            onChanged: (v) => m.setField('name', v),
          ),
        ),
        space(
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: AppField(
                  'Cidade *',
                  value: m.value('city'),
                  placeholder: 'Cidade',
                  error: m.fieldErrors['city'],
                  onChanged: (v) => m.setField('city', v),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppField(
                  'UF *',
                  value: m.value('uf'),
                  placeholder: 'PR',
                  error: m.fieldErrors['uf'],
                  onChanged: (v) => m.setField('uf', v.toUpperCase()),
                ),
              ),
            ],
          ),
        ),
        space(
          AppField(
            'Telefone com DDD *',
            value: m.value('phone'),
            placeholder: '(00) 00000-0000',
            keyboard: TextInputType.phone,
            error: m.fieldErrors['phone'],
            onChanged: (v) => m.setField('phone', v),
          ),
        ),
        space(
          AppField(
            'CNPJ',
            value: m.value('cnpj'),
            optional: true,
            placeholder: '00.000.000/0000-00',
            keyboard: TextInputType.number,
            onChanged: (v) => m.setField('cnpj', v),
          ),
        ),
        const AppNote('Você poderá vincular representadas depois de salvar.'),
        gap(24),
        AppButton('Salvar cliente', loading: m.busy, onPressed: m.saveClient),
        gap(8),
        AppButton('Cancelar', variant: 'text', onPressed: m.back),
      ]);
    },
  );
}
