import 'package:flutter/material.dart';
import 'package:leyu_mobile/core/theme/app_colors.dart';

class HorizontalCarouselWidget extends StatefulWidget {
  final List<Widget> items;

  const HorizontalCarouselWidget({
    super.key,
    required this.items,
  });

  @override
  _HorizontalCarouselWidgetState createState() => _HorizontalCarouselWidgetState();
}

class _HorizontalCarouselWidgetState extends State<HorizontalCarouselWidget> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 1);
    _pageController.addListener(() {
      int next = _pageController.page!.round();
      if (_currentPage != next) {
        setState(() {
          _currentPage = next;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 200,
          child: PageView.builder(
            controller: _pageController,
            pageSnapping: false,
            padEnds: false,
            itemCount: widget.items.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: widget.items[index],
              );
            },
          ),
        ),
        BottomIndicator(
          currentIndex: _currentPage,
          totalItems: widget.items.length,
        ),
      ],
    );
  }
}

class BottomIndicator extends StatelessWidget {
  final int currentIndex;
  final int totalItems;

  const BottomIndicator({
    super.key,
    required this.currentIndex,
    required this.totalItems,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(totalItems, (index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Container(
              width: index == currentIndex ? 24.0 : 8.0,
              height: 8.0,
              decoration: BoxDecoration(
                color: index == currentIndex ? AppColors.primary : const Color(0xFFD9D9D9),
                borderRadius: BorderRadius.circular(4.0),
              ),
            ),
          );
        }),
      ),
    );
  }
}