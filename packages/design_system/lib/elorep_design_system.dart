import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

abstract final class T {
  static const navy = Color(0xFF102A56),
      blue = Color(0xFF245EDB),
      bg = Color(0xFFF3F6FB),
      ink = Color(0xFF172B4D),
      muted = Color(0xFF62718A),
      line = Color(0xFFE3EAF4),
      soft = Color(0xFFEAF0FF),
      green = Color(0xFF18734C),
      greenSoft = Color(0xFFE8F5EF),
      danger = Color(0xFFB42335),
      dangerSoft = Color(0xFFFFF0F1),
      violet = Color(0xFF6347BD),
      violetSoft = Color(0xFFF1EDFF);
  static const spaces = [4.0, 8.0, 12.0, 16.0, 24.0, 32.0];
  static ThemeData theme() => ThemeData(
    useMaterial3: true,
    fontFamily: 'packages/elorep_design_system/Roboto',
    scaffoldBackgroundColor: bg,
    colorScheme: ColorScheme.fromSeed(seedColor: navy).copyWith(
      primary: navy,
      secondary: blue,
      surface: Colors.white,
      onSurface: ink,
      onSurfaceVariant: muted,
      outlineVariant: line,
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(fontSize: 14, color: ink),
      bodySmall: TextStyle(fontSize: 12, color: muted),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: line),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: line),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: blue, width: 2),
      ),
      hintStyle: const TextStyle(color: muted, fontSize: 13),
    ),
    dividerColor: line,
    snackBarTheme: SnackBarThemeData(
      backgroundColor: navy,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: ink,
      surfaceTintColor: Colors.transparent,
      centerTitle: true,
      elevation: 0,
      titleTextStyle: TextStyle(
        fontFamily: 'packages/elorep_design_system/Roboto',
        fontSize: 18,
        fontWeight: FontWeight.w800,
        color: ink,
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
    ),
  );
}

class EloIcon extends StatelessWidget {
  const EloIcon(this.name, {super.key, this.color = T.ink, this.size = 22});
  final String name;
  final Color color;
  final double size;
  @override
  Widget build(BuildContext context) => SizedBox(
    width: size,
    height: size,
    child: SvgPicture.asset(
      'assets/icons/$name.svg',
      package: 'elorep_design_system',
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    ),
  );
}

Widget txt(
  String s, {
  double size = 14,
  FontWeight weight = FontWeight.w400,
  Color color = T.ink,
  double? height,
  int? maxLines,
}) => Text(
  s,
  style: TextStyle(
    fontSize: size,
    fontWeight: weight,
    color: color,
    height: height,
  ),
  maxLines: maxLines,
  overflow: maxLines == null ? null : TextOverflow.ellipsis,
);
Widget title(String s) => txt(s, size: 18, weight: FontWeight.w800);
Widget gap([double n = 16]) => SizedBox(height: n);

class Surface extends StatelessWidget {
  const Surface({
    super.key,
    required this.child,
    this.padding = 16,
    this.color = Colors.white,
    this.radius = 22,
    this.border = true,
    this.shadow = false,
  });
  final Widget child;
  final double padding, radius;
  final Color color;
  final bool border, shadow;
  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.all(padding),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(radius),
      border: border ? Border.all(color: T.line) : null,
      boxShadow: shadow
          ? [
              BoxShadow(
                color: T.navy.withValues(alpha: .09),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ]
          : null,
    ),
    child: Material(type: MaterialType.transparency, child: child),
  );
}

class IconBox extends StatelessWidget {
  const IconBox(
    this.icon, {
    super.key,
    this.color = T.blue,
    this.background = T.soft,
    this.size = 40,
  });
  final String icon;
  final Color color, background;
  final double size;
  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: background,
      borderRadius: BorderRadius.circular(13),
    ),
    alignment: Alignment.center,
    child: EloIcon(icon, color: color),
  );
}

class AppButton extends StatelessWidget {
  const AppButton(
    this.label, {
    super.key,
    this.onPressed,
    this.icon,
    this.variant = 'primary',
    this.loading = false,
  });
  final String label, variant;
  final String? icon;
  final VoidCallback? onPressed;
  final bool loading;
  @override
  Widget build(BuildContext context) {
    final color = variant == 'primary'
        ? Colors.white
        : variant == 'danger'
        ? T.danger
        : T.navy;
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: loading ? null : onPressed,
        style: TextButton.styleFrom(
          minimumSize: const Size(48, 52),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          backgroundColor: variant == 'primary'
              ? (onPressed == null ? T.navy.withValues(alpha: .35) : T.navy)
              : variant == 'danger'
              ? T.dangerSoft
              : variant == 'secondary'
              ? Colors.white
              : Colors.transparent,
          foregroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: variant == 'secondary'
                ? const BorderSide(color: T.line)
                : BorderSide.none,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (loading)
              const SizedBox.square(
                dimension: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            else if (icon != null)
              EloIcon(icon!, color: color, size: 20),
            if (icon != null || loading) const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: onPressed == null && !loading
                      ? color.withValues(alpha: .5)
                      : color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AppField extends StatelessWidget {
  const AppField(
    this.label, {
    super.key,
    this.value = '',
    this.onChanged,
    this.placeholder,
    this.error,
    this.optional = false,
    this.obscure = false,
    this.suffix,
    this.prefix,
    this.lines = 1,
    this.keyboard,
    this.readOnly = false,
    this.onTap,
  });
  final String label, value;
  final ValueChanged<String>? onChanged;
  final String? placeholder, error, prefix;
  final bool optional, obscure, readOnly;
  final Widget? suffix;
  final int lines;
  final TextInputType? keyboard;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Expanded(child: txt(label, size: 13, weight: FontWeight.w700)),
          if (optional) txt('Opcional', size: 10, color: T.muted),
        ],
      ),
      gap(7),
      TextFormField(
        initialValue: value,
        onChanged: onChanged,
        readOnly: readOnly,
        onTap: onTap,
        obscureText: obscure,
        maxLines: lines,
        keyboardType: keyboard,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          hintText: placeholder,
          errorText: error,
          suffixIcon: suffix,
          prefixText: prefix,
        ),
      ),
    ],
  );
}

class AppSelect extends StatelessWidget {
  const AppSelect(
    this.label, {
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
  });
  final String label;
  final String? value;
  final Map<String, String> items;
  final ValueChanged<String?> onChanged;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      txt(label, size: 13, weight: FontWeight.w700),
      gap(7),
      DropdownButtonFormField<String>(
        initialValue: value,
        isExpanded: true,
        items: [
          for (final e in items.entries)
            DropdownMenuItem(
              value: e.key,
              child: Text(
                e.value,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 13),
              ),
            ),
        ],
        onChanged: onChanged,
      ),
    ],
  );
}

class AppStatus extends StatelessWidget {
  const AppStatus(this.label, {super.key});
  final String label;
  @override
  Widget build(BuildContext context) {
    final color = ['Faturado', 'Entregue', 'Concluída'].contains(label)
        ? T.green
        : label == 'Cancelado' || label == 'Cancelada'
        ? T.danger
        : label == 'Aprovado'
        ? T.violet
        : label == 'Enviado' || label == 'Planejada'
        ? T.blue
        : T.muted;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .09),
        borderRadius: BorderRadius.circular(8),
      ),
      child: txt(label, size: 10, weight: FontWeight.w700, color: color),
    );
  }
}

class AppNote extends StatelessWidget {
  const AppNote(this.text, {super.key});
  final String text;
  @override
  Widget build(BuildContext context) => Surface(
    radius: 14,
    padding: 12,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const EloIcon('info', color: T.muted, size: 18),
        const SizedBox(width: 9),
        Expanded(child: txt(text, size: 11, color: T.muted, height: 1.45)),
      ],
    ),
  );
}

class StateView extends StatelessWidget {
  const StateView({
    super.key,
    this.kind = 'empty',
    required this.title,
    this.message = '',
    this.onRetry,
  });
  final String kind, title, message;
  final VoidCallback? onRetry;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (kind == 'loading')
          const CircularProgressIndicator()
        else
          IconBox(
            kind == 'error' ? 'error' : 'folder',
            color: kind == 'error' ? T.danger : T.blue,
            background: kind == 'error' ? T.dangerSoft : T.soft,
            size: 56,
          ),
        gap(),
        txt(title, weight: FontWeight.w700),
        gap(8),
        txt(message, size: 13, color: T.muted, height: 1.5),
        if (onRetry != null) ...[
          gap(),
          AppButton(
            'Tentar novamente',
            variant: 'secondary',
            icon: 'refresh',
            onPressed: onRetry,
          ),
        ],
      ],
    ),
  );
}

class Initials extends StatelessWidget {
  const Initials(this.name, {super.key, this.index = 0, this.size = 43});
  final String name;
  final int index;
  final double size;
  @override
  Widget build(BuildContext context) {
    final colors = [T.blue, T.green, T.violet, const Color(0xFFA55E00)];
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: colors[index % 4].withValues(alpha: .09),
        borderRadius: BorderRadius.circular(14),
      ),
      alignment: Alignment.center,
      child: txt(
        name
            .split(' ')
            .where((s) => s.isNotEmpty)
            .take(2)
            .map((s) => s[0])
            .join(),
        weight: FontWeight.w800,
        color: colors[index % 4],
      ),
    );
  }
}
