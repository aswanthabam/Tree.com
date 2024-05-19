import 'package:flutter/material.dart';
import 'package:tree_com/core/theme/app_theme.dart';
import 'package:tree_com/presentation/bloc/user_bloc/user_bloc.dart';
import 'package:tree_com/presentation/pages/capture.dart';
import 'package:tree_com/presentation/pages/home.dart';
import 'package:tree_com/presentation/pages/login.dart';
import 'package:tree_com/presentation/pages/profile.dart';
import 'package:tree_com/presentation/pages/register.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tree_com/presentation/pages/splash_screen.dart';

import 'core/utils/api.dart';
import 'data/datasources/user_data_source.dart';
import 'data/repositories/user_repository.dart';

void main() {
  runApp(MultiBlocProvider(
      providers: [
        BlocProvider<UserBloc>(
          create: (context) => UserBloc(
            repository: UserRepository(
              UserDataSource(
                API(),
              ),
            ),
          ),
        ),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: 'splash_screen',
          theme: AppTheme.lightTheme,
          routes: {
            'register': (context) => const RegisterPage(),
            'login': (context) => const LoginPage(),
            'home': (context) => const HomePage(),
            'profile': (context) => const ProfilePage(),
            'splash_screen': (context) => const SplashScreen(),
            'capture': (context) => const CapturePage(),
          })));
}
