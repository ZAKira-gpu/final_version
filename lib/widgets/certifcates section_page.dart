import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'dart:ui';

class CertificateSection extends StatelessWidget {
  const CertificateSection({super.key});

  @override
  Widget build(BuildContext context) {
    final brandColor = const Color(0xFF5ea092);
    final isMobile = MediaQuery.of(context).size.width < 700;

    final List<Map<String, String>> certificates = [
      {
        "image": "assets/mtf.png",
        "title": "DevOps Certificate",
        "issuer": "MTF Institute",
        "url": "https://edu.gtf.pt/pluginfile.php/1/tool_certificate/issues/1743439939/3178026125MC.pdf"
      },
      {
        "image": "assets/flu.png",
        "title": "Flutter Programming",
        "issuer": "Udemy",
        "url": "https://www.udemy.com/certificate/UC-fb4001a5-4da0-4714-8ebe-6b86d7a6e139/"
      },
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 48),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFfafcfb), Color(0xFF45a99d)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "My Certificates",
            style: GoogleFonts.montserrat(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 40),
          isMobile
              ? Column(
            children: List.generate(certificates.length, (index) {
              final cert = certificates[index];
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 600),
                child: SlideAnimation(
                  verticalOffset: 50,
                  child: FadeInAnimation(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: HoverCard(
                        imageUrl: cert['image']!,
                        title: cert['title']!,
                        issuer: cert['issuer']!,
                        url: cert['url']!,
                        brandColor: brandColor,
                      ),
                    ),
                  ),
                ),
              );
            }),
          )
              : SizedBox(
            height: 460,
            child: AnimationLimiter(
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: certificates.length,
                separatorBuilder: (_, __) => const SizedBox(width: 32),
                itemBuilder: (context, index) {
                  final cert = certificates[index];
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 600),
                    child: SlideAnimation(
                      horizontalOffset: 50,
                      child: FadeInAnimation(
                        child: HoverCard(
                          imageUrl: cert['image']!,
                          title: cert['title']!,
                          issuer: cert['issuer']!,
                          url: cert['url']!,
                          brandColor: brandColor,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HoverCard extends StatefulWidget {
  final String imageUrl;
  final String title;
  final String issuer;
  final String url;
  final Color brandColor;

  const HoverCard({
    required this.imageUrl,
    required this.title,
    required this.issuer,
    required this.url,
    required this.brandColor,
  });

  @override
  State<HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<HoverCard> {
  bool isHovered = false;

  void _launchUrl() async {
    final uri = Uri.parse(widget.url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        transform: Matrix4.identity()..scale(isHovered ? 1.05 : 1.0),
        curve: Curves.easeInOut,
        width: 380,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: isHovered ? Colors.black26 : Colors.black12,
              blurRadius: isHovered ? 14 : 10,
              offset: const Offset(0, 6),
            )
          ],
        ),
        child: InkWell(
          onTap: _launchUrl,
          borderRadius: BorderRadius.circular(18),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                child: Image.asset(
                  widget.imageUrl,
                  height: 300,
                  width: MediaQuery.of(context).size.width < 700
                      ? double.infinity
                      : MediaQuery.of(context).size.width * 0.8,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 250,
                    color: Colors.grey[300],
                    alignment: Alignment.center,
                    child: const Icon(Icons.broken_image, size: 40, color: Colors.grey),
                  ),
                )
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      widget.title,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF222222),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.issuer,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        color: widget.brandColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
