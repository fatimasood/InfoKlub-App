import 'package:flutter/material.dart';
import 'package:infoklub/app/theme.dart';
import 'package:infoklub/models/reminder/reminder_model.dart';
import 'package:infoklub/viewmodels/Reminders/reminders_viewmodel.dart';
import 'package:infoklub/views/Reminders/add_reminder.dart';
import 'package:provider/provider.dart';

class RemindersHome extends StatelessWidget {
  const RemindersHome({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RemindersViewModel(),
      child: Scaffold(
        backgroundColor: AppTheme.halfwhite,
        body: SafeArea(
          child: Column(
            children: [
              const _ReminderStatsRow(),
              const SizedBox(height: 10),
              const _AllRemindersCard(),
              const SizedBox(height: 15),
              const _ListHeading(),
              const SizedBox(height: 10),
              const Expanded(child: _RemindersList()),
              const _BottomActionBar(),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReminderStatsRow extends StatelessWidget {
  const _ReminderStatsRow();

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<RemindersViewModel>(context);

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            child: _StatCard(
              icon: Icons.calendar_today,
              iconColor: Colors.white,
              iconBgColor: AppTheme.purpleAccent,
              count: vm.todayCount,
              label: 'Today',
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _StatCard(
              icon: Icons.schedule,
              iconColor: AppTheme.whiteColor,
              iconBgColor: AppTheme.redAccent,
              count: vm.scheduledCount,
              label: 'Scheduled',
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final int count;
  final String label;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.count,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconBgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              Text(
                '$count',
                style: const TextStyle(
                  fontSize: 26,
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}

class _AllRemindersCard extends StatelessWidget {
  const _AllRemindersCard();

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<RemindersViewModel>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5.0,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: AppTheme.tealAccent,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.list, color: Colors.white, size: 20),
                ),
                const SizedBox(height: 5),
                Text(
                  'All',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              '${vm.totalCount}',
              style: const TextStyle(
                fontSize: 26,
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ListHeading extends StatelessWidget {
  const _ListHeading();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Text(
            'My List',
            style: TextStyle(
              fontSize: 26,
              color: AppTheme.secondaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacer(),
          Icon(Icons.filter_list, color: AppTheme.secondaryColor),
        ],
      ),
    );
  }
}

class _RemindersList extends StatelessWidget {
  const _RemindersList();

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<RemindersViewModel>(context);

    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.grey.withOpacity(0.3),
          ),
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 5.0,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: vm.reminders.isEmpty
            ? const _EmptyState()
            : ListView.separated(
                padding: const EdgeInsets.all(8.0),
                itemCount: vm.reminders.length,
                separatorBuilder: (context, index) => Divider(
                  height: 1,
                  thickness: 1,
                  color: Colors.grey.withOpacity(0.2),
                ),
                itemBuilder: (context, index) {
                  final reminder = vm.reminders[index];
                  return _ReminderItem(reminder: reminder);
                },
              ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_off,
              size: 60, color: Colors.grey.withOpacity(0.5)),
          const SizedBox(height: 16),
          Text(
            'No reminders yet',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap + to add your first reminder',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReminderItem extends StatelessWidget {
  final Reminder reminder;

  const _ReminderItem({required this.reminder});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<RemindersViewModel>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => vm.toggleCompletion(reminder.id),
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: reminder.isCompleted
                    ? (reminder.color ?? Theme.of(context).primaryColor)
                    : Colors.transparent,
                border: Border.all(
                  color: reminder.isCompleted
                      ? (reminder.color ?? Theme.of(context).primaryColor)
                      : AppTheme.primaryColor,
                  width: 2,
                ),
              ),
              child: reminder.isCompleted
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reminder.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    decoration: reminder.isCompleted
                        ? TextDecoration.lineThrough
                        : null,
                    color: reminder.isCompleted
                        ? AppTheme.secondaryColor.withOpacity(0.8)
                        : AppTheme.secondaryColor,
                  ),
                ),
                if (reminder.notes != null && reminder.notes!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    reminder.notes!,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.secondaryColor.withOpacity(0.6),
                    ),
                  ),
                ],
                if (reminder.date != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    _formatDateTime(reminder.date!, reminder.time),
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.secondaryColor.withOpacity(0.8),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (reminder.color != null)
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: reminder.color,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime date, TimeOfDay? time) {
    final timeStr = time != null
        ? '${time.hour}:${time.minute.toString().padLeft(2, '0')} • '
        : '';
    return '$timeStr${date.day}/${date.month}/${date.year}';
  }
}

class _BottomActionBar extends StatelessWidget {
  const _BottomActionBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => _showAddReminderDialog(context),
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.secondaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Icon(
                  Icons.add,
                  size: 24,
                  color: AppTheme.secondaryColor,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () => _showAddReminderDialog(context),
            child: Text(
              'New Reminder',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppTheme.secondaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddReminderDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.white.withOpacity(0.5),
      builder: (context) => const AddReminder(),
    );
  }
}
