class PyramidSettings {
  final double initialUnit;
  final double layer1Multiplier;
  final double layer2Multiplier;
  final double layer3Multiplier;
  final double layer4Multiplier;
  final double tiePenalty;

  const PyramidSettings({
    this.initialUnit = 1,
    this.layer1Multiplier = 4,
    this.layer2Multiplier = 3,
    this.layer3Multiplier = 2,
    this.layer4Multiplier = 1,
    this.tiePenalty = 2,
  });

  PyramidSettings copyWith({
    double? initialUnit,
    double? layer1Multiplier,
    double? layer2Multiplier,
    double? layer3Multiplier,
    double? layer4Multiplier,
    double? tiePenalty,
  }) {
    return PyramidSettings(
      initialUnit: initialUnit ?? this.initialUnit,
      layer1Multiplier: layer1Multiplier ?? this.layer1Multiplier,
      layer2Multiplier: layer2Multiplier ?? this.layer2Multiplier,
      layer3Multiplier: layer3Multiplier ?? this.layer3Multiplier,
      layer4Multiplier: layer4Multiplier ?? this.layer4Multiplier,
      tiePenalty: tiePenalty ?? this.tiePenalty,
    );
  }

  int multiplierForLayer(int layerIndex) {
    switch (layerIndex) {
      case 0:
        return layer1Multiplier.toInt();
      case 1:
        return layer2Multiplier.toInt();
      case 2:
        return layer3Multiplier.toInt();
      case 3:
        return layer4Multiplier.toInt();
      default:
        return 1;
    }
  }
}
