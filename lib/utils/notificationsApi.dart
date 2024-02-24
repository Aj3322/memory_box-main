import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:hackharvard21/utils/utils.dart';
import 'package:rxdart/rxdart.dart';

class NotificationsApi {
  static final onNotifications = BehaviorSubject<String?>();

  static Future<void> showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'basic_channel',
        title: title ?? '',
        body: body ?? '',
      ),
      actionButtons: [
        NotificationActionButton(
          key: 'OPEN',
          label: 'Open',
        ),
      ],
    );
  }

  static Future<void> initialize() async {
    AwesomeNotifications().initialize(
      'resource://drawable/res_app_icon',
      [
        NotificationChannel(
          channelKey: 'basic_channel',
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic notifications',
          defaultColor: Color(0xFF9D50DD),
          ledColor: Colors.white,
        ),
      ],
    );

    // No direct equivalent for actionStream in awesome_notifications
    // Instead, handle actions directly in createNotification
  }

  static Future<void> imageNotification() async {
    const String img =
        "https://m.media-amazon.com/images/I/71ijlv+oixL._AC_SX679_.jpg";
    final bigPicturePath = await Utils.downloadFile(img, 'bigPicture');

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        bigPicture: bigPicturePath,
        notificationLayout: NotificationLayout.BigPicture,
        id: 0,
        channelKey: 'basic_channel',
        title: 'Time to take Aspirin',
        body: '1 dose',
      ),
      // actionButtons: [
      //   NotificationActionButton(
      //     key: 'OPEN',
      //     label: 'Open',
      //
      //     onPressed: (context, action) {
      //       // Handle the action here
      //       onNotifications.add(action.buttonKey);
      //     },
      //   ),
      // ],
    );
  }
}
