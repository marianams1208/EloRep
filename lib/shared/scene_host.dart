import 'package:flutter/material.dart';
import 'package:elorep_design_system/elorep_design_system.dart';

import 'scene_view_model.dart';

class SceneHost extends StatefulWidget {
  const SceneHost({
    super.key,
    required this.model,
    required this.builder,
    this.title,
    this.titleBuilder,
    this.active,
    this.action,
    this.fab,
    this.back = true,
  });
  final SceneViewModel model;
  final Widget Function(BuildContext, SceneViewModel) builder;
  final String? title, active;
  final String Function()? titleBuilder;
  final Widget? action;
  final VoidCallback? fab;
  final bool back;
  @override
  State<SceneHost> createState() => _SceneHostState();
}

class _SceneHostState extends State<SceneHost> {
  @override
  void dispose() {
    widget.model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: widget.model,
    builder: (context, _) {
      final m = widget.model;
      return Scaffold(
        appBar: widget.title == null && widget.titleBuilder == null
            ? null
            : AppBar(
                title: Text(widget.titleBuilder?.call() ?? widget.title!),
                leading: widget.back
                    ? IconButton(
                        tooltip: 'Voltar',
                        onPressed: m.back,
                        icon: const EloIcon('arrowLeft'),
                      )
                    : const SizedBox.shrink(),
                actions: [if (widget.action != null) widget.action!],
                bottom: const PreferredSize(
                  preferredSize: Size.fromHeight(1),
                  child: Divider(height: 1, color: T.line),
                ),
              ),
        body: SafeArea(
          top: widget.title == null,
          child: Column(
            children: [
              if (m.busy && m.data != null)
                const LinearProgressIndicator(minHeight: 2),
              if (m.error != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  color: T.dangerSoft,
                  child: Row(
                    children: [
                      const EloIcon('error', color: T.danger, size: 18),
                      const SizedBox(width: 8),
                      Expanded(child: txt(m.error!, size: 12, color: T.danger)),
                      if (m.data == null && widget.title != 'Login')
                        TextButton(
                          onPressed: m.load,
                          child: const Text('Tentar novamente'),
                        ),
                    ],
                  ),
                ),
              Expanded(child: widget.builder(context, m)),
            ],
          ),
        ),
        floatingActionButton: widget.fab == null
            ? null
            : FloatingActionButton(
                tooltip: 'Novo registro',
                backgroundColor: T.blue,
                foregroundColor: Colors.white,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                onPressed: widget.fab,
                child: const EloIcon('plus', color: Colors.white),
              ),
        bottomNavigationBar: widget.active == null
            ? null
            : SafeArea(
                top: false,
                child: Container(
                  height: 72,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(top: BorderSide(color: T.line)),
                  ),
                  child: Row(
                    children: [
                      for (final item in const [
                        ('home', 'home', 'Início'),
                        ('clients', 'users', 'Clientes'),
                        ('orders', 'receipt', 'Pedidos'),
                        ('visits', 'calendar', 'Visitas'),
                      ])
                        Expanded(
                          child: Semantics(
                            selected: widget.active == item.$1,
                            child: InkWell(
                              onTap: () => widget.active == item.$1
                                  ? null
                                  : m.coordinator.root(item.$1),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 22,
                                    height: 3,
                                    decoration: BoxDecoration(
                                      color: widget.active == item.$1
                                          ? T.blue
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                  ),
                                  gap(9),
                                  EloIcon(
                                    item.$2,
                                    color: widget.active == item.$1
                                        ? T.blue
                                        : T.muted,
                                  ),
                                  gap(4),
                                  txt(
                                    item.$3,
                                    size: 10,
                                    weight: FontWeight.w600,
                                    color: widget.active == item.$1
                                        ? T.blue
                                        : T.muted,
                                  ),
                                  gap(7),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
      );
    },
  );
}

class SceneAssembly extends StatefulWidget {
  const SceneAssembly({super.key, required this.builder});
  final WidgetBuilder builder;
  @override
  State<SceneAssembly> createState() => _SceneAssemblyState();
}

class _SceneAssemblyState extends State<SceneAssembly> {
  Widget? child;
  @override
  Widget build(BuildContext context) => child ??= widget.builder(context);
}

Widget page(List<Widget> children, {double padding = 16}) => ListView(
  padding: EdgeInsets.fromLTRB(padding, 18, padding, 32),
  children: children,
);
Widget space(Widget child, {double bottom = 16}) => Padding(
  padding: EdgeInsets.only(bottom: bottom),
  child: child,
);
Widget meta(String left, String right) => Padding(
  padding: const EdgeInsets.symmetric(vertical: 16),
  child: Row(
    children: [
      Expanded(child: txt(left, size: 14, weight: FontWeight.w700)),
      txt(right, size: 10, color: T.muted),
    ],
  ),
);
Widget searchBox(String hint, ValueChanged<String> changed) => TextField(
  onChanged: changed,
  decoration: InputDecoration(
    hintText: hint,
    prefixIcon: const Padding(
      padding: EdgeInsets.all(14),
      child: EloIcon('search', color: T.muted, size: 20),
    ),
  ),
);
Widget linkRow(String icon, String label, String subtitle, VoidCallback tap) =>
    InkWell(
      onTap: tap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            IconBox(icon, color: T.navy, background: T.bg, size: 38),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  txt(label, weight: FontWeight.w700),
                  gap(3),
                  txt(subtitle, size: 11, color: T.muted),
                ],
              ),
            ),
            const EloIcon('chevron', color: T.muted, size: 19),
          ],
        ),
      ),
    );
Widget detailRows(List<(String, String)> rows) => Surface(
  child: Column(
    children: [
      for (var i = 0; i < rows.length; i++) ...[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: txt(rows[i].$1, size: 12, color: T.muted)),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: Text(
                  rows[i].$2,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (i < rows.length - 1) const Divider(height: 1, color: T.line),
      ],
    ],
  ),
);
Future<bool> confirmAction(
  BuildContext context,
  String title,
  String body,
) async =>
    await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c, false),
            child: const Text('Voltar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(c, true),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    ) ??
    false;
