import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class AppointmentCalendar extends StatefulWidget {
  final bool showDayView;
  
  const AppointmentCalendar({
    super.key,
    this.showDayView = false,
  });

  @override
  State<AppointmentCalendar> createState() => _AppointmentCalendarState();
}

class _AppointmentCalendarState extends State<AppointmentCalendar> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  
  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    
    if (widget.showDayView) {
      _calendarFormat = CalendarFormat.week;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TableCalendar(
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: _focusedDay,
          calendarFormat: _calendarFormat,
          selectedDayPredicate: (day) {
            return isSameDay(_selectedDay, day);
          },
          onDaySelected: (selectedDay, focusedDay) {
            if (!isSameDay(_selectedDay, selectedDay)) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            }
          },
          onFormatChanged: (format) {
            if (_calendarFormat != format) {
              setState(() {
                _calendarFormat = format;
              });
            }
          },
          onPageChanged: (focusedDay) {
            _focusedDay = focusedDay;
          },
          calendarStyle: CalendarStyle(
            todayDecoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            selectedDecoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              shape: BoxShape.circle,
            ),
            markerDecoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              shape: BoxShape.circle,
            ),
          ),
          headerStyle: HeaderStyle(
            formatButtonVisible: !widget.showDayView,
            titleCentered: true,
            formatButtonShowsNext: false,
          ),
        ),
        const SizedBox(height: 16),
        if (_selectedDay != null) _buildAppointmentsList(),
      ],
    );
  }

  Widget _buildAppointmentsList() {
    // This would be replaced with actual appointment data from a repository
    final appointments = [
      _AppointmentData(
        patientName: 'John Smith',
        time: '09:00 AM',
        type: 'Check-up',
        status: 'Confirmed',
      ),
      _AppointmentData(
        patientName: 'Sarah Johnson',
        time: '10:30 AM',
        type: 'Follow-up',
        status: 'Confirmed',
      ),
      _AppointmentData(
        patientName: 'Michael Brown',
        time: '01:15 PM',
        type: 'Consultation',
        status: 'Pending',
      ),
      _AppointmentData(
        patientName: 'Emily Davis',
        time: '03:45 PM',
        type: 'Emergency',
        status: 'Confirmed',
      ),
    ];

    if (widget.showDayView && appointments.isEmpty) {
      return const Center(
        child: Text('No appointments for this day'),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.showDayView ? 3 : appointments.length,
      itemBuilder: (context, index) {
        if (widget.showDayView && index >= appointments.length) {
          return null;
        }
        
        final appointment = appointments[index];
        
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              child: Text(appointment.patientName[0]),
            ),
            title: Text(appointment.patientName),
            subtitle: Text('${appointment.time} - ${appointment.type}'),
            trailing: Chip(
              label: Text(
                appointment.status,
                style: TextStyle(
                  color: appointment.status == 'Confirmed'
                      ? Colors.white
                      : Colors.black,
                  fontSize: 12,
                ),
              ),
              backgroundColor: appointment.status == 'Confirmed'
                  ? Colors.green
                  : Colors.amber,
            ),
            onTap: () {
              // Navigate to appointment details
            },
          ),
        );
      },
    );
  }
}

class _AppointmentData {
  final String patientName;
  final String time;
  final String type;
  final String status;

  _AppointmentData({
    required this.patientName,
    required this.time,
    required this.type,
    required this.status,
  });
}
