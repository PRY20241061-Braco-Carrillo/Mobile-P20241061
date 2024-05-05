final Map<String, String> currencySymbol = <String, String>{
  "USD": "\$",
  "PEN": "S/",
  "EUR": "€",
};

String getCurrencySymbol(String currency) {
  return currencySymbol[currency.toUpperCase()] ?? "";
}
