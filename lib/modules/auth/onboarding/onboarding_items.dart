import "package:easy_localization/easy_localization.dart";

import 'onboarding.types.dart';

class OnboardingItems {
  List<OnboardingInfo> items = <OnboardingInfo>[
    OnboardingInfo(
        title: tr("onboarding_title_1"),
        descriptions: tr("onboarding_desc_1"),
        image: "assets/images/onboarding/onboarding_1.svg"),
    OnboardingInfo(
        title: tr("onboarding_title_2"),
        descriptions: tr("onboarding_desc_2"),
        image: "assets/images/onboarding/onboarding_2.svg"),
    OnboardingInfo(
        title: tr("onboarding_title_3"),
        descriptions: tr("onboarding_desc_3"),
        image: "assets/images/onboarding/onboarding_3.svg"),
    OnboardingInfo(
        title: tr("onboarding_title_4"),
        descriptions: tr("onboarding_desc_4"),
        image: "assets/images/onboarding/onboarding_4.svg"),
  ];
}
