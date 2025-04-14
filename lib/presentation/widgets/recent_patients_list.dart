import 'package:flutter/material.dart';

class RecentPatientsList extends StatelessWidget {
  const RecentPatientsList({super.key});

  @override
  Widget build(BuildContext context) {
    // This would be replaced with actual patient data from a repository
    final patients = [
      _PatientData(
        name: 'John Smith',
        age: 45,
        lastVisit: '2 days ago',
        condition: 'Hypertension',
      ),
      _PatientData(
        name: 'Sarah Johnson',
        age: 32,
        lastVisit: '1 week ago',
        condition: 'Diabetes Type 2',
      ),
      _PatientData(
        name: 'Michael Brown',
        age: 28,
        lastVisit: 'Yesterday',
        condition: 'Asthma',
      ),
      _PatientData(
        name: 'Emily Davis',
        age: 56,
        lastVisit: '3 days ago',
        condition: 'Arthritis',
      ),
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: patients.length,
      itemBuilder: (context, index) {
        final patient = patients[index];
        
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              child: Text(patient.name[0]),
            ),
            title: Text(patient.name),
            subtitle: Text('${patient.age} years - ${patient.condition}'),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Last visit',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(
                  patient.lastVisit,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            onTap: () {
              // Navigate to patient details
            },
          ),
        );
      },
    );
  }
}

class _PatientData {
  final String name;
  final int age;
  final String lastVisit;
  final String condition;

  _PatientData({
    required this.name,
    required this.age,
    required this.lastVisit,
    required this.condition,
  });
}
