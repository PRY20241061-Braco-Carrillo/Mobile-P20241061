import "package:flutter/material.dart";
import "../../../../utils/constants/size_unit.types.dart";

abstract class SizeSelectable {
  Widget buildWidget();
}

extension SizeByPiecesSelectable on ISizeByPieces {
  Widget buildWidget() {
    return Slider(
      value: portion.toDouble(),
      onChanged: (double newVal) {},
      min: 1,
      max: 10,
      divisions: 10,
      label: description,
    );
  }
}

extension SizeByWeightSelectable on ISizeByWeight {
  Widget buildWidget() {
    return Slider(
      value: weight.toDouble(),
      onChanged: (double newVal) {},
      max: 1000,
      divisions: 100,
      label: '$weight ${unit.toString().split('.').last}',
    );
  }
}

extension SizeByVolumeSelectable on ISizeByVolume {
  Widget buildWidget() {
    return Slider(
      value: volume.toDouble(),
      onChanged: (double newVal) {},
      max: 2000,
      divisions: 100,
      label: '$volume ${unit.toString().split('.').last}',
    );
  }
}

extension SizeByDescriptionSelectable on ISizeByDescription {
  Widget buildWidget() {
    // Implementar una lógica específica si se necesita un widget diferente para descripción
    // Aquí usamos un ejemplo básico
    return Text(description.toString().split(".").last);
  }
}

class SizeSelectorWidget extends StatelessWidget {
  final SizeSelectable sizeModel;

  const SizeSelectorWidget({super.key, required this.sizeModel});

  @override
  Widget build(BuildContext context) {
    return sizeModel.buildWidget();
  }
}
