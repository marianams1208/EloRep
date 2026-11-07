import 'package:flutter/material.dart';
import 'package:elorep_design_system/elorep_design_system.dart';

import '../../shared/scene_host.dart';
import 'login_view_model.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key, required this.viewModel});
  final LoginViewModel viewModel;
  @override
  Widget build(BuildContext context) => SceneHost(
    model: viewModel,
    back: true,
    builder: (context, m) {
      return page([
        Row(
          children: [
            Transform.rotate(
              angle: -.087,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: T.navy,
                  borderRadius: BorderRadius.circular(13),
                ),
                alignment: Alignment.center,
                child: Transform.rotate(
                  angle: .087,
                  child: txt(
                    'E',
                    size: 24,
                    weight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            RichText(
              text: const TextSpan(
                style: TextStyle(
                  fontFamily: 'packages/elorep_design_system/Roboto',
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -.8,
                ),
                children: [
                  TextSpan(
                    text: 'Elo',
                    style: TextStyle(color: T.navy),
                  ),
                  TextSpan(
                    text: 'Rep',
                    style: TextStyle(color: T.blue),
                  ),
                ],
              ),
            ),
          ],
        ),
        gap(42),
        txt(
          'GESTÃO COMERCIAL SIMPLES',
          size: 10,
          weight: FontWeight.w800,
          color: T.blue,
        ),
        gap(10),
        RichText(
          text: const TextSpan(
            style: TextStyle(
              fontFamily: 'packages/elorep_design_system/Roboto',
              fontSize: 35,
              height: 1.08,
              letterSpacing: -1.2,
              fontWeight: FontWeight.w800,
              color: T.navy,
            ),
            children: [
              TextSpan(text: 'Sua carteira,\n'),
              TextSpan(
                text: 'mais perto',
                style: TextStyle(color: T.blue),
              ),
              TextSpan(text: ' de você.'),
            ],
          ),
        ),
        gap(14),
        txt(
          'Clientes, pedidos e visitas organizados para o seu dia render mais.',
          size: 14,
          height: 1.5,
          color: T.muted,
        ),
        gap(32),
        Surface(
          padding: 18,
          radius: 24,
          border: false,
          shadow: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              title('Boas-vindas'),
              gap(5),
              txt('Acesse sua conta para continuar.', size: 13, color: T.muted),
              gap(20),
              AppField(
                'E-mail',
                value: m.value('email'),
                keyboard: TextInputType.emailAddress,
                onChanged: (v) => m.setField('email', v),
              ),
              gap(16),
              AppField(
                'Senha',
                value: m.value('password'),
                obscure: !m.showPassword,
                onChanged: (v) => m.setField('password', v),
                suffix: IconButton(
                  tooltip: 'Mostrar ou ocultar senha',
                  onPressed: () {
                    m.showPassword = !m.showPassword;
                    m.changed();
                  },
                  icon: EloIcon(
                    m.showPassword ? 'eyeOff' : 'eye',
                    size: 20,
                    color: T.muted,
                  ),
                ),
              ),
              gap(20),
              AppButton('Entrar', loading: m.busy, onPressed: m.login),
              gap(14),
              Center(
                child: txt(
                  'Ambiente de demonstração • Dados fictícios',
                  size: 11,
                  color: T.muted,
                ),
              ),
            ],
          ),
        ),
        gap(18),
      ], padding: 22);
    },
  );
}
