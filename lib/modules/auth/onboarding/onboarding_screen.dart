import "../../../config/routes/routes.dart";
import "../../../core/shared_preferences/services/shared_preferences.service.dart";
import "onboarding_items.dart";
import "package:easy_localization/easy_localization.dart";
import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:go_router/go_router.dart";
import "package:smooth_page_indicator/smooth_page_indicator.dart";

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingScreen> {
  final OnboardingItems controller = OnboardingItems();
  final PageController pageController = PageController();

  bool isLastPage = false;

  @override
  Widget build(BuildContext context) {
    final String labelSkipKey = "OnBoarding.buttons.SKIP.label".tr();
    final String labelNextKey = "OnBoarding.buttons.NEXT.label".tr();

    return Scaffold(
      bottomSheet: Container(
        color: Theme.of(context).colorScheme.primaryContainer,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: isLastPage
            ? getStarted()
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextButton(
                    onPressed: () =>
                        pageController.jumpToPage(controller.items.length - 1),
                    child: Text(labelSkipKey),
                  ),
                  SmoothPageIndicator(
                    controller: pageController,
                    count: controller.items.length,
                    onDotClicked: (int index) => pageController.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.easeIn),
                    effect: WormEffect(
                      dotHeight: 12,
                      dotWidth: 12,
                      activeDotColor: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  TextButton(
                    onPressed: () => pageController.nextPage(
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.easeIn),
                    child: Text(labelNextKey),
                  ),
                ],
              ),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15),
        child: PageView.builder(
          onPageChanged: (int index) =>
              setState(() => isLastPage = index == controller.items.length - 1),
          itemCount: controller.items.length,
          controller: pageController,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SvgPicture.asset(controller.items[index].image, height: 250),
                const SizedBox(height: 15),
                Text(
                  controller.items[index].title,
                  style: const TextStyle(
                      fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),
                Text(
                  controller.items[index].descriptions,
                  style: const TextStyle(color: Colors.grey, fontSize: 17),
                  textAlign: TextAlign.center,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget getStarted() {
    final String labelStartKey = "OnBoarding.buttons.START.label".tr();
    final String labelErrorKey = "OnBoarding.buttons.ERROR.label".tr();
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Theme.of(context).colorScheme.primary,
            ),
            height: 50,
            child: TextButton(
              onPressed: () async {
                final bool success = await SharedPreferencesService.instance
                    .setOnboardingComplete(true);
                if (!mounted) return;
                if (success) {
                  context.go(AppRoutes.accessOptions);
                } else {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(labelErrorKey)));
                }
              },
              child: Text(labelStartKey,
                  style: const TextStyle(color: Colors.white)),
            ),
          ),
        ),
      ],
    );
  }
}
