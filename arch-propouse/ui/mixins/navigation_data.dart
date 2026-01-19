class NavigationData {
  String route;
  bool clear;
  dynamic arguments;
  bool navigationBack;

  NavigationData({
    required this.route,
    required this.clear,
    this.arguments,
    this.navigationBack = false,
  });
}
