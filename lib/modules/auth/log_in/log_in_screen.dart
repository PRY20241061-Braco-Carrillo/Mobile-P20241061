import "../../../layout/scrollable_layout.dart";
import "../sign_up/sign_up_screen.dart";
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
final GlobalKey<FormState> formKey = GlobalKey<FormState>();

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

class LogInScreen extends ConsumerWidget {
  const LogInScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String email = ref.watch(emailProvider);
    final String password = ref.watch(passwordProvider);
    final bool passwordVisible = ref.watch(passwordVisibilityProvider);

    const String labelEmailKey = "Auth.labels.EMAIL.label";
    const String validatorNameKey = "Auth.labels.NAME.validator";
    const String labelPasswordKey = "Auth.labels.PASSWORD.label";
    const String validatorConfirmPasswordKey =
        "Auth.labels.CONFIRM_PASSWORD.validator";
    const String labelLoginKey = "Auth.buttons.LOGIN.label";
    const String labelSignUpKey = "Auth.buttons.SIGNUP.label";
    const String labelDontHaveAccountKey =
        "Auth.buttons.DONT_HAVE_ACCOUNT.label";

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: ScrollableLayout(
        header: CBaseIconHeader(
            height: 200, data: HeaderIconData(title: "Log In", isAsset: true)),
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
                  initialValue: email,
                  onChanged: (String value) =>
                      ref.read(emailProvider.notifier).state = value,
                  decoration: CustomInputDecoration.getTextFieldDecoration(
                    label: labelEmailKey,
                    context: context,
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (String? value) =>
                      validateField(value, isValidName, validatorNameKey),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  initialValue: password,
                  onChanged: (String value) =>
                      ref.read(passwordProvider.notifier).state = value,
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
                  obscureText: !passwordVisible,
                  keyboardType: TextInputType.visiblePassword,
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return null;
                    }
                    final String password =
                        ref.read(passwordProvider.notifier).state;
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
                  onPressed: () {
                    if (formKey.currentState!.validate()) {}
                  },
                  child: Text(labelLoginKey.tr().toUpperCase(),
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
                      Text(labelDontHaveAccountKey.tr(),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.grey)),
                      Text(labelSignUpKey.tr(),
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
