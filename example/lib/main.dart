import 'package:flutter/material.dart';
import 'package:gcal_toggle_switcher/gcal_toggle_switcher.dart';

void main() => runApp(const GCalApp());

class GCalApp extends StatelessWidget {
  const GCalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google Calendar',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1A73E8),
          brightness: Brightness.light,
        ),
        fontFamily: 'Roboto',
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const GCalHomePage(),
    );
  }
}

class GCalHomePage extends StatefulWidget {
  const GCalHomePage({super.key});

  @override
  State<GCalHomePage> createState() => _GCalHomePageState();
}

class _GCalHomePageState extends State<GCalHomePage> {
  final _ctrl = GCalToggleController(initialIndex: 0);

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _TopBar(ctrl: _ctrl),
          const Divider(height: 1, color: Color(0xFFDADCE0)),
          Expanded(
            child: Row(
              children: [
                ListenableBuilder(
                  listenable: _ctrl,
                  builder: (_, __) => AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: _ctrl.index == 0
                        ? const _CalendarSidebar(key: ValueKey('cal-side'))
                        : const _TasksSidebar(key: ValueKey('task-side')),
                  ),
                ),

                const VerticalDivider(width: 1, color: Color(0xFFDADCE0)),

                Expanded(
                  child: GCalToggleSwitcher(
                    controller: _ctrl,
                    showPill: false,      // NEW: Hides duplicate pill in the body
                    showPageArea: true,
                    tabs: const [
                      GCalToggleTab(
                        icon: Icons.calendar_month_outlined,
                        label: 'Calendar',
                        tooltip: 'Calendar view',
                        page: _CalendarPage(),
                      ),
                      GCalToggleTab(
                        icon: Icons.check_circle_outline,
                        label: 'Tasks',
                        tooltip: 'Tasks view',
                        page: _TasksPage(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.ctrl});
  final GCalToggleController ctrl;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.menu, color: Color(0xFF444746)),
              onPressed: () {},
            ),
            const SizedBox(width: 4),
            Image.network(
              'https://ssl.gstatic.com/calendar/images/dynamiclogo_2020q4/calendar_20_2x.png',
              width: 40,
              height: 40,
              errorBuilder: (_, __, ___) => Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF1A73E8),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.calendar_today,
                    color: Colors.white, size: 22),
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'Calendar',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w400,
                color: Color(0xFF3C4043),
                letterSpacing: -0.5,
              ),
            ),

            const SizedBox(width: 16),

            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFDADCE0)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
                minimumSize: const Size(0, 36),
              ),
              child: const Text('Today',
                  style: TextStyle(
                      color: Color(0xFF3C4043),
                      fontWeight: FontWeight.w500,
                      fontSize: 14)),
            ),

            const SizedBox(width: 8),

            IconButton(
              icon: const Icon(Icons.chevron_left, color: Color(0xFF444746)),
              onPressed: () {},
            ),
            IconButton(
              icon:
                  const Icon(Icons.chevron_right, color: Color(0xFF444746)),
              onPressed: () {},
            ),

            const SizedBox(width: 8),

            const Text(
              '20 April 2026',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                color: Color(0xFF3C4043),
              ),
            ),

            const Spacer(),

            IconButton(
              icon: const Icon(Icons.search, color: Color(0xFF444746)),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.help_outline, color: Color(0xFF444746)),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.settings_outlined,
                  color: Color(0xFF444746)),
              onPressed: () {},
            ),

            const SizedBox(width: 8),

            GCalToggleSwitcher(
              controller: ctrl,
              showPill: true,
              showPageArea: false, 
              tabs: const [
                GCalToggleTab(
                  icon: Icons.calendar_month_outlined,
                  label: 'Calendar',
                  tooltip: 'Calendar view',
                  page: SizedBox.shrink(),
                ),
                GCalToggleTab(
                  icon: Icons.check_circle_outline,
                  label: 'Tasks',
                  tooltip: 'Tasks view',
                  page: SizedBox.shrink(),
                ),
              ],
            ),

            const SizedBox(width: 16),
          ],
        ),
      ),
    );
  }
}

class _CalendarSidebar extends StatelessWidget {
  const _CalendarSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 256,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            _CreateButton(),
            const SizedBox(height: 16),
            _MiniCalendar(),
            const SizedBox(height: 16),
            _SearchPeople(),
            const SizedBox(height: 16),
            _SideSection(
              title: 'Booking pages',
              trailing: const Icon(Icons.add, size: 18, color: Color(0xFF444746)),
            ),
            const SizedBox(height: 16),
            _SideSection(
              title: 'My calendars',
              trailing: const Icon(Icons.expand_less,
                  size: 18, color: Color(0xFF444746)),
              children: const [
                _CalendarEntry(label: 'Syed Anas', color: Color(0xFF1A73E8)),
                _CalendarEntry(
                    label: 'Birthdays', color: Color(0xFF33B679), checked: true),
                _CalendarEntry(label: 'Tasks', color: Color(0xFF1A73E8)),
                _CalendarEntry(
                    label: 'Test Check CS-3B', color: Color(0xFF7986CB), checked: true),
                _CalendarEntry(
                    label: 'Work schedule', color: Color(0xFF7986CB), checked: true),
              ],
            ),
            const SizedBox(height: 16),
            _SideSection(
              title: 'Other calendars',
              trailing: Row(
                children: const [
                  Icon(Icons.add, size: 18, color: Color(0xFF444746)),
                  SizedBox(width: 4),
                  Icon(Icons.expand_less, size: 18, color: Color(0xFF444746)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TasksSidebar extends StatelessWidget {
  const _TasksSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 256,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            _CreateButton(),
            const SizedBox(height: 24),
            _TaskSideChip(
              icon: Icons.check_circle_outline,
              label: 'All tasks',
              isActive: true,
            ),
            _TaskSideChip(
              icon: Icons.star_border,
              label: 'Starred',
            ),
            const SizedBox(height: 16),
            _SideSection(
              title: 'Lists',
              trailing: const Icon(Icons.expand_less,
                  size: 18, color: Color(0xFF444746)),
              children: const [
                _CalendarEntry(
                    label: 'My Tasks', color: Color(0xFF1A73E8), checked: true),
              ],
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Row(
                children: const [
                  Icon(Icons.add, size: 18, color: Color(0xFF444746)),
                  SizedBox(width: 8),
                  Text('Create new list',
                      style: TextStyle(
                          fontSize: 14, color: Color(0xFF444746))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CreateButton extends StatefulWidget {
  @override
  State<_CreateButton> createState() => _CreateButtonState();
}

class _CreateButtonState extends State<_CreateButton> {
  bool _hovered = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        decoration: BoxDecoration(
          color: _hovered ? const Color(0xFFF1F3F4) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.add, size: 20, color: Color(0xFF444746)),
            SizedBox(width: 8),
            Text('Create',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF3C4043))),
            SizedBox(width: 8),
            Icon(Icons.arrow_drop_down, size: 18, color: Color(0xFF444746)),
          ],
        ),
      ),
    );
  }
}

class _MiniCalendar extends StatelessWidget {
  const _MiniCalendar();

  @override
  Widget build(BuildContext context) {
    final days = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
    final startOffset = 3;
    final daysInMonth = 30;
    final today = 20;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text('April 2026',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF3C4043))),
            const Spacer(),
            GestureDetector(
              onTap: () {},
              child:
                  const Icon(Icons.chevron_left, size: 18, color: Color(0xFF444746)),
            ),
            GestureDetector(
              onTap: () {},
              child: const Icon(Icons.chevron_right,
                  size: 18, color: Color(0xFF444746)),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: days
              .map((d) => Expanded(
                    child: Center(
                      child: Text(d,
                          style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF70757A),
                              fontWeight: FontWeight.w500)),
                    ),
                  ))
              .toList(),
        ),
        const SizedBox(height: 4),
        Builder(builder: (_) {
          final cells = <Widget>[];
          for (int i = 0; i < startOffset; i++) {
            cells.add(const SizedBox());
          }
          for (int d = 1; d <= daysInMonth; d++) {
            final isToday = d == today;
            cells.add(_MiniDay(day: d, isToday: isToday));
          }
          while (cells.length % 7 != 0) cells.add(const SizedBox());

          final rows = <Widget>[];
          for (int r = 0; r < cells.length / 7; r++) {
            rows.add(Row(
              children: List.generate(
                  7,
                  (c) => Expanded(child: cells[r * 7 + c])),
            ));
            rows.add(const SizedBox(height: 2));
          }
          return Column(children: rows);
        }),
      ],
    );
  }
}

class _MiniDay extends StatefulWidget {
  const _MiniDay({required this.day, this.isToday = false});
  final int day;
  final bool isToday;

  @override
  State<_MiniDay> createState() => _MiniDayState();
}

class _MiniDayState extends State<_MiniDay> {
  bool _hovered = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.isToday
                ? const Color(0xFF1A73E8)
                : _hovered
                    ? const Color(0xFFF1F3F4)
                    : Colors.transparent,
          ),
          child: Center(
            child: Text(
              '${widget.day}',
              style: TextStyle(
                fontSize: 12,
                color: widget.isToday
                    ? Colors.white
                    : const Color(0xFF3C4043),
                fontWeight: widget.isToday
                    ? FontWeight.w600
                    : FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SearchPeople extends StatelessWidget {
  const _SearchPeople();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFDADCE0)),
        borderRadius: BorderRadius.circular(4),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: const [
          Icon(Icons.people_outline, size: 18, color: Color(0xFF444746)),
          SizedBox(width: 8),
          Text('Search for people',
              style: TextStyle(
                  fontSize: 13, color: Color(0xFF70757A))),
        ],
      ),
    );
  }
}

class _SideSection extends StatelessWidget {
  const _SideSection(
      {required this.title, this.trailing, this.children = const []});
  final String title;
  final Widget? trailing;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(title,
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF3C4043))),
            const Spacer(),
            if (trailing != null) trailing!,
          ],
        ),
        const SizedBox(height: 4),
        ...children,
      ],
    );
  }
}

class _CalendarEntry extends StatefulWidget {
  const _CalendarEntry(
      {required this.label, required this.color, this.checked = false});
  final String label;
  final Color color;
  final bool checked;

  @override
  State<_CalendarEntry> createState() => _CalendarEntryState();
}

class _CalendarEntryState extends State<_CalendarEntry> {
  bool _hovered = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        decoration: BoxDecoration(
          color: _hovered ? const Color(0xFFF1F3F4) : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: Row(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: widget.checked ? widget.color : Colors.transparent,
                border: Border.all(
                    color: widget.color, width: widget.checked ? 0 : 2),
                borderRadius: BorderRadius.circular(3),
              ),
              child: widget.checked
                  ? const Icon(Icons.check, size: 12, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 10),
            Text(widget.label,
                style: const TextStyle(
                    fontSize: 13, color: Color(0xFF3C4043))),
          ],
        ),
      ),
    );
  }
}

class _TaskSideChip extends StatefulWidget {
  const _TaskSideChip(
      {required this.icon, required this.label, this.isActive = false});
  final IconData icon;
  final String label;
  final bool isActive;

  @override
  State<_TaskSideChip> createState() => _TaskSideChipState();
}

class _TaskSideChipState extends State<_TaskSideChip> {
  bool _hovered = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        margin: const EdgeInsets.symmetric(vertical: 1),
        decoration: BoxDecoration(
          color: widget.isActive
              ? const Color(0xFFD3E3FD)
              : _hovered
                  ? const Color(0xFFF1F3F4)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Icon(widget.icon,
                size: 18,
                color: widget.isActive
                    ? const Color(0xFF001D6C)
                    : const Color(0xFF444746)),
            const SizedBox(width: 12),
            Text(widget.label,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: widget.isActive
                        ? FontWeight.w600
                        : FontWeight.w400,
                    color: widget.isActive
                        ? const Color(0xFF001D6C)
                        : const Color(0xFF3C4043))),
          ],
        ),
      ),
    );
  }
}

class _CalendarPage extends StatelessWidget {
  const _CalendarPage();

  @override
  Widget build(BuildContext context) {
    final hours = [
      '8 AM', '9 AM', '10 AM', '11 AM',
      '12 PM', '1 PM', '2 PM', '3 PM',
      '4 PM', '5 PM', '6 PM', '7 PM', '8 PM',
    ];

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              const SizedBox(width: 56), 
              Column(
                children: [
                  const Text('MON',
                      style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF1A73E8),
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1)),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                        color: Color(0xFF1A73E8), shape: BoxShape.circle),
                    child: const Center(
                      child: Text('20',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w400)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const Divider(height: 1, color: Color(0xFFDADCE0)),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                  child: Row(
                    children: const [
                      SizedBox(
                        width: 56,
                        child: Center(
                          child: Text('GMT+05',
                              style: TextStyle(
                                  fontSize: 10, color: Color(0xFF70757A))),
                        ),
                      ),
                    ],
                  ),
                ),
                for (final h in hours) _TimeSlot(label: h),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _TimeSlot extends StatefulWidget {
  const _TimeSlot({required this.label});
  final String label;

  @override
  State<_TimeSlot> createState() => _TimeSlotState();
}

class _TimeSlotState extends State<_TimeSlot> {
  bool _hovered = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Column(
        children: [
          Container(
            height: 48,
            color: _hovered ? const Color(0xFFF8F9FA) : Colors.white,
            child: Row(
              children: [
                SizedBox(
                  width: 56,
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8, top: 4),
                      child: Text(widget.label,
                          style: const TextStyle(
                              fontSize: 10, color: Color(0xFF70757A))),
                    ),
                  ),
                ),
                const VerticalDivider(
                    width: 1, color: Color(0xFFDADCE0)),
                const Expanded(child: SizedBox()),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFDADCE0)),
        ],
      ),
    );
  }
}

class _TasksPage extends StatelessWidget {
  const _TasksPage();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFDADCE0)),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('My Tasks',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF3C4043))),
                Icon(Icons.more_vert, color: Color(0xFF444746)),
              ],
            ),
            const SizedBox(height: 12),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Row(
                children: const [
                  Icon(Icons.check_circle_outline,
                      color: Color(0xFF1A73E8), size: 20),
                  SizedBox(width: 8),
                  Text('Add a task',
                      style: TextStyle(
                          color: Color(0xFF1A73E8),
                          fontWeight: FontWeight.w500,
                          fontSize: 14)),
                ],
              ),
            ),

            const Spacer(),

            Center(
              child: Column(
                children: [
                  _TasksIllustration(),
                  const SizedBox(height: 24),
                  const Text('All tasks complete',
                      style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF3C4043),
                          fontWeight: FontWeight.w400)),
                  const SizedBox(height: 6),
                  const Text('Nice work!',
                      style: TextStyle(
                          fontSize: 14, color: Color(0xFF70757A))),
                ],
              ),
            ),

            const Spacer(),

            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Row(
                children: const [
                  Icon(Icons.chevron_right,
                      size: 20, color: Color(0xFF444746)),
                  SizedBox(width: 4),
                  Text('Completed (1)',
                      style: TextStyle(
                          fontSize: 14, color: Color(0xFF3C4043))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TasksIllustration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 120,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            bottom: 8,
            child: Container(
              width: 80,
              height: 70,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F3F4),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
          Positioned(
            top: 4,
            left: 18,
            child: Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: Color(0xFF34A853),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 28),
            ),
          ),
          Positioned(
            right: 14,
            top: 16,
            child: Column(
              children: [
                Container(
                  width: 22,
                  height: 22,
                  decoration: const BoxDecoration(
                    color: Color(0xFFB0501A),
                    shape: BoxShape.circle,
                  ),
                ),
                Container(
                  width: 18,
                  height: 30,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A73E8),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 24,
            left: 22,
            child: Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: const Color(0xFFFBBC04),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}