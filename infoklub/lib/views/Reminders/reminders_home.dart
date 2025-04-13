import 'package:flutter/material.dart';
import 'package:infoklub/app/theme.dart';
import 'package:infoklub/viewmodels/Reminders/reminders_viewmodel.dart';
import 'package:provider/provider.dart';

class RemindersHome extends StatelessWidget {
  const RemindersHome({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RemindersViewModel(),
      child: const Scaffold(
        backgroundColor: AppTheme.halfwhite,
        body: SafeArea(
          child: Column(
            children: [
              //const SizedBox(height: 20),
              // Stats Row
              _ReminderStatsRow(),
              SizedBox(height: 10),
              // All Reminders Card
              _AllRemindersCard(),
              SizedBox(height: 15),
              // My List Heading
              _ListHeading(),
              SizedBox(height: 10),
              // Reminders List
              Expanded(child: _RemindersList()),
              // Bottom Action Bar
              _BottomActionBar(),
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
                const SizedBox(
                  height: 5,
                ),
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
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'My List',
          style: TextStyle(
            fontSize: 26,
            color: AppTheme.secondaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
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
        child: ListView.separated(
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
                if (reminder.dateTime != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    _formatDateTime(reminder.dateTime!),
                    style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.secondaryColor.withOpacity(0.8)),
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

  String _formatDateTime(DateTime dt) {
    return '${dt.hour}:${dt.minute.toString().padLeft(2, '0')} • ${dt.day}/${dt.month}/${dt.year}';
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
          Container(
            // padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Icon(
                Icons.add,
                size: 18,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'New Reminder',
            style: TextStyle(
              color: AppTheme.secondaryColor,
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
          const Spacer(),
          const Text(
            'Add List',
            style: TextStyle(
              color: AppTheme.secondaryColor,
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
