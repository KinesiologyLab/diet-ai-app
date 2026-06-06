import 'package:flutter/material.dart';

void main() {
  runApp(const RehabGuideApp());
}

class RehabGuideApp extends StatelessWidget {
  const RehabGuideApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '홈 운동 가이드',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1F7A6B),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF7FAF8),
        textTheme: const TextTheme(
          headlineMedium: TextStyle(fontWeight: FontWeight.w800),
          titleLarge: TextStyle(fontWeight: FontWeight.w800),
          titleMedium: TextStyle(fontWeight: FontWeight.w700),
          bodyLarge: TextStyle(height: 1.45),
          bodyMedium: TextStyle(height: 1.45),
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: Color(0xFFE0E8E4)),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
      home: const RehabGuideFlow(),
    );
  }
}

enum FlowStep { onboarding, bodyPart, kneeCheck, movementCheck, result }

enum CheckStatus { possible, difficult }

class CheckItem {
  const CheckItem({
    required this.id,
    required this.title,
    required this.description,
    required this.difficultRoutine,
  });

  final String id;
  final String title;
  final String description;
  final Routine difficultRoutine;
}

class Routine {
  const Routine({
    required this.title,
    required this.category,
    required this.description,
    required this.steps,
  });

  final String title;
  final String category;
  final String description;
  final List<String> steps;
}

const List<CheckItem> kneeCheckItems = [
  CheckItem(
    id: 'ankle',
    title: '발목 가동성 체크',
    description: '무릎을 앞으로 보내며 발목이 부드럽게 움직이는지 확인해요.',
    difficultRoutine: Routine(
      title: '발목 가동성 운동',
      category: '가동성',
      description: '발목이 뻣뻣하게 느껴질 때 무릎 움직임 부담을 줄이는 데 도움을 줍니다.',
      steps: ['벽 앞 무릎 밀기 8회', '종아리 스트레칭 20초', '천천히 2세트 반복'],
    ),
  ),
  CheckItem(
    id: 'hip',
    title: '고관절 유연성 체크',
    description: '앉거나 숙일 때 엉덩이 주변이 편하게 움직이는지 살펴봐요.',
    difficultRoutine: Routine(
      title: '고관절 스트레칭',
      category: '스트레칭',
      description: '고관절 주변 긴장을 낮추고 하체 움직임을 편하게 준비합니다.',
      steps: ['누워서 무릎 당기기 20초', '엉덩이 스트레칭 20초', '좌우 2세트 진행'],
    ),
  ),
  CheckItem(
    id: 'balance',
    title: '한 발 균형 체크',
    description: '한 발로 서 있을 때 몸이 크게 흔들리는지 확인해요.',
    difficultRoutine: Routine(
      title: '균형/활성화 운동',
      category: '활성화',
      description: '하체 안정감과 무릎 주변 근육의 사용감을 깨우는 루틴입니다.',
      steps: ['한 발 서기 15초', '의자 잡고 미니 스쿼트 8회', '좌우 2세트 진행'],
    ),
  ),
];

const Routine basicKneeRoutine = Routine(
  title: '무릎 기본 컨디셔닝 루틴',
  category: '유지 관리',
  description: '체크가 모두 가능했다면 가벼운 준비 운동으로 움직임을 유지해요.',
  steps: ['가벼운 제자리 걷기 1분', '무릎 주변 부드러운 굽혔다 펴기 10회', '편안한 범위에서 2세트'],
);

class RehabGuideFlow extends StatefulWidget {
  const RehabGuideFlow({super.key});

  @override
  State<RehabGuideFlow> createState() => _RehabGuideFlowState();
}

class _RehabGuideFlowState extends State<RehabGuideFlow> {
  final TextEditingController _bodyPartController = TextEditingController();
  FlowStep _step = FlowStep.onboarding;
  String _selectedBodyPart = '';
  CheckItem? _selectedMovementCheckItem;
  final Map<String, CheckStatus> _checkResults = {
    for (final item in kneeCheckItems) item.id: CheckStatus.possible,
  };

  @override
  void dispose() {
    _bodyPartController.dispose();
    super.dispose();
  }

  void _goToBodyPart() {
    setState(() => _step = FlowStep.bodyPart);
  }

  void _selectBodyPart(String bodyPart) {
    setState(() {
      _selectedBodyPart = bodyPart;
      _bodyPartController.text = bodyPart;
    });
  }

  void _goToKneeCheck() {
    final input = _bodyPartController.text.trim();
    if (input.isEmpty) {
      _showMessage('불편한 부위를 입력하거나 빠른 선택을 눌러주세요.');
      return;
    }

    setState(() {
      _selectedBodyPart = input;
      _step = FlowStep.kneeCheck;
    });

    if (input != '무릎') {
      _showMessage('1차 MVP에서는 무릎 움직임 체크를 먼저 제공합니다.');
    }
  }

  void _updateCheck(String id, CheckStatus status) {
    setState(() => _checkResults[id] = status);
  }

  void _openMovementCheck(CheckItem item) {
    setState(() {
      _selectedMovementCheckItem = item;
      _step = FlowStep.movementCheck;
    });
  }

  void _closeMovementCheck() {
    setState(() => _step = FlowStep.kneeCheck);
  }

  void _goToResult() {
    setState(() => _step = FlowStep.result);
  }

  void _restart() {
    setState(() {
      _step = FlowStep.bodyPart;
      _selectedBodyPart = '';
      _bodyPartController.clear();
      for (final item in kneeCheckItems) {
        _checkResults[item.id] = CheckStatus.possible;
      }
    });
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return switch (_step) {
      FlowStep.onboarding => OnboardingScreen(onStart: _goToBodyPart),
      FlowStep.bodyPart => BodyPartScreen(
        controller: _bodyPartController,
        selectedBodyPart: _selectedBodyPart,
        onSelectBodyPart: _selectBodyPart,
        onNext: _goToKneeCheck,
      ),
      FlowStep.kneeCheck => KneeCheckScreen(
        bodyPart: _selectedBodyPart,
        results: _checkResults,
        onChange: _updateCheck,
        onStartMovementCheck: _openMovementCheck,
        onNext: _goToResult,
        onBack: () => setState(() => _step = FlowStep.bodyPart),
      ),
      FlowStep.movementCheck => MovementCheckCameraScreen(
        item: _selectedMovementCheckItem ?? kneeCheckItems.first,
        onComplete: _closeMovementCheck,
        onBack: _closeMovementCheck,
      ),
      FlowStep.result => ResultScreen(
        results: _checkResults,
        onRestart: _restart,
        onBack: () => setState(() => _step = FlowStep.kneeCheck),
      ),
    };
  }
}

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key, required this.onStart});

  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Spacer(),
          IconBadge(
            icon: Icons.self_improvement,
            label: '홈 움직임 가이드',
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 24),
          Text(
            '불편한 부위에 맞춰\n움직임을 자가 점검해요',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          Text(
            '간단한 움직임 체크를 통해 스트레칭, 교정운동, 활성화 운동 루틴을 안내합니다.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),
          const InfoCard(
            icon: Icons.info_outline,
            title: '의학적 진단이 아닌 운동 가이드입니다',
            body: '질환을 판단하거나 치료를 확정하지 않습니다. 통증이 심하거나 지속되면 전문가 상담을 권장합니다.',
          ),
          const Spacer(),
          FilledButton(onPressed: onStart, child: const Text('시작하기')),
        ],
      ),
    );
  }
}

class BodyPartScreen extends StatelessWidget {
  const BodyPartScreen({
    super.key,
    required this.controller,
    required this.selectedBodyPart,
    required this.onSelectBodyPart,
    required this.onNext,
  });

  final TextEditingController controller;
  final String selectedBodyPart;
  final ValueChanged<String> onSelectBodyPart;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    const quickOptions = ['무릎', '어깨', '허리', '발목'];

    return AppScaffold(
      title: '자가 점검',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '어느 부위가 불편한가요?',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 12),
          Text(
            '현재 가장 신경 쓰이는 부위를 적어주세요. 1차 MVP에서는 무릎 체크를 먼저 제공합니다.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: '불편한 부위',
              hintText: '예: 무릎',
              prefixIcon: Icon(Icons.edit_location_alt_outlined),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          Text('빠른 선택', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (final option in quickOptions)
                FilterChip(
                  label: Text(option),
                  selected: selectedBodyPart == option,
                  onSelected: (_) => onSelectBodyPart(option),
                  avatar:
                      selectedBodyPart == option
                          ? const Icon(Icons.check, size: 18)
                          : null,
                ),
            ],
          ),
          const SizedBox(height: 24),
          const InfoCard(
            icon: Icons.directions_walk,
            title: '오늘은 무릎 흐름으로 안내해요',
            body: '다른 부위를 선택해도 무릎 움직임 체크 화면으로 이동합니다.',
          ),
          const Spacer(),
          FilledButton(onPressed: onNext, child: const Text('다음')),
        ],
      ),
    );
  }
}

class KneeCheckScreen extends StatelessWidget {
  const KneeCheckScreen({
    super.key,
    required this.bodyPart,
    required this.results,
    required this.onChange,
    required this.onStartMovementCheck,
    required this.onNext,
    required this.onBack,
  });

  final String bodyPart;
  final Map<String, CheckStatus> results;
  final void Function(String id, CheckStatus status) onChange;
  final ValueChanged<CheckItem> onStartMovementCheck;
  final VoidCallback onNext;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: '무릎 움직임 체크',
      onBack: onBack,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '무릎 주변 움직임을 체크해요',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 12),
          Text(
            '$bodyPart 불편감과 관련될 수 있는 움직임을 가볍게 확인합니다. 무리하지 말고 편안한 범위에서 선택해주세요.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.separated(
              itemCount: kneeCheckItems.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = kneeCheckItems[index];
                return CheckCard(
                  item: item,
                  selectedStatus: results[item.id] ?? CheckStatus.possible,
                  onChange: (status) => onChange(item.id, status),
                  onStartMovementCheck: () => onStartMovementCheck(item),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(onPressed: onNext, child: const Text('추천 루틴 보기')),
        ],
      ),
    );
  }
}

class MovementCheckCameraScreen extends StatelessWidget {
  const MovementCheckCameraScreen({
    super.key,
    required this.item,
    required this.onComplete,
    required this.onBack,
  });

  final CheckItem item;
  final VoidCallback onComplete;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: '자가 움직임 체크',
      onBack: onBack,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(item.title, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 10),
          Text(
            '모범 동작을 참고한 뒤 내 동작을 편안한 범위에서 확인해요.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 18),
          Expanded(
            child: ListView(
              children: [
                MovementPreviewCard(
                  title: '모범 동작',
                  description: '${item.title.replaceAll(' 체크', '')} 테스트 예시 영상',
                  icon: Icons.play_circle_outline,
                  backgroundColor: const Color(0xFFE6EBE8),
                  foregroundColor: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 14),
                MovementPreviewCard(
                  title: '내 동작',
                  description: '카메라 미리보기 영역',
                  icon: Icons.videocam_outlined,
                  backgroundColor: const Color(0xFF202525),
                  foregroundColor: Colors.white,
                  isDark: true,
                ),
                const SizedBox(height: 14),
                const InfoCard(
                  icon: Icons.info_outline,
                  title: '실제 분석은 아직 연결하지 않았어요',
                  body: '현재 화면은 카메라 미리보기처럼 보이는 UI입니다. 무리하지 말고 불편하면 움직임을 멈춰주세요.',
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(onPressed: onComplete, child: const Text('체크 완료')),
        ],
      ),
    );
  }
}

class ResultScreen extends StatelessWidget {
  const ResultScreen({
    super.key,
    required this.results,
    required this.onRestart,
    required this.onBack,
  });

  final Map<String, CheckStatus> results;
  final VoidCallback onRestart;
  final VoidCallback onBack;

  List<Routine> get recommendedRoutines {
    final routines =
        kneeCheckItems
            .where((item) => results[item.id] == CheckStatus.difficult)
            .map((item) => item.difficultRoutine)
            .toList();

    return routines.isEmpty ? [basicKneeRoutine] : routines;
  }

  @override
  Widget build(BuildContext context) {
    final routines = recommendedRoutines;

    return AppScaffold(
      title: '추천 결과',
      onBack: onBack,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('오늘의 운동 가이드', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 12),
          Text(
            '움직임 체크에서 어려웠던 항목을 기준으로 루틴을 추천했어요.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.separated(
              itemCount: routines.length + 1,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                if (index == routines.length) {
                  return const InfoCard(
                    icon: Icons.health_and_safety_outlined,
                    title: '전문가 상담 권장',
                    body: '통증이 심하거나 지속되면 운동을 중단하고 전문가 상담을 권장합니다.',
                  );
                }
                return RoutineCard(routine: routines[index]);
              },
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: onRestart,
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('다시 점검하기'),
          ),
        ],
      ),
    );
  }
}

class AppScaffold extends StatelessWidget {
  const AppScaffold({super.key, required this.child, this.title, this.onBack});

  final Widget child;
  final String? title;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          title == null
              ? null
              : AppBar(
                title: Text(title!),
                leading:
                    onBack == null
                        ? null
                        : IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: onBack,
                          tooltip: '뒤로',
                        ),
              ),
      body: SafeArea(
        child: Padding(padding: const EdgeInsets.all(20), child: child),
      ),
    );
  }
}

class CheckCard extends StatelessWidget {
  const CheckCard({
    super.key,
    required this.item,
    required this.selectedStatus,
    required this.onChange,
    required this.onStartMovementCheck,
  });

  final CheckItem item;
  final CheckStatus selectedStatus;
  final ValueChanged<CheckStatus> onChange;
  final VoidCallback onStartMovementCheck;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(item.description),
            const SizedBox(height: 16),
            SegmentedButton<CheckStatus>(
              segments: const [
                ButtonSegment(
                  value: CheckStatus.possible,
                  label: Text('가능'),
                  icon: Icon(Icons.check_circle_outline),
                ),
                ButtonSegment(
                  value: CheckStatus.difficult,
                  label: Text('어려움'),
                  icon: Icon(Icons.error_outline),
                ),
              ],
              selected: {selectedStatus},
              onSelectionChanged: (selection) => onChange(selection.first),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: onStartMovementCheck,
              icon: const Icon(Icons.videocam_outlined),
              label: const Text('동작 체크하기'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(44),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MovementPreviewCard extends StatelessWidget {
  const MovementPreviewCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.backgroundColor,
    required this.foregroundColor,
    this.isDark = false,
  });

  final String title;
  final String description;
  final IconData icon;
  final Color backgroundColor;
  final Color foregroundColor;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isDark ? const Color(0xFF111616) : null,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: isDark ? Colors.white : null,
              ),
            ),
            const SizedBox(height: 12),
            AspectRatio(
              aspectRatio: 16 / 10,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color:
                        isDark
                            ? const Color(0xFF3A4141)
                            : const Color(0xFFD4DDD9),
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(icon, size: 48, color: foregroundColor),
                      const SizedBox(height: 10),
                      Text(
                        description,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: foregroundColor,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RoutineCard extends StatelessWidget {
  const RoutineCard({super.key, required this.routine});

  final Routine routine;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconBadge(
              icon: Icons.fitness_center,
              label: routine.category,
              color: Theme.of(context).colorScheme.secondary,
            ),
            const SizedBox(height: 12),
            Text(routine.title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(routine.description),
            const SizedBox(height: 14),
            for (final step in routine.steps)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.check,
                      size: 18,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(child: Text(step)),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  const InfoCard({
    super.key,
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer.withAlpha(115),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 6),
                  Text(body),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class IconBadge extends StatelessWidget {
  const IconBadge({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(color: color, fontWeight: FontWeight.w800),
            ),
          ],
        ),
      ),
    );
  }
}
