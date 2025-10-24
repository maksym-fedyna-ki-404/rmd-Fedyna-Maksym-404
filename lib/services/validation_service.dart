class ValidationService {
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ім\'я не може бути порожнім';
    }
    
    if (value.length < 2) {
      return 'Ім\'я повинно містити мінімум 2 символи';
    }
    
    if (value.contains(RegExp(r'[0-9]'))) {
      return 'Ім\'я не може містити цифри';
    }
    
    if (value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Ім\'я не може містити спеціальні символи';
    }
    
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email не може бути порожнім';
    }
    
    if (!value.contains('@')) {
      return 'Email повинен містити символ @';
    }
    
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Введіть коректний email';
    }
    
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Пароль не може бути порожнім';
    }
    
    if (value.length < 6) {
      return 'Пароль повинен містити мінімум 6 символів';
    }
    
    if (value.length > 50) {
      return 'Пароль не може містити більше 50 символів';
    }
    
    return null;
  }

  static String? validateConfirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'Підтвердження пароля не може бути порожнім';
    }
    
    if (value != password) {
      return 'Паролі не співпадають';
    }
    
    return null;
  }
}

