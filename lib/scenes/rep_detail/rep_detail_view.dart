import 'package:flutter/material.dart';
import 'package:elorep_design_system/elorep_design_system.dart';

import '../../shared/scene_host.dart';
import 'rep_detail_view_model.dart';

class RepDetailView extends StatelessWidget {
  const RepDetailView({super.key, required this.viewModel});
  final RepDetailViewModel viewModel;
  @override
  Widget build(BuildContext context) => SceneHost(
    model: viewModel,
    titleBuilder: () =>
        viewModel.data == null ? 'Representada' : viewModel.rep['name'],
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
      final r = m.rep;
      final rule = r['bps'] == null
          ? 'Regra não configurada'
          : '${(r['bps'] / 100).toString().replaceAll('.0', '').replaceAll('.', ',')}% sobre faturado';
      return page([
        Row(
          children: [
            Initials(r['name'], size: 60),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  title(r['name']),
                  gap(6),
                  txt(r['description'], size: 13, color: T.muted),
                ],
              ),
            ),
          ],
        ),
        gap(24),
        detailRows([
          ('Nome comercial', r['name']),
          ('Região de atendimento', 'Paraná'),
          ('Contato comercial', 'Dados não informados'),
        ]),
        gap(20),
        Surface(
          color: T.greenSoft,
          border: false,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const IconBox('wallet', color: T.green, background: Colors.white),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    txt(
                      'REGRA DE COMISSÃO',
                      size: 10,
                      color: T.green,
                      weight: FontWeight.w700,
                    ),
                    gap(8),
                    txt(
                      rule,
                      size: 20,
                      weight: FontWeight.w800,
                      color: T.green,
                    ),
                    gap(8),
                    txt(
                      r['bps'] == null
                          ? 'Confirme as condições antes de configurar.'
                          : 'Apuração mensal após confirmação do faturamento.',
                      size: 12,
                      color: T.green,
                      height: 1.5,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        gap(18),
        const AppNote(
          'Regra exibida como demonstração. Confirme as condições com a representada.',
        ),
      ]);
    },
  );
}
