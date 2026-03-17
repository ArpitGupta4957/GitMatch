class Validators {
  Validators._();

  static String? email(String? value) {
    if (value == null || value.isEmpty) return 'Email is required';
    final regex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w{2,}$');
    if (!regex.hasMatch(value)) return 'Enter a valid email';
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  static String? name(String? value) {
    if (value == null || value.isEmpty) return 'Name is required';
    if (value.length < 2) return 'Name is too short';
    return null;
  }

  static String? url(String? value) {
    if (value == null || value.isEmpty) return null; // optional
    final regex = RegExp(r'^https?://[\w\-]+(\.[\w\-]+)+[/#?]?.*$');
    if (!regex.hasMatch(value)) return 'Enter a valid URL';
    return null;
  }

  static String? username(String? value) {
    if (value == null || value.isEmpty) return 'Username is required';
    final regex = RegExp(r'^[a-zA-Z0-9_\-]+$');
    if (!regex.hasMatch(value)) return 'Only letters, numbers, _ and -';
    return null;
  }

  static String? bio(String? value) {
    if (value != null && value.length > 160) {
      return 'Bio must be 160 characters or less';
    }
    return null;
  }
}
