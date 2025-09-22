part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const HOME = _Paths.HOME;
  static const USERS = _Paths.USERS;
  static const DASHBOARD = _Paths.DASHBOARD;
  static const CALCULATOR = _Paths.CALCULATOR;
}

abstract class _Paths {
  _Paths._();
  static const HOME = '/';
  static const USERS = '/users';
  static const DASHBOARD = '/dashboard';
  static const CALCULATOR = '/calculator';
}