import 'package:diet_ai_app/main.dart';
import 'package:flutter/material.dart';
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
    expect(find.text('동작 체크하기'), findsWidgets);

    await tester.tap(find.text('동작 체크하기').first);
    await tester.pumpAndSettle();

    expect(find.text('자가 움직임 체크'), findsOneWidget);
    expect(find.text('모범 동작'), findsOneWidget);
    expect(find.text('발목 가동성 테스트 예시 영상'), findsOneWidget);

    await tester.drag(find.byType(ListView), const Offset(0, -360));
    await tester.pumpAndSettle();

    expect(find.text('내 동작'), findsOneWidget);
    expect(find.text('카메라 미리보기 영역'), findsOneWidget);

    await tester.tap(find.text('체크 완료'));
    await tester.pumpAndSettle();

    expect(find.text('무릎 주변 움직임을 체크해요'), findsOneWidget);

    final difficultButtons = find.text('어려움');
    await tester.tap(difficultButtons.first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('추천 루틴 보기'));
    await tester.pumpAndSettle();

    expect(find.text('오늘의 운동 가이드'), findsOneWidget);
    expect(find.text('발목 가동성 추천 루틴'), findsOneWidget);
    expect(find.text('벽 발목 가동성 운동'), findsOneWidget);
    expect(find.text('종아리 스트레칭'), findsOneWidget);
    expect(find.text('힐 레이즈'), findsOneWidget);

    await tester.tap(find.text('벽 발목 가동성 운동'));
    await tester.pumpAndSettle();

    expect(find.text('운동 상세'), findsOneWidget);
    expect(find.text('운동 목적'), findsOneWidget);
    expect(find.text('수행 방법'), findsOneWidget);
    expect(find.text('권장 횟수/시간'), findsOneWidget);
    expect(find.text('주의사항'), findsOneWidget);
    expect(find.text('좌우 8~10회씩 2세트'), findsOneWidget);

    await tester.drag(find.byType(ListView), const Offset(0, -520));
    await tester.pumpAndSettle();

    expect(find.text('통증이 심해지면 중단하고 전문가 상담을 권장합니다.'), findsOneWidget);

    await tester.tap(find.byTooltip('뒤로'));
    await tester.pumpAndSettle();

    expect(find.text('오늘의 운동 가이드'), findsOneWidget);

    await tester.drag(find.byType(ListView), const Offset(0, -480));
    await tester.pumpAndSettle();

    expect(
      find.text('이 결과는 의학적 진단이 아닌 자가 움직임 체크 기반 운동 가이드입니다.'),
      findsOneWidget,
    );
    expect(find.text('통증이 심하거나 지속된다면 전문가 상담을 권장합니다.'), findsOneWidget);
    expect(find.text('전문가 상담 권장'), findsOneWidget);
  });

  testWidgets('shows basic knee routine when every check is possible', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const RehabGuideApp());

    await tester.tap(find.text('시작하기'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('무릎'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('다음'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('추천 루틴 보기'));
    await tester.pumpAndSettle();

    expect(find.text('기본 무릎 컨디셔닝 루틴'), findsOneWidget);
    expect(find.text('바디웨이트 스쿼트'), findsOneWidget);
    expect(find.text('런지'), findsOneWidget);
    expect(find.text('힙힌지 연습'), findsOneWidget);
  });
}
