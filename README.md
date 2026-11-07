# EloRep - telas do Figma em Flutter

Novo projeto Flutter baseado no ZIP **Protótipos do App EloRep**, enviado pela Mari. Esta implementação usa o visual e os fluxos desse arquivo como referência, sem reaproveitar as telas antigas do app de representantes.

## Abrir no Mac / VS Code
Descompacte o ZIP e abra **a pasta EloRep_Flutter_Figma**, onde está `pubspec.yaml`. Este projeto não possui outra pasta `flutter` dentro: o terminal deve estar nesta própria pasta.

```bash
flutter pub get
flutter run -d chrome --web-port=7357
```

SDK validado: Flutter 3.47.9 / Dart 3.13.7. Requer Dart >=3.13.0. Se sua instalação for anterior, atualize o Flutter antes de executar.

**Conta local de demonstração:** `mariana@elorep.demo` / `123456`.

Não é preciso iniciar uma API. Esta entrega implementa o aplicativo e sua demonstração local; não possui autenticação HTTP nem backend em produção. Não use dados comerciais reais.

## O que está implementado
16 telas: Login, Home, Clientes, Novo/Editar cliente, Detalhes do cliente, Pasta da representada, Pedidos, Novo pedido, Revisão do pedido, Detalhes do pedido, Visitas, Planejar visita, Representadas, Detalhes da representada, Metas e comissões e Carteira por cidade.

Busca de clientes e representadas; filtros por cidade, representada e status; cadastro/edição de clientes com validação; edição dos vínculos; histórico filtrado pelo cliente e representada corretos; criação de pedido com revisão; status com confirmação e histórico; planejamento e conclusão/cancelamento de visitas; escolha de data e horário; restauração da sessão demonstrativa e logout.

Dados da demonstração são salvos por um adaptador flutter_secure_storage, incluindo os registros e a sessão local. Senha não é armazenada. No Chrome, mantenha o endereço e a porta para usar o mesmo armazenamento. Limpar os dados do navegador, usar janela anônima ou mudar de origem/porta pode iniciar outra demonstração. O comportamento do Keychain/Keystore em dispositivos nativos não foi validado nesta sessão.

## Design System / Sample App

```bash
flutter run -d chrome -t lib/main_sample.dart --web-port=7358
```

Catálogo de tokens, tipografia, espaçamentos, componentes e estados. Cor azul-marinho #102A56; destaque #245EDB; fundo #F3F6FB; Roboto incluída localmente com licença OFL. Os 28 ícones SVG preservam a geometria dos ícones definidos no código React do Figma. O painel lateral de handoff do Figma é documentação de design; não é apresentado como uma tela comercial do celular.

## Estrutura da aula
- `packages/core`: dados e regras em Dart puro; Result, armazenamento por interface, repositório e validações.
- `packages/design_system`: tokens, tema, SVGs e widgets compartilhados.
- `lib/scenes`: 16 cenas com View, ViewModel, Factory, Server e Coordinator.
- `lib/shared`: ciclo de vida, comportamento comum, navegação visual e componentes de composição.
- `lib/data`: implementação do armazenamento seguro da demonstração.
- `test`: testes de regras, layouts e fluxos de cadastro/pedido/visita.
- `qa_previews`: imagens renderizadas pelo Flutter durante os testes.

Views exibem estado e chamam ViewModels; ViewModels delegam operações aos Servers; Servers chamam o repositório Core. Coordinators controlam a navegação. Factories montam as dependências. Componentes e comportamento comum são compartilhados para evitar cópias entre cenas.

## Diferenças funcionais em relação ao protótipo
No Figma vários detalhes são fixos e botões só demonstram uma ação. Aqui detalhes, pedidos, pastas e visitas usam o registro selecionado. A Home apresenta as quantidades da base local, em vez do número decorativo “24”. Não há mapa ou rastreamento. Metas e comissões mantêm exemplos ilustrativos do design e não são apuração real nem se recalculam pelos novos pedidos. A agenda começa na semana dos exemplos de junho de 2025; use as setas ou “Ir para a semana atual”.

Layouts se adaptam ao tamanho disponível; no navegador de computador o aplicativo fica centralizado com largura máxima de 430 px. Não há moldura decorativa de celular no aplicativo nativo.

## Verificações
Consulte `docs/VALIDACAO.md`. Para executar os testes:

```bash
flutter analyze
flutter test
```
