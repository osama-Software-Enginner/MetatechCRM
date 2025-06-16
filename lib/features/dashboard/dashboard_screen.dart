import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
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
              final cardWidth = ResponsiveHelper.isMobile(context)
                  ? width * 0.9
                  : width * 0.2;
              final chartHeight = ResponsiveHelper.isMobile(context)
                  ? width * 0.6
                  : width * 0.3;

              if (state is DashboardLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is DashboardError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Error: ${state.message}',
                        style: AppTextStyles.textTheme(context).bodyMedium,
                      ),
                      SizedBox(height: AppDimensions.padding(context)),
                      ElevatedButton(
                        onPressed: () =>
                            context.read<DashboardBloc>().add(LoadDashboard()),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }
              if (state is DashboardLoaded) {
                final cards = [
                  {
                    'title': 'Ongoing Projects',
                    'percent': '10',
                    'percentNumber': state.graphData.length.toString(),
                    'route': '/profile',
                  },
                  {
                    'title': 'Total Leads',
                    'percent': '10',
                    'percentNumber': state.campaignTimeSeriesData
                        .where(
                          (data) =>
                              state.visibleEmirates.contains(data['emirate']),
                        )
                        .fold(
                          0.0,
                          (sum, data) =>
                              sum +
                              (data['leads'] as List<double>).reduce(
                                (a, b) => a + b,
                              ),
                        )
                        .toStringAsFixed(0),
                    'route': '/projects',
                  },
                  {
                    'title': 'Active Campaigns',
                    'percent': '10',
                    'percentNumber': state.visibleEmirates.length.toString(),
                    'route': '/projects',
                  },
                  {
                    'title': 'Total Impressions',
                    'percent': '10',
                    'percentNumber': state.campaignTimeSeriesData
                        .where(
                          (data) =>
                              state.visibleEmirates.contains(data['emirate']),
                        )
                        .fold(
                          0.0,
                          (sum, data) =>
                              sum +
                              (data['impressions'] as List<double>).reduce(
                                (a, b) => a + b,
                              ),
                        )
                        .toStringAsFixed(0),
                    'route': '/projects',
                  },
                  {
                    'title': 'Lorem Ipsum',
                    'percent': '10',
                    'percentNumber': 10.toStringAsFixed(0),
                    'route': '/',
                  },
                  {
                    'title': 'Lorem Ipsum',
                    'percent': '10',
                    'percentNumber': 10.toStringAsFixed(0),
                    'route': '/',
                  },
                  {
                    'title': 'Lorem Ipsum',
                    'percent': '10',
                    'percentNumber': 10.toStringAsFixed(0),
                    'route': '/',
                  },
                  {
                    'title': 'Lorem Ipsum',
                    'percent': '10',
                    'percentNumber': 10.toStringAsFixed(0),
                    'route': '/',
                  },
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
                            onTap: () => Navigator.pushNamed(
                              context,
                              card['route'] as String,
                            ),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: AppDimensions.padding(context)),

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
                                  margin: EdgeInsets.symmetric(
                                    horizontal: AppDimensions.scale(
                                      context,
                                      2.0,
                                    ),
                                  ),
                                  height: AppDimensions.scale(context, 10.0),
                                  decoration: BoxDecoration(
                                    color: isCompleted
                                        ? AppColors.success
                                        : AppColors.warning,
                                    borderRadius: BorderRadius.circular(
                                      AppDimensions.scale(context, 5.0),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: AppDimensions.spacingSmall(context),
                                ),
                                Text(
                                  stage['name'],
                                  style: AppTextStyles.textTheme(context)
                                      .labelSmall
                                      ?.copyWith(color: AppColors.textPrimary),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: AppDimensions.paddingLarge(context)),
                      Text(
                        'Campaign Leads Over Time',
                        style: AppTextStyles.textTheme(
                          context,
                        ).titleMedium,
                      ),

                      SizedBox(height: AppDimensions.padding(context)),

                      // SizedBox(
                      //   height: AppDimensions.scale(context, 150),
                      //   child: Row(
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: [
                      //       /// Pie Chart
                      //       SizedBox(
                      //         width: ResponsiveHelper.isMobile(context)
                      //             ? AppDimensions.scale(context, 120)
                      //             : AppDimensions.scale(context, 180),
                      //         child: Padding(
                      //           padding: EdgeInsets.all(AppDimensions.padding(context)),
                      //           child: PieChart(
                      //             PieChartData(
                      //               sections: state.graphData.asMap().entries.map((entry) {
                      //                 final index = entry.key;
                      //                 final data = entry.value;
                      //                 return PieChartSectionData(
                      //                   color: [
                      //                     AppColors.brand,
                      //                     AppColors.brand.shade700,
                      //                     AppColors.success,
                      //                     AppColors.warning,
                      //                   ][index % 4],
                      //                   value: data['value'] as double,
                      //                   title: '${data['name']}\n${data['value']}',
                      //                   radius: ResponsiveHelper.isMobile(context) ? 40 : 60,
                      //                   titleStyle: AppTextStyles.textTheme(context).labelSmall?.copyWith(
                      //                     color: Colors.white,
                      //                     fontSize: ResponsiveHelper.isMobile(context) ? 10 : 12,
                      //                   ),
                      //                 );
                      //               }).toList(),
                      //               sectionsSpace: 2,
                      //               centerSpaceRadius: ResponsiveHelper.isMobile(context) ? 25 : 35,
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //
                      //       SizedBox(width: AppDimensions.padding(context)),
                      //
                      //       /// Wrap - Chips
                      //       Expanded(
                      //         child: Wrap(
                      //           spacing: AppDimensions.padding(context),
                      //           runSpacing: AppDimensions.padding(context),
                      //           children: state.campaignTimeSeriesData.map((data) {
                      //             final emirate = data['emirate'] as String;
                      //             return ChoiceChip(
                      //               label: Text(emirate),
                      //               selected: state.visibleEmirates.contains(emirate),
                      //               onSelected: (selected) {
                      //                 context.read<DashboardBloc>().add(ToggleEmirate(emirate));
                      //               },
                      //               selectedColor: AppColors.brand.shade100,
                      //               backgroundColor: AppColors.background,
                      //               labelStyle: AppTextStyles.textTheme(context).bodySmall?.copyWith(
                      //                 color: state.visibleEmirates.contains(emirate)
                      //                     ? AppColors.brand
                      //                     : AppColors.textSecondary,
                      //               ),
                      //             );
                      //           }).toList(),
                      //         ),
                      //       ),
                      //
                      //       SizedBox(width: AppDimensions.padding(context)),
                      //
                      //       /// Line Chart
                      //       SizedBox(
                      //         width: ResponsiveHelper.isMobile(context)
                      //             ? AppDimensions.scale(context, 150)
                      //             : AppDimensions.scale(context, 220),
                      //         child: Padding(
                      //           padding: EdgeInsets.all(AppDimensions.padding(context)),
                      //           child: state.visibleEmirates.isEmpty
                      //               ? Center(
                      //             child: Text(
                      //               'Select an emirate to view data',
                      //               style: AppTextStyles.textTheme(context).bodyMedium,
                      //             ),
                      //           )
                      //               : LineChart(
                      //             LineChartData(
                      //               gridData: const FlGridData(show: true),
                      //               titlesData: FlTitlesData(
                      //                 leftTitles: AxisTitles(
                      //                   sideTitles: SideTitles(
                      //                     showTitles: true,
                      //                     reservedSize: 40,
                      //                     getTitlesWidget: (value, meta) {
                      //                       return Text(
                      //                         value.toInt().toString(),
                      //                         style: AppTextStyles.textTheme(context).labelSmall,
                      //                       );
                      //                     },
                      //                   ),
                      //                 ),
                      //                 bottomTitles: AxisTitles(
                      //                   sideTitles: SideTitles(
                      //                     showTitles: true,
                      //                     getTitlesWidget: (value, meta) {
                      //                       return Text(
                      //                         'D${value.toInt() + 1}',
                      //                         style: AppTextStyles.textTheme(context).labelSmall,
                      //                       );
                      //                     },
                      //                   ),
                      //                 ),
                      //                 topTitles: const AxisTitles(
                      //                   sideTitles: SideTitles(showTitles: false),
                      //                 ),
                      //                 rightTitles: const AxisTitles(
                      //                   sideTitles: SideTitles(showTitles: false),
                      //                 ),
                      //               ),
                      //               borderData: FlBorderData(show: true),
                      //               lineBarsData: state.campaignTimeSeriesData
                      //                   .asMap()
                      //                   .entries
                      //                   .where((entry) => state.visibleEmirates.contains(entry.value['emirate']))
                      //                   .map((entry) {
                      //                 final index = entry.key;
                      //                 final data = entry.value;
                      //                 return LineChartBarData(
                      //                   spots: (data['leads'] as List<double>)
                      //                       .asMap()
                      //                       .entries
                      //                       .map((e) => FlSpot(e.key.toDouble(), e.value))
                      //                       .toList(),
                      //                   isCurved: true,
                      //                   color: [
                      //                     AppColors.brand,
                      //                     AppColors.brand.shade700,
                      //                     AppColors.success,
                      //                     AppColors.warning,
                      //                   ][index % 4],
                      //                   barWidth: 2,
                      //                   dotData: const FlDotData(show: false),
                      //                 );
                      //               }).toList(),
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),

                    SizedBox(
                      height: AppDimensions.scale(context, 300),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: BlocBuilder<DashboardBloc, DashboardState>(
                          builder: (context, state) {
                            if (state is DashboardLoading) {
                              return const Center(child: CircularProgressIndicator());
                            } else if (state is DashboardError) {
                              return Center(child: Text(state.message));
                            } else if (state is! DashboardLoaded) {
                              return const SizedBox();
                            }

                            final graphData = state.graphData;

                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /// Pie Chart
                                SizedBox(
                                  width: ResponsiveHelper.isMobile(context)
                                      ? AppDimensions.scale(context, 140)
                                      : AppDimensions.scale(context, 200),
                                  child: Padding(
                                    padding: EdgeInsets.all(AppDimensions.padding(context)),
                                    child: PieChart(
                                      PieChartData(
                                        sections: graphData.asMap().entries.map((entry) {
                                          final index = entry.key;
                                          final data = entry.value;
                                          return PieChartSectionData(
                                            color: [
                                              AppColors.brand,
                                              AppColors.brand.shade700,
                                              AppColors.success,
                                              AppColors.warning,
                                            ][index % 4],
                                            value: data['value'] as double,
                                            title: '${data['name']}\n${data['value']}',
                                            radius: ResponsiveHelper.isMobile(context) ? 40 : 60,
                                            titleStyle: AppTextStyles.textTheme(context).labelSmall?.copyWith(
                                              color: Colors.white,
                                              fontSize: ResponsiveHelper.isMobile(context) ? 10 : 12,
                                            ),
                                          );
                                        }).toList(),
                                        sectionsSpace: 2,
                                        centerSpaceRadius: ResponsiveHelper.isMobile(context) ? 25 : 35,
                                      ),
                                    ),
                                  ),
                                ),

                                SizedBox(width: AppDimensions.padding(context)),

                                /// Bar Chart
                                SizedBox(
                                  width: ResponsiveHelper.isMobile(context)
                                      ? AppDimensions.scale(context, 280)
                                      : AppDimensions.scale(context, 400),
                                  child: Padding(
                                    padding: EdgeInsets.all(AppDimensions.padding(context)),
                                    child: BarChart(
                                      BarChartData(
                                        alignment: BarChartAlignment.spaceEvenly,
                                        maxY: graphData
                                            .map((e) => (e['value'] as num).toDouble())
                                            .reduce((a, b) => a > b ? a : b) +
                                            10,
                                        titlesData: FlTitlesData(
                                          bottomTitles: AxisTitles(
                                            sideTitles: SideTitles(
                                              showTitles: true,
                                              getTitlesWidget: (value, _) {
                                                final index = value.toInt();
                                                if (index >= 0 && index < graphData.length) {
                                                  return Text(
                                                    graphData[index]['name'],
                                                    style: AppTextStyles.textTheme(context).labelSmall,
                                                  );
                                                }
                                                return const SizedBox();
                                              },
                                            ),
                                          ),
                                          leftTitles: AxisTitles(
                                            sideTitles: SideTitles(
                                              showTitles: true,
                                              reservedSize: 30,
                                              getTitlesWidget: (value, _) => Text(
                                                value.toInt().toString(),
                                                style: AppTextStyles.textTheme(context).labelSmall,
                                              ),
                                            ),
                                          ),
                                          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                        ),
                                        gridData: FlGridData(show: true),
                                        borderData: FlBorderData(show: false),
                                        barGroups: graphData.asMap().entries.map((entry) {
                                          final index = entry.key;
                                          final data = entry.value;
                                          return BarChartGroupData(
                                            x: index,
                                            barRods: [
                                              BarChartRodData(
                                                toY: (data['value'] as num).toDouble(),
                                                width: 18,
                                                color: [
                                                  AppColors.brand,
                                                  AppColors.success,
                                                  AppColors.warning,
                                                  AppColors.brand.shade700,
                                                ][index % 4],
                                                borderRadius: BorderRadius.circular(6),
                                              )
                                            ],
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
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
                            onTap: () => Navigator.pushNamed(
                              context,
                              card['route'] as String,
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
