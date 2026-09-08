String ? basicValidator(String ? value) {
  return value?.trim().isNotEmpty != true ? "Preencha o campo corretamente" : null;
}

String ? phoneValidator(String ? value) {
  final String ? cleanedValue = value?.trim();

  if (cleanedValue == null || cleanedValue.isEmpty) {
    return "Preencha o campo corretamente";
  }
  
  final String onlyNumbers = cleanedValue.replaceAll(RegExp(r"[^\d]"), "");
  
  if (onlyNumbers.length < 10 || onlyNumbers.length > 11) {
    return "Número inválido";
  }
  
  return null;
}
