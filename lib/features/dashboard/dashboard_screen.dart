import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../design_system/app_colors.dart';
import '../../design_system/app_text_styles.dart';
import '../../design_system/dimensions.dart';
import '../../utils/responsive_helper.dart';
import '../../widgets/dashboard_card.dart';
import '../../widgets/drawer_item.dart';
import 'bloc/dashboard_bloc.dart';
import 'bloc/dashboard_event.dart';
import 'bloc/dashboard_state.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DashboardBloc()..add(LoadDashboard()),
      child: Scaffold(
        appBar: AppBar(
          title: Image.asset(
            'assets/logo/Metatech-latest-logo.webp',
            width: AppDimensions.iconSizeLarge(context),
            height: AppDimensions.iconSizeLarge(context),
          ),
          centerTitle: true,
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerItem(
                title: 'Dashboard',
                icon: Icons.dashboard,
                route: '/dashboard',
                onTap: () {
                  Navigator.pop(context);
                  context.read<DashboardBloc>().add(LoadDashboard());
                },
              ),
              DrawerItem(
                title: 'Profile',
                icon: Icons.person,
                route: '/profile',
              ),
              DrawerItem(
                title: 'Projects',
                icon: Icons.work_outline,
                route: '/projects',
              ),
              DrawerItem(
                title: 'Invoices',
                icon: Icons.receipt_long,
                route: '/invoices',
              ),
              DrawerItem(
                title: 'Support',
                icon: Icons.support_agent,
                route: '/support',
              ),
              DrawerItem(
                title: 'Logout',
                icon: Icons.logout,
                route: '/login',
                iconColor: AppColors.error,
                textColor: AppColors.error,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, '/login');
                },
              ),
            ],
          ),
        ),
        body: Container(
          color: AppColors.background,
          padding: EdgeInsets.all(AppDimensions.padding(context)),
          child: BlocBuilder<DashboardBloc, DashboardState>(
            builder: (context, state) {
              final width = MediaQuery.of(context).size.width;
              final cardWidth = ResponsiveHelper.isMobile(context) ? width * 0.9 : width * 0.2;

              if (state is DashboardLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is DashboardError) {
                return Center(child: Text('Error: ${state.message}'));
              }
              if (state is DashboardLoaded) {
                final cards = [
                  {'title': 'Ongoing Project', 'percent': '10', 'percentNumber': '20', 'route': '/profile'},
                  {'title': 'Total Leads', 'percent': '10', 'percentNumber': '20', 'route': '/projects'},
                  {'title': 'Active Campaigns', 'percent': '10', 'percentNumber': '20', 'route': '/projects'},
                  {'title': 'Total Impression', 'percent': '10', 'percentNumber': '20', 'route': '/projects'},
                ];

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome, ${state.clientName}',
                        style: AppTextStyles.textTheme(context).headlineSmall,
                      ),
                      SizedBox(height: AppDimensions.padding(context)),
                      Wrap(
                        spacing: AppDimensions.padding(context),
                        runSpacing: AppDimensions.padding(context),
                        children: cards.map((card) {
                          return DashboardCard(
                            title: card['title'] as String,
                            percent: double.tryParse(card['percent'] ?? '0') ?? 0.0,
                            percentNumber: double.tryParse(card['percentNumber'] ?? '0') ?? 0.0,
                            width: cardWidth,
                            onTap: () => Navigator.pushNamed(context, card['route'] as String),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: AppDimensions.paddingLarge(context)),
                      Text(
                        'Project Progress',
                        style: AppTextStyles.textTheme(context).headlineSmall,
                      ),
                      SizedBox(height: AppDimensions.padding(context)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: state.sdlcStages.asMap().entries.map((entry) {
                          final index = entry.key;
                          final stage = entry.value;
                          final isCompleted = stage['completed'] as bool;
                          return Expanded(
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: AppDimensions.scale(context, 2.0)),
                                  height: AppDimensions.scale(context, 10.0),
                                  decoration: BoxDecoration(
                                    color: isCompleted ? AppColors.success : AppColors.warning,
                                    borderRadius: BorderRadius.circular(AppDimensions.scale(context, 5.0)),
                                  ),
                                ),
                                SizedBox(height: AppDimensions.spacingSmall(context)),
                                Text(
                                  stage['name'],
                                  style: AppTextStyles.textTheme(context).labelSmall?.copyWith(
                                    color: AppColors.textPrimary,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),

                    ],
                  ),
                );
              }
              return const Center(child: Text('Initial State'));
            },
          ),
        ),
      ),
    );
  }
}