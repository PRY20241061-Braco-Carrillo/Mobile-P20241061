class NutritionalInformationAR {
  final String nutritionalInformationId;
  final int calories;
  final int proteins;
  final int totalFat;
  final int carbohydrates;
  final bool isVegan;
  final bool isVegetarian;
  final bool isLowCalories;
  final bool isHighProtein;
  final bool isWithoutGluten;
  final bool isWithoutNut;
  final bool isWithoutLactose;
  final bool isWithoutEggs;
  final bool isWithoutSeafood;
  final bool isWithoutPig;

  NutritionalInformationAR({
    required this.nutritionalInformationId,
    required this.calories,
    required this.proteins,
    required this.totalFat,
    required this.carbohydrates,
    required this.isVegan,
    required this.isVegetarian,
    required this.isLowCalories,
    required this.isHighProtein,
    required this.isWithoutGluten,
    required this.isWithoutNut,
    required this.isWithoutLactose,
    required this.isWithoutEggs,
    required this.isWithoutSeafood,
    required this.isWithoutPig,
  });

  factory NutritionalInformationAR.fromJson(Map<String, dynamic> json) {
    return NutritionalInformationAR(
      nutritionalInformationId: json['nutritionalInformationId'],
      calories: json['calories'],
      proteins: json['proteins'],
      totalFat: json['totalFat'],
      carbohydrates: json['carbohydrates'],
      isVegan: json['isVegan'],
      isVegetarian: json['isVegetarian'],
      isLowCalories: json['isLowCalories'],
      isHighProtein: json['isHighProtein'],
      isWithoutGluten: json['isWithoutGluten'],
      isWithoutNut: json['isWithoutNut'],
      isWithoutLactose: json['isWithoutLactose'],
      isWithoutEggs: json['isWithoutEggs'],
      isWithoutSeafood: json['isWithoutSeafood'],
      isWithoutPig: json['isWithoutPig'],
    );
  }
}
