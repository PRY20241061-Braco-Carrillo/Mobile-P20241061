import "package:flutter/material.dart";

class ScrollableLayout extends StatelessWidget {
  final Widget header;
  final Widget body;
  final Color backgroundColor;
  final double topPadding;
  final double borderRadius;
  final bool isLoading;
  final Future<void> Function()? onRefresh;

  const ScrollableLayout({
    super.key,
    required this.header,
    required this.body,
    this.backgroundColor = Colors.white,
    this.topPadding = 5.0,
    this.borderRadius = 30.0,
    this.isLoading = false,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        _buildContent(context),
        if (isLoading) const _LoadingOverlay(),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    final Container content = Container(
      color: Theme.of(context).colorScheme.background,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: <Widget>[
          SliverToBoxAdapter(child: header),
          SliverToBoxAdapter(child: SizedBox(height: topPadding)),
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
            child: Container(color: backgroundColor),
          ),
        ],
      ),
    );

    if (onRefresh != null) {
      return RefreshIndicator(
        onRefresh: onRefresh!,
        child: content,
      );
    } else {
      return content;
    }
  }
}

class _LoadingOverlay extends StatelessWidget {
  const _LoadingOverlay();

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: const CircularProgressIndicator(),
    );
  }
}
