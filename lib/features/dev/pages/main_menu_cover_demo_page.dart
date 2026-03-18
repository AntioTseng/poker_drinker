import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

class MainMenuCoverDemoPage extends StatelessWidget {
  const MainMenuCoverDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final concepts = <_CoverConceptData>[
      const _CoverConceptData(
        title: 'Editorial Tavern',
        eyebrow: '最穩的高級感方向',
        rationale: '用雜誌封面式排版去做首頁，重點是留白、字級層級與少量酒紅重點色。這種方向最耐看，也最容易接近正式上架版本。',
        fit: '適合你現在這個產品階段，因為它能保留喝酒主題，但不會太俗或太像派對小遊戲合集。',
        palette: [Color(0xFFF7EEDF), Color(0xFFF1DEC8), Color(0xFF6E1625)],
        mood: _CoverMood.editorial,
      ),
      const _CoverConceptData(
        title: 'Velvet Casino',
        eyebrow: '最有主打感的封面',
        rationale: '把首頁做得像高級桌面賭場海報，透過酒紅絲絨、金色細節與聚光燈式焦點，讓主打遊戲有更強的舞台感。',
        fit: '如果你想強化「打開 App 就知道今晚主打什麼」的直覺，這個方向會比現在更有記憶點。',
        palette: [Color(0xFF2B0F16), Color(0xFF7A2131), Color(0xFFE8C98D)],
        mood: _CoverMood.velvet,
      ),
      const _CoverConceptData(
        title: 'Deck Box Minimal',
        eyebrow: '最像正式商品包裝',
        rationale:
            '這個方向把首頁當作牌盒封面來設計，資訊極少，靠材質、框線與標章質感取勝。它會讓整個產品看起來更像一個完成品，而不是功能列表。',
        fit: '適合你如果未來想做品牌感、想讓截圖上架時看起來更乾淨、更像獨立遊戲品牌。',
        palette: [Color(0xFFF6F1E7), Color(0xFFD7C4AE), Color(0xFF33241D)],
        mood: _CoverMood.deckbox,
      ),
      const _CoverConceptData(
        title: 'After Hours Poster',
        eyebrow: '最年輕、最有活動感',
        rationale: '用夜生活海報的構圖處理首頁，做出比較強的情緒張力與活動視覺。這種風格更衝、更搶眼，但也比較挑品牌一致性。',
        fit: '如果你希望它更像「今晚開局的邀請函」，而不是穩定工具型首頁，這會是更大膽的方向。',
        palette: [Color(0xFF201726), Color(0xFFC04C63), Color(0xFFF2B37A)],
        mood: _CoverMood.poster,
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('POKER DRINKER Cover Demo')),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppTheme.pageBackground, AppTheme.pageBackgroundSoft],
          ),
        ),
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          itemCount: concepts.length + 1,
          separatorBuilder: (context, index) => const SizedBox(height: 18),
          itemBuilder: (context, index) {
            if (index == 0) {
              return _IntroPanel(textTheme: textTheme);
            }

            final concept = concepts[index - 1];
            return _ConceptSection(concept: concept);
          },
        ),
      ),
    );
  }
}

enum _CoverMood { editorial, velvet, deckbox, poster }

class _CoverConceptData {
  final String title;
  final String eyebrow;
  final String rationale;
  final String fit;
  final List<Color> palette;
  final _CoverMood mood;

  const _CoverConceptData({
    required this.title,
    required this.eyebrow,
    required this.rationale,
    required this.fit,
    required this.palette,
    required this.mood,
  });
}

class _IntroPanel extends StatelessWidget {
  final TextTheme textTheme;

  const _IntroPanel({required this.textTheme});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppTheme.panel,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: AppTheme.secondaryAccent.withValues(alpha: 0.16),
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
              '這不是在找唯一正解，而是在找最適合你的品牌定位。',
              style: textTheme.titleLarge?.copyWith(color: AppTheme.ink),
            ),
            const SizedBox(height: 10),
            Text(
              '現在這版首頁已經比之前乾淨很多，但還不是「唯一最好的 UIUX」。對這種喝酒主題卡牌 App 來說，首頁質感很大程度取決於你想讓它更像：高級桌遊、夜生活海報、獨立品牌包裝，還是主打遊戲入口。下面這幾款是我認為有機會比現況更有質感的方向。',
              style: textTheme.bodyMedium?.copyWith(
                color: AppTheme.subtleInk,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConceptSection extends StatelessWidget {
  final _CoverConceptData concept;

  const _ConceptSection({required this.concept});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppTheme.panel,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: concept.palette.last.withValues(alpha: 0.12)),
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
                color: concept.palette.last,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              concept.title,
              style: textTheme.headlineSmall?.copyWith(color: AppTheme.ink),
            ),
            const SizedBox(height: 14),
            AspectRatio(
              aspectRatio: 0.62,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: _CoverPreview(concept: concept),
              ),
            ),
            const SizedBox(height: 16),
            _ReasonBlock(title: '為什麼這個方向有質感', content: concept.rationale),
            const SizedBox(height: 10),
            _ReasonBlock(title: '它適合你現在的原因', content: concept.fit),
          ],
        ),
      ),
    );
  }
}

class _ReasonBlock extends StatelessWidget {
  final String title;
  final String content;

  const _ReasonBlock({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: AppTheme.pageBackground.withValues(alpha: 0.7),
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

class _CoverPreview extends StatelessWidget {
  final _CoverConceptData concept;

  const _CoverPreview({required this.concept});

  @override
  Widget build(BuildContext context) {
    switch (concept.mood) {
      case _CoverMood.editorial:
        return _EditorialCover(concept: concept);
      case _CoverMood.velvet:
        return _VelvetCover(concept: concept);
      case _CoverMood.deckbox:
        return _DeckBoxCover(concept: concept);
      case _CoverMood.poster:
        return _PosterCover(concept: concept);
    }
  }
}

class _EditorialCover extends StatelessWidget {
  final _CoverConceptData concept;

  const _EditorialCover({required this.concept});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [concept.palette[0], concept.palette[1]],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 20,
            right: -14,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: concept.palette[2].withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 22, 22, 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _PreviewTopBar(ink: concept.palette[2]),
                const Spacer(),
                Text(
                  '遊戲\n大廳',
                  style: TextStyle(
                    color: concept.palette[2],
                    fontSize: 46,
                    height: 0.95,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'Pick the mood for tonight.',
                  style: TextStyle(
                    color: concept.palette[2].withValues(alpha: 0.72),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 18),
                _PreviewTierRow(
                  accent: concept.palette[2],
                  title: '喝掛',
                  subtitle: '今晚主打',
                  strong: true,
                ),
                const SizedBox(height: 10),
                _PreviewTierRow(
                  accent: concept.palette[2].withValues(alpha: 0.72),
                  title: '小酌 / 微醺',
                  subtitle: '輕量入口',
                  strong: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _VelvetCover extends StatelessWidget {
  final _CoverConceptData concept;

  const _VelvetCover({required this.concept});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: const Alignment(0, -0.2),
          radius: 1.1,
          colors: [concept.palette[1], concept.palette[0]],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -22,
            left: -6,
            right: -6,
            child: Container(
              height: 130,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    concept.palette[2].withValues(alpha: 0.52),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 22, 22, 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _PreviewTopBar(ink: concept.palette[2], light: true),
                const SizedBox(height: 28),
                Text(
                  'TONIGHT\'S\nTABLE',
                  style: TextStyle(
                    color: concept.palette[2],
                    fontSize: 40,
                    height: 0.95,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'Pyramid Poker headlines the night.',
                  style: TextStyle(
                    color: concept.palette[2].withValues(alpha: 0.78),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: concept.palette[2].withValues(alpha: 0.32),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _FeaturedPill(
                        label: 'FEATURED',
                        background: concept.palette[2].withValues(alpha: 0.16),
                        color: concept.palette[2],
                      ),
                      const SizedBox(height: 14),
                      Text(
                        '金字塔\n撲克牌',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 34,
                          height: 1,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(
                            Icons.person_rounded,
                            size: 16,
                            color: concept.palette[2],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '2-6人',
                            style: TextStyle(
                              color: concept.palette[2],
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const Spacer(),
                          Icon(
                            Icons.arrow_forward_rounded,
                            color: concept.palette[2],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DeckBoxCover extends StatelessWidget {
  final _CoverConceptData concept;

  const _DeckBoxCover({required this.concept});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: concept.palette[0],
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: concept.palette[0],
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: concept.palette[2].withValues(alpha: 0.28),
            ),
            boxShadow: [
              BoxShadow(
                color: concept.palette[2].withValues(alpha: 0.08),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                top: 16,
                left: 16,
                right: 16,
                bottom: 16,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: concept.palette[2].withValues(alpha: 0.12),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'POKER DRINKER',
                      style: TextStyle(
                        color: concept.palette[2],
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 3,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: concept.palette[2].withValues(alpha: 0.22),
                        ),
                      ),
                      child: Icon(
                        Icons.style_rounded,
                        color: concept.palette[2],
                        size: 38,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'POKER DRINKER',
                      style: TextStyle(
                        color: concept.palette[2],
                        fontSize: 34,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'A party card game\nfor drinking rounds with friends',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: concept.palette[2].withValues(alpha: 0.72),
                        fontSize: 16,
                        height: 1.35,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    _OutlineTicket(
                      color: concept.palette[2],
                      label: 'POKER DRINKER / Light Buzz / Tipsy / Wasted',
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

class _PosterCover extends StatelessWidget {
  final _CoverConceptData concept;

  const _PosterCover({required this.concept});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [concept.palette[0], concept.palette[1]],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            left: -24,
            top: 70,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: concept.palette[2].withValues(alpha: 0.18),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            right: -34,
            bottom: 58,
            child: Container(
              width: 170,
              height: 170,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 22, 22, 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _PreviewTopBar(ink: Colors.white, light: true),
                const SizedBox(height: 26),
                Text(
                  'OPEN\nA\nROUND',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 46,
                    height: 0.9,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  'A sharper, louder cover that feels like tonight\'s event poster.',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.78),
                    fontSize: 15,
                    height: 1.35,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                _PosterStrip(color: concept.palette[2]),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _PosterTag(
                        title: '小酌',
                        color: Colors.white.withValues(alpha: 0.14),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _PosterTag(
                        title: '喝掛',
                        color: concept.palette[2].withValues(alpha: 0.24),
                        highlighted: true,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PreviewTopBar extends StatelessWidget {
  final Color ink;
  final bool light;

  const _PreviewTopBar({required this.ink, this.light = false});

  @override
  Widget build(BuildContext context) {
    final color = light ? Colors.white : ink;

    return Row(
      children: [
        Text(
          'POKER DRINKER',
          style: TextStyle(
            color: color,
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
        const Spacer(),
        Icon(Icons.settings, color: color, size: 18),
      ],
    );
  }
}

class _PreviewTierRow extends StatelessWidget {
  final Color accent;
  final String title;
  final String subtitle;
  final bool strong;

  const _PreviewTierRow({
    required this.accent,
    required this.title,
    required this.subtitle,
    required this.strong,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: strong ? 0.7 : 0.44),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: accent.withValues(alpha: strong ? 0.28 : 0.14),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: strong ? 40 : 28,
            decoration: BoxDecoration(
              color: accent,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: accent,
                    fontSize: strong ? 24 : 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: accent.withValues(alpha: 0.68),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          if (strong) Icon(Icons.arrow_forward_rounded, color: accent),
        ],
      ),
    );
  }
}

class _FeaturedPill extends StatelessWidget {
  final String label;
  final Color background;
  final Color color;

  const _FeaturedPill({
    required this.label,
    required this.background,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}

class _OutlineTicket extends StatelessWidget {
  final Color color;
  final String label;

  const _OutlineTicket({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: color.withValues(alpha: 0.78),
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _PosterStrip extends StatelessWidget {
  final Color color;

  const _PosterStrip({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Pyramid Poker',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: const Icon(Icons.arrow_forward_rounded, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class _PosterTag extends StatelessWidget {
  final String title;
  final Color color;
  final bool highlighted;

  const _PosterTag({
    required this.title,
    required this.color,
    this.highlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withValues(alpha: highlighted ? 0.28 : 0.1),
        ),
      ),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: highlighted ? 18 : 16,
        ),
      ),
    );
  }
}
