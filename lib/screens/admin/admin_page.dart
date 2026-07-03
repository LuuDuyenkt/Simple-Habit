import 'package:flutter/material.dart';

class AdminPage extends StatelessWidget {
  final List<Map<String, dynamic>> tasks;

  const AdminPage({
    super.key,
    required this.tasks,
  });

  @override
  Widget build(BuildContext context) {
    const mainPurple = Color(0xFF7C74F8);

    final totalUsers = 120;
    final activeUsers = 86;
    final newUsers = 24;

    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: const Text('Admin Dashboard'),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              const Text(
              'Overview',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: _adminCard(
                        context,
                        title: 'Total Users',
                        value: '$totalUsers',
                        icon: Icons.people_outline,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _adminCard(
                        context,
                        title: 'Active Users',
                        value: '$activeUsers',
                        icon: Icons.person_outline,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                Row(
                  children: [
                    Expanded(
                      child: _adminCard(
                        context,
                        title: 'New Users',
                        value: '$newUsers',
                        icon: Icons.person_add_alt_1_outlined,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _adminCard(
                        context,
                        title: 'Feedback',
                        value: '18',
                        icon: Icons.feedback_outlined,
                      ),
                    ),
                  ],
                ),

            const SizedBox(height: 14),

                const SizedBox(height: 28),

                const Text(
                  'Analytics',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 12),

                _chartCard(
                  context,
                  title: 'User Growth',
                  labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May'],
                  values: [20, 40, 70, 110, 160],
                  maxValue: 160,
                ),

                _chartCard(
                  context,
                  title: 'Retention Rate',
                  labels: ['D1', 'D3', 'D7', 'D14'],
                  values: [100, 70, 55, 40],
                  maxValue: 100,
                ),

                _chartCard(
                  context,
                  title: 'Habit Consistency',
                  labels: ['1-3', '4-7', '8-14', '15+'],
                  values: [40, 30, 20, 10],
                  maxValue: 40,
                ),

                const Text(
                  'User List',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),


                const SizedBox(height: 12),

                _userTile(
                  context,
                  name: 'Luu Duyen',
                  status: 'Active',
                  habits: 6,
                  completed: 5,
                  pending: 1,
                  streak: 4,
                ),

                _userTile(
                  context,
                  name: 'Minh Anh',
                  status: 'Active',
                  habits: 7,
                  completed: 6,
                  pending: 1,
                  streak: 8,
                ),

                _userTile(
                  context,
                  name: 'Hoang Nam',
                  status: 'Inactive',
                  habits: 5,
                  completed: 3,
                  pending: 2,
                  streak: 2,
                ),

            // const SizedBox(height: 28),

            // const Text(
            //   'User List',
            //   style: TextStyle(
            //     fontSize: 20,
            //     fontWeight: FontWeight.w700,
            //   ),
            // ),
            //
            // const SizedBox(height: 12),
            //
            // Container(
            //     padding: const EdgeInsets.all(16),
            //     decoration: BoxDecoration(
            //         color: Theme.of(context).cardColor,
            //         borderRadius: BorderRadius.circular(18),
            //         boxShadow: [BoxShadow(
            //           color: Colors.black.withOpacity(0.05),
            //           blurRadius: 10,
            //           offset: const Offset(0, 4),
            //         ),
            //         ],
            //     ),
            //   child: Row(
            //     children: [
            //       const CircleAvatar(
            //         backgroundColor: mainPurple,
            //         child: Icon(Icons.person, color: Colors.white),
            //       ),
            //       const SizedBox(width: 14),
            //       Expanded(
            //         child: Column(
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           children: [
            //             const Text(
            //               'Luu Duyen',
            //               style: TextStyle(
            //                 fontSize: 16,
            //                 fontWeight: FontWeight.w700,
            //               ),
            //             ),
            //             const SizedBox(height: 4),
            //             Text(
            //               'Habits: 6 • Completed: 5',
            //               style: TextStyle(
            //                 color: Theme.of(context).textTheme.bodySmall?.color,
            //               ),
            //             ),
            //           ],
            //         ),
            //       ),
            //       const Text(
            //         'Active',
            //         style: TextStyle(
            //           color: mainPurple,
            //           fontWeight: FontWeight.w600,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
              ],
            ),
          ),
        ),
    );
  }

  Widget _adminCard(
      BuildContext context, {
        required String title,
        required String value,
        required IconData icon,
      }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFF7C74F8), size: 28),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _userTile(
      BuildContext context, {
        required String name,
        required String status,
        required int habits,
        required int completed,
        required int pending,
        required int streak,
      }) {
    const mainPurple = Color(0xFF7C74F8);

    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (_) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: Color(0xFF7C74F8),
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  _detailRow('Habits', '$habits'),
                  _detailRow('Completed Today', '$completed'),
                  _detailRow('Pending Today', '$pending'),
                  _detailRow('Streak', '$streak days'),

                  const SizedBox(height: 20),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            const CircleAvatar(
              backgroundColor: mainPurple,
              child: Icon(Icons.person, color: Colors.white),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Habits: $habits • Completed: $completed',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              status,
              style: const TextStyle(
                color: mainPurple,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  Widget _chartCard(
      BuildContext context, {
        required String title,
        required List<String> labels,
        required List<int> values,
        required int maxValue,
      }) {
    const mainPurple = Color(0xFF7C74F8);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 18),

          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(values.length, (index) {
              final percent = values[index] / maxValue;

              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    '${values[index]}',
                    style: TextStyle(
                      fontSize: 11,
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: 22,
                    height: 90 * percent,
                    decoration: BoxDecoration(
                      color: mainPurple.withOpacity(0.75),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    labels[index],
                    style: TextStyle(
                      fontSize: 11,
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

}