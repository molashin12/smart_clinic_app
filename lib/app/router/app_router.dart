import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_clinic_app/presentation/blocs/auth/auth_bloc.dart';
import 'package:smart_clinic_app/presentation/screens/auth/login_screen.dart';
import 'package:smart_clinic_app/presentation/screens/auth/register_screen.dart';
import 'package:smart_clinic_app/presentation/screens/dashboard/doctor_dashboard_screen.dart';
import 'package:smart_clinic_app/presentation/screens/dashboard/nurse_dashboard_screen.dart';
import 'package:smart_clinic_app/presentation/screens/dashboard/receptionist_dashboard_screen.dart';
import 'package:smart_clinic_app/presentation/screens/dashboard/pharmacist_dashboard_screen.dart';
import 'package:smart_clinic_app/presentation/screens/splash_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    routes: [
      // Splash and Auth Routes
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      
      // Dashboard Routes based on role
      GoRoute(
        path: '/doctor-dashboard',
        builder: (context, state) => const DoctorDashboardScreen(),
      ),
      GoRoute(
        path: '/nurse-dashboard',
        builder: (context, state) => const NurseDashboardScreen(),
      ),
      GoRoute(
        path: '/receptionist-dashboard',
        builder: (context, state) => const ReceptionistDashboardScreen(),
      ),
      GoRoute(
        path: '/pharmacist-dashboard',
        builder: (context, state) => const PharmacistDashboardScreen(),
      ),
    ],
    redirect: (context, state) {
      final authState = context.read<AuthBloc>().state;
      final isAuthenticated = authState is Authenticated;
      final isAuthRoute = state.matchedLocation == '/login' || 
                          state.matchedLocation == '/register';
      
      // If the user is on the splash screen, allow it
      if (state.matchedLocation == '/') {
        return null;
      }
      
      // If not authenticated and not on an auth route, redirect to login
      if (!isAuthenticated && !isAuthRoute) {
        return '/login';
      }
      
      // If authenticated and on an auth route, redirect to appropriate dashboard
      if (isAuthenticated && isAuthRoute) {
        final user = (authState as Authenticated).user;
        switch (user.role) {
          case 'doctor':
            return '/doctor-dashboard';
          case 'nurse':
            return '/nurse-dashboard';
          case 'receptionist':
            return '/receptionist-dashboard';
          case 'pharmacist':
            return '/pharmacist-dashboard';
          default:
            return '/doctor-dashboard';
        }
      }
      
      // No redirection needed
      return null;
    },
  );
}
