import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

class MainMenuCoverDemoPage extends StatelessWidget {
  const MainMenuCoverDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final concepts = <_BrandConcept>[
      const _BrandConcept(
        title: 'Crest Fan',
        eyebrow: '最接近你提供圖片感覺的一版',
        summary: '左上直接用三張扇形撲克牌做品牌 icon，搭配穩定的一行字標，最像真正可上線的 app header。',
        why:
            '你已經明確喜歡 crest header，而且指定要三張撲克牌圖像。這版最直覺、辨識最快，也最符合使用者對首頁左上品牌區的閱讀習慣。',
        strengths: ['三張牌 icon 最清楚。', '品牌辨識速度最快。', '最容易正式套回現有首頁。'],
        tradeoffs: ['視覺驚喜感比更設計化的版本低一些。', '需要靠細節比例做精緻度。'],
        variant: _BrandVariant.crestFan,
      ),
      const _BrandConcept(
        title: 'Crest Emblem',
        eyebrow: '最像完整品牌徽章系統的一版',
        summary: '把三張撲克牌收進一個金色 emblem 裡，再搭配更高級的字標比例，品牌系統感最完整。',
        why: '如果你希望未來不只首頁，連 loading、活動頁、icon 都能共用同一套識別，這版會是最好的基底。',
        strengths: ['品牌系統感最完整。', '未來延展性最好。', '看起來最像正式識別設計。'],
        tradeoffs: ['比起直接扇形牌 icon，辨識速度稍慢。', '如果 emblem 太重，畫面會顯得正式。'],
        variant: _BrandVariant.crestEmblem,
      ),
      const _BrandConcept(
        title: 'Crest Banner',
        eyebrow: '最有夜店招牌與酒吧牌桌感的一版',
        summary: '三張撲克牌 icon 保留，但整體做成更像招牌 banner 的 header，品牌個性最強。',
        why: '如果你希望首頁一打開就有更明顯的夜生活和酒局感，這版會比純穩定字標更有表演性，也更貼近 Golden Curtain。',
        strengths: ['舞台感最強。', '最有夜生活品牌氣質。', '和 Golden Curtain 背景連動最好。'],
        tradeoffs: ['如果控制不好，容易太像活動頁。', '比另外兩版更依賴整頁風格一致。'],
        variant: _BrandVariant.crestBanner,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Brand Title Demo'),
        backgroundColor: AppTheme.pageBackground,
        foregroundColor: AppTheme.ink,
        surfaceTintColor: Colors.transparent,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppTheme.pageBackground, AppTheme.pageBackgroundSoft],
          ),
        ),
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
          itemCount: concepts.length + 1,
          separatorBuilder: (_, __) => const SizedBox(height: 18),
          itemBuilder: (context, index) {
            if (index == 0) {
              return const _BrandIntroPanel();
            }

            return _ConceptSection(concept: concepts[index - 1]);
          },
        ),
      ),
    );
  }
}

enum _BrandVariant { crestFan, crestEmblem, crestBanner }

class _BrandConcept {
  final String title;
  final String eyebrow;
  final String summary;
  final String why;
  final List<String> strengths;
  final List<String> tradeoffs;
  final _BrandVariant variant;

  const _BrandConcept({
    required this.title,
    required this.eyebrow,
    required this.summary,
    required this.why,
    required this.strengths,
    required this.tradeoffs,
    required this.variant,
  });
}

class _BrandIntroPanel extends StatelessWidget {
  const _BrandIntroPanel();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppTheme.panel,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: AppTheme.secondaryAccent.withValues(alpha: 0.18),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 22,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '你現在的 POKER DRINKER 太普通，根本原因是它還只是「標題」，不是「品牌字標」。',
              style: textTheme.headlineSmall?.copyWith(color: AppTheme.ink),
            ),
            const SizedBox(height: 10),
            Text(
              '這次不再比較不同字標策略，而是專門深挖你選的 crest header。重點放在三件事：三張撲克牌 icon 要怎麼做才像品牌而不是素材、文字怎麼和酒吧牌桌主題對上，以及整個左上角 header 怎麼兼顧辨識度與使用者閱讀效率。',
              style: textTheme.bodyMedium?.copyWith(
                color: AppTheme.subtleInk,
                height: 1.55,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConceptSection extends StatelessWidget {
  final _BrandConcept concept;

  const _ConceptSection({required this.concept});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppTheme.panel,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: const Color(0xFFE8C98D).withValues(alpha: 0.18),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 22,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              concept.eyebrow,
              style: textTheme.labelLarge?.copyWith(
                color: const Color(0xFFE8C98D),
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              concept.title,
              style: textTheme.headlineSmall?.copyWith(color: AppTheme.ink),
            ),
            const SizedBox(height: 8),
            Text(
              concept.summary,
              style: textTheme.bodyMedium?.copyWith(
                color: AppTheme.subtleInk,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 14),
            AspectRatio(
              aspectRatio: 0.54,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: _BrandPreview(variant: concept.variant),
              ),
            ),
            const SizedBox(height: 16),
            _ReasonCard(title: '為什麼這版對你的 App 有效', content: concept.why),
            const SizedBox(height: 12),
            _BulletCard(
              title: '優點',
              accent: const Color(0xFF2E7D5B),
              items: concept.strengths,
            ),
            const SizedBox(height: 10),
            _BulletCard(
              title: '缺點',
              accent: const Color(0xFF9D5B50),
              items: concept.tradeoffs,
            ),
          ],
        ),
      ),
    );
  }
}

class _ReasonCard extends StatelessWidget {
  final String title;
  final String content;

  const _ReasonCard({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: AppTheme.pageBackground.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: textTheme.titleSmall?.copyWith(
              color: AppTheme.ink,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            content,
            style: textTheme.bodyMedium?.copyWith(
              color: AppTheme.subtleInk,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _BulletCard extends StatelessWidget {
  final String title;
  final Color accent;
  final List<String> items;

  const _BulletCard({
    required this.title,
    required this.accent,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: accent.withValues(alpha: 0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: textTheme.titleSmall?.copyWith(
              color: AppTheme.ink,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          for (var index = 0; index < items.length; index++) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 7),
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: accent,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    items[index],
                    style: textTheme.bodyMedium?.copyWith(
                      color: AppTheme.subtleInk,
                      height: 1.45,
                    ),
                  ),
                ),
              ],
            ),
            if (index != items.length - 1) const SizedBox(height: 6),
          ],
        ],
      ),
    );
  }
}

class _BrandPreview extends StatelessWidget {
  final _BrandVariant variant;

  const _BrandPreview({required this.variant});

  @override
  Widget build(BuildContext context) {
    return _GoldenCurtainShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _BrandHeader(variant: variant),
          const SizedBox(height: 16),
          const _PreviewContent(),
        ],
      ),
    );
  }
}

class _GoldenCurtainShell extends StatelessWidget {
  final Widget child;

  const _GoldenCurtainShell({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF14080D), Color(0xFF3A131C)],
        ),
      ),
      child: Stack(
        children: [
          const Positioned.fill(child: _CurtainGlow(accent: Color(0xFFF0CD8D))),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            child: child,
          ),
        ],
      ),
    );
  }
}

class _BrandHeader extends StatelessWidget {
  final _BrandVariant variant;

  const _BrandHeader({required this.variant});

  @override
  Widget build(BuildContext context) {
    switch (variant) {
      case _BrandVariant.crestFan:
        return const _CrestFanHeader();
      case _BrandVariant.crestEmblem:
        return const _CrestEmblemHeader();
      case _BrandVariant.crestBanner:
        return const _CrestBannerHeader();
    }
  }
}

class _CrestFanHeader extends StatelessWidget {
  const _CrestFanHeader();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      children: [
        const _PlayingCardsMark(),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'POKER DRINKER',
                style: textTheme.titleLarge?.copyWith(
                  color: const Color(0xFFFFE3B1),
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.1,
                ),
              ),
              Text(
                '今晚這桌，先暖場再進主桌',
                style: textTheme.labelSmall?.copyWith(
                  color: const Color(0xFFF0CD8D).withValues(alpha: 0.78),
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.4,
                ),
              ),
            ],
          ),
        ),
        const Icon(Icons.settings_rounded, color: Color(0xFFF0CD8D), size: 20),
      ],
    );
  }
}

class _CrestEmblemHeader extends StatelessWidget {
  const _CrestEmblemHeader();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0x22F0CD8D),
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0x55F0CD8D)),
          ),
          child: const Center(
            child: SizedBox(
              width: 34,
              height: 28,
              child: _PlayingCardsMark(compact: true),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'POKER DRINKER',
                style: textTheme.titleLarge?.copyWith(
                  color: const Color(0xFFFFE3B1),
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.0,
                ),
              ),
              Text(
                '喝酒、玩牌、把整桌氣氛一路推上去',
                style: textTheme.labelSmall?.copyWith(
                  color: const Color(0xFFF0CD8D).withValues(alpha: 0.78),
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.35,
                ),
              ),
            ],
          ),
        ),
        const Icon(Icons.settings_rounded, color: Color(0xFFF0CD8D), size: 20),
      ],
    );
  }
}

class _CrestBannerHeader extends StatelessWidget {
  const _CrestBannerHeader();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 11, 12, 11),
      decoration: BoxDecoration(
        color: const Color(0x33E8C98D),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0x66F0CD8D)),
      ),
      child: Row(
        children: [
          const _PlayingCardsMark(),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'POKER DRINKER',
                  style: textTheme.titleLarge?.copyWith(
                    color: const Color(0xFFFFE3B1),
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.3,
                  ),
                ),
                Text(
                  '今晚開哪一局，決定這桌喝到哪裡',
                  style: textTheme.labelSmall?.copyWith(
                    color: const Color(0xFFF0CD8D).withValues(alpha: 0.82),
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.settings_rounded,
            color: Color(0xFFF0CD8D),
            size: 18,
          ),
        ],
      ),
    );
  }
}

class _PlayingCardsMark extends StatelessWidget {
  final bool compact;

  const _PlayingCardsMark({this.compact = false});

  @override
  Widget build(BuildContext context) {
    final width = compact ? 34.0 : 42.0;
    final height = compact ? 28.0 : 34.0;

    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 0,
            top: compact ? 4 : 6,
            child: Transform.rotate(
              angle: -0.28,
              child: _MiniCard(
                suit: '♥',
                width: compact ? 16 : 18,
                height: compact ? 22 : 24,
              ),
            ),
          ),
          Positioned(
            left: compact ? 9 : 12,
            top: 0,
            child: _MiniCard(
              suit: '♠',
              width: compact ? 17 : 19,
              height: compact ? 23 : 26,
              highlighted: true,
            ),
          ),
          Positioned(
            right: 0,
            top: compact ? 4 : 6,
            child: Transform.rotate(
              angle: 0.28,
              child: _MiniCard(
                suit: '♦',
                width: compact ? 16 : 18,
                height: compact ? 22 : 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniCard extends StatelessWidget {
  final String suit;
  final double width;
  final double height;
  final bool highlighted;

  const _MiniCard({
    required this.suit,
    required this.width,
    required this.height,
    this.highlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    final foreground = highlighted
        ? const Color(0xFFFFE3B1)
        : const Color(0xFFF0CD8D);
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFF14080D),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: foreground.withValues(alpha: highlighted ? 0.92 : 0.72),
          width: 1.2,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(2, 1, 2, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'A',
                  style: TextStyle(
                    color: foreground,
                    fontSize: 5.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  suit,
                  style: TextStyle(
                    color: foreground,
                    fontSize: 5.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                suit,
                style: TextStyle(
                  color: foreground,
                  fontSize: highlighted ? 10 : 9,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PreviewContent extends StatelessWidget {
  const _PreviewContent();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '今晚主場準備開燈',
          style: textTheme.labelLarge?.copyWith(
            color: const Color(0xFFE8C98D),
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '從暖場進門\n一路走到主桌',
          style: textTheme.headlineSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            height: 0.96,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          '首頁上方的品牌字標，不只是放名字而已。它要先讓玩家一眼感受到這是一個把喝酒、玩牌、帶桌上氣氛一路推進到主桌的 app，接著才自然往下看今晚要開哪一局。',
          style: textTheme.bodySmall?.copyWith(
            color: Colors.white.withValues(alpha: 0.74),
            height: 1.45,
          ),
        ),
        const SizedBox(height: 14),
        const _TierBlock(
          title: '小酌',
          caption: '先暖場',
          accent: Color(0xFFD6A66A),
          games: ['比大小', '撲克牌賽馬'],
        ),
        const SizedBox(height: 10),
        const _TierBlock(
          title: '微醺',
          caption: '節奏上來',
          accent: Color(0xFFD88E7C),
          games: ['微醺模式預留'],
        ),
        const SizedBox(height: 10),
        const _TierBlock(
          title: '喝掛',
          caption: '主桌時刻',
          accent: Color(0xFFE8C98D),
          games: ['金字塔撲克牌', '喝掛模式預留'],
          highlighted: true,
        ),
      ],
    );
  }
}

class _TierBlock extends StatelessWidget {
  final String title;
  final String caption;
  final Color accent;
  final List<String> games;
  final bool highlighted;

  const _TierBlock({
    required this.title,
    required this.caption,
    required this.accent,
    required this.games,
    this.highlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            accent.withValues(alpha: highlighted ? 0.18 : 0.10),
            const Color(0xFF2A1015).withValues(alpha: 0.94),
          ],
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: accent.withValues(alpha: highlighted ? 0.28 : 0.14),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Row(
                children: [
                  Icon(Icons.wine_bar_rounded, size: 14, color: accent),
                  const SizedBox(width: 4),
                  Text(
                    caption,
                    style: textTheme.labelSmall?.copyWith(
                      color: accent,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                title,
                style: textTheme.titleSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          for (var index = 0; index < games.length; index++) ...[
            Row(
              children: [
                Expanded(
                  child: Text(
                    games[index],
                    style: textTheme.bodyMedium?.copyWith(
                      color: games[index] == '金字塔撲克牌'
                          ? const Color(0xFFFFE1B0)
                          : Colors.white.withValues(alpha: 0.82),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    games[index] == '喝掛模式預留' ? '4-10人' : '2-6人',
                    style: textTheme.labelSmall?.copyWith(
                      color: accent,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            if (index != games.length - 1) const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}

class _CurtainGlow extends StatelessWidget {
  final Color accent;

  const _CurtainGlow({required this.accent});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _CurtainGlowPainter(accent));
  }
}

class _CurtainGlowPainter extends CustomPainter {
  final Color accent;

  _CurtainGlowPainter(this.accent);

  @override
  void paint(Canvas canvas, Size size) {
    final beamPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [accent.withValues(alpha: 0.16), Colors.transparent],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height * 0.6));

    final path1 = Path()
      ..moveTo(size.width * 0.10, 0)
      ..lineTo(size.width * 0.30, 0)
      ..lineTo(size.width * 0.18, size.height * 0.62)
      ..lineTo(size.width * 0.02, size.height * 0.62)
      ..close();

    final path2 = Path()
      ..moveTo(size.width * 0.62, 0)
      ..lineTo(size.width * 0.88, 0)
      ..lineTo(size.width * 0.98, size.height * 0.72)
      ..lineTo(size.width * 0.74, size.height * 0.72)
      ..close();

    canvas.drawPath(path1, beamPaint);
    canvas.drawPath(path2, beamPaint);
  }

  @override
  bool shouldRepaint(covariant _CurtainGlowPainter oldDelegate) {
    return oldDelegate.accent != accent;
  }
}
