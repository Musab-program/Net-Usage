part of 'app_pages.dart';

/// Defines the route names used for navigation.
abstract class Routes {
  Routes._();
  static const SPLASH = _Paths.SPLASH;
  static const HOME = _Paths.HOME;
  static const USERS = _Paths.USERS;
  static const DASHBOARD = _Paths.DASHBOARD;
  static const CALCULATOR = _Paths.CALCULATOR;
}

/// Defines the actual path strings for the routes.
abstract class _Paths {
  _Paths._();
  static const SPLASH = '/splash';
  static const HOME = '/';
  static const USERS = '/users';
  static const DASHBOARD = '/dashboard';
  static const CALCULATOR = '/calculator';
}
