/// Centralized reference to every image asset used across the app.
///
/// Keep all asset paths here so screens never hardcode raw strings and
/// renaming/moving a file only requires updating one place.
class AppAssets {
  AppAssets._();

  static const String _imagesPath = 'assets/images';

  static const String logo = '$_imagesPath/logo.png';
  static const String sportoLogo = '$_imagesPath/sporto_logo.png';
}
