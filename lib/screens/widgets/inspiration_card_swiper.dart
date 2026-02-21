import 'package:flutter/material.dart';
import '../../models/template.dart';
import '../../utils/app_colors.dart';
import 'postcard_inspiration_card.dart';

class InspirationCardSwiper extends StatefulWidget {
  final List<Template> templates;
  final Function(Template) onCardTap;
  final double? viewportFraction;

  const InspirationCardSwiper({
    super.key,
    required this.templates,
    required this.onCardTap,
    this.viewportFraction,
  });

  @override
  State<InspirationCardSwiper> createState() => _InspirationCardSwiperState();
}

class _InspirationCardSwiperState extends State<InspirationCardSwiper> {
  late PageController _pageController;
  int _currentPage = 0;
  final List<String> _cachedDates = [];
  final List<String> _cachedSentences = [];
  bool _isMounted = false;

  @override
  void initState() {
    super.initState();
    _isMounted = true;
    _initializeCache();
    Future.microtask(() {
      if (_isMounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _isMounted = false;
    _pageController.dispose();
    super.dispose();
  }

  void _initializeCache() {
    for (int i = 0; i < widget.templates.length; i++) {
      _cachedDates.add(_getCurrentDate(i));
      _cachedSentences.add(_getRandomSentence(i));
    }
  }

  String _getCurrentDate(int seed) {
    final DateTime now = DateTime.now();
    final List<String> weekdays = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
    final DateTime targetDate = DateTime(now.year, now.month, now.day + seed);
    final String weekday = weekdays[targetDate.weekday - 1];
    return '${targetDate.year}.${targetDate.month.toString().padLeft(2, '0')}.${targetDate.day.toString().padLeft(2, '0')} $weekday';
  }

  String _getRandomSentence(int seed) {
    final List<String> sentences = [
      '风很温柔',
      '阳光正好',
      '岁月静好',
      '人间值得',
      '未来可期',
      '万物可爱',
      '平安喜乐',
      '温暖如初',
      '一切顺利',
      '心想事成',
      '时光荏苒',
      '岁月如歌',
      '花开四季',
      '云卷云舒',
      '潮起潮落',
      '星辰大海',
      '春暖花开',
      '秋高气爽',
      '冬雪皑皑',
      '夏雨绵绵',
    ];
    return sentences[(DateTime.now().millisecondsSinceEpoch + seed * 1000) % sentences.length];
  }

  double _getViewportFraction(BuildContext context) {
    if (widget.viewportFraction != null) {
      return widget.viewportFraction!;
    }
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 800) {
      return 0.6;
    } else if (screenWidth > 600) {
      return 0.7;
    } else if (screenWidth > 400) {
      return 0.85;
    } else {
      return 0.95;
    }
  }

  EdgeInsets _getCardPadding(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 800) {
      return const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0);
    } else if (screenWidth > 600) {
      return const EdgeInsets.symmetric(horizontal: 12.0, vertical: 20.0);
    } else if (screenWidth > 400) {
      return const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0);
    } else {
      return const EdgeInsets.symmetric(horizontal: 4.0, vertical: 12.0);
    }
  }

  void _goToNextPage() {
    if (_currentPage < widget.templates.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _goToPreviousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewportFraction = _getViewportFraction(context);
    _pageController = PageController(
      initialPage: _currentPage,
      viewportFraction: viewportFraction,
    );
    
    return Stack(
      children: [
        PageView.builder(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentPage = index;
            });
          },
          itemCount: widget.templates.length,
          itemBuilder: (context, index) {
            final template = widget.templates[index];
            final isActive = index == _currentPage;
            
            return TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: Duration(milliseconds: 500 + index * 100),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(0, (1 - value) * 30),
                    child: child,
                  ),
                );
              },
              child: AnimatedBuilder(
                animation: _pageController,
                builder: (context, child) {
                  double value = 0.0;
                  if (_pageController.position.haveDimensions) {
                    value = _pageController.page! - index;
                    value = (1 - (value.abs() * 0.3)).clamp(0.0, 1.0);
                  }
                  
                  return Transform.scale(
                    scale: isActive ? 1.0 : 0.9,
                    child: Opacity(
                      opacity: isActive ? 1.0 : 0.8,
                      child: Padding(
                        padding: _getCardPadding(context),
                        child: PostcardInspirationCard(
                          template: template,
                          date: _cachedDates[index],
                          sentence: _cachedSentences[index],
                          onTap: () => widget.onCardTap(template),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
        
        // 左侧滑动按钮
        Positioned(
          left: 8,
          top: 0,
          bottom: 0,
          child: Center(
            child: _currentPage > 0
                ? _buildNavButton(
                    icon: Icons.chevron_left,
                    onTap: _goToPreviousPage,
                  )
                : const SizedBox.shrink(),
          ),
        ),
        
        // 右侧滑动按钮
        Positioned(
          right: 8,
          top: 0,
          bottom: 0,
          child: Center(
            child: _currentPage < widget.templates.length - 1
                ? _buildNavButton(
                    icon: Icons.chevron_right,
                    onTap: _goToNextPage,
                  )
                : const SizedBox.shrink(),
          ),
        ),
      ],
    );
  }

  Widget _buildNavButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            icon,
            color: AppColors.primary,
            size: 28,
          ),
        ),
      ),
    );
  }
}
