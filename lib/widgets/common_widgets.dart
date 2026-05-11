import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../core/app_theme.dart';

/* ────────────────────────────────────────────────────────────────────
   App shells & headers
   ──────────────────────────────────────────────────────────────────── */

class AppShell extends StatelessWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final bool showBack;
  final bool greenHeader;
  final EdgeInsetsGeometry padding;

  const AppShell({
    super.key,
    required this.title,
    required this.body,
    this.actions,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.showBack = true,
    this.greenHeader = true,
    this.padding = const EdgeInsets.fromLTRB(16, 14, 16, 0),
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      extendBodyBehindAppBar: false,
      appBar: greenHeader
          ? PreferredSize(
              preferredSize: const Size.fromHeight(64),
              child: Container(
                decoration: const BoxDecoration(gradient: AppColors.headerGradient),
                child: AppBar(
                  title: Text(title),
                  actions: actions,
                  automaticallyImplyLeading: showBack,
                  backgroundColor: Colors.transparent,
                  iconTheme: const IconThemeData(color: Colors.white),
                ),
              ),
            )
          : AppBar(
              title: Text(title, style: const TextStyle(color: AppColors.text)),
              actions: actions,
              automaticallyImplyLeading: showBack,
              iconTheme: const IconThemeData(color: AppColors.text),
              backgroundColor: AppColors.background,
            ),
      body: SafeArea(
        top: false,
        child: Padding(padding: padding, child: body),
      ),
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}

class GreenHeaderScaffold extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? headerExtra;
  final List<Widget>? actions;
  final bool showBack;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;

  const GreenHeaderScaffold({
    super.key,
    required this.title,
    required this.child,
    this.headerExtra,
    this.actions,
    this.showBack = true,
    this.bottomNavigationBar,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(gradient: AppColors.headerGradient),
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  SizedBox(
                    height: 56,
                    child: Row(
                      children: [
                        if (showBack)
                          IconButton(
                            onPressed: () => Navigator.maybePop(context),
                            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                          )
                        else
                          const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18),
                          ),
                        ),
                        if (actions != null) ...actions! else const SizedBox(width: 48),
                      ],
                    ),
                  ),
                  if (headerExtra != null)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: headerExtra,
                    ),
                ],
              ),
            ),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}

/* ────────────────────────────────────────────────────────────────────
   Role-aware top brand bar (logo + bell)
   ──────────────────────────────────────────────────────────────────── */

class RoleTopBar extends StatelessWidget {
  final String title;
  final VoidCallback? onNotifications;
  final VoidCallback? onMenu;
  const RoleTopBar({super.key, required this.title, this.onNotifications, this.onMenu});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
      decoration: const BoxDecoration(gradient: AppColors.headerGradient),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            IconButton(
              onPressed: onMenu,
              icon: const Icon(Icons.menu_rounded, color: Colors.white),
            ),
            const Spacer(),
            Row(
              children: [
                Text(title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                    )),
                const SizedBox(width: 8),
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: .12),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.accentGold, width: 1.4),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(Icons.mosque_rounded, color: AppColors.accentGold, size: 20),
                ),
              ],
            ),
            const Spacer(),
            IconButton(
              onPressed: onNotifications,
              icon: const Icon(Icons.notifications_none_rounded, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

/* ────────────────────────────────────────────────────────────────────
   Section titles
   ──────────────────────────────────────────────────────────────────── */

class AppSectionTitle extends StatelessWidget {
  final String title;
  final String? action;
  final IconData? icon;
  final VoidCallback? onTap;
  const AppSectionTitle({super.key, required this.title, this.action, this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (icon != null) ...[
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(width: 6),
        ],
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        const Spacer(),
        if (action != null)
          TextButton(
            onPressed: onTap,
            child: Row(children: [
              Text(action!),
              const Icon(Icons.chevron_left_rounded, size: 18, color: AppColors.primary),
            ]),
          ),
      ],
    );
  }
}

/* ────────────────────────────────────────────────────────────────────
   Cards & tiles
   ──────────────────────────────────────────────────────────────────── */

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Color? color;
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(14),
    this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final card = Container(
      decoration: BoxDecoration(
        color: color ?? AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border, width: 0.6),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: padding,
      child: child,
    );
    if (onTap == null) return card;
    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      onTap: onTap,
      child: card,
    );
  }
}

class KpiCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final String? sub;
  final VoidCallback? onTap;
  const KpiCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.color = AppColors.primary,
    this.sub,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: .12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              const Spacer(),
              if (sub != null)
                Text(sub!, style: const TextStyle(fontSize: 11, color: AppColors.muted, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 10),
          Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.text)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 12.5, color: AppColors.muted, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class KpiGrid extends StatelessWidget {
  final List<Widget> items;
  final int crossAxisCount;
  final double aspect;
  const KpiGrid({super.key, required this.items, this.crossAxisCount = 2, this.aspect = 1.45});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: crossAxisCount,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: aspect,
      children: items,
    );
  }
}

class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;
  const StatCard({super.key, required this.label, required this.value, this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AppCard(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: color ?? AppColors.text)),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(color: AppColors.muted, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

class InfoTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;
  final Widget? trailing;
  const InfoTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.color = AppColors.primary,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(12),
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: .12),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(color: AppColors.muted, fontSize: 12.5)),
              ],
            ),
          ),
          trailing ?? const Icon(Icons.chevron_left_rounded, color: AppColors.muted),
        ],
      ),
    );
  }
}

class ScreenMenuCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final String route;
  const ScreenMenuCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    return InfoTile(
      title: title,
      subtitle: subtitle,
      icon: icon,
      onTap: () => Navigator.pushNamed(context, route),
    );
  }
}

/* ────────────────────────────────────────────────────────────────────
   Progress ring (donut)
   ──────────────────────────────────────────────────────────────────── */

class ProgressRing extends StatelessWidget {
  final double value; // 0..1
  final double size;
  final double strokeWidth;
  final Color color;
  final Color trackColor;
  final Widget? center;
  final String? label;
  const ProgressRing({
    super.key,
    required this.value,
    this.size = 90,
    this.strokeWidth = 10,
    this.color = AppColors.primary,
    this.trackColor = const Color(0xFFEFE6D5),
    this.center,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _RingPainter(value: value.clamp(0, 1), color: color, track: trackColor, stroke: strokeWidth),
        child: Center(
          child: center ??
              Text(
                label ?? '${(value.clamp(0, 1) * 100).round()}%',
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: AppColors.text),
              ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double value;
  final Color color;
  final Color track;
  final double stroke;
  _RingPainter({required this.value, required this.color, required this.track, required this.stroke});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - stroke / 2;

    final trackPaint = Paint()
      ..color = track
      ..strokeWidth = stroke
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final valuePaint = Paint()
      ..color = color
      ..strokeWidth = stroke
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);
    final sweep = 2 * math.pi * value;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweep,
      false,
      valuePaint,
    );
  }

  @override
  bool shouldRepaint(covariant _RingPainter old) =>
      old.value != value || old.color != color || old.track != track || old.stroke != stroke;
}

class ProgressCard extends StatelessWidget {
  final String title;
  final double value;
  final String footer;
  const ProgressCard({super.key, required this.title, required this.value, required this.footer});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          Row(
            children: [
              ProgressRing(value: value, size: 78, strokeWidth: 9),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(footer, style: const TextStyle(color: AppColors.muted)),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: LinearProgressIndicator(value: value, minHeight: 8),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/* ────────────────────────────────────────────────────────────────────
   Status badges & chips
   ──────────────────────────────────────────────────────────────────── */

enum BadgeKind { success, warning, danger, info, neutral, gold }

class StatusBadge extends StatelessWidget {
  final String text;
  final BadgeKind kind;
  final IconData? icon;
  const StatusBadge({super.key, required this.text, this.kind = BadgeKind.neutral, this.icon});

  @override
  Widget build(BuildContext context) {
    final c = badgeColor(kind);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: c.withValues(alpha: .14),
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: c.withValues(alpha: .35), width: 0.8),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        if (icon != null) ...[
          Icon(icon, size: 13, color: c),
          const SizedBox(width: 4),
        ],
        Text(text, style: TextStyle(color: c, fontWeight: FontWeight.w800, fontSize: 11.5)),
      ]),
    );
  }

}

Color badgeColor(BadgeKind k) {
  switch (k) {
    case BadgeKind.success:
      return AppColors.success;
    case BadgeKind.warning:
      return AppColors.warning;
    case BadgeKind.danger:
      return AppColors.danger;
    case BadgeKind.info:
      return AppColors.info;
    case BadgeKind.gold:
      return AppColors.accentGold;
    case BadgeKind.neutral:
      return AppColors.muted;
  }
}

class FilterChipsBar extends StatelessWidget {
  final List<String> items;
  final int selected;
  final ValueChanged<int> onChanged;
  const FilterChipsBar({super.key, required this.items, required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, i) {
          final active = i == selected;
          return ChoiceChip(
            label: Text(items[i]),
            selected: active,
            onSelected: (_) => onChanged(i),
            selectedColor: AppColors.primary,
            labelStyle: TextStyle(
              color: active ? Colors.white : AppColors.text,
              fontWeight: FontWeight.w700,
            ),
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.pill),
              side: BorderSide(color: active ? AppColors.primary : AppColors.border),
            ),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemCount: items.length,
      ),
    );
  }
}

class SearchFilterBar extends StatelessWidget {
  final String hint;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onFilter;
  const SearchFilterBar({super.key, this.hint = 'بحث', this.onChanged, this.onFilter});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            onChanged: onChanged,
            decoration: InputDecoration(
              hintText: hint,
              prefixIcon: const Icon(Icons.search_rounded, color: AppColors.muted),
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
            ),
          ),
        ),
        const SizedBox(width: 10),
        InkWell(
          onTap: onFilter,
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: const Icon(Icons.tune_rounded, color: Colors.white),
          ),
        ),
      ],
    );
  }
}

/* ────────────────────────────────────────────────────────────────────
   Profile header (avatar + name + role)
   ──────────────────────────────────────────────────────────────────── */

class RoleDashboardHeader extends StatelessWidget {
  final String name;
  final String role;
  final String? avatarAsset;
  final IconData fallback;
  final VoidCallback? onTap;
  const RoleDashboardHeader({
    super.key,
    required this.name,
    required this.role,
    this.avatarAsset,
    this.fallback = Icons.person_rounded,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: .1),
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.accentGold, width: 1.5),
            ),
            alignment: Alignment.center,
            child: Icon(fallback, color: AppColors.primary, size: 28),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(role, style: const TextStyle(color: AppColors.muted, fontSize: 12)),
                const SizedBox(height: 2),
                Text(name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
              ],
            ),
          ),
          const Icon(Icons.chevron_left_rounded, color: AppColors.muted),
        ],
      ),
    );
  }
}

/* ────────────────────────────────────────────────────────────────────
   List item cards (center / circle / teacher / visit / report etc.)
   ──────────────────────────────────────────────────────────────────── */

class EntityListCard extends StatelessWidget {
  final IconData leading;
  final Color leadingColor;
  final String title;
  final String subtitle;
  final String? trailingText;
  final BadgeKind? badgeKind;
  final String? badgeText;
  final VoidCallback? onTap;
  const EntityListCard({
    super.key,
    required this.leading,
    this.leadingColor = AppColors.primary,
    required this.title,
    required this.subtitle,
    this.trailingText,
    this.badgeKind,
    this.badgeText,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: leadingColor.withValues(alpha: .12),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Icon(leading, color: leadingColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                Text(subtitle,
                    style: const TextStyle(color: AppColors.muted, fontSize: 12.5),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (badgeText != null)
                StatusBadge(text: badgeText!, kind: badgeKind ?? BadgeKind.neutral)
              else
                const Icon(Icons.chevron_left_rounded, color: AppColors.muted),
              if (trailingText != null) ...[
                const SizedBox(height: 4),
                Text(trailingText!, style: const TextStyle(color: AppColors.muted, fontSize: 11)),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class PersonCard extends StatelessWidget {
  final String name;
  final String subtitle;
  final IconData icon;
  final String? badgeText;
  final BadgeKind? badgeKind;
  final VoidCallback? onTap;
  const PersonCard({
    super.key,
    required this.name,
    required this.subtitle,
    this.icon = Icons.person_rounded,
    this.badgeText,
    this.badgeKind,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.accentGold.withValues(alpha: .18),
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.accentGold, width: 1.2),
            ),
            alignment: Alignment.center,
            child: const Icon(Icons.person_rounded, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 3),
                Text(subtitle, style: const TextStyle(color: AppColors.muted, fontSize: 12.5)),
              ],
            ),
          ),
          if (badgeText != null) StatusBadge(text: badgeText!, kind: badgeKind ?? BadgeKind.neutral),
        ],
      ),
    );
  }
}

/* ────────────────────────────────────────────────────────────────────
   Rating selector & score input row
   ──────────────────────────────────────────────────────────────────── */

class RatingSelector extends StatelessWidget {
  final int max;
  final int value;
  final ValueChanged<int> onChanged;
  const RatingSelector({super.key, this.max = 10, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: List.generate(max, (i) {
        final n = i + 1;
        final active = n <= value;
        return InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => onChanged(n),
          child: Container(
            width: 30,
            height: 30,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: active ? AppColors.primary : Colors.white,
              border: Border.all(color: active ? AppColors.primary : AppColors.border),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text('$n',
                style: TextStyle(
                  color: active ? Colors.white : AppColors.text,
                  fontWeight: FontWeight.w800,
                  fontSize: 12.5,
                )),
          ),
        );
      }),
    );
  }
}

class StarRating extends StatelessWidget {
  final double value;
  final double size;
  final int max;
  const StarRating({super.key, required this.value, this.size = 18, this.max = 5});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(max, (i) {
        final filled = i < value.round();
        return Icon(
          filled ? Icons.star_rounded : Icons.star_border_rounded,
          color: AppColors.accentGold,
          size: size,
        );
      }),
    );
  }
}

class ScoreInputRow extends StatelessWidget {
  final String label;
  final int max;
  final int value;
  final ValueChanged<int> onChanged;
  const ScoreInputRow({super.key, required this.label, required this.max, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w700))),
          SizedBox(
            width: 110,
            child: TextField(
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              controller: TextEditingController(text: value > 0 ? '$value' : ''),
              decoration: InputDecoration(
                hintText: '0 / $max',
                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                fillColor: Colors.white,
              ),
              onSubmitted: (s) {
                final v = int.tryParse(s) ?? 0;
                onChanged(v.clamp(0, max));
              },
            ),
          ),
        ],
      ),
    );
  }
}

/* ────────────────────────────────────────────────────────────────────
   Bottom action bars
   ──────────────────────────────────────────────────────────────────── */

class PrimaryBottomButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;
  final IconData? icon;
  const PrimaryBottomButton({super.key, required this.title, this.onPressed, this.icon});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: ElevatedButton.icon(
        onPressed: onPressed ?? () {},
        icon: icon != null ? Icon(icon, color: Colors.white) : const SizedBox.shrink(),
        label: Text(title),
      ),
    );
  }
}

class DraftSubmitBar extends StatelessWidget {
  final VoidCallback? onDraft;
  final VoidCallback? onSubmit;
  final String draftLabel;
  final String submitLabel;
  const DraftSubmitBar({
    super.key,
    this.onDraft,
    this.onSubmit,
    this.draftLabel = 'حفظ مسودة',
    this.submitLabel = 'إرسال',
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: onDraft,
              child: Text(draftLabel),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: onSubmit,
              child: Text(submitLabel),
            ),
          ),
        ],
      ),
    );
  }
}

class ApprovalActionBar extends StatelessWidget {
  final VoidCallback? onApprove;
  final VoidCallback? onReturn;
  const ApprovalActionBar({super.key, this.onApprove, this.onReturn});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Row(children: [
        Expanded(
          child: OutlinedButton.icon(
            icon: const Icon(Icons.replay_rounded, color: AppColors.warning),
            label: const Text('إرجاع', style: TextStyle(color: AppColors.warning)),
            style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.warning)),
            onPressed: onReturn,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 2,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.check_circle_rounded, color: Colors.white),
            label: const Text('اعتماد'),
            onPressed: onApprove,
          ),
        ),
      ]),
    );
  }
}

/* ────────────────────────────────────────────────────────────────────
   Empty / Error / Loading
   ──────────────────────────────────────────────────────────────────── */

class AppEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  const AppEmptyState({super.key, this.icon = Icons.inbox_outlined, required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: .08),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.primary, size: 36),
            ),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
            if (subtitle != null) ...[
              const SizedBox(height: 6),
              Text(subtitle!, style: const TextStyle(color: AppColors.muted), textAlign: TextAlign.center),
            ],
          ],
        ),
      ),
    );
  }
}

class AppErrorState extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  const AppErrorState({super.key, required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline_rounded, size: 40, color: AppColors.danger),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.text)),
            if (onRetry != null) ...[
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded, color: Colors.white),
                label: const Text('إعادة المحاولة'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/* ────────────────────────────────────────────────────────────────────
   Login inputs
   ──────────────────────────────────────────────────────────────────── */

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool obscureText;
  final TextInputType keyboardType;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.primary),
        fillColor: Colors.white,
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      child: isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
            )
          : Text(text),
    );
  }
}

/* ────────────────────────────────────────────────────────────────────
   Quick action grid (dashboard chips)
   ──────────────────────────────────────────────────────────────────── */

class QuickAction {
  final String label;
  final IconData icon;
  final Color color;
  final String? route;
  final VoidCallback? onTap;
  const QuickAction({required this.label, required this.icon, this.color = AppColors.primary, this.route, this.onTap});
}

class QuickActionGrid extends StatelessWidget {
  final List<QuickAction> actions;
  final int crossAxisCount;
  const QuickActionGrid({super.key, required this.actions, this.crossAxisCount = 4});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: crossAxisCount,
      childAspectRatio: .92,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      children: actions.map((a) {
        return InkWell(
          borderRadius: BorderRadius.circular(AppRadius.md),
          onTap: a.onTap ??
              (a.route != null ? () => Navigator.pushNamed(context, a.route!) : null),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: AppColors.border),
            ),
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: a.color.withValues(alpha: .12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(a.icon, color: a.color, size: 22),
                ),
                const SizedBox(height: 8),
                Text(
                  a.label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 11.5),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
