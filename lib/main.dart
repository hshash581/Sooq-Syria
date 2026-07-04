import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'core/config/app_config.dart';
import 'core/config/routes_config.dart';
import 'core/services/firebase_service.dart';
import 'core/services/local_storage_service.dart';
import 'core/services/connectivity_service.dart';
import 'core/theme/app_theme.dart';
import 'features/settings/presentation/bloc/settings_bloc.dart';
import 'features/settings/presentation/bloc/settings_state.dart';
import 'features/settings/presentation/bloc/settings_event.dart';
import 'features/settings/data/repositories/settings_repository_impl.dart';
import 'features/settings/data/datasources/settings_local_data_source.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_state.dart';
import 'features/auth/presentation/bloc/auth_event.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FirebaseService().initialize();
  await LocalStorageService().initialize();
  await ConnectivityService().initialize();

  FlutterNativeSplash.remove();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const SooqSyriaApp());
}

class SooqSyriaApp extends StatelessWidget {
  const SooqSyriaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SettingsBloc>(
          create: (_) {
            final settingsRepo = SettingsRepositoryImpl(
              localDataSource: SettingsLocalDataSource(),
            );
            return SettingsBloc(settingsRepository: settingsRepo)
              ..add(const LoadSettings());
          },
        ),
        BlocProvider<AuthBloc>(
          create: (_) {
            final authRepo = AuthRepositoryImpl(
              remoteDataSource: AuthRemoteDataSource(),
            );
            final bloc = AuthBloc(authRepository: authRepo);
            bloc.stream.listen((state) {
              AppRouter.updateAuthState(state is Authenticated);
            });
            bloc.add(const CheckAuthStatus());
            return bloc;
          },
        ),
      ],
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          final themeMode = state is SettingsLoaded
              ? state.themeMode
              : ThemeMode.light;
          return MaterialApp.router(
            title: AppConfig.appName,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: themeMode,
            locale: const Locale('ar'),
            supportedLocales: const [Locale('ar')],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }
}
