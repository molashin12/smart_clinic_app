import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_clinic_app/presentation/blocs/auth/auth_bloc.dart';
import 'package:smart_clinic_app/presentation/widgets/dashboard_stats_card.dart';

class PharmacistDashboardScreen extends StatefulWidget {
  const PharmacistDashboardScreen({super.key});

  @override
  State<PharmacistDashboardScreen> createState() => _PharmacistDashboardScreenState();
}

class _PharmacistDashboardScreenState extends State<PharmacistDashboardScreen> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Pharmacist Dashboard'),
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
      floatingActionButton: _selectedIndex == 1 
          ? FloatingActionButton(
              onPressed: () {
                // Add new medication or inventory item
              },
              child: const Icon(Icons.add),
            )
          : null,
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
            leading: const Icon(Icons.inventory_2),
            title: const Text('Inventory'),
            onTap: () {
              Navigator.pop(context);
              setState(() {
                _selectedIndex = 1;
              });
            },
          ),
          ListTile(
            leading: const Icon(Icons.medical_services),
            title: const Text('Prescriptions'),
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
        return _buildInventoryTab();
      case 2:
        return _buildPrescriptionsTab();
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
            'Welcome, Pharmacist',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            'Here\'s your pharmacy overview for today',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),
          
          // Stats Cards
          Row(
            children: [
              Expanded(
                child: DashboardStatsCard(
                  title: 'Pending Prescriptions',
                  value: '8',
                  icon: Icons.medical_services,
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
                  title: 'Fulfilled Today',
                  value: '12',
                  icon: Icons.check_circle,
                  color: Colors.green,
                  onTap: () {
                    // Navigate to fulfilled prescriptions
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
                  title: 'Low Stock Items',
                  value: '5',
                  icon: Icons.warning_amber,
                  color: Colors.orange,
                  onTap: () {
                    setState(() {
                      _selectedIndex = 1;
                    });
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: DashboardStatsCard(
                  title: 'Expiring Soon',
                  value: '3',
                  icon: Icons.event_busy,
                  color: Colors.red,
                  onTap: () {
                    // Navigate to expiring medications
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
                        icon: Icons.qr_code_scanner,
                        label: 'Scan Prescription',
                        onTap: () {
                          // Navigate to scan prescription
                        },
                      ),
                      _buildQuickActionButton(
                        icon: Icons.add_shopping_cart,
                        label: 'Add Inventory',
                        onTap: () {
                          // Navigate to add inventory
                        },
                      ),
                      _buildQuickActionButton(
                        icon: Icons.receipt_long,
                        label: 'Generate Report',
                        onTap: () {
                          // Navigate to reports
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          
          // Pending Prescriptions
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
                        'Pending Prescriptions',
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
                  _buildPendingPrescriptionsList(),
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

  Widget _buildPendingPrescriptionsList() {
    // This would be replaced with actual prescription data from a repository
    final prescriptions = [
      _PrescriptionData(
        patientName: 'John Smith',
        doctorName: 'Dr. Wilson',
        date: 'Today, 10:30 AM',
        medications: 3,
        priority: 'High',
      ),
      _PrescriptionData(
        patientName: 'Sarah Johnson',
        doctorName: 'Dr. Martinez',
        date: 'Today, 11:45 AM',
        medications: 2,
        priority: 'Medium',
      ),
      _PrescriptionData(
        patientName: 'Michael Brown',
        doctorName: 'Dr. Wilson',
        date: 'Today, 01:15 PM',
        medications: 1,
        priority: 'Low',
      ),
      _PrescriptionData(
        patientName: 'Emily Davis',
        doctorName: 'Dr. Lee',
        date: 'Yesterday, 04:30 PM',
        medications: 4,
        priority: 'High',
      ),
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3, // Show only first 3
      itemBuilder: (context, index) {
        final prescription = prescriptions[index];
        
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              child: Text(prescription.patientName[0]),
            ),
            title: Text(prescription.patientName),
            subtitle: Text('${prescription.doctorName} • ${prescription.date}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Chip(
                  label: Text(
                    '${prescription.medications} meds',
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  backgroundColor: Colors.grey.shade200,
                ),
                const SizedBox(width: 8),
                Chip(
                  label: Text(
                    prescription.priority,
                    style: TextStyle(
                      color: _getPriorityColor(prescription.priority)[1],
                      fontSize: 12,
                    ),
                  ),
                  backgroundColor: _getPriorityColor(prescription.priority)[0],
                ),
              ],
            ),
            onTap: () {
              // Navigate to prescription details
            },
          ),
        );
      },
    );
  }

  List<Color> _getPriorityColor(String priority) {
    switch (priority) {
      case 'High':
        return [Colors.red.shade100, Colors.red.shade900];
      case 'Medium':
        return [Colors.orange.shade100, Colors.orange.shade900];
      case 'Low':
        return [Colors.green.shade100, Colors.green.shade900];
      default:
        return [Colors.grey.shade100, Colors.grey.shade900];
    }
  }

  Widget _buildInventoryTab() {
    return const Center(
      child: Text('Inventory Tab - To be implemented'),
    );
  }

  Widget _buildPrescriptionsTab() {
    return const Center(
      child: Text('Prescriptions Tab - To be implemented'),
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
          icon: Icon(Icons.inventory_2),
          label: 'Inventory',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.medical_services),
          label: 'Prescriptions',
        ),
      ],
    );
  }
}

class _PrescriptionData {
  final String patientName;
  final String doctorName;
  final String date;
  final int medications;
  final String priority;

  _PrescriptionData({
    required this.patientName,
    required this.doctorName,
    required this.date,
    required this.medications,
    required this.priority,
  });
}
