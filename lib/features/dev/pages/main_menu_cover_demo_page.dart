import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

class MainMenuCoverDemoPage extends StatelessWidget {
  const MainMenuCoverDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final concepts = <_MenuConceptData>[
      const _MenuConceptData(
        title: 'Quiet Luxury Menu',
        eyebrow: '最接近正式上線版本',
        rationale: '把首頁當成酒吧菜單處理，重點是可讀性、層級和清楚的可點擊線索。畫面安靜，但不失質感。',
        fit: '如果你要的是穩、耐看、容易上線，這會是最安全也最成熟的方向。',
        palette: [Color(0xFF14090D), Color(0xFF2B171B), Color(0xFFE7C88D)],
        mood: _MenuMood.quietLuxury,
      ),
      const _MenuConceptData(
        title: 'Signature Spotlight',
        eyebrow: '主打遊戲最清楚的一版',
        rationale: '一打開就先看到今晚主桌，其他等級退成次要入口。適合需要強推某個玩法的產品節奏。',
        fit: '如果你希望使用者一眼就知道要先按哪裡，這版的動線最直接。',
        palette: [Color(0xFF1A0A10), Color(0xFF5D1625), Color(0xFFF2D39A)],
        mood: _MenuMood.signatureSpotlight,
      ),
      const _MenuConceptData(
        title: 'Editorial Ledger',
        eyebrow: '最像精品品牌編排',
        rationale: '用更強的排版感取代卡片感，像一本精緻酒單。資訊更像被編輯過，而不是被堆進容器裡。',
        fit: '如果你要優雅感和設計感明顯高於一般遊戲大廳，這版很有潛力。',
        palette: [Color(0xFFF5EEDF), Color(0xFFE6D4BC), Color(0xFF3D261F)],
        mood: _MenuMood.editorialLedger,
      ),
      const _MenuConceptData(
        title: 'Velvet Stage',
        eyebrow: '保留品牌張力的一版',
        rationale: '維持酒紅與金色的戲劇感，但資訊架構改成先選酒感類別，再選類別底下的遊戲，視覺上更成熟也更能長期擴充。',
        fit: '如果你想保留 POKER DRINKER 的舞台氣質，同時讓未來新增遊戲時不會跑版，這版最有延展性。',
        palette: [Color(0xFF1A0A0F), Color(0xFF3D111B), Color(0xFFE8C98D)],
        mood: _MenuMood.velvetStage,
        previewAspectRatio: 0.5,
      ),
      const _MenuConceptData(
        title: 'Modern Minimal',
        eyebrow: '最清爽、最產品化的一版',
        rationale: '把所有裝飾壓到最低，讓資訊架構、留白和按鈕線索變成主角。最容易做出俐落的使用體驗。',
        fit: '如果你優先重視 UIUX 的穩定性，這版會最容易讓使用者立即理解。',
        palette: [Color(0xFF101012), Color(0xFF1C1C22), Color(0xFFF0C98A)],
        mood: _MenuMood.modernMinimal,
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('POKER DRINKER Main Menu Demo')),
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

enum _MenuMood {
  quietLuxury,
  signatureSpotlight,
  editorialLedger,
  velvetStage,
  modernMinimal,
}

class _MenuConceptData {
  final String title;
  final String eyebrow;
  final String rationale;
  final String fit;
  final List<Color> palette;
  final _MenuMood mood;
  final double previewAspectRatio;

  const _MenuConceptData({
    required this.title,
    required this.eyebrow,
    required this.rationale,
    required this.fit,
    required this.palette,
    required this.mood,
    this.previewAspectRatio = 0.58,
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
              '這一頁是首頁上線方向比稿，不是單純看風格圖。',
              style: textTheme.titleLarge?.copyWith(color: AppTheme.ink),
            ),
            const SizedBox(height: 10),
            Text(
              '每個版本都在回答同一件事：怎麼讓玩家一眼看懂、知道要按哪裡、同時又維持 POKER DRINKER 應該有的設計感和優雅感。你可以先挑資訊架構最對的方向，再往下微調視覺細節。',
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
  final _MenuConceptData concept;

  const _ConceptSection({required this.concept});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppTheme.panel,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: concept.palette.last.withValues(alpha: 0.14)),
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
              aspectRatio: concept.previewAspectRatio,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: _MenuPreview(concept: concept),
              ),
            ),
            const SizedBox(height: 16),
            _ReasonBlock(title: '為什麼這版有機會上線', content: concept.rationale),
            const SizedBox(height: 10),
            _ReasonBlock(title: '適合你現在的原因', content: concept.fit),
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

class _MenuPreview extends StatelessWidget {
  final _MenuConceptData concept;

  const _MenuPreview({required this.concept});

  @override
  Widget build(BuildContext context) {
    switch (concept.mood) {
      case _MenuMood.quietLuxury:
        return _QuietLuxuryPreview(concept: concept);
      case _MenuMood.signatureSpotlight:
        return _SignatureSpotlightPreview(concept: concept);
      case _MenuMood.editorialLedger:
        return _EditorialLedgerPreview(concept: concept);
      case _MenuMood.velvetStage:
        return _VelvetStagePreview(concept: concept);
      case _MenuMood.modernMinimal:
        return _ModernMinimalPreview(concept: concept);
    }
  }
}

class _PreviewFrame extends StatelessWidget {
  final List<Color> colors;
  final Widget child;
  final bool light;

  const _PreviewFrame({
    required this.colors,
    required this.child,
    this.light = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: colors,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _PreviewTopBar(light: light),
            const SizedBox(height: 18),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}

class _QuietLuxuryPreview extends StatelessWidget {
  final _MenuConceptData concept;

  const _QuietLuxuryPreview({required this.concept});

  @override
  Widget build(BuildContext context) {
    return _PreviewFrame(
      colors: [concept.palette[0], concept.palette[1]],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _StageLabel(label: 'Tonight\'s menu', color: concept.palette[2]),
          const SizedBox(height: 10),
          _StageHeadline(
            title: '選今晚要開的那一桌',
            body: '清楚分成暖場、進場、主桌三個酒感層級。',
            color: Colors.white,
            muted: Colors.white.withValues(alpha: 0.72),
          ),
          const SizedBox(height: 18),
          _MenuDivider(color: concept.palette[2].withValues(alpha: 0.24)),
          const SizedBox(height: 12),
          _MenuStrip(
            accent: const Color(0xFFCC9A5C),
            title: '小酌',
            subtitle: '比大小 / 撲克牌賽馬',
            count: 1,
          ),
          const SizedBox(height: 14),
          _MenuStrip(
            accent: const Color(0xFFC98574),
            title: '微醺',
            subtitle: '微醺模式預留',
            count: 2,
          ),
          const SizedBox(height: 18),
          _HeroMenuPanel(
            title: '喝掛',
            subtitle: '今晚主桌 / 金字塔撲克牌',
            pill: '2-6人',
            accent: concept.palette[2],
            background: const Color(0xFF4C1622),
          ),
        ],
      ),
    );
  }
}

class _SignatureSpotlightPreview extends StatelessWidget {
  final _MenuConceptData concept;

  const _SignatureSpotlightPreview({required this.concept});

  @override
  Widget build(BuildContext context) {
    return _PreviewFrame(
      colors: [concept.palette[0], concept.palette[1]],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _StageLabel(label: 'Headlining table', color: concept.palette[2]),
          const SizedBox(height: 10),
          _HeroFeatureCard(
            accent: concept.palette[2],
            title: '金字塔撲克牌',
            subtitle: '今晚主打，直接進入主桌。',
            badge: '2-6人',
          ),
          const SizedBox(height: 18),
          _CompactTierLine(
            title: '小酌',
            detail: '比大小 / 撲克牌賽馬',
            accent: const Color(0xFFD4A362),
            count: 1,
          ),
          const SizedBox(height: 10),
          _CompactTierLine(
            title: '微醺',
            detail: '微醺模式預留',
            accent: const Color(0xFFD28B78),
            count: 2,
          ),
          const Spacer(),
          Text(
            '這版最像產品首頁：先推主入口，再保留次要選項。',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.68),
              fontSize: 12,
              height: 1.4,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _EditorialLedgerPreview extends StatelessWidget {
  final _MenuConceptData concept;

  const _EditorialLedgerPreview({required this.concept});

  @override
  Widget build(BuildContext context) {
    return _PreviewFrame(
      colors: [concept.palette[0], concept.palette[1]],
      light: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _StageLabel(label: 'CURATED ROUNDS', color: concept.palette[2]),
          const SizedBox(height: 12),
          Text(
            'POKER\nDRINKER',
            style: TextStyle(
              color: concept.palette[2],
              fontSize: 36,
              height: 0.92,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            '一張像精品酒單的首頁。層級靠排版，不靠厚重卡片。',
            style: TextStyle(
              color: concept.palette[2].withValues(alpha: 0.74),
              fontSize: 13,
              height: 1.45,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 18),
          _EditorialRow(
            index: '01',
            title: '小酌',
            detail: '比大小 / 撲克牌賽馬',
            accent: concept.palette[2],
          ),
          const SizedBox(height: 10),
          _EditorialRow(
            index: '02',
            title: '微醺',
            detail: '微醺模式預留',
            accent: concept.palette[2],
          ),
          const SizedBox(height: 10),
          _EditorialHeroRow(
            title: '喝掛',
            detail: '今晚主桌 / 金字塔撲克牌',
            accent: const Color(0xFF6B1D28),
          ),
        ],
      ),
    );
  }
}

class _VelvetStagePreview extends StatelessWidget {
  final _MenuConceptData concept;

  const _VelvetStagePreview({required this.concept});

  @override
  Widget build(BuildContext context) {
    return _PreviewFrame(
      colors: [concept.palette[1], concept.palette[0]],
      child: Stack(
        children: [
          Positioned(
            top: -26,
            right: -18,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: concept.palette[2].withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _StageLabel(label: 'Velvet selection', color: concept.palette[2]),
              const SizedBox(height: 12),
              Text(
                '先選酒感，\n再進玩法',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 27,
                  height: 0.98,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                '三個都是同級類別，真正的遊戲入口收在各自底下，未來擴充也能維持穩定版面。',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.72),
                  fontSize: 12,
                  height: 1.4,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 14),
              _VelvetCategoryBlock(
                title: '小酌',
                accent: const Color(0xFFD5A96A),
                count: 1,
                games: const [
                  _CategoryGameData(label: '比大小', meta: '2-8人'),
                  _CategoryGameData(label: '撲克牌賽馬', meta: '3-8人'),
                ],
              ),
              const SizedBox(height: 8),
              _VelvetCategoryBlock(
                title: '微醺',
                accent: const Color(0xFFD38D7E),
                count: 2,
                games: const [
                  _CategoryGameData(label: '微醺模式預留', meta: '2-6人'),
                  _CategoryGameData(label: '更多玩法預留', meta: 'TBD', dimmed: true),
                ],
              ),
              const SizedBox(height: 8),
              _VelvetCategoryBlock(
                title: '喝掛',
                accent: concept.palette[2],
                count: 3,
                featured: true,
                games: const [
                  _CategoryGameData(
                    label: '金字塔撲克牌',
                    meta: '2-6人',
                    highlighted: true,
                  ),
                  _CategoryGameData(label: '喝掛模式預留', meta: '4-10人'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ModernMinimalPreview extends StatelessWidget {
  final _MenuConceptData concept;

  const _ModernMinimalPreview({required this.concept});

  @override
  Widget build(BuildContext context) {
    return _PreviewFrame(
      colors: [concept.palette[0], concept.palette[1]],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _StageLabel(label: 'Main menu', color: concept.palette[2]),
          const SizedBox(height: 12),
          _StageHeadline(
            title: 'Quick, clear, elegant.',
            body: '把所有花樣降到最低，只留下最必要的點擊線索。',
            color: Colors.white,
            muted: Colors.white.withValues(alpha: 0.66),
          ),
          const SizedBox(height: 20),
          _MinimalRow(
            title: '小酌',
            detail: '2 款暖場玩法',
            accent: const Color(0xFFD4A25F),
          ),
          const SizedBox(height: 8),
          _MinimalRow(
            title: '微醺',
            detail: '1 款進場玩法',
            accent: const Color(0xFFD38C76),
          ),
          const SizedBox(height: 8),
          _MinimalHeroRow(
            title: '喝掛',
            detail: '金字塔撲克牌',
            accent: const Color(0xFFB24A5B),
            pill: '立即進入',
          ),
        ],
      ),
    );
  }
}

class _PreviewTopBar extends StatelessWidget {
  final bool light;

  const _PreviewTopBar({this.light = false});

  @override
  Widget build(BuildContext context) {
    final color = light ? const Color(0xFF33241D) : const Color(0xFFE8C98D);

    return Row(
      children: [
        Text(
          'POKER DRINKER',
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.1,
          ),
        ),
        const Spacer(),
        Icon(Icons.settings, color: color, size: 18),
      ],
    );
  }
}

class _StageLabel extends StatelessWidget {
  final String label;
  final Color color;

  const _StageLabel({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        color: color,
        fontSize: 10,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.3,
      ),
    );
  }
}

class _StageHeadline extends StatelessWidget {
  final String title;
  final String body;
  final Color color;
  final Color muted;

  const _StageHeadline({
    required this.title,
    required this.body,
    required this.color,
    required this.muted,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: color,
            fontSize: 28,
            height: 1.0,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          body,
          style: TextStyle(
            color: muted,
            fontSize: 13,
            height: 1.42,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _MenuDivider extends StatelessWidget {
  final Color color;

  const _MenuDivider({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(height: 1, color: color);
  }
}

class _MenuStrip extends StatelessWidget {
  final Color accent;
  final String title;
  final String subtitle;
  final int count;

  const _MenuStrip({
    required this.accent,
    required this.title,
    required this.subtitle,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(width: 6),
                  _PreviewDrinks(count: count, color: accent),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.66),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Icon(Icons.chevron_right, color: accent),
      ],
    );
  }
}

class _HeroMenuPanel extends StatelessWidget {
  final String title;
  final String subtitle;
  final String pill;
  final Color accent;
  final Color background;

  const _HeroMenuPanel({
    required this.title,
    required this.subtitle,
    required this.pill,
    required this.accent,
    required this.background,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: accent.withValues(alpha: 0.26)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(width: 8),
              _PreviewDrinks(count: 3, color: accent),
              const Spacer(),
              _MiniPill(label: pill, color: accent),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.74),
              fontSize: 13,
              height: 1.4,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroFeatureCard extends StatelessWidget {
  final Color accent;
  final String title;
  final String subtitle;
  final String badge;

  const _HeroFeatureCard({
    required this.accent,
    required this.title,
    required this.subtitle,
    required this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [const Color(0xFF4E1622), const Color(0xFF2A1015)],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: accent.withValues(alpha: 0.28)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tonight\'s featured round',
            style: TextStyle(
              color: accent,
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        height: 1,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.74),
                        fontSize: 13,
                        height: 1.4,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _MiniPill(label: badge, color: accent),
                  const SizedBox(height: 14),
                  Icon(Icons.arrow_forward_rounded, color: accent, size: 22),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CompactTierLine extends StatelessWidget {
  final String title;
  final String detail;
  final Color accent;
  final int count;

  const _CompactTierLine({
    required this.title,
    required this.detail,
    required this.accent,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(width: 6),
                    _PreviewDrinks(count: count, color: accent),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  detail,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.64),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: accent, size: 18),
        ],
      ),
    );
  }
}

class _CategoryGameData {
  final String label;
  final String meta;
  final bool highlighted;
  final bool dimmed;

  const _CategoryGameData({
    required this.label,
    required this.meta,
    this.highlighted = false,
    this.dimmed = false,
  });
}

class _VelvetCategoryBlock extends StatelessWidget {
  final String title;
  final Color accent;
  final int count;
  final bool featured;
  final List<_CategoryGameData> games;

  const _VelvetCategoryBlock({
    required this.title,
    required this.accent,
    required this.count,
    required this.games,
    this.featured = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: const [Color(0xFF4E1622), Color(0xFF2A1015)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: accent.withValues(alpha: featured ? 0.24 : 0.14),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: featured ? 22 : 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(width: 6),
                    _PreviewDrinks(count: count, color: accent),
                  ],
                ),
              ),
              Text(
                '${games.length} 款',
                style: TextStyle(
                  color: accent.withValues(alpha: 0.82),
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          for (var index = 0; index < games.length; index++) ...[
            _VelvetGameRow(game: games[index], accent: accent),
            if (index != games.length - 1)
              Divider(
                height: 12,
                thickness: 1,
                color: Colors.white.withValues(alpha: 0.06),
              ),
          ],
        ],
      ),
    );
  }
}

class _VelvetGameRow extends StatelessWidget {
  final _CategoryGameData game;
  final Color accent;

  const _VelvetGameRow({required this.game, required this.accent});

  @override
  Widget build(BuildContext context) {
    final labelColor = game.dimmed
        ? Colors.white.withValues(alpha: 0.48)
        : Colors.white.withValues(alpha: game.highlighted ? 1 : 0.86);
    final metaColor = game.dimmed
        ? accent.withValues(alpha: 0.4)
        : accent.withValues(alpha: game.highlighted ? 1 : 0.82);

    return Row(
      children: [
        Expanded(
          child: Text(
            game.label,
            style: TextStyle(
              color: labelColor,
              fontSize: game.highlighted ? 17 : 14,
              fontWeight: game.highlighted ? FontWeight.w800 : FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: 8),
        _MiniPill(label: game.meta, color: metaColor),
        if (game.highlighted) ...[
          const SizedBox(width: 8),
          Icon(Icons.arrow_forward_rounded, color: accent, size: 18),
        ],
      ],
    );
  }
}

class _EditorialRow extends StatelessWidget {
  final String index;
  final String title;
  final String detail;
  final Color accent;

  const _EditorialRow({
    required this.index,
    required this.title,
    required this.detail,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: accent.withValues(alpha: 0.18)),
          bottom: BorderSide(color: accent.withValues(alpha: 0.08)),
        ),
      ),
      child: Row(
        children: [
          Text(
            index,
            style: TextStyle(
              color: accent.withValues(alpha: 0.5),
              fontSize: 13,
              fontWeight: FontWeight.w800,
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
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  detail,
                  style: TextStyle(
                    color: accent.withValues(alpha: 0.66),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_outward_rounded, color: accent, size: 18),
        ],
      ),
    );
  }
}

class _EditorialHeroRow extends StatelessWidget {
  final String title;
  final String detail;
  final Color accent;

  const _EditorialHeroRow({
    required this.title,
    required this.detail,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accent.withValues(alpha: 0.16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '03',
            style: TextStyle(
              color: accent.withValues(alpha: 0.6),
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: accent,
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Icon(Icons.arrow_forward_rounded, color: accent),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            detail,
            style: TextStyle(
              color: accent.withValues(alpha: 0.74),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _MinimalRow extends StatelessWidget {
  final String title;
  final String detail;
  final Color accent;

  const _MinimalRow({
    required this.title,
    required this.detail,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  detail,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.62),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_rounded, color: accent, size: 18),
        ],
      ),
    );
  }
}

class _MinimalHeroRow extends StatelessWidget {
  final String title;
  final String detail;
  final Color accent;
  final String pill;

  const _MinimalHeroRow({
    required this.title,
    required this.detail,
    required this.accent,
    required this.pill,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 14, 0, 14),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: accent.withValues(alpha: 0.38), width: 2),
          bottom: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(width: 8),
                    _PreviewDrinks(count: 3, color: accent),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  detail,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.68),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          _MiniPill(label: pill, color: accent),
        ],
      ),
    );
  }
}

class _MiniPill extends StatelessWidget {
  final String label;
  final Color color;

  const _MiniPill({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.18)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _PreviewDrinks extends StatelessWidget {
  final int count;
  final Color color;

  const _PreviewDrinks({required this.count, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var index = 0; index < count; index++) ...[
          Icon(Icons.wine_bar_rounded, size: 12, color: color),
          if (index != count - 1) const SizedBox(width: 2),
        ],
      ],
    );
  }
}
