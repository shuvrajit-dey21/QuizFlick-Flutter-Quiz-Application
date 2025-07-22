import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample notifications data
    final List<NotificationItem> notifications = [
      NotificationItem(
        title: 'Daily Quiz Available!',
        message: 'Your daily quiz is ready. Complete it to maintain your streak!',
        time: '2 hours ago',
        isRead: false,
        icon: Icons.quiz,
        color: Colors.blue,
      ),
      NotificationItem(
        title: 'New High Score!',
        message: 'Congratulations! You achieved a new high score in Science category.',
        time: '1 day ago',
        isRead: true,
        icon: Icons.star,
        color: Colors.orange,
      ),
      NotificationItem(
        title: 'Weekly Challenge',
        message: 'Join this week\'s challenge and compete with other players!',
        time: '2 days ago',
        isRead: true,
        icon: Icons.emoji_events,
        color: Colors.purple,
      ),
      NotificationItem(
        title: 'App Update Available',
        message: 'A new version of the app is available with exciting features!',
        time: '3 days ago',
        isRead: true,
        icon: Icons.system_update,
        color: Colors.green,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24.0,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade400, Colors.blue.shade900],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              // Mark all as read functionality
              Get.snackbar(
                'Success',
                'All notifications marked as read',
                backgroundColor: Colors.green,
                colorText: Colors.white,
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            icon: const Icon(Icons.done_all),
            tooltip: 'Mark all as read',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade50, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: notifications.isEmpty
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.notifications_off,
                      size: 80,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No notifications yet',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notification = notifications[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    elevation: notification.isRead ? 2 : 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: notification.color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          notification.icon,
                          color: notification.color,
                          size: 24,
                        ),
                      ),
                      title: Text(
                        notification.title,
                        style: TextStyle(
                          fontWeight: notification.isRead 
                              ? FontWeight.w500 
                              : FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(
                            notification.message,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            notification.time,
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      trailing: notification.isRead
                          ? null
                          : Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                              ),
                            ),
                      onTap: () {
                        // Handle notification tap
                        Get.snackbar(
                          'Notification',
                          notification.title,
                          backgroundColor: notification.color,
                          colorText: Colors.white,
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }
}

class NotificationItem {
  final String title;
  final String message;
  final String time;
  final bool isRead;
  final IconData icon;
  final Color color;

  NotificationItem({
    required this.title,
    required this.message,
    required this.time,
    required this.isRead,
    required this.icon,
    required this.color,
  });
}
