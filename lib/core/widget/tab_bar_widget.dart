import 'package:fangapp/core/theme/app_colors.dart';
import 'package:fangapp/core/theme/app_styles.dart';
import 'package:fangapp/core/widget/tab_bar_button_widget.dart';
import 'package:flutter/material.dart';

class TabBarWidget extends StatefulWidget implements PreferredSizeWidget {
  const TabBarWidget({
    Key? key,
    required this.tabController,
    required this.labels,
    this.labelSize = 13.0,
    this.onTabChange,
    this.isScrollable = true,
    this.showNavigateButtons = false,
  }) : super(key: key);

  final List<String> labels;
  final double labelSize;
  final Function(int)? onTabChange;
  final bool isScrollable;
  final TabController tabController;
  final bool showNavigateButtons;

  @override
  _TabBarWidgetState createState() => _TabBarWidgetState();

  @override
  Size get preferredSize => const Size.fromHeight(30.0);
}

class _TabBarWidgetState extends State<TabBarWidget> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.tabController.index;
    widget.tabController.addListener(_onTabChanged);
  }

  void _onTabChanged() {
    if (widget.tabController.indexIsChanging && widget.onTabChange != null) {
      widget.onTabChange!(widget.tabController.index);
    }
    setState(() {
      _currentIndex = widget.tabController.index;
    });
  }

  @override
  void didUpdateWidget(covariant TabBarWidget oldWidget) {
    if (oldWidget.tabController != widget.tabController) {
      oldWidget.tabController.removeListener(_onTabChanged);
      widget.tabController.addListener(_onTabChanged);
    }
    setState(() {
      _currentIndex = widget.tabController.index;
    });
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        if (widget.showNavigateButtons)
          TabBarButtonWidget(
            enabled: _currentIndex > 0,
            tabController: widget.tabController,
          ),
        Flexible(
          child: TabBar(
            controller: widget.tabController,
            isScrollable: widget.isScrollable,
            overlayColor: MaterialStateProperty.all(Colors.transparent),
            labelColor: AppColors.blueLight,
            indicatorColor: AppColors.blueLight,
            unselectedLabelColor: AppColors.white,
            unselectedLabelStyle: AppStyles.mediumTitle(
              context,
              size: widget.labelSize,
            ),
            labelStyle: AppStyles.mediumTitle(context, size: widget.labelSize),
            tabs: widget.labels
                .map(
                  (String label) => Tab(
                    text: label.toUpperCase(),
                  ),
                )
                .toList(),
          ),
        ),
        if (widget.showNavigateButtons)
          TabBarButtonWidget(
            isLeft: false,
            enabled: _currentIndex < widget.tabController.length - 1,
            tabController: widget.tabController,
          ),
      ],
    );
  }

  @override
  void dispose() {
    widget.tabController.removeListener(_onTabChanged);
    super.dispose();
  }
}
