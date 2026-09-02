import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/qanomy_app_bar.dart';
import '../../../core/widgets/qanomy_card.dart';
import '../widgets/add_hearing_dialog.dart';

class MockHearing {
  final String id;
  final String caseTitle;
  final String clientName;
  final String lawyerName;
  final String courtName;
  final String location;
  final String? caseType;
  final String docName;
  DateTime dateTime;
  String status; // 'Pending', 'Overdue', 'Done'

  MockHearing({
    required this.id,
    required this.caseTitle,
    required this.clientName,
    required this.lawyerName,
    required this.courtName,
    required this.location,
    this.caseType,
    required this.docName,
    required this.dateTime,
    required this.status,
  });
}

class HearingsCalendarScreen extends StatefulWidget {
  const HearingsCalendarScreen({super.key});

  @override
  State<HearingsCalendarScreen> createState() => _HearingsCalendarScreenState();
}

class _HearingsCalendarScreenState extends State<HearingsCalendarScreen> {
  late DateTime _focusedDate;
  late DateTime _selectedDate;
  late List<MockHearing> _hearings;
  final Set<String> _expandedHearingIds = {};

  final List<String> _monthNames = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  final List<String> _weekdays = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'];

  @override
  void initState() {
    super.initState();
    final today = DateTime.now();
    _focusedDate = today;
    _selectedDate = today;
    
    // Seed mock hearings around current date
    _hearings = [
      MockHearing(
        id: '1',
        caseTitle: 'Ali vs Ahmed',
        clientName: 'Arooj Client',
        lawyerName: 'Haris khan',
        courtName: 'Anti-Terrorism Court (ATC), Lahore',
        location: 'Court 3',
        caseType: 'Criminal',
        docName: 'Vakalatnama_Signed.pdf',
        dateTime: DateTime(today.year, today.month, today.day, 18, 8),
        status: 'Overdue',
      ),
      MockHearing(
        id: '2',
        caseTitle: 'Ejaz vs Adnan',
        clientName: 'Ejaz Ahmed',
        lawyerName: 'Haris khan',
        courtName: 'High Court, Lahore',
        location: 'Court 1',
        caseType: 'Civil',
        docName: 'evidence_photos.zip',
        dateTime: DateTime(today.year, today.month, today.day, 10, 0),
        status: 'Pending',
      ),
      MockHearing(
        id: '3',
        caseTitle: 'Alia vs Adnan',
        clientName: 'Alia Bibi',
        lawyerName: 'Fatima',
        courtName: 'District Court, Rawalpindi',
        location: 'Court 2',
        caseType: 'Family',
        docName: 'atc_order_copy.pdf',
        dateTime: today.subtract(const Duration(days: 2)),
        status: 'Done',
      ),
      MockHearing(
        id: '4',
        caseTitle: 'Ali vs Babar',
        clientName: 'Babar Hussain',
        lawyerName: 'Fatima',
        courtName: 'High Court, Karachi',
        location: 'Court 5',
        caseType: 'Criminal',
        docName: 'reply_statement.docx',
        dateTime: today.add(const Duration(days: 3)),
        status: 'Pending',
      ),
    ];
  }

  int _getDaysInMonth(int year, int month) {
    if (month == 2) {
      final bool isLeap = (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
      return isLeap ? 29 : 28;
    }
    const days = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    return days[month - 1];
  }

  String _formatDateTime(DateTime dt) {
    final monthStr = _monthNames[dt.month - 1];
    final hour = dt.hour == 0 ? 12 : (dt.hour > 12 ? dt.hour - 12 : dt.hour);
    final minute = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour >= 12 ? 'pm' : 'am';
    return '${dt.day} $monthStr ${dt.year}, ${hour.toString().padLeft(2, "0")}:$minute $period';
  }

  List<MockHearing> _getHearingsForDate(DateTime date) {
    return _hearings.where((h) => 
      h.dateTime.year == date.year &&
      h.dateTime.month == date.month &&
      h.dateTime.day == date.day
    ).toList();
  }

  void _nextMonth() {
    setState(() {
      if (_focusedDate.month == 12) {
        _focusedDate = DateTime(_focusedDate.year + 1, 1);
      } else {
        _focusedDate = DateTime(_focusedDate.year, _focusedDate.month + 1);
      }
    });
  }

  void _prevMonth() {
    setState(() {
      if (_focusedDate.month == 1) {
        _focusedDate = DateTime(_focusedDate.year - 1, 12);
      } else {
        _focusedDate = DateTime(_focusedDate.year, _focusedDate.month - 1);
      }
    });
  }

  void _openAddHearingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AddHearingDialog(
        onSave: (data) {
          final newHearing = MockHearing(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            caseTitle: data['caseTitle'] as String,
            clientName: 'Arooj Client',
            lawyerName: 'Adv. Haris Khan',
            courtName: 'High Court, Lahore',
            location: data['location'] as String,
            caseType: 'Legal Matter',
            docName: data['docName'] as String,
            dateTime: data['dateTime'] as DateTime,
            status: 'Pending',
          );

          setState(() {
            _hearings.add(newHearing);
            _selectedDate = newHearing.dateTime;
            _focusedDate = newHearing.dateTime;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('New hearing added successfully!')),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedDayHearings = _getHearingsForDate(_selectedDate);

    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      appBar: const QanomyAppBar(
        title: 'Hearings & Calendar',
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.princetonOrange,
        tooltip: 'Add Hearing',
        onPressed: () => _openAddHearingDialog(context),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.s24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Calendar Wrapper Card
            QanomyCard(
              padding: EdgeInsets.zero,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Column(
                  children: [
                    // Premium Gradient Header
                    Container(
                      height: 110,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [AppColors.primaryNavy, AppColors.blueGreen],
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${_focusedDate.year}',
                                style: GoogleFonts.inter(
                                  color: Colors.white70,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _monthNames[_focusedDate.month - 1],
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.chevron_left, color: Colors.white, size: 28),
                                onPressed: _prevMonth,
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                icon: const Icon(Icons.chevron_right, color: Colors.white, size: 28),
                                onPressed: _nextMonth,
                              ),
                            ],
                          )
                        ],
                      ),
                    ),

                    // Weekdays labels Row
                    Padding(
                      padding: const EdgeInsets.only(top: 16, bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: _weekdays.map((day) {
                          final isSunday = day == 'SUN';
                          return SizedBox(
                            width: 40,
                            child: Text(
                              day,
                              textAlign: TextAlign.center,
                              style: AppTypography.labelSmall.copyWith(
                                color: isSunday ? AppColors.princetonOrange : AppColors.textMuted,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    const Divider(color: AppColors.border, height: 1),

                    // Days Grid
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: _buildDaysGrid(),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.s24),

            // Hearings Section Header
            Row(
              children: [
                const Icon(Icons.gavel, color: AppColors.primaryNavy, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Hearings on ${_selectedDate.day} ${_monthNames[_selectedDate.month - 1]} ${_selectedDate.year}',
                  style: AppTypography.titleMedium.copyWith(
                    color: AppColors.primaryNavy,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.s16),

            // Details List
            if (selectedDayHearings.isEmpty)
              QanomyCard(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.calendar_today_outlined, color: AppColors.textMuted.withOpacity(0.4), size: 48),
                      const SizedBox(height: 16),
                      Text(
                        'No hearings scheduled for this day.',
                        style: AppTypography.bodyInter.copyWith(color: AppColors.textMuted),
                      ),
                    ],
                  ),
                ),
              )
            else
              ...selectedDayHearings.map((h) => _buildHearingCard(h)),
          ],
        ),
      ),
    );
  }

  Widget _buildDaysGrid() {
    final year = _focusedDate.year;
    final month = _focusedDate.month;

    // Get first day and days count
    final firstDayOfMonth = DateTime(year, month, 1);
    final daysInMonth = _getDaysInMonth(year, month);

    // leading empty slots representing previous month days
    // 0 = Sunday, 1 = Monday ... 6 = Saturday
    final int leadingSpaces = firstDayOfMonth.weekday == 7 ? 0 : firstDayOfMonth.weekday;

    final prevMonth = month == 1 ? 12 : month - 1;
    final prevYear = month == 1 ? year - 1 : year;
    final prevMonthDays = _getDaysInMonth(prevYear, prevMonth);

    final List<Widget> dayWidgets = [];

    // 1. Previous Month Days (Muted)
    for (int i = leadingSpaces - 1; i >= 0; i--) {
      final dayVal = prevMonthDays - i;
      final dt = DateTime(prevYear, prevMonth, dayVal);
      dayWidgets.add(_buildDayCell(dt, isCurrentMonth: false));
    }

    // 2. Current Month Days
    for (int i = 1; i <= daysInMonth; i++) {
      final dt = DateTime(year, month, i);
      dayWidgets.add(_buildDayCell(dt, isCurrentMonth: true));
    }

    // 3. Next Month Days (Muted)
    final totalCells = 42; // standard 6 rows
    final trailingSpaces = totalCells - dayWidgets.length;
    final nextMonth = month == 12 ? 1 : month + 1;
    final nextYear = month == 12 ? year + 1 : year;
    for (int i = 1; i <= trailingSpaces; i++) {
      final dt = DateTime(nextYear, nextMonth, i);
      dayWidgets.add(_buildDayCell(dt, isCurrentMonth: false));
    }

    return GridView.count(
      crossAxisCount: 7,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      children: dayWidgets,
    );
  }

  Widget _buildDayCell(DateTime date, {required bool isCurrentMonth}) {
    final today = DateTime.now();
    final isToday = today.year == date.year && today.month == date.month && today.day == date.day;
    final isSelected = _selectedDate.year == date.year && _selectedDate.month == date.month && _selectedDate.day == date.day;
    
    // Check hearings on this day
    final dayHearings = _getHearingsForDate(date);
    final hasHearings = dayHearings.isNotEmpty;

    // Get color based on hearing status
    Color? hearingCircleColor;
    if (hasHearings) {
      if (dayHearings.any((h) => h.status == 'Overdue')) {
        hearingCircleColor = AppColors.pastelRed; // Overdue
      } else if (dayHearings.every((h) => h.status == 'Done')) {
        hearingCircleColor = AppColors.pastelGreen; // Done
      } else {
        hearingCircleColor = AppColors.pastelBlue; // Pending
      }
    }

    Widget cellContent = Center(
      child: Text(
        '${date.day}',
        style: AppTypography.bodyInterMedium.copyWith(
          color: isSelected
              ? Colors.white
              : isCurrentMonth
                  ? AppColors.textPrimary
                  : AppColors.textMuted.withOpacity(0.5),
          fontWeight: isToday || isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );

    // Apply circle backgrounds
    if (isSelected) {
      // Solid filled circle for selected date
      cellContent = Container(
        decoration: const BoxDecoration(
          color: AppColors.princetonOrange,
          shape: BoxShape.circle,
        ),
        child: cellContent,
      );
    } else if (isToday) {
      // Bold navy outline circle for current date
      cellContent = Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.primaryNavy, width: 2),
        ),
        child: cellContent,
      );
    } else if (hasHearings && hearingCircleColor != null) {
      // Filled circle representing status for hearings date
      cellContent = Container(
        decoration: BoxDecoration(
          color: hearingCircleColor,
          shape: BoxShape.circle,
          border: Border.all(
            color: hearingCircleColor == AppColors.pastelRed 
              ? Colors.redAccent.withOpacity(0.2) 
              : hearingCircleColor == AppColors.pastelGreen 
                ? Colors.green.withOpacity(0.2) 
                : AppColors.primaryNavy.withOpacity(0.1),
            width: 1
          )
        ),
        child: cellContent,
      );
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDate = date;
          if (date.month != _focusedDate.month || date.year != _focusedDate.year) {
            _focusedDate = date;
          }
        });
      },
      child: cellContent,
    );
  }

  Widget _buildHearingCard(MockHearing hearing) {
    final bool isOverdue = hearing.status == 'Overdue';
    final bool isDone = hearing.status == 'Done';
    final bool isExpanded = _expandedHearingIds.contains(hearing.id);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.s24),
      child: QanomyCard(
        padding: const EdgeInsets.all(AppSpacing.s24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row (Clickable to Expand/Collapse)
            GestureDetector(
              onTap: () {
                setState(() {
                  if (isExpanded) {
                    _expandedHearingIds.remove(hearing.id);
                  } else {
                    _expandedHearingIds.add(hearing.id);
                  }
                });
              },
              behavior: HitTestBehavior.opaque,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      hearing.caseTitle,
                      style: AppTypography.bodyInterSemiBold.copyWith(
                        fontSize: 16,
                        color: AppColors.primaryNavy,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: isDone 
                              ? AppColors.pastelGreen 
                              : isOverdue 
                                  ? AppColors.pastelRed 
                                  : AppColors.pastelOrange,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          isDone 
                              ? 'Completed' 
                              : isOverdue 
                                  ? 'Overdue' 
                                  : 'Pending',
                          style: AppTypography.labelSmall.copyWith(
                            color: isDone 
                                ? Colors.green[800] 
                                : isOverdue 
                                    ? Colors.red[800] 
                                    : Colors.orange[800],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        isExpanded ? Icons.expand_less : Icons.expand_more,
                        color: AppColors.textMuted,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            if (isExpanded) ...[
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Divider(color: AppColors.border, height: 1),
              ),

              // Details Grid (2 columns)
              Wrap(
                spacing: 24,
                runSpacing: 16,
                children: [
                  _buildDetailItem(
                    icon: Icons.calendar_today_outlined,
                    label: 'Date & Time',
                    value: _formatDateTime(hearing.dateTime),
                    width: 240,
                  ),
                  _buildDetailItem(
                    icon: Icons.location_on_outlined,
                    label: 'Location',
                    value: hearing.location,
                    width: 240,
                  ),
                  _buildDetailItem(
                    icon: Icons.gavel_outlined,
                    label: 'Court',
                    value: hearing.courtName,
                    width: 240,
                  ),
                  _buildDetailItem(
                    icon: Icons.person_outline,
                    label: 'Assigned Lawyer',
                    value: hearing.lawyerName,
                    width: 240,
                  ),
                  _buildDetailItem(
                    icon: Icons.people_outline,
                    label: 'Client',
                    value: hearing.clientName,
                    width: 240,
                  ),
                  _buildDetailItem(
                    icon: Icons.label_outline,
                    label: 'Case Type',
                    value: hearing.caseType ?? '—',
                    width: 240,
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Attached Document Section
              Text(
                'Attached Document',
                style: AppTypography.bodyInterSemiBold.copyWith(
                  fontSize: 14,
                  color: AppColors.primaryNavy,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.description, color: AppColors.princetonOrange, size: 20),
                    const SizedBox(width: 12),
                    Flexible(
                      child: Text(
                        hearing.docName,
                        style: AppTypography.bodyInterMedium.copyWith(
                          color: AppColors.princetonOrange,
                          fontSize: 13,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),

              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Divider(color: AppColors.border, height: 1),
              ),

              // Hearing Status Actions Section
              Text(
                'Hearing Status Actions',
                style: AppTypography.bodyInterSemiBold.copyWith(
                  fontSize: 14,
                  color: AppColors.primaryNavy,
                ),
              ),
              const SizedBox(height: 16),
              
              // Action Buttons Row/Column (responsive LayoutBuilder)
              LayoutBuilder(
                builder: (context, constraints) {
                  final isMobile = constraints.maxWidth < 550;
                  
                  final rescheduleRow = Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 40,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${hearing.dateTime.day}/${hearing.dateTime.month}/${hearing.dateTime.year}',
                                style: AppTypography.bodyInter.copyWith(fontSize: 13),
                              ),
                              const Icon(Icons.calendar_today, size: 16, color: AppColors.textMuted),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        height: 40,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.princetonOrange,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            elevation: 0,
                          ),
                          onPressed: () => _showReschedulePicker(context, hearing),
                          child: Text(
                            'Reschedule',
                            style: AppTypography.bodyInterMedium.copyWith(color: Colors.white, fontSize: 13),
                          ),
                        ),
                      ),
                    ],
                  );

                  final finalizeButton = SizedBox(
                    height: 40,
                    width: isMobile ? double.infinity : null,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDone ? Colors.grey[400] : const Color(0xFF00A86B),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        elevation: 0,
                      ),
                      onPressed: isDone ? null : () {
                        setState(() {
                          hearing.status = 'Done';
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Hearing marked as completed successfully!')),
                        );
                      },
                      icon: const Icon(Icons.check_circle_outline, color: Colors.white, size: 18),
                      label: Text(
                        isDone ? 'Completed' : 'Mark as Done',
                        style: AppTypography.bodyInterMedium.copyWith(color: Colors.white, fontSize: 13),
                      ),
                    ),
                  );

                  if (isMobile) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        rescheduleRow,
                        const SizedBox(height: 12),
                        finalizeButton,
                      ],
                    );
                  }

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(child: rescheduleRow),
                      const SizedBox(width: 24),
                      finalizeButton,
                    ],
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }



  Widget _buildDetailItem({
    required IconData icon,
    required String label,
    required String value,
    required double width,
  }) {
    return SizedBox(
      width: width,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.textMuted, size: 18),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTypography.bodyInter.copyWith(
                    color: AppColors.textMuted,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: AppTypography.bodyInterSemiBold.copyWith(
                    color: AppColors.primaryNavy,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showReschedulePicker(BuildContext context, MockHearing hearing) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: hearing.dateTime,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.princetonOrange,
              onPrimary: Colors.white,
              onSurface: AppColors.primaryNavy,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      if (!context.mounted) return;
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(hearing.dateTime),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: AppColors.princetonOrange,
                onPrimary: Colors.white,
                onSurface: AppColors.primaryNavy,
              ),
            ),
            child: child!,
          );
        },
      );

      if (pickedTime != null) {
        setState(() {
          hearing.dateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          // If rescheduled to future, remove Overdue tag if present
          if (hearing.dateTime.isAfter(DateTime.now()) && hearing.status == 'Overdue') {
            hearing.status = 'Pending';
          }
        });
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Hearing rescheduled to ${_formatDateTime(hearing.dateTime)}')),
        );
      }
    }
  }
}
