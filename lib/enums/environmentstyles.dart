enum EnvironmentStyle { AUTOMATIC, LIGHT, DARK }

extension DeepwallEnvironmentStyle on EnvironmentStyle {
  static const values = {
    EnvironmentStyle.AUTOMATIC: -7,
    EnvironmentStyle.LIGHT: 0,
    EnvironmentStyle.DARK: 1,
  };

  int get value => values[this];
}
