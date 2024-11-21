class ValidationUtils {
  static String? validateLocation(String location) {
    final trimmedLocation = location.trim();

    if (trimmedLocation.isEmpty) {
      return "Please enter a valid city name.";
    }

    return null;
  }

  static String capitalize(String input) {
    if (input.isEmpty) return input;

    return input[0].toUpperCase() + input.substring(1);
  }
}
