import 'package:flutter/material.dart';
import 'package:elorep_design_system/elorep_design_system.dart';

void main() => runApp(
  MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: T.theme(),
    home: const DesignSystemSample(),
  ),
);

class DesignSystemSample extends StatefulWidget {
  const DesignSystemSample({super.key});
  @override
  State<DesignSystemSample> createState() => _DesignSystemSampleState();
}

class _DesignSystemSampleState extends State<DesignSystemSample> {
  int count = 0;
  @override
  Widget build(BuildContext context) => DefaultTabController(
    length: 3,
    child: Scaffold(
      appBar: AppBar(
        title: const Text('EloRep • Design System'),
        bottom: const TabBar(
          tabs: [
            Tab(text: 'Fundamentos'),
            Tab(text: 'Componentes'),
            Tab(text: 'Estados'),
          ],
        ),
      ),
      body: TabBarView(
        children: [
          ListView(
            padding: const EdgeInsets.all(24),
            children: [
              title('Cores semânticas'),
              gap(18),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  for (final e in [
                    ('Azul-marinho', T.navy),
                    ('Destaque', T.blue),
                    ('Fundo', T.bg),
                    ('Texto', T.ink),
                    ('Secundário', T.muted),
                    ('Sucesso', T.green),
                    ('Erro', T.danger),
                  ])
                    SizedBox(
                      width: 130,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 55,
                            decoration: BoxDecoration(
                              color: e.$2,
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          gap(6),
                          txt(e.$1, size: 12),
                        ],
                      ),
                    ),
                ],
              ),
              gap(28),
              title('Tipografia • Roboto'),
              gap(),
              txt('Display 35 / 800', size: 35, weight: FontWeight.w800),
              gap(),
              title('Título 18 / 800'),
              gap(),
              txt('Texto 14 / 400'),
              gap(),
              txt('LEGENDA 10 / 700', size: 10, weight: FontWeight.w700),
              gap(28),
              title('Espaçamento'),
              txt('4 • 8 • 12 • 16 • 24 • 32'),
              gap(20),
              title('Raios'),
              txt('16 campos • 22 cartões • 26 métrica'),
            ],
          ),
          ListView(
            padding: const EdgeInsets.all(24),
            children: [
              AppButton(
                'Ação ($count)',
                onPressed: () => setState(() => count++),
              ),
              gap(),
              AppButton('Secundário', variant: 'secondary', onPressed: () {}),
              gap(),
              const AppButton('Desabilitado'),
              gap(),
              const AppButton('Carregando', loading: true),
              gap(),
              const AppField('Cliente', placeholder: 'Nome do cliente'),
              gap(),
              const AppField('Telefone', error: 'Informe telefone com DDD.'),
              gap(),
              const AppField('Senha', obscure: true),
              gap(),
              const Surface(
                child: ListTile(
                  leading: IconBox('building'),
                  title: Text('CommercialCard'),
                  subtitle: Text('Dados de demonstração'),
                ),
              ),
              gap(),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final s in [
                    'Rascunho',
                    'Enviado',
                    'Aprovado',
                    'Faturado',
                    'Entregue',
                    'Cancelado',
                  ])
                    AppStatus(s),
                ],
              ),
              gap(),
              const AppNote('Informações úteis sobre a ação.'),
            ],
          ),
          ListView(
            children: [
              const StateView(kind: 'loading', title: 'Carregando informações'),
              const StateView(
                title: 'Nenhum cliente cadastrado',
                message: 'Cadastre seu primeiro cliente.',
              ),
              StateView(
                kind: 'error',
                title: 'Não foi possível carregar',
                message: 'Tente novamente.',
                onRetry: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Nova tentativa simulada.')),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
