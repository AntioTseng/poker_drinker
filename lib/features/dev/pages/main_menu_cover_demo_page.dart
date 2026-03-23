import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

class MainMenuCoverDemoPage extends StatelessWidget {
  const MainMenuCoverDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final concepts = <_HomepageConcept>[
      const _HomepageConcept(
        title: 'Signature List',
        eyebrow: '最穩、最容易正式上線的一版',
        summary: '保留你現在的酒吧牌單感，但把層級收乾淨，讓 header 更像招牌，遊戲卡更像真正的點單入口。',
        why: '你現在的首頁已經有不錯的品牌基底，真正需要的不是推翻，而是把品牌、資訊與互動順序梳理好。這版最適合先正式落地。',
        strengths: [
          '最符合你目前已經建立的酒紅 + 金色品牌語言。',
          '開發成本最低，能直接從現在的首頁演進。',
          '使用者一進來就知道要往下選遊戲，不會先被概念吸走。',
        ],
        tradeoffs: ['驚喜感不如更大膽的重排版型。', '如果未來遊戲數量快速增加，還是要再調整列表資訊密度。'],
        variant: _HomepageVariant.signatureList,
      ),
      const _HomepageConcept(
        title: 'Equal Grid',
        eyebrow: '四款遊戲平權、選局效率最高的一版',
        summary: '把首頁做成更像酒吧 menu 的 2x2 主選單，每款遊戲第一屏就能看到，最適合你接下來把四款遊戲都補齊。',
        why: '既然你不想要「今晚主打」，那首頁最佳策略就是讓四款遊戲公平出場，使用者一眼比較人數、節奏與玩法，再決定今晚要開哪一局。',
        strengths: [
          '最適合四個遊戲都存在的產品結構。',
          '首屏即可完成比較，決策速度最快。',
          '視覺上更像真正的酒局選單，而不是內容導流頁。',
        ],
        tradeoffs: ['如果卡片資訊放太多，容易變擁擠。', '需要更嚴格控制字級與文案長度，否則手機版容易失衡。'],
        variant: _HomepageVariant.equalGrid,
      ),
      const _HomepageConcept(
        title: 'Neon Stage',
        eyebrow: '品牌戲劇性最強的一版',
        summary: '把首頁做成像夜店門口的電子牌板，上方招牌更有表演性，下方遊戲像今晚節目單，品牌記憶點最強。',
        why:
            '如果你想把 POKER DRINKER 做得更像一個有夜生活氣味的品牌，而不是單純的小遊戲集合，這版最能把酒吧、牌桌、夜店感整合起來。',
        strengths: [
          '品牌個性最強，最容易讓人留下印象。',
          '和你現在的霓虹招牌 header 方向最一致。',
          '未來很適合延伸到活動頁、節日主題頁或 loading 畫面。',
        ],
        tradeoffs: ['最容易搶走遊戲卡本身的注意力。', '如果全頁節奏控制不好，會比其他版本更像活動頁。'],
        variant: _HomepageVariant.neonStage,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Homepage Demo'),
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
              return const _IntroPanel();
            }

            return _ConceptSection(concept: concepts[index - 1]);
          },
        ),
      ),
    );
  }
}

enum _HomepageVariant { signatureList, equalGrid, neonStage }

class _HomepageConcept {
  final String title;
  final String eyebrow;
  final String summary;
  final String why;
  final List<String> strengths;
  final List<String> tradeoffs;
  final _HomepageVariant variant;

  const _HomepageConcept({
    required this.title,
    required this.eyebrow,
    required this.summary,
    required this.why,
    required this.strengths,
    required this.tradeoffs,
    required this.variant,
  });
}

class _IntroPanel extends StatelessWidget {
  const _IntroPanel();

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
              '這三版不是單純換皮，而是依照你現在的產品背景重新定義首頁任務。',
              style: textTheme.headlineSmall?.copyWith(color: AppTheme.ink),
            ),
            const SizedBox(height: 10),
            Text(
              '我根據你目前已經確定的方向來提案：POKER DRINKER 是朋友局撲克牌喝酒遊戲、視覺要有深酒紅與金色的牌桌酒吧氣味、首頁不需要主打推薦、而是要在四個遊戲都存在的前提下，讓使用者快速選今晚要開哪一局。下面三版的差異，不在美術風格本身，而在「首頁到底要怎麼幫人做決策」。',
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
  final _HomepageConcept concept;

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
                child: _HomepagePreview(variant: concept.variant),
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

class _HomepagePreview extends StatelessWidget {
  final _HomepageVariant variant;

  const _HomepagePreview({required this.variant});

  @override
  Widget build(BuildContext context) {
    return _NightShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _PreviewHeader(variant: variant),
          const SizedBox(height: 14),
          switch (variant) {
            _HomepageVariant.signatureList => const _SignatureListPreview(),
            _HomepageVariant.equalGrid => const _EqualGridPreview(),
            _HomepageVariant.neonStage => const _NeonStagePreview(),
          },
        ],
      ),
    );
  }
}

class _NightShell extends StatelessWidget {
  final Widget child;

  const _NightShell({required this.child});

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
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
            child: child,
          ),
        ],
      ),
    );
  }
}

class _PreviewHeader extends StatelessWidget {
  final _HomepageVariant variant;

  const _PreviewHeader({required this.variant});

  @override
  Widget build(BuildContext context) {
    switch (variant) {
      case _HomepageVariant.signatureList:
        return const _SignboardHeader(mode: _HeaderMode.refined);
      case _HomepageVariant.equalGrid:
        return const _SignboardHeader(mode: _HeaderMode.compact);
      case _HomepageVariant.neonStage:
        return const _SignboardHeader(mode: _HeaderMode.neon);
    }
  }
}

enum _HeaderMode { refined, compact, neon }

class _SignboardHeader extends StatelessWidget {
  final _HeaderMode mode;

  const _SignboardHeader({required this.mode});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isNeon = mode == _HeaderMode.neon;
    final isCompact = mode == _HeaderMode.compact;

    return Container(
      padding: EdgeInsets.fromLTRB(
        isCompact ? 12 : 14,
        isCompact ? 10 : 12,
        isCompact ? 12 : 14,
        isCompact ? 10 : 12,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isNeon
              ? const [Color(0xFF3D1322), Color(0xFF15070D)]
              : const [Color(0xFF34111A), Color(0xFF17080D)],
        ),
        borderRadius: BorderRadius.circular(isCompact ? 20 : 22),
        border: Border.all(color: const Color(0x66F0CD8D)),
        boxShadow: [
          if (isNeon)
            const BoxShadow(
              color: Color(0x30F0CD8D),
              blurRadius: 24,
              spreadRadius: 1,
            ),
          const BoxShadow(
            color: Color(0x30000000),
            blurRadius: 24,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        children: [
          _PlayingCardsMark(compact: isCompact),
          SizedBox(width: isCompact ? 10 : 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!isCompact)
                  Text(
                    '今晚的牌局',
                    style: textTheme.labelSmall?.copyWith(
                      color: const Color(0xFFF0CD8D).withValues(alpha: 0.82),
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.6,
                    ),
                  ),
                if (!isCompact) const SizedBox(height: 3),
                Text(
                  'POKER DRINKER',
                  style:
                      (isCompact
                              ? textTheme.titleLarge
                              : textTheme.headlineSmall)
                          ?.copyWith(
                            color: const Color(0xFFFFE3B1),
                            fontWeight: FontWeight.w900,
                            letterSpacing: isCompact ? 1.0 : 1.2,
                            height: 0.96,
                            shadows: isNeon
                                ? const [
                                    Shadow(
                                      color: Color(0x55F0CD8D),
                                      blurRadius: 14,
                                    ),
                                  ]
                                : null,
                          ),
                ),
                const SizedBox(height: 4),
                Text(
                  isCompact ? '今晚選一局，馬上開桌' : '朋友局最順手的撲克牌喝酒遊戲',
                  style: textTheme.bodySmall?.copyWith(
                    color: const Color(0xFFF0CD8D).withValues(alpha: 0.82),
                    fontWeight: FontWeight.w700,
                    height: 1.25,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: isCompact ? 34 : 38,
            height: isCompact ? 34 : 38,
            decoration: BoxDecoration(
              color: const Color(0x33E8C98D),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0x66F0CD8D)),
            ),
            child: const Icon(
              Icons.settings_rounded,
              color: Color(0xFFF0CD8D),
              size: 18,
            ),
          ),
        ],
      ),
    );
  }
}

class _SignatureListPreview extends StatelessWidget {
  const _SignatureListPreview();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '今晚先開哪一局',
          style: textTheme.titleMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        const _ListTierCard(
          caption: '先暖場',
          title: '小酌',
          accent: Color(0xFFD6A66A),
          games: [_PreviewGameData('比大小', '規則最直覺，上手最快。', '2-8人')],
        ),
        const SizedBox(height: 10),
        const _ListTierCard(
          caption: '節奏上來',
          title: '微醺',
          accent: Color(0xFFD88E7C),
          games: [_PreviewGameData('撲克牌賽馬', '節奏連續，氣氛升得快。', '3-8人')],
        ),
        const SizedBox(height: 10),
        const _ListTierCard(
          caption: '主桌時刻',
          title: '喝掛',
          accent: Color(0xFFE8C98D),
          games: [_PreviewGameData('金字塔撲克牌', '主桌核心玩法，張力最高。', '2-6人')],
          highlighted: true,
        ),
      ],
    );
  }
}

class _EqualGridPreview extends StatelessWidget {
  const _EqualGridPreview();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '今晚開哪一局',
          style: textTheme.titleMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '先看人數，再決定這桌要暖場、連打，還是直接進主桌。',
          style: textTheme.bodySmall?.copyWith(
            color: Colors.white.withValues(alpha: 0.72),
            height: 1.35,
          ),
        ),
        const SizedBox(height: 10),
        const Row(
          children: [
            Expanded(
              child: _GridGameCard(
                title: '比大小',
                tier: '小酌',
                players: '2-8人',
                accent: Color(0xFFD6A66A),
                meta: '最快開局',
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: _GridGameCard(
                title: '撲克牌賽馬',
                tier: '微醺',
                players: '3-8人',
                accent: Color(0xFFD88E7C),
                meta: '連打升溫',
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        const Row(
          children: [
            Expanded(
              child: _GridGameCard(
                title: '金字塔撲克牌',
                tier: '喝掛',
                players: '2-6人',
                accent: Color(0xFFE8C98D),
                meta: '主桌核心',
                highlighted: true,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: _GridGameCard(
                title: '終極懲罰局',
                tier: '喝掛+',
                players: '4-10人',
                accent: Color(0xFFB76A7D),
                meta: '多人失控',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _NeonStagePreview extends StatelessWidget {
  const _NeonStagePreview();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0x33E8C98D), Color(0x122B0D14)],
            ),
            border: Border.all(color: const Color(0x55F0CD8D)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'TONIGHT\'S BOARD',
                style: textTheme.labelLarge?.copyWith(
                  color: const Color(0xFFE8C98D),
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '今晚這桌從哪裡開始失控',
                style: textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const _StageLineRow(
          title: '暖場線',
          accent: Color(0xFFD6A66A),
          games: ['比大小'],
        ),
        const SizedBox(height: 8),
        const _StageLineRow(
          title: '升溫線',
          accent: Color(0xFFD88E7C),
          games: ['撲克牌賽馬'],
        ),
        const SizedBox(height: 8),
        const _StageLineRow(
          title: '主桌線',
          accent: Color(0xFFE8C98D),
          games: ['金字塔撲克牌', '終極懲罰局'],
          highlighted: true,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _NeonInfoChip(
                label: '2-10 人皆可開桌',
                accent: const Color(0xFFE8C98D),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _NeonInfoChip(
                label: '先看節奏，再選懲罰感',
                accent: const Color(0xFFD88E7C),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _PreviewGameData {
  final String title;
  final String summary;
  final String players;

  const _PreviewGameData(this.title, this.summary, this.players);
}

class _ListTierCard extends StatelessWidget {
  final String caption;
  final String title;
  final Color accent;
  final List<_PreviewGameData> games;
  final bool highlighted;

  const _ListTierCard({
    required this.caption,
    required this.title,
    required this.accent,
    required this.games,
    this.highlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(Icons.wine_bar_rounded, size: 12, color: accent),
              const SizedBox(width: 5),
              Text(
                caption,
                style: textTheme.labelSmall?.copyWith(
                  color: accent,
                  fontWeight: FontWeight.w800,
                ),
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
          const SizedBox(height: 8),
          for (var index = 0; index < games.length; index++) ...[
            _PreviewListGameCard(game: games[index], accent: accent),
            if (index != games.length - 1) const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}

class _PreviewListGameCard extends StatelessWidget {
  final _PreviewGameData game;
  final Color accent;

  const _PreviewListGameCard({required this.game, required this.accent});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: accent.withValues(alpha: 0.14)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  game.title,
                  style: textTheme.titleMedium?.copyWith(
                    color: const Color(0xFFE8C98D),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  game.summary,
                  style: textTheme.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.68),
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  game.players,
                  style: textTheme.labelSmall?.copyWith(
                    color: accent,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Icon(
                Icons.arrow_forward_rounded,
                color: Color(0xFFE8C98D),
                size: 16,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GridGameCard extends StatelessWidget {
  final String title;
  final String tier;
  final String players;
  final String meta;
  final Color accent;
  final bool highlighted;

  const _GridGameCard({
    required this.title,
    required this.tier,
    required this.players,
    required this.meta,
    required this.accent,
    this.highlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      height: 136,
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            accent.withValues(alpha: highlighted ? 0.18 : 0.10),
            const Color(0xFF231018),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accent.withValues(alpha: 0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  tier,
                  style: textTheme.labelSmall?.copyWith(
                    color: accent,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const Spacer(),
              Icon(
                Icons.north_east_rounded,
                color: const Color(0xFFE8C98D).withValues(alpha: 0.92),
                size: 18,
              ),
            ],
          ),
          const Spacer(),
          Text(
            title,
            style: textTheme.titleMedium?.copyWith(
              color: const Color(0xFFFFE3B1),
              fontWeight: FontWeight.w900,
              height: 1.08,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            meta,
            style: textTheme.bodySmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.72),
              height: 1.3,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            players,
            style: textTheme.labelSmall?.copyWith(
              color: accent,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _StageLineRow extends StatelessWidget {
  final String title;
  final Color accent;
  final List<String> games;
  final bool highlighted;

  const _StageLineRow({
    required this.title,
    required this.accent,
    required this.games,
    this.highlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 11, 12, 11),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            accent.withValues(alpha: highlighted ? 0.18 : 0.08),
            const Color(0xFF210E15),
          ],
        ),
        border: Border.all(color: accent.withValues(alpha: 0.22)),
        boxShadow: [
          if (highlighted)
            BoxShadow(
              color: accent.withValues(alpha: 0.18),
              blurRadius: 18,
              spreadRadius: 1,
            ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: accent, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 56,
            child: Text(
              title,
              style: textTheme.labelSmall?.copyWith(
                color: accent,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: games
                  .map(
                    (game) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0x22000000),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: accent.withValues(alpha: 0.18),
                        ),
                      ),
                      child: Text(
                        game,
                        style: textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _NeonInfoChip extends StatelessWidget {
  final String label;
  final Color accent;

  const _NeonInfoChip({required this.label, required this.accent});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: accent.withValues(alpha: 0.18)),
      ),
      child: Text(
        label,
        style: textTheme.labelSmall?.copyWith(
          color: accent,
          fontWeight: FontWeight.w800,
          height: 1.25,
        ),
      ),
    );
  }
}

class _PlayingCardsMark extends StatelessWidget {
  final bool compact;

  const _PlayingCardsMark({this.compact = false});

  @override
  Widget build(BuildContext context) {
    final width = compact ? 36.0 : 46.0;
    final height = compact ? 30.0 : 38.0;

    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 0,
            top: compact ? 5 : 7,
            child: Transform.rotate(
              angle: -0.28,
              child: _MiniCard(
                suit: '♥',
                width: compact ? 16 : 19,
                height: compact ? 22 : 26,
              ),
            ),
          ),
          Positioned(
            left: compact ? 10 : 13,
            top: 0,
            child: _MiniCard(
              suit: '♠',
              width: compact ? 17 : 20,
              height: compact ? 23 : 28,
              highlighted: true,
            ),
          ),
          Positioned(
            right: 0,
            top: compact ? 5 : 7,
            child: Transform.rotate(
              angle: 0.28,
              child: _MiniCard(
                suit: '♦',
                width: compact ? 16 : 19,
                height: compact ? 22 : 26,
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
