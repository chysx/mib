import 'package:mib/common/constant.dart';
import 'package:mib/route/page_builder.dart';
import 'package:mib/ui/page/checkin/checkin_inventory_page.dart';
import 'package:mib/ui/page/checkin/checkin_inventory_presenter.dart';
import 'package:mib/ui/page/checkin/checkin_page.dart';
import 'package:mib/ui/page/checkin/checkin_presenter.dart';
import 'package:mib/ui/page/checkin/checkin_shipment_page.dart';
import 'package:mib/ui/page/checkin/checkin_shipment_presenter.dart';
import 'package:mib/ui/page/checkout/checkout_inventory_page.dart';
import 'package:mib/ui/page/checkout/checkout_inventory_presenter.dart';
import 'package:mib/ui/page/checkout/checkout_page.dart';
import 'package:mib/ui/page/checkout/checkout_presenter.dart';
import 'package:mib/ui/page/checkout/checkout_shipment_page.dart';
import 'package:mib/ui/page/checkout/checkout_shipment_presenter.dart';
import 'package:mib/ui/page/darshboard/daily_page.dart';
import 'package:mib/ui/page/darshboard/daily_presenter.dart';
import 'package:mib/ui/page/darshboard/inventory_page.dart';
import 'package:mib/ui/page/darshboard/inventory_presenter.dart';
import 'package:mib/ui/page/delivery/delivery_page.dart';
import 'package:mib/ui/page/delivery/delivery_presenter.dart';
import 'package:mib/ui/page/delivery_summary/delivery_summary_page.dart';
import 'package:mib/ui/page/delivery_summary/delivery_summary_presenter.dart';
import 'package:mib/ui/page/document/document_page.dart';
import 'package:mib/ui/page/document/document_presenter.dart';
import 'package:mib/ui/page/login/login_page.dart';
import 'package:mib/ui/page/login/login_presenter.dart';
import 'package:mib/ui/page/print/checkout_slip/print_checkout_slip_page.dart';
import 'package:mib/ui/page/print/checkout_slip/print_checkout_slip_presenter.dart';
import 'package:mib/ui/page/print/print_delivery_slip_page.dart';
import 'package:mib/ui/page/print/print_delivery_slip_presenter.dart';
import 'package:mib/ui/page/print/vansales_slip/print_vansales_slip_page.dart';
import 'package:mib/ui/page/print/vansales_slip/print_vansales_slip_presenter.dart';
import 'package:mib/ui/page/profile/profile_page.dart';
import 'package:mib/ui/page/profile/profile_presenter.dart';
import 'package:mib/ui/page/route/route_page.dart';
import 'package:mib/ui/page/route/route_presenter.dart';
import 'package:mib/ui/page/route_plan/route_plan_page.dart';
import 'package:mib/ui/page/route_plan/route_plan_presenter.dart';
import 'package:mib/ui/page/route_plan_detail/route_plan_detail_page.dart';
import 'package:mib/ui/page/route_plan_detail/route_plan_detail_presenter.dart';
import 'package:mib/ui/page/settings/settings_page.dart';
import 'package:mib/ui/page/settings/settings_presenter.dart';
import 'package:mib/ui/page/start_of_day/start_of_day_page.dart';
import 'package:mib/ui/page/start_of_day/start_of_day_presenter.dart';
import 'package:mib/ui/page/sync/sync_page.dart';
import 'package:mib/ui/page/sync/sync_presenter.dart';
import 'package:mib/ui/page/task_list/task_list_page.dart';
import 'package:mib/ui/page/task_list/task_list_presenter.dart';
import 'package:mib/ui/page/vansales/vansales_page.dart';
import 'package:mib/ui/page/vansales/vansales_presenter.dart';
import 'package:mib/ui/page/vansales_summary/vansales_summary_page.dart';
import 'package:mib/ui/page/vansales_summary/vansales_summary_presenter.dart';
import 'package:mib/ui/page/visit_summary/visit_summary_page.dart';
import 'package:mib/ui/page/visit_summary/visit_summary_presenter.dart';
import 'package:mib/ui/page/visit_summary_detail/visit_summary_detail_page.dart';
import 'package:mib/ui/page/visit_summary_detail/visit_summary_detail_presenter.dart';
import 'package:fluro/fluro.dart';

import '../application.dart';
import 'package:provider/provider.dart';

/// Copyright  Shanghai eBest Information Technology Co. Ltd  2019
///  All rights reserved.
///
///  Author:       张国鹏
///  Email:        guopeng.zhang@ebestmobile.com)
///  Date:         2019/8/2 15:17

PageBuilder notFoundHandler = PageBuilder(builder: (bundle) {
  Application.logger.i('not found router');
  return null;
});

PageBuilder rootHandler = PageBuilder(builder: (bundle) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(
          builder: (context) => new LoginPresenter()
            ..onEvent(LoginEvent.InitData)),
    ],
    child: LoginPage(),
  );
});

PageBuilder settingsHandler = PageBuilder(builder: (bundle) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(builder: (context) => new SettingPresenter()
        ..onEvent(SettingEvent.InitData)),
    ],
    child: SettingsPage(),
  );
});

PageBuilder routeHandler = PageBuilder(builder: (bundle) {
  RouteTitle routeTitle = new RouteTitle();
  return MultiProvider(
    providers: [
      ChangeNotifierProvider<RouteTitle>(builder: (context) => routeTitle),
      ChangeNotifierProvider<RoutePresenter>(
          builder: (context) => new RoutePresenter()
            ..routeTitle = routeTitle
            ..setBundle(bundle)
            ..onEvent(RouteEvent.InitData)),
    ],
    child: RoutePage(),
  );
});

PageBuilder checkoutShipmentHandler = PageBuilder(builder: (bundle) {
  return MultiProvider(
    providers: [
      //ChangeNotifierProvider(builder: (context) => new CheckoutShipmentPresenter()..initData()),

      ChangeNotifierProvider<CheckoutShipmentPresenter>(
          builder: (context) => new CheckoutShipmentPresenter()
            ..onEvent(ShipmentEvent.InitData)),
    ],
    child: CheckoutShipmentPage(),
  );
});

PageBuilder checkoutHandler = PageBuilder(builder: (bundle) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(
          builder: (context) => new CheckoutPresenter()
            ..setBundle(bundle)
            ..onEvent(CheckOutEvent.InitData)),
    ],
    child: CheckoutPage(),
  );
});

PageBuilder checkoutInventoryHandler = PageBuilder(builder: (bundle) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(
          builder: (context) => new CheckoutInventoryPresenter()
            ..setBundle(bundle)
            ..onEvent(CheckOutInventoryEvent.InitData)),
    ],
    child: CheckoutInventoryPage(),
  );
});

PageBuilder checkInHandler = PageBuilder(builder: (bundle) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(
          builder: (context) => new CheckInPresenter()
            ..setBundle(bundle)
            ..onEvent(CheckInEvent.InitData)),
    ],
    child: CheckInPage(),
  );
});

PageBuilder checkInInventoryHandler = PageBuilder(builder: (bundle) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(
          builder: (context) => new CheckInInventoryPresenter()
            ..setBundle(bundle)
            ..onEvent(CheckInInventoryEvent.InitData)),
    ],
    child: CheckInInventoryPage(),
  );
});

PageBuilder checkInShipmentHandler = PageBuilder(builder: (bundle) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(
          builder: (context) => new CheckInShipmentPresenter()
            ..onEvent(CheckInShipmentEvent.InitData)),
    ],
    child: CheckInShipmentPage(),
  );
});

PageBuilder syncHandler = PageBuilder(builder: (bundle) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(
          builder: (context) => new SyncPresenter()
            ..onEvent(SyncEvent.InitData)),
    ],
    child: SyncPage(),
  );
});

PageBuilder routePlanHandler = PageBuilder(builder: (bundle) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(
          builder: (context) => new RoutePlanPresenter()
            ..setBundle(bundle)
            ..onEvent(RoutePlanEvent.InitData)),
    ],
    child: RoutePlanPage(),
  );
});

PageBuilder taskListHandler = PageBuilder(builder: (bundle) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider<TaskListPresenter>(
          builder: (context) => new TaskListPresenter()
            ..setBundle(bundle)
            ..onEvent(TaskListEvent.InitData)),
    ],
    child: TaskListPage(),
  );
});

PageBuilder deliveryHandler = PageBuilder(builder: (bundle) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider<DeliveryPresenter>(
          builder: (context) => new DeliveryPresenter()
            ..setBundle(bundle)
            ..onEvent(DeliveryEvent.InitData)),
    ],
    child: DeliveryPage(),
  );
});

PageBuilder deliverySummaryHandler = PageBuilder(builder: (bundle) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider<DeliverySummaryPresenter>(
          builder: (context) => new DeliverySummaryPresenter()
            ..setBundle(bundle)
            ..onEvent(DeliverySummaryEvent.InitData,context),),
    ],
    child: DeliverySummaryPage(),
  );
});

PageBuilder profileHandler = PageBuilder(builder: (bundle) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider<ProfilePresenter>(
          builder: (context) => new ProfilePresenter()
            ..setBundle(bundle)
            ..onEvent(ProfileEvent.InitData)),
    ],
    child: ProfilePage(),
  );
});

PageBuilder visitSummaryHandler = PageBuilder(builder: (bundle) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(
          builder: (context) => new VisitSummaryPresenter()
            ..setBundle(bundle)
            ..onEvent(VisitSummaryEvent.InitData)),
    ],
    child: VisitSummaryPage(),
  );
});

PageBuilder visitSummaryDetailHandler = PageBuilder(builder: (bundle) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(
          builder: (context) => new VisitSummaryDetailPresenter()
            ..setBundle(bundle)
            ..onEvent(VisitSummaryDetailEvent.InitData)),
    ],
    child: VisitSummaryDetailPage(),
  );
});

PageBuilder documentHandler = PageBuilder(builder: (bundle) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(
          builder: (context) => new DocumentPresenter()
            ..setBundle(bundle)
            ..onEvent(DocumentEvent.InitData)),
    ],
    child: DocumentPage(),
  );
});

PageBuilder printDeliverySlipHandler = PageBuilder(builder: (bundle) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(
          builder: (context) => new PrintDeliverySlipPresenter()
            ..setBundle(bundle)
            ..onEvent(PrintDeliverySlipEvent.InitData)),
    ],
    child: PrintDeliverySlipPage(),
  );
});

PageBuilder printCheckoutSlipHandler = PageBuilder(builder: (bundle) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(
          builder: (context) => new PrintCheckoutSlipPresenter()
            ..setBundle(bundle)
            ..onEvent(PrintCheckoutSlipEvent.InitData)),
    ],
    child: PrintCheckoutSlipPage(),
  );
});

PageBuilder routePlanDetailHandler = PageBuilder(builder: (bundle) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(
          builder: (context) => new RoutePlanDetailPresenter()
            ..setBundle(bundle)
            ..onEvent(RoutePlanDetailEvent.InitData)),
    ],
    child: RoutePlanDetailPage(),
  );
});

PageBuilder vanSalesHandler = PageBuilder(builder: (bundle) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(
          builder: (context) => new VanSalesPresenter()
            ..setBundle(bundle)
            ..onEvent(VanSalesEvent.InitData)),
    ],
    child: VanSalesPage(),
  );
});

PageBuilder vanSalesSummaryHandler = PageBuilder(builder: (bundle) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(
          builder: (context) => new VanSalesSummaryPresenter()
            ..setBundle(bundle)
            ..onEvent(VanSalesSummaryEvent.InitData)),
    ],
    child: VanSalesSummaryPage(),
  );
});

PageBuilder printVanSalesSlipHandler = PageBuilder(builder: (bundle) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(
          builder: (context) => new PrintVanSalesSlipPresenter()
            ..setBundle(bundle)
            ..onEvent(PrintVanSalesSlipEvent.InitData)),
    ],
    child: PrintVanSalesSlipPage(),
  );
});

PageBuilder startOfDayHandler = PageBuilder(builder: (bundle) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(
          builder: (context) => new StartOfDayPresenter()
            ..onEvent(StartOfDayEvent.InitData)),
    ],
    child: StartOfDayPage(),
  );
});

PageBuilder dailyHandler = PageBuilder(builder: (bundle) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(
          builder: (context) => new DailyPresenter()
            ..onEvent(DailyEvent.InitData)),
    ],
    child: DailyPage(),
  );
});

PageBuilder inventoryHandler = PageBuilder(builder: (bundle) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(
          builder: (context) => new InventoryPresenter()
            ..setBundle(bundle)
            ..onEvent(InventoryEvent.InitData)),
    ],
    child: InventoryPage(),
  );
});