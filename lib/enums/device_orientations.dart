enum DeviceOrientations { PORTRAIT, LANDSCAPE }

extension DeepwallDeviceOrientations on DeviceOrientations {
  static const values = {
    DeviceOrientations.PORTRAIT: 1,
    DeviceOrientations.LANDSCAPE: 2,
  };

  int? get value => values[this];
}
