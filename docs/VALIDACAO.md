# Validação executada

Ambiente: Flutter 3.47.9, Dart 3.13.7, Linux.

- flutter analyze --no-pub: No issues found.
- flutter test --no-pub: 42 testes aprovados.
- 32 verificações de layout: as 16 cenas renderizadas em 390x844 e 320x844 sem exceção/overflow.
- 7 testes de dados: valores em centavos, credenciais inválidas, restauração/logout, validação de cliente, IDs e transições de pedido, visita e reversão quando armazenamento falha.
- 3 fluxos de widgets: cadastro/retorno à lista; pedido com validação, revisão, salvamento e envio; planejamento/retorno à agenda.
- flutter build web --release --no-pub --no-wasm-dry-run: concluído.
- flutter build web -t lib/main_sample.dart --output build/sample --release --no-pub --no-wasm-dry-run: concluído.
- 28 SVGs extraídos dos ícones JSX do projeto do Figma, todos verificados como XML válido.
- Imports locais, arquivos de cada cena e configurações JSON conferidos.
- Imagens Flutter de Login, Home, Clientes e Detalhes do pedido renderizadas e inspecionadas em qa_previews. As sombras dos testes podem diferir das sombras do renderizador real.

Não foram executados builds Android/iOS/macOS nem testes de Keychain/Keystore em aparelhos. Os testes de persistência usam o adaptador MemoryStorage; o app normal usa flutter_secure_storage. A revisão visual foi feita sobre imagens de widgets Flutter e o código/CSS do Figma; não houve comparação automatizada pixel a pixel com o navegador original. A compilação web mostrou aviso de fonte Cupertino da ferramenta; as telas usam SVGs próprios e MaterialIcons do SDK.

Nenhum teste de API remota foi feito, porque esta entrega é uma demonstração local e não implementa servidor. Metas/comissões são exemplos estáticos, sem apuração real. Persistência local não equivale a sincronização entre aparelhos ou autorização de produção.
