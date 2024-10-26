import "package:easy_localization/easy_localization.dart";
import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:quickalert/models/quickalert_type.dart";
import "package:quickalert/widgets/quickalert_dialog.dart";

import "../../../config/routes/routes.dart";
import "../../../core/models/auth/login/login_request.types.dart";
import "../../../core/models/auth/sign_up/sign_up.request.types.dart";
import "../../../core/notifiers/auth/login_notifier.dart";
import "../../../core/notifiers/auth/sign_up.notifier.dart";
import "../../../layout/scrollable_layout.dart";
import "../../../shared/widgets/global/button.dart";
import "../../../shared/widgets/global/header/icon_header.dart";

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
//final AutoDisposeStateProvider<String> phoneProvider =
//    StateProvider.autoDispose<String>(
//        (AutoDisposeStateProviderRef<String> ref) => "");
final AutoDisposeStateProvider<bool> confirmPasswordVisibilityProvider =
    StateProvider.autoDispose<bool>(
        (AutoDisposeStateProviderRef<bool> ref) => false);
//final AutoDisposeStateProvider<String> countryCodeProvider =
//    StateProvider.autoDispose<String>(
//        (AutoDisposeStateProviderRef<String> ref) => "+51");
final AutoDisposeStateProvider<List<bool>> passwordValidationProvider =
    StateProvider.autoDispose<List<bool>>(
        (AutoDisposeStateProviderRef<List<bool>> ref) =>
            <bool>[false, false, false, false, false]);
final GlobalKey<FormState> formKey = GlobalKey<FormState>();

final AutoDisposeStateProvider<bool> isLoadingProvider =
    StateProvider.autoDispose<bool>(
        (AutoDisposeStateProviderRef<bool> ref) => false);

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
  final String confirmPassword =
      ref.read(confirmPasswordProvider.notifier).state;
  return password.isNotEmpty && password == confirmPassword;
}

bool isValidName(String name) {
  const Pattern pattern = r"^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$";
  final RegExp regex = RegExp(pattern.toString());
  return regex.hasMatch(name.trim());
}

bool isValidLastName(String lastName) {
  const Pattern pattern = r"^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$";
  final RegExp regex = RegExp(pattern.toString());
  return regex.hasMatch(lastName.trim());
}

bool isValidPhone(String phone) {
  const Pattern pattern = r"^(?:[+0]9)?[0-9]+$";
  final RegExp regex = RegExp(pattern.toString());
  return regex.hasMatch(phone);
}

bool isFormValid(WidgetRef ref) {
  final List<bool> validations = ref.read(passwordValidationProvider);
  final bool allPasswordValidations =
      validations.every((bool element) => element);
  final bool emailValid = isValidEmail(ref.read(emailProvider));
  final bool passwordConfirmed = isPasswordConfirmed(ref);
  final bool nameValid = isValidName(ref.read(nameProvider));
  final bool lastNameValid = isValidLastName(ref.read(lastNameProvider));
  //final bool phoneValid = isValidPhone(ref.read(phoneProvider));

  return allPasswordValidations &&
      emailValid &&
      passwordConfirmed &&
      nameValid &&
      lastNameValid;
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
        borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide:
            BorderSide(color: Theme.of(context).colorScheme.error, width: 2),
      ),
    );
  }
}

SignUpRequest buildSignUpRequest(WidgetRef ref) {
  return SignUpRequest(
      email: ref.read(emailProvider),
      password: ref.read(passwordProvider),
      names: ref.read(nameProvider),
      lastNames: ref.read(lastNameProvider),
      role: "CLIENT");
}

class SignUpScreen extends ConsumerWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context); // Obtiene el tema actual

    final bool isLoading = ref.watch(isLoadingProvider);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: ScrollableLayout(
        backgroundColor: theme.colorScheme.surface,
        header: CBaseIconHeader(
          height: 200,
          headerKey: "sign_up",
          onButtonPressed: (BuildContext context) {
            GoRouter.of(context).push(AppRoutes.accessOptions);
          },
        ),
        body: _buildSignUpForm(context, ref, theme),
        isLoading: isLoading,
      ),
    );
  }

  Widget _buildSignUpForm(
      BuildContext context, WidgetRef ref, ThemeData theme) {
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
    //const String labelPhoneKey = "Auth.labels.PHONE.label";
    //const String validatorPhoneKey = "Auth.labels.PHONE.validator";
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
    //const String labelPhoneCodeKey = "Auth.labels.PHONE_CODE.label";

    const String labelSignUpDialogSuccess =
        "Auth.dialogs.SUCCESS_REGISTER.label";
    const String labelSignUpDialogError = "Auth.dialogs.ERROR.label";
    const String labelSignUpDialogValidation = "Auth.dialogs.VALIDATION.label";

    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Container(
        color: theme.colorScheme.surface,
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 40),
            TextFormField(
              initialValue: ref.watch(nameProvider),
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
              initialValue: ref.watch(lastNameProvider),
              onChanged: (String value) =>
                  ref.read(lastNameProvider.notifier).state = value,
              decoration: CustomInputDecoration.getTextFieldDecoration(
                label: labelLastNameKey,
                context: context,
              ),
              validator: (String? value) =>
                  validateField(value, isValidLastName, validatorLastNameKey),
            ),
            const SizedBox(height: 10),
            TextFormField(
              initialValue: ref.watch(emailProvider),
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
                    color: theme.colorScheme.primary,
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
                validatorPasswordKey,
              ),
            ),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children:
                  validations.asMap().entries.map((MapEntry<int, bool> entry) {
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
              initialValue: ref.watch(confirmPasswordProvider),
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
                      .state = !ref.watch(confirmPasswordVisibilityProvider),
                ),
              ),
              obscureText: !ref.watch(confirmPasswordVisibilityProvider),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return null;
                }
                final String password =
                    ref.read(passwordProvider.notifier).state;
                return password == value
                    ? null
                    : validatorConfirmPasswordKey.tr();
              },
            ),
            const SizedBox(height: 20),
            BaseButton(
              label: labelSignUpKey.tr(),
              onPressed: () {
                if (formKey.currentState!.validate() && isFormValid(ref)) {
                  final SignUpRequest requestData = buildSignUpRequest(ref);
                  ref
                      .read(signUpNotifierProvider.notifier)
                      .performAction(requestData, () {
                    ref.read(isLoadingProvider.notifier).state = true;
                  }, (String successMessage) {
                    ref.read(isLoadingProvider.notifier).state = false;

                    final LoginRequest loginRequest = LoginRequest(
                      email: ref.read(emailProvider),
                      password: ref.read(passwordProvider),
                    );

                    ref
                        .read(logInNotifierProvider.notifier)
                        .performAction(loginRequest, () {
                      ref.read(isLoadingProvider.notifier).state = true;
                    }, (String loginSuccessMessage) {
                      ref.read(isLoadingProvider.notifier).state = false;
                      QuickAlert.show(
                        context: context,
                        type: QuickAlertType.success,
                        title: "",
                        text: labelSignUpDialogSuccess.tr(),
                        barrierDismissible: false,
                        onConfirmBtnTap: () {
                          GoRouter.of(context).push(AppRoutes.tabScreen);
                        },
                      ).then((_) {
                        GoRouter.of(context).push(AppRoutes.tabScreen);
                      });
                    }, (String loginErrorMessage) {
                      ref.read(isLoadingProvider.notifier).state = false;
                      QuickAlert.show(
                        context: context,
                        type: QuickAlertType.error,
                        text: loginErrorMessage,
                        barrierDismissible: false,
                        onConfirmBtnTap: () {
                          GoRouter.of(context).push(AppRoutes.tabScreen);
                        },
                      ).then((_) {
                        GoRouter.of(context).push(AppRoutes.tabScreen);
                      });
                    });
                  }, (String errorMessage) {
                    ref.read(isLoadingProvider.notifier).state = false;
                    QuickAlert.show(
                      context: context,
                      type: QuickAlertType.error,
                      text: errorMessage,
                      barrierDismissible: false,
                      onConfirmBtnTap: () {
                        Navigator.of(context).pop();
                      },
                    );
                  });
                } else {
                  QuickAlert.show(
                    context: context,
                    type: QuickAlertType.error,
                    text: labelSignUpDialogValidation.tr(),
                    barrierDismissible: false,
                    onConfirmBtnTap: () {
                      Navigator.of(context).pop();
                    },
                  );
                }
              },
            ),
            const SizedBox(height: 30),
            Align(
              alignment: Alignment.bottomRight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(labelAlreadyHaveAccountKey.tr(),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.grey)),
                  TextButton(
                    onPressed: () => context.push(AppRoutes.logIn),
                    child: Text(
                      labelLoginKey.tr(),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30)
          ],
        ),
      ),
    );
  }
}
