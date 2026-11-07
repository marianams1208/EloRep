# Referência e telas

Referência: ZIP exportado do Figma Make, arquivo zfmZ1Pl5b9lDGW9OvjXquj, especialmente src/App.tsx e src/index.css. Implementação Flutter nova.

| Estado no Figma | Cena Flutter |
|---|---|
| login | lib/scenes/login |
| home | lib/scenes/home |
| clients | lib/scenes/clients |
| clientForm | lib/scenes/client_form |
| clientDetail | lib/scenes/client_detail |
| repFolder | lib/scenes/rep_folder |
| orders | lib/scenes/orders |
| orderForm | lib/scenes/order_form |
| orderReview | lib/scenes/order_review |
| orderDetail | lib/scenes/order_detail |
| visits | lib/scenes/visits |
| visitForm | lib/scenes/visit_form |
| reps | lib/scenes/reps |
| repDetail | lib/scenes/rep_detail |
| goals | lib/scenes/goals |
| cities | lib/scenes/cities |

Paleta, tipografia, raios e ícones seguem o código do Figma. A renderização Flutter é adaptativa; não usa WebView nem coloca uma imagem da tela como interface.

Os componentes de UI ficam em packages/design_system. Os padrões visuais compostos de pedido e formulários ficam em lib/shared, consumindo os componentes do pacote. O Core não importa Flutter.

O aplicativo funciona como demonstração local. Integração HTTP, servidor, apuração comercial real, sincronização entre dispositivos e publicação nas lojas não fazem parte desta entrega.
