import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomFooter extends StatefulWidget {
  const CustomFooter({super.key});

  @override
  State<CustomFooter> createState() => _CustomFooterState();
}

class _CustomFooterState extends State<CustomFooter> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  IconData? _hoveredIcon;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const textColor = Color(0xFFCCE8DA);
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 700;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ClipPath(
          clipper: TopCurveClipper(progress: _controller.value),
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF5ea092), Color(0xFF2c5952)],
              ),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 16 : 32,
              vertical: isMobile ? 32 : 48,
            ),
            child: Column(
              children: [
                const SizedBox(height: 80),
                isMobile
                    ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    sectionHeader(),
                    const SizedBox(height: 24),
                    curvedDivider(),
                    const SizedBox(height: 24),
                    contactAndSocials(isMobile: true),
                  ],
                )
                    : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 2, child: sectionHeader()),
                    SizedBox(
                      width: screenWidth * 0.15,
                      height: 160,
                      child: CustomPaint(painter: AnimatedCurvePainter(animation: _controller)),
                    ),
                    Expanded(flex: 2, child: contactAndSocials(isMobile: false)),
                  ],
                ),
                const SizedBox(height: 32),
                const Divider(color: Color(0xFF3A4F4F)),
                const SizedBox(height: 12),
                const Text(
                  "Built using Flutter 💙 with much ❤️",
                  style: TextStyle(fontSize: 13, color: textColor, fontFamily: 'Montserrat'),
                ),
                const SizedBox(height: 6),
                const Text(
                  "© 2025 Zaki",
                  style: TextStyle(fontSize: 13, color: textColor, fontFamily: 'Montserrat'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget sectionHeader() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Let’s work together!",
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFFCCE8DA),
          ),
        ),
        SizedBox(height: 8),
        Text(
          "I'm available for Freelancing",
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 18,
            color: Color(0xFFCCE8DA),
          ),
        ),
      ],
    );
  }

  Widget curvedDivider() {
    return SizedBox(
      height: 120,
      width: 160,
      child: CustomPaint(painter: AnimatedCurvePainter(animation: _controller)),
    );
  }

  Widget contactAndSocials({required bool isMobile}) {
    return Column(
      crossAxisAlignment: isMobile ? CrossAxisAlignment.start : CrossAxisAlignment.end,
      children: [
        const Text(
          "- Contact Info -",
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Color(0xFFCCE8DA),
          ),
        ),
        const SizedBox(height: 8),
        contactItem(Icons.email, "zakira-cpu@outlook.fr"),
        contactItem(Icons.phone, "+213 5572 57137"),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          alignment: isMobile ? WrapAlignment.start : WrapAlignment.end,
          children: [
            hoverableIcon(FontAwesomeIcons.github, "https://github.com/ZAKira-gpu"),
            hoverableIcon(FontAwesomeIcons.linkedinIn, "https://www.linkedin.com/in/mohammed-chaib-draa-855535285/"),
            hoverableIcon(FontAwesomeIcons.stackOverflow, "https://stackoverflow.com/users/30758702/hi-im-zaki"),
            hoverableIcon(FontAwesomeIcons.medium, "https://medium.com/@mohammedchaib26"),
            hoverableIcon(FontAwesomeIcons.discord, "https://discord.com/users/yourid"),
          ],
        ),
      ],
    );
  }

  static Widget contactItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Color(0xFFCCE8DA), size: 16),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              text,
              style: const TextStyle(color: Color(0xFFCCE8DA), fontFamily: 'Montserrat'),
            ),
          ),
        ],
      ),
    );
  }

  Widget hoverableIcon(IconData icon, String url) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hoveredIcon = icon),
      onExit: (_) => setState(() => _hoveredIcon = null),
      child: GestureDetector(
        onTap: () => launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication),
        child: AnimatedScale(
          scale: _hoveredIcon == icon ? 1.2 : 1.0,
          duration: const Duration(milliseconds: 200),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: FaIcon(icon, color: const Color(0xFFCCE8DA), size: 18),
          ),
        ),
      ),
    );
  }
}

// Top curve clipper
class TopCurveClipper extends CustomClipper<Path> {
  final double progress;
  TopCurveClipper({required this.progress});

  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, 60);
    path.quadraticBezierTo(
      size.width / 4,
      -80 * progress,
      size.width / 2,
      80 + 30 * progress,
    );
    path.quadraticBezierTo(
      size.width * 3 / 4,
      160 - 60 * progress,
      size.width,
      60,
    );
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant TopCurveClipper oldClipper) => true;
}

// Curve painter
class AnimatedCurvePainter extends CustomPainter {
  final Animation<double> animation;
  AnimatedCurvePainter({required this.animation}) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFCCE8DA)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(0, size.height / 2);
    path.quadraticBezierTo(
      size.width / 2,
      -30 + 60 * animation.value,
      size.width,
      size.height / 2,
    );
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant AnimatedCurvePainter oldDelegate) =>
      oldDelegate.animation != animation;
}
