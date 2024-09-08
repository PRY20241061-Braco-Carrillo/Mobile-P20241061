import "package:easy_localization/easy_localization.dart";
import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:go_router/go_router.dart";

import "../../../config/routes/routes.dart";

class AccessOptionsScreen extends StatefulWidget {
  const AccessOptionsScreen({super.key});

  @override
  AccessOptionsScreenState createState() => AccessOptionsScreenState();
}

class AccessOptionsScreenState extends State<AccessOptionsScreen> {
  @override
  Widget build(BuildContext context) {
    // final String labelGuest = "OnBoarding.buttons.START_GUESS.label".tr();
    final String labelLogIn = "OnBoarding.buttons.LOG_IN.label".tr();
    final String labelSignUp = "OnBoarding.buttons.SIGN_UP.label".tr();

    return Scaffold(
      body: Column(
        children: <Widget>[
          const SizedBox(height: 80),
          Expanded(
            flex: 3,
            child: SvgPicture.asset("assets/images/onboarding/onboarding_4.svg",
                height: 200),
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                Text("Smartaste",
                    style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.secondary)),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () => context.push(AppRoutes.logIn),
                  child: Text(labelLogIn,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground)),
                ),
                Container(
                  color: Colors.grey,
                  width: 2,
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () => context.push(AppRoutes.signUp),
                  child: Text(labelSignUp,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
