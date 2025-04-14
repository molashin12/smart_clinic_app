import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:smart_clinic_app/app/config/firebase_options.dart';
import 'package:smart_clinic_app/app/router/app_router.dart';
import 'package:smart_clinic_app/app/theme/app_theme.dart';
import 'package:smart_clinic_app/data/repositories/auth_repository_impl.dart';
import 'package:smart_clinic_app/data/repositories/clinic_repository_impl.dart';
import 'package:smart_clinic_app/data/repositories/patient_repository_impl.dart';
import 'package:smart_clinic_app/data/repositories/appointment_repository_impl.dart';
import 'package:smart_clinic_app/data/repositories/prescription_repository_impl.dart';
import 'package:smart_clinic_app/data/services/isar_service.dart';
import 'package:smart_clinic_app/data/services/sync_service.dart';
import 'package:smart_clinic_app/domain/repositories/auth_repository.dart';
import 'package:smart_clinic_app/domain/repositories/clinic_repository.dart';
import 'package:smart_clinic_app/domain/repositories/patient_repository.dart';
import 'package:smart_clinic_app/domain/repositories/appointment_repository.dart';
import 'package:smart_clinic_app/domain/repositories/prescription_repository.dart';
import 'package:smart_clinic_app/presentation/blocs/auth/auth_bloc.dart';
import 'package:smart_clinic_app/presentation/providers/theme_provider.dart';

final GetIt getIt = GetIt.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Setup dependency injection
  await setupDependencies();
  
  runApp(const MyApp());
}

Future<void> setupDependencies() async {
  // Services
  final isarService = IsarService();
  await isarService.initialize();
  getIt.registerSingleton<IsarService>(isarService);
  
  // Repositories
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());
  getIt.registerLazySingleton<ClinicRepository>(() => ClinicRepositoryImpl());
  getIt.registerLazySingleton<PatientRepository>(() => PatientRepositoryImpl());
  getIt.registerLazySingleton<AppointmentRepository>(() => AppointmentRepositoryImpl());
  getIt.registerLazySingleton<PrescriptionRepository>(() => PrescriptionRepositoryImpl());
  
  // SyncService with all required dependencies
  getIt.registerLazySingleton<SyncService>(() => SyncService(
    isarService: getIt<IsarService>(),
    authRepository: getIt<AuthRepository>(),
    clinicRepository: getIt<ClinicRepository>(),
    patientRepository: getIt<PatientRepository>(),
    appointmentRepository: getIt<AppointmentRepository>(),
    prescriptionRepository: getIt<PrescriptionRepository>(),
  ));
  
  // Initialize SyncService
  getIt<SyncService>().initialize();
  
  // BLoCs
  getIt.registerFactory(() => AuthBloc(authRepository: getIt<AuthRepository>()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        BlocProvider(create: (_) => getIt<AuthBloc>()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp.router(
            title: 'Smart Clinic Management',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            routerConfig: AppRouter.router,
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
