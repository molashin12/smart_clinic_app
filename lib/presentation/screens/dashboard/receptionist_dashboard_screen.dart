import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_clinic_app/presentation/blocs/auth/auth_bloc.dart';
import 'package:smart_clinic_app/presentation/widgets/dashboard_stats_card.dart';

class ReceptionistDashboardScreen extends StatefulWidget {
  const ReceptionistDashboardScreen({super.key});

  @override
  State<ReceptionistDashboardScreen> createState() => _ReceptionistDashboardScreenState();
}

class _ReceptionistDashboardScreenState extends State<ReceptionistDashboardScreen> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Receptionist Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // Navigate to notifications
            },
          ),
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: () {
              // Trigger manual sync
            },
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add new appointment or patient based on current tab
          if (_selectedIndex == 0) {
            // Add new appointment
          } else if (_selectedIndex == 1) {
            // Add new patient
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildDrawer() {
    final authState = context.watch<AuthBloc>().state;
    String userName = '';
    String userEmail = '';
    
    if (authState is Authenticated) {
      userName = authState.user.displayName ?? '';
      userEmail = authState.user.email ?? '';
    }
    
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(userName),
            accountEmail: Text(userEmail),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                userName.isNotEmpty ? userName[0].toUpperCase() : '',
                style: const TextStyle(fontSize: 24.0),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Dashboard'),
            onTap: () {
              Navigator.pop(context);
              setState(() {
                _selectedIndex = 0;
              });
            },
          ),
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text('Patients'),
            onTap: () {
              Navigator.pop(context);
              setState(() {
                _selectedIndex = 1;
              });
            },
          ),
          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: const Text('Appointments'),
            onTap: () {
              Navigator.pop(context);
              setState(() {
                _selectedIndex = 2;
              });
            },
          ),
          ListTile(
            leading: const Icon(Icons.business),
            title: const Text('Clinics'),
            onTap: () {
              Navigator.pop(context);
              // Navigate to clinics screen
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              // Navigate to settings screen
            },
          ),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('Help & Support'),
            onTap: () {
              Navigator.pop(context);
              // Navigate to help screen
            },
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Logout'),
            onTap: () {
              Navigator.pop(context);
              context.read<AuthBloc>().add(SignOutRequested());
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildDashboardTab();
      case 1:
        return _buildPatientsTab();
      case 2:
        return _buildAppointmentsTab();
      default:
        return _buildDashboardTab();
    }
  }

  Widget _buildDashboardTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome, Receptionist',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            'Here\'s your clinic overview for today',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),
          
          // Stats Cards
          Row(
            children: [
              Expanded(
                child: DashboardStatsCard(
                  title: 'Today\'s Appointments',
                  value: '12',
                  icon: Icons.calendar_today,
                  color: Colors.blue,
                  onTap: () {
                    setState(() {
                      _selectedIndex = 2;
                    });
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: DashboardStatsCard(
                  title: 'Waiting Patients',
                  value: '4',
                  icon: Icons.people,
                  color: Colors.orange,
                  onTap: () {
                    // Navigate to waiting list
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: DashboardStatsCard(
                  title: 'Available Doctors',
                  value: '3',
                  icon: Icons.medical_services,
                  color: Colors.green,
                  onTap: () {
                    // Navigate to doctors list
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: DashboardStatsCard(
                  title: 'New Registrations',
                  value: '2',
                  icon: Icons.person_add,
                  color: Colors.purple,
                  onTap: () {
                    setState(() {
                      _selectedIndex = 1;
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Quick Actions
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quick Actions',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildQuickActionButton(
                        icon: Icons.add_circle,
                        label: 'New Patient',
                        onTap: () {
                          // Navigate to add patient
                        },
                      ),
                      _buildQuickActionButton(
                        icon: Icons.calendar_month,
                        label: 'Book Appointment',
                        onTap: () {
                          // Navigate to book appointment
                        },
                      ),
                      _buildQuickActionButton(
                        icon: Icons.check_circle,
                        label: 'Check-in Patient',
                        onTap: () {
                          // Navigate to check-in
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          
          // Today's Appointments
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Today\'s Appointments',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _selectedIndex = 2;
                          });
                        },
                        child: const Text('View All'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildAppointmentsList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
              child: Icon(
                icon,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentsList() {
    // This would be replaced with actual appointment data from a repository
    final appointments = [
      _AppointmentData(
        patientName: 'John Smith',
        doctorName: 'Dr. Wilson',
        time: '09:00 AM',
        status: 'Checked In',
      ),
      _AppointmentData(
        patientName: 'Sarah Johnson',
        doctorName: 'Dr. Martinez',
        time: '10:30 AM',
        status: 'Waiting',
      ),
      _AppointmentData(
        patientName: 'Michael Brown',
        doctorName: 'Dr. Wilson',
        time: '01:15 PM',
        status: 'Scheduled',
      ),
      _AppointmentData(
        patientName: 'Emily Davis',
        doctorName: 'Dr. Lee',
        time: '03:45 PM',
        status: 'Scheduled',
      ),
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3, // Show only first 3
      itemBuilder: (context, index) {
        final appointment = appointments[index];
        
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              child: Text(appointment.patientName[0]),
            ),
            title: Text(appointment.patientName),
            subtitle: Text('${appointment.time} - ${appointment.doctorName}'),
            trailing: Chip(
              label: Text(
                appointment.status,
                style: TextStyle(
                  color: _getStatusColor(appointment.status)[1],
                  fontSize: 12,
                ),
              ),
              backgroundColor: _getStatusColor(appointment.status)[0],
            ),
            onTap: () {
              // Navigate to appointment details
            },
          ),
        );
      },
    );
  }

  List<Color> _getStatusColor(String status) {
    switch (status) {
      case 'Checked In':
        return [Colors.green, Colors.white];
      case 'Waiting':
        return [Colors.orange, Colors.white];
      case 'Scheduled':
        return [Colors.blue.shade100, Colors.blue.shade900];
      case 'Completed':
        return [Colors.grey.shade300, Colors.black87];
      case 'Cancelled':
        return [Colors.red.shade100, Colors.red.shade900];
      default:
        return [Colors.grey, Colors.white];
    }
  }

  Widget _buildPatientsTab() {
    return const Center(
      child: Text('Patients Tab - To be implemented'),
    );
  }

  Widget _buildAppointmentsTab() {
    return const Center(
      child: Text('Appointments Tab - To be implemented'),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people),
          label: 'Patients',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          label: 'Appointments',
        ),
      ],
    );
  }
}

class _AppointmentData {
  final String patientName;
  final String doctorName;
  final String time;
  final String status;

  _AppointmentData({
    required this.patientName,
    required this.doctorName,
    required this.time,
    required this.status,
  });
}
