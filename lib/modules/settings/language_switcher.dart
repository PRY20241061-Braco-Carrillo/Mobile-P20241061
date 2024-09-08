import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LanguageSwitcherWidget extends ConsumerWidget {
  const LanguageSwitcherWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            'Settings.buttons.CHANGE_LANGUAGE.label'.tr(), // Localization key
            style: Theme.of(context).textTheme.bodyText1,
          ),
          DropdownButton<Locale>(
            value: context.locale,
            items: [
              DropdownMenuItem(
                value: const Locale('en', 'US'),
                child: Text('English'),
              ),
              DropdownMenuItem(
                value: const Locale('es', 'ES'),
                child: Text('Español'),
              ),
            ],
            onChanged: (Locale? newLocale) {
              if (newLocale != null) {
                context.setLocale(newLocale);
              }
            },
          ),
        ],
      ),
    );
  }
}
