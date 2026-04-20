import 'package:flutter/material.dart';

import 'gcal_toggle_controller.dart';
import 'gcal_toggle_tab.dart';

class GCalToggleSwitcher extends StatefulWidget {
  const GCalToggleSwitcher({
    super.key,
    required this.tabs,
    this.controller,
    this.initialIndex = 0,
    this.onChanged,
    this.showPill = true,       // Added to control pill visibility
    this.showPageArea = true,
    this.pillBorderColor,
    this.activeBgColor,
    this.activeIconColor,
    this.activeLabelColor,
    this.hoverBgColor,
    this.inactiveIconColor,
  }) : assert(tabs.length >= 2, 'Provide at least 2 tabs.');

  final List<GCalToggleTab> tabs;
  final GCalToggleController? controller;
  final int initialIndex;
  final ValueChanged<int>? onChanged;
  final bool showPill;
  final bool showPageArea;

  final Color? pillBorderColor;
  final Color? activeBgColor;
  final Color? activeIconColor;
  final Color? activeLabelColor;
  final Color? hoverBgColor;
  final Color? inactiveIconColor;

  @override
  State<GCalToggleSwitcher> createState() => _GCalToggleSwitcherState();
}

class _GCalToggleSwitcherState extends State<GCalToggleSwitcher>
    with TickerProviderStateMixin {
  GCalToggleController? _ownCtrl;
  GCalToggleController get _ctrl => widget.controller ?? _ownCtrl!;

  late AnimationController _slideCtrl;
  late Animation<double> _slideAnim; 

  int _from = 0;
  int _to = 0;

  late AnimationController _fadeCtrl;
  late Animation<double> _fadeAnim;
  int _displayedPage = 0;
  int _incomingPage = 0;

  @override
  void initState() {
    super.initState();
    _ownCtrl ??= widget.controller == null
        ? GCalToggleController(initialIndex: widget.initialIndex)
        : null;

    _from = _ctrl.index;
    _to = _ctrl.index;
    _displayedPage = _ctrl.index;
    _incomingPage = _ctrl.index;

    _slideCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _slideAnim = CurvedAnimation(parent: _slideCtrl, curve: Curves.easeInOut);

    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeInOut);

    _fadeCtrl.addStatusListener((s) {
      if (s == AnimationStatus.completed) {
        if (mounted) {
          setState(() {
            _displayedPage = _incomingPage;
            _fadeCtrl.reset();
          });
        }
      }
    });

    _ctrl.addListener(_onIndexChanged);
  }

  @override
  void didUpdateWidget(GCalToggleSwitcher old) {
    super.didUpdateWidget(old);
    if (old.controller != widget.controller) {
      _ctrl.removeListener(_onIndexChanged);
      _ownCtrl?.dispose();
      _ownCtrl = null;
      if (widget.controller == null) {
        _ownCtrl = GCalToggleController(initialIndex: _to);
      }
      _ctrl.addListener(_onIndexChanged);
    }
  }

  void _onIndexChanged() {
    final next = _ctrl.index;
    if (next == _to) return;
    setState(() {
      _from = _to;
      _to = next;
      _incomingPage = next;
    });
    _slideCtrl.forward(from: 0);
    _fadeCtrl.forward(from: 0);
  }

  void _select(int index) {
    if (index == _to) return;
    _ctrl.jumpTo(index);
    widget.onChanged?.call(index);
  }

  @override
  void dispose() {
    _ctrl.removeListener(_onIndexChanged);
    _ownCtrl?.dispose();
    _slideCtrl.dispose();
    _fadeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      // Removed CrossAxisAlignment.stretch to fix the Infinite Width crash!
      crossAxisAlignment: CrossAxisAlignment.start, 
      children: [
        if (widget.showPill)
          _PillToggle(
            tabs: widget.tabs,
            activeIndex: _to,
            fromIndex: _from,
            slideAnim: _slideAnim,
            onTap: _select,
            pillBorderColor: widget.pillBorderColor,
            activeBgColor: widget.activeBgColor,
            activeIconColor: widget.activeIconColor,
            activeLabelColor: widget.activeLabelColor,
            hoverBgColor: widget.hoverBgColor,
            inactiveIconColor: widget.inactiveIconColor,
          ),
        if (widget.showPageArea)
          Expanded(
            child: _CrossFadePage(
              tabs: widget.tabs,
              displayedIndex: _displayedPage,
              incomingIndex: _incomingPage,
              fadeAnim: _fadeAnim,
            ),
          ),
      ],
    );
  }
}

class _PillToggle extends StatelessWidget {
  const _PillToggle({
    required this.tabs,
    required this.activeIndex,
    required this.fromIndex,
    required this.slideAnim,
    required this.onTap,
    this.pillBorderColor,
    this.activeBgColor,
    this.activeIconColor,
    this.activeLabelColor,
    this.hoverBgColor,
    this.inactiveIconColor,
  });

  final List<GCalToggleTab> tabs;
  final int activeIndex;
  final int fromIndex;
  final Animation<double> slideAnim;
  final ValueChanged<int> onTap;

  final Color? pillBorderColor;
  final Color? activeBgColor;
  final Color? activeIconColor;
  final Color? activeLabelColor;
  final Color? hoverBgColor;
  final Color? inactiveIconColor;

  @override
  Widget build(BuildContext context) {
    final borderCol = pillBorderColor ?? const Color(0xFFDADCE0);
    final activeBg = activeBgColor ?? const Color(0xFFD3E3FD);
    final activeIcon = activeIconColor ?? const Color(0xFF001D6C);
    final activeLabel = activeLabelColor ?? const Color(0xFF001D6C);
    final hoverBg = hoverBgColor ?? const Color(0xFFE8EAED);
    final inactiveIcon = inactiveIconColor ?? const Color(0xFF444746);

    return Container(
      height: 40,
      decoration: BoxDecoration(
        border: Border.all(color: borderCol, width: 1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(19),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (int i = 0; i < tabs.length; i++)
              _Chip(
                tab: tabs[i],
                index: i,
                isActive: i == activeIndex,
                wasActive: i == fromIndex,
                slideAnim: slideAnim,
                activeBg: activeBg,
                activeIcon: activeIcon,
                activeLabel: activeLabel,
                hoverBg: hoverBg,
                inactiveIcon: inactiveIcon,
                onTap: () => onTap(i),
                isFirst: i == 0,
                isLast: i == tabs.length - 1,
              ),
          ],
        ),
      ),
    );
  }
}

class _Chip extends StatefulWidget {
  const _Chip({
    required this.tab,
    required this.index,
    required this.isActive,
    required this.wasActive,
    required this.slideAnim,
    required this.activeBg,
    required this.activeIcon,
    required this.activeLabel,
    required this.hoverBg,
    required this.inactiveIcon,
    required this.onTap,
    required this.isFirst,
    required this.isLast,
  });

  final GCalToggleTab tab;
  final int index;
  final bool isActive;
  final bool wasActive;
  final Animation<double> slideAnim;
  final Color activeBg;
  final Color activeIcon;
  final Color activeLabel;
  final Color hoverBg;
  final Color inactiveIcon;
  final VoidCallback onTap;
  final bool isFirst;
  final bool isLast;

  @override
  State<_Chip> createState() => _ChipState();
}

class _ChipState extends State<_Chip> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.slideAnim,
      builder: (context, _) {
        final double t;
        if (widget.isActive) {
          t = widget.slideAnim.value;
        } else if (widget.wasActive) {
          t = 1.0 - widget.slideAnim.value;
        } else {
          t = 0.0;
        }

        final highlightBg = Color.lerp(Colors.transparent, widget.activeBg, t)!;
        final iconColor = Color.lerp(widget.inactiveIcon, widget.activeIcon, t)!;
        final labelColor = Color.lerp(Colors.transparent, widget.activeLabel, t)!;

        Color bg = highlightBg;
        if (_pressed) {
          bg = Color.lerp(bg, Colors.black, 0.08)!;
        } else if (_hovered && t < 0.5) {
          bg = Color.lerp(bg, widget.hoverBg, 0.6)!;
        }

        return MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setState(() => _hovered = true),
          onExit: (_) => setState(() {
            _hovered = false;
            _pressed = false;
          }),
          child: GestureDetector(
            onTapDown: (_) => setState(() => _pressed = true),
            onTapUp: (_) => setState(() => _pressed = false),
            onTapCancel: () => setState(() => _pressed = false),
            onTap: widget.onTap,
            child: Tooltip(
              message: widget.tab.tooltip,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 120),
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: BorderRadius.horizontal(
                    left: widget.isFirst ? const Radius.circular(19) : Radius.zero,
                    right: widget.isLast ? const Radius.circular(19) : Radius.zero,
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(widget.tab.icon, size: 20, color: iconColor),
                    if (widget.tab.label != null)
                      ClipRect(
                        child: AnimatedAlign(
                          widthFactor: t.clamp(0.0, 1.0),
                          alignment: Alignment.centerLeft,
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeInOut,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 6),
                            child: Text(
                              widget.tab.label!,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: labelColor,
                                letterSpacing: 0.1,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CrossFadePage extends StatelessWidget {
  const _CrossFadePage({
    required this.tabs,
    required this.displayedIndex,
    required this.incomingIndex,
    required this.fadeAnim,
  });

  final List<GCalToggleTab> tabs;
  final int displayedIndex;
  final int incomingIndex;
  final Animation<double> fadeAnim;

  @override
  Widget build(BuildContext context) {
    final bool transitioning = displayedIndex != incomingIndex ||
        fadeAnim.status == AnimationStatus.forward;

    return AnimatedBuilder(
      animation: fadeAnim,
      builder: (context, _) {
        return Stack(
          fit: StackFit.expand,
          children: [
            FadeTransition(
              opacity: Tween<double>(begin: 1, end: 0).animate(
                CurvedAnimation(
                  parent: fadeAnim,
                  curve: const Interval(0, 0.5, curve: Curves.easeOut),
                ),
              ),
              child: tabs[displayedIndex].page,
            ),
            if (transitioning && incomingIndex != displayedIndex)
              FadeTransition(
                opacity: Tween<double>(begin: 0, end: 1).animate(
                  CurvedAnimation(
                    parent: fadeAnim,
                    curve: const Interval(0.5, 1, curve: Curves.easeIn),
                  ),
                ),
                child: tabs[incomingIndex].page,
              ),
          ],
        );
      },
    );
  }
}