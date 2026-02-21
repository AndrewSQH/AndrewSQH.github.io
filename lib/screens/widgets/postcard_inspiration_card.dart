import 'package:flutter/material.dart';
import '../../models/template.dart';
import '../../utils/app_colors.dart';

class PostcardInspirationCard extends StatefulWidget {
  final Template template;
  final String date;
  final String sentence;
  final VoidCallback onTap;

  const PostcardInspirationCard({
    super.key,
    required this.template,
    required this.date,
    required this.sentence,
    required this.onTap,
  });

  @override
  State<PostcardInspirationCard> createState() => _PostcardInspirationCardState();
}

class _PostcardInspirationCardState extends State<PostcardInspirationCard> {
  bool _isPressed = false;

  String _getTemplateName(String templateId) {
    switch (templateId) {
      case 'pattern_1':
        return '清风笺';
      case 'pattern_2':
        return '明月笺';
      case 'pattern_3':
        return '岁月笺';
      case 'pattern_4':
        return '云舒笺';
      case 'pattern_5':
        return '花开笺';
      case 'pattern_6':
        return '流年笺';
      case 'pattern_7':
        return '安然笺';
      case 'pattern_8':
        return '田园笺';
      case 'pattern_9':
        return '云海笺';
      case 'pattern_10':
        return '古城笺';
      case 'pattern_11':
        return '晨雾笺';
      case 'pattern_horizontal_1':
        return '横向经典';
      case 'pattern_horizontal_2':
        return '横向风景';
      case 'pattern_horizontal_3':
        return '横向简约';
      case 'pattern_horizontal_4':
        return '横向文艺';
      case 'pattern_horizontal_5':
        return '横向现代';
      case 'pattern_horizontal_6':
        return '横向自然';
      case 'pattern_horizontal_7':
        return '横向城市';
      case 'pattern_horizontal_8':
        return '横向人物';
      case 'pattern_horizontal_9':
        return '横向建筑';
      case 'pattern_horizontal_10':
        return '横向花卉';
      default:
        return '星笺';
    }
  }

  double _getTitleFontSize(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 800) {
      return 24;
    } else if (screenWidth > 600) {
      return 22;
    } else if (screenWidth > 400) {
      return 20;
    } else {
      return 18;
    }
  }

  double _getDateFontSize(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 800) {
      return 16;
    } else if (screenWidth > 600) {
      return 15;
    } else if (screenWidth > 400) {
      return 14;
    } else {
      return 12;
    }
  }

  double _getSentenceFontSize(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 800) {
      return 18;
    } else if (screenWidth > 600) {
      return 17;
    } else if (screenWidth > 400) {
      return 16;
    } else {
      return 14;
    }
  }

  double _getPadding(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 800) {
      return 16;
    } else if (screenWidth > 600) {
      return 14;
    } else if (screenWidth > 400) {
      return 12;
    } else {
      return 10;
    }
  }

  List<BoxShadow> _getCardShadows() {
    return [
      BoxShadow(
        color: AppColors.shadow.withOpacity(0.2),
        blurRadius: 20,
        spreadRadius: 1,
        offset: const Offset(0, 8),
      ),
      BoxShadow(
        color: AppColors.shadow.withOpacity(0.08),
        blurRadius: 10,
        spreadRadius: 0,
        offset: const Offset(0, 3),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final padding = _getPadding(context);
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: widget.onTap,
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        borderRadius: BorderRadius.circular(widget.template.borderRadius),
        splashColor: AppColors.primary.withOpacity(0.2),
        highlightColor: AppColors.primary.withOpacity(0.08),
        child: AnimatedScale(
          scale: _isPressed ? 0.97 : 1.0,
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeInOut,
          child: Container(
            decoration: BoxDecoration(
              color: HexColor(widget.template.backgroundColor),
              border: Border.all(
                color: HexColor(widget.template.borderColor),
                width: widget.template.borderWidth,
              ),
              borderRadius: BorderRadius.circular(widget.template.borderRadius),
              boxShadow: _getCardShadows(),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(widget.template.borderRadius),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 3,
                    child: _buildTemplatePreview(),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: EdgeInsets.all(padding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            _getTemplateName(widget.template.id),
                            style: TextStyle(
                              fontFamily: 'XingKaiTi',
                              fontSize: _getTitleFontSize(context),
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF2D2D2D),
                              letterSpacing: 2,
                              height: 1.2,
                            ),
                          ),
                          Text(
                            widget.date,
                            style: TextStyle(
                              fontFamily: 'XingKaiTi',
                              fontSize: _getDateFontSize(context),
                              color: Colors.grey[600],
                              height: 1.4,
                            ),
                          ),
                          Text(
                            widget.sentence,
                            style: TextStyle(
                              fontFamily: 'XingKaiTi',
                              fontSize: _getSentenceFontSize(context),
                              color: Colors.grey[700],
                              fontStyle: FontStyle.italic,
                              height: 1.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTemplatePreview() {
    final margin = _getPadding(context) / 2;
    
    if (widget.template.imagePath != null) {
      return Container(
        margin: EdgeInsets.all(margin),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.template.borderRadius / 2),
        ),
        clipBehavior: Clip.antiAlias,
        child: Image.asset(
          widget.template.imagePath!,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey[200],
              child: const Center(
                child: Icon(Icons.broken_image, color: Colors.grey, size: 32),
              ),
            );
          },
        ),
      );
    }

    return Center(
      child: Padding(
        padding: EdgeInsets.all(margin),
        child: Text(
          widget.template.name,
          style: TextStyle(
            fontSize: _getSentenceFontSize(context),
            fontWeight: FontWeight.w500,
            color: HexColor('#333333'),
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
