import 'package:diet_ai_app/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows knee check flow and recommended routine', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const RehabGuideApp());

    expect(find.text('불편한 부위에 맞춰\n움직임을 자가 점검해요'), findsOneWidget);
    expect(find.text('의학적 진단이 아닌 운동 가이드입니다'), findsOneWidget);

    await tester.tap(find.text('시작하기'));
    await tester.pumpAndSettle();

    expect(find.text('어느 부위가 불편한가요?'), findsOneWidget);

    await tester.tap(find.text('무릎'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('다음'));
    await tester.pumpAndSettle();

    expect(find.text('무릎 주변 움직임을 체크해요'), findsOneWidget);
    expect(find.text('발목 가동성 체크'), findsOneWidget);

    final difficultButtons = find.text('어려움');
    await tester.tap(difficultButtons.first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('추천 루틴 보기'));
    await tester.pumpAndSettle();

    expect(find.text('오늘의 운동 가이드'), findsOneWidget);
    expect(find.text('발목 가동성 운동'), findsOneWidget);
    expect(find.text('전문가 상담 권장'), findsOneWidget);
  });
}
