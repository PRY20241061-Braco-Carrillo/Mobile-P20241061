import "package:flutter/material.dart";

class ScrollableLayout extends StatelessWidget {
  final Widget header;
  final Widget body;
  final Color backgroundColor;
  final double topPadding;
  final double borderRadius;
  final bool isLoading;

  const ScrollableLayout({
    super.key,
    required this.header,
    required this.body,
    this.backgroundColor = Colors.white,
    this.topPadding = 5.0,
    this.borderRadius = 30.0,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          color: Theme.of(context).colorScheme.background,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: header,
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: topPadding,
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(borderRadius),
                      topRight: Radius.circular(borderRadius),
                    ),
                  ),
                  child: body,
                ),
              ),
              SliverFillRemaining(
                hasScrollBody: false,
                fillOverscroll: true,
                child: Container(
                  color: backgroundColor,
                ),
              ),
            ],
          ),
        ),
        if (isLoading) const _LoadingOverlay(),
      ],
    );
  }
}

class _LoadingOverlay extends StatelessWidget {
  const _LoadingOverlay();

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: Colors.black45,
      child: const CircularProgressIndicator(),
    );
  }
}
