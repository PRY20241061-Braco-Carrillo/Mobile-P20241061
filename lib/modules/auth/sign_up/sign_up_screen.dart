import "../../../layout/scrollable_layout.dart";
import "../../../shared/widgets/global/header/header.types.dart";
import "../../../shared/widgets/global/header/icon_header.dart";
import "package:easy_localization/easy_localization.dart";
import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

final AutoDisposeStateProvider<String> emailProvider =
    StateProvider.autoDispose<String>(
        (AutoDisposeStateProviderRef<String> ref) => "");
final AutoDisposeStateProvider<String> passwordProvider =
    StateProvider.autoDispose<String>(
        (AutoDisposeStateProviderRef<String> ref) => "");
final AutoDisposeStateProvider<bool> passwordVisibilityProvider =
    StateProvider.autoDispose<bool>(
        (AutoDisposeStateProviderRef<bool> ref) => false);
final AutoDisposeStateProvider<String> confirmPasswordProvider =
    StateProvider.autoDispose<String>(
        (AutoDisposeStateProviderRef<String> ref) => "");
final AutoDisposeStateProvider<String> nameProvider =
    StateProvider.autoDispose<String>(
        (AutoDisposeStateProviderRef<String> ref) => "");
final AutoDisposeStateProvider<String> lastNameProvider =
    StateProvider.autoDispose<String>(
        (AutoDisposeStateProviderRef<String> ref) => "");
final AutoDisposeStateProvider<String> phoneProvider =
    StateProvider.autoDispose<String>(
        (AutoDisposeStateProviderRef<String> ref) => "");
final AutoDisposeStateProvider<bool> confirmPasswordVisibilityProvider =
    StateProvider.autoDispose<bool>(
        (AutoDisposeStateProviderRef<bool> ref) => false);
final AutoDisposeStateProvider<String> countryCodeProvider =
    StateProvider.autoDispose<String>(
        (AutoDisposeStateProviderRef<String> ref) => "+51");
final AutoDisposeStateProvider<List<bool>> passwordValidationProvider =
    StateProvider.autoDispose<List<bool>>(
        (AutoDisposeStateProviderRef<List<bool>> ref) =>
            <bool>[false, false, false, false, false]);
final GlobalKey<FormState> formKey = GlobalKey<FormState>();

String? validateField(
    String? value, bool Function(String value) isValid, String message) {
  if (value == null || value.isEmpty) {
    return null;
  } else {
    return isValid(value) ? null : message.tr();
  }
}

bool isValidEmail(String email) {
  const Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  final RegExp regex = RegExp(pattern.toString());
  return regex.hasMatch(email);
}

bool isValidPassword(String password, String email) {
  final bool hasUpperCase = password.contains(RegExp(r"[A-Z]"));
  final bool hasLowerCase = password.contains(RegExp(r"[a-z]"));
  final bool hasDigits = password.contains(RegExp(r"\d"));
  final bool hasMinLength = password.length >= 6;
  final bool isNotEmail = password != email;

  return hasUpperCase &&
      hasLowerCase &&
      hasDigits &&
      hasMinLength &&
      isNotEmail;
}

void updatePasswordValidations(WidgetRef ref, String password, String email) {
  final bool hasUpperCase = password.contains(RegExp(r"[A-Z]"));
  final bool hasLowerCase = password.contains(RegExp(r"[a-z]"));
  final bool hasDigits = password.contains(RegExp(r"\d"));
  final bool hasMinLength = password.length >= 6;
  final bool isNotEmail = password != email;
  ref.read(passwordValidationProvider.notifier).state = <bool>[
    hasUpperCase,
    hasLowerCase,
    hasDigits,
    hasMinLength,
    isNotEmail
  ];
}

bool isPasswordConfirmed(WidgetRef ref) {
  final String password = ref.read(passwordProvider.notifier).state;
  final String confirmPassword = ref.read(confirmPasswordProvider.notifier).state;
  return password.isNotEmpty && password == confirmPassword;
}

bool isValidName(String name) {
  return name.trim().isNotEmpty;
}

bool isValidLastName(String lastName) {
  return lastName.trim().isNotEmpty;
}

bool isValidPhone(String phone) {
  const Pattern pattern = r"^(?:[+0]9)?[0-9]+$";
  final RegExp regex = RegExp(pattern.toString());
  return regex.hasMatch(phone);
}

bool isFormValid(WidgetRef ref) {
  final List<bool> validations = ref.read(passwordValidationProvider.notifier).state;
  return validations.every((bool element) => element) &&
      isValidEmail(ref.read(emailProvider.notifier).state) &&
      isPasswordConfirmed(ref) &&
      isValidName(ref.read(nameProvider.notifier).state) &&
      isValidLastName(ref.read(lastNameProvider.notifier).state) &&
      isValidPhone(ref.read(phoneProvider.notifier).state);
}

class CustomInputDecoration {
  static InputDecoration getTextFieldDecoration({
    required String label,
    Widget? suffixIcon,
    required BuildContext context,
  }) {
    return InputDecoration(
      labelText: label.tr(),
      suffixIcon: suffixIcon,
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      contentPadding:
          const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide:
            BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
      ),
      labelStyle: TextStyle(
          fontSize: 12, color: Theme.of(context).colorScheme.onSurface),
      errorStyle:
          TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.error),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide:
            BorderSide(color: Theme.of(context).colorScheme.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide:
            BorderSide(color: Theme.of(context).colorScheme.error, width: 2),
      ),
    );
  }
}

class SignUpScreen extends ConsumerWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String email = ref.watch(emailProvider);
    final String password = ref.watch(passwordProvider);
    final List<bool> validations = ref.watch(passwordValidationProvider);
    const String labelSignUpKey = "Auth.buttons.SIGNUP.label";
    const String labelNameKey = "Auth.labels.NAME.label";
    const String validatorNameKey = "Auth.labels.NAME.validator";
    const String labelLastNameKey = "Auth.labels.LAST_NAME.label";
    const String validatorLastNameKey = "Auth.labels.LASTNAME.validator";
    const String labelEmailKey = "Auth.labels.EMAIL.label";
    const String validatorEmailKey = "Auth.labels.EMAIL.validator";
    const String labelPhoneKey = "Auth.labels.PHONE.label";
    const String validatorPhoneKey = "Auth.labels.PHONE.validator";
    const String labelPasswordKey = "Auth.labels.PASSWORD.label";
    const String validatorPasswordKey = "Auth.labels.PASSWORD.validator";
    const String validatorUpperKey = "Auth.labels.PASSWORD.uppercase";
    const String validatorLowerKey = "Auth.labels.PASSWORD.lowercase";
    const String validatorDigitKey = "Auth.labels.PASSWORD.number";
    const String validatorLengthKey = "Auth.labels.PASSWORD.length";
    const String validatorNotEmailKey = "Auth.labels.PASSWORD.not_email";
    const String labelConfirmPasswordKey = "Auth.labels.CONFIRM_PASSWORD.label";
    const String validatorConfirmPasswordKey =
        "Auth.labels.CONFIRM_PASSWORD.validator";
    const String labelLoginKey = "Auth.buttons.LOGIN.label";
    const String labelAlreadyHaveAccountKey =
        "Auth.buttons.ALREADY_HAVE_ACCOUNT.label";
    const String labelPhoneCodeKey = "Auth.labels.PHONE_CODE.label";

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: ScrollableLayout(
        header: CBaseIconHeader(
            height: 200,
            data: HeaderIconData(title: labelSignUpKey.tr(), isAsset: true)),
        body: Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 40),
                TextFormField(
                  initialValue: ref.read(nameProvider),
                  onChanged: (String value) =>
                      ref.read(nameProvider.notifier).state = value,
                  decoration: CustomInputDecoration.getTextFieldDecoration(
                    label: labelNameKey,
                    context: context,
                  ),
                  validator: (String? value) =>
                      validateField(value, isValidName, validatorNameKey),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  initialValue: ref.read(lastNameProvider),
                  onChanged: (String value) =>
                      ref.read(lastNameProvider.notifier).state = value,
                  decoration: CustomInputDecoration.getTextFieldDecoration(
                    label: labelLastNameKey,
                    context: context,
                  ),
                  validator: (String? value) => validateField(
                      value, isValidLastName, validatorLastNameKey),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  initialValue: email,
                  onChanged: (String value) =>
                      ref.read(emailProvider.notifier).state = value,
                  decoration: CustomInputDecoration.getTextFieldDecoration(
                    label: labelEmailKey,
                    context: context,
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (String? value) =>
                      validateField(value, isValidEmail, validatorEmailKey),
                ),
                const SizedBox(height: 10),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        initialValue: ref.read(countryCodeProvider),
                        onChanged: (String value) => ref
                            .read(countryCodeProvider.notifier)
                            .state = value,
                        decoration:
                            CustomInputDecoration.getTextFieldDecoration(
                          label: labelPhoneCodeKey,
                          context: context,
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        initialValue: ref.read(phoneProvider),
                        onChanged: (String value) =>
                            ref.read(phoneProvider.notifier).state = value,
                        decoration:
                            CustomInputDecoration.getTextFieldDecoration(
                          label: labelPhoneKey,
                          context: context,
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (String? value) => validateField(
                            value, isValidPhone, validatorPhoneKey),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextFormField(
                  initialValue: password,
                  onChanged: (String value) {
                    ref.read(passwordProvider.notifier).state = value;
                    updatePasswordValidations(ref, value, email);
                  },
                  decoration: CustomInputDecoration.getTextFieldDecoration(
                    label: labelPasswordKey,
                    context: context,
                    suffixIcon: IconButton(
                      icon: Icon(
                        ref.watch(passwordVisibilityProvider)
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      onPressed: () => ref
                          .read(passwordVisibilityProvider.notifier)
                          .state = !ref.read(passwordVisibilityProvider),
                    ),
                  ),
                  obscureText: !ref.watch(passwordVisibilityProvider),
                  keyboardType: TextInputType.visiblePassword,
                  validator: (String? value) => validateField(
                      value,
                      (String value) => isValidPassword(value, email),
                      validatorPasswordKey),
                ),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: validations.asMap().entries.map((MapEntry<int, bool> entry) {
                    String text;
                    switch (entry.key) {
                      case 0:
                        text = validatorUpperKey.tr();
                        break;
                      case 1:
                        text = validatorLowerKey.tr();
                        break;
                      case 2:
                        text = validatorDigitKey.tr();
                        break;
                      case 3:
                        text = validatorLengthKey.tr();
                        break;
                      case 4:
                        text = validatorNotEmailKey.tr();
                        break;
                      default:
                        text = "";
                    }
                    return Container(
                      margin: const EdgeInsets.only(top: 2.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(
                            entry.value
                                ? Icons.check_box
                                : Icons.check_box_outline_blank,
                            size: 16.0,
                            color: entry.value
                                ? Theme.of(context).primaryColor
                                : Colors.grey,
                          ),
                          const SizedBox(width: 4.0),
                          Text(
                            text,
                            style: const TextStyle(fontSize: 12.0),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  initialValue: ref.read(confirmPasswordProvider),
                  onChanged: (String value) =>
                      ref.read(confirmPasswordProvider.notifier).state = value,
                  decoration: CustomInputDecoration.getTextFieldDecoration(
                    label: labelConfirmPasswordKey,
                    context: context,
                    suffixIcon: IconButton(
                      icon: Icon(
                        ref.watch(confirmPasswordVisibilityProvider)
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      onPressed: () => ref
                              .read(confirmPasswordVisibilityProvider.notifier)
                              .state =
                          !ref.watch(confirmPasswordVisibilityProvider),
                    ),
                  ),
                  obscureText: !ref.watch(confirmPasswordVisibilityProvider),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return null;
                    }
                    final String password = ref.read(passwordProvider.notifier).state;
                    return password == value
                        ? null
                        : validatorConfirmPasswordKey;
                  },
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  onPressed: isFormValid(ref)
                      ? () {
                          if (formKey.currentState!.validate()) {
                            // Handle valid form
                          }
                        }
                      : null,
                  child: Text(labelSignUpKey.tr().toUpperCase(),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20)),
                ),
                const SizedBox(height: 70),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(labelAlreadyHaveAccountKey.tr(),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.grey)),
                      Text(labelLoginKey.tr(),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              color: Colors.black)),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
