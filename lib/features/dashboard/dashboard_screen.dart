import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../design_system/app_colors.dart';
import '../../design_system/app_text_styles.dart';
import '../../design_system/dimensions.dart';
import '../../utils/responsive_helper.dart';
import '../../widgets/customDrawer.dart';
import '../../widgets/dashboard_card.dart';
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
        body: Row(
          children: [
            const CustomDrawer(selectedRoute: '/dashboard'),
            Expanded(child: Container(
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
                        'title': 'Rank Keyword',
                        'percent': '10',
                        'percentNumber': 10.toStringAsFixed(0),
                        'route': '/',
                      },
                      {
                        'title': 'Traffic',
                        'percent': '10',
                        'percentNumber': 10.toStringAsFixed(0),
                        'route': '/',
                      },
                      {
                        'title': 'Total Click',
                        'percent': '10',
                        'percentNumber': 10.toStringAsFixed(0),
                        'route': '/',
                      },
                      {
                        'title': 'Avg Position',
                        'percent': '10',
                        'percentNumber': 10.toStringAsFixed(0),
                        'route': '/',
                      },
                    ];

                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          WelcomeText(clientName: state.clientName),

                          SizedBox(height: AppDimensions.padding(context)),
                          AnimatedDashboardCards(
                            cards: cards,
                            cardWidth: cardWidth,
                          ),
                          SizedBox(height: AppDimensions.padding(context)),

                          ProjectProgressSection(sdlcStages: state.sdlcStages),
                          SizedBox(height: AppDimensions.paddingLarge(context)),
                          const CampaignChartSection(),

                          SizedBox(height: AppDimensions.padding(context)),
                          AnimatedDashboardCards(
                            cards: cards,
                            cardWidth: cardWidth,
                          ),
                        ],
                      ),
                    );
                  }
                  return const Center(child: Text('Initial State'));
                },
              ),
            ),),

          ],
        ),
      ),
    );
  }
}

class AnimatedDashboardCards extends StatefulWidget {
  final List<Map<String, String>> cards;
  final double cardWidth;

  const AnimatedDashboardCards({
    super.key,
    required this.cards,
    required this.cardWidth,
  });

  @override
  State<AnimatedDashboardCards> createState() => _AnimatedDashboardCardsState();
}

class _AnimatedDashboardCardsState extends State<AnimatedDashboardCards> {
  late List<bool> _visibleList;

  @override
  void initState() {
    super.initState();
    _visibleList = List.generate(widget.cards.length, (_) => false);

    _runStaggeredAnimation();
  }

  void _runStaggeredAnimation() {
    for (int i = 0; i < widget.cards.length; i++) {
      Future.delayed(Duration(milliseconds: 100 * i), () {
        if (mounted) {
          setState(() {
            _visibleList[i] = true;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppDimensions.padding(context),
      runSpacing: AppDimensions.padding(context),
      children: List.generate(widget.cards.length, (index) {
        final card = widget.cards[index];

        return AnimatedOpacity(
          opacity: _visibleList[index] ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
          child: AnimatedSlide(
            offset: _visibleList[index] ? Offset.zero : const Offset(0, 0.1),
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOut,
            child: DashboardCard(
              title: card['title'] ?? '',
              percent: double.tryParse(card['percent'] ?? '0') ?? 0.0,
              percentNumber: double.tryParse(card['percentNumber'] ?? '0') ?? 0.0,
              width: widget.cardWidth,
              onTap: () => Navigator.pushNamed(
                context,
                card['route'] ?? '',
              ),
            ),
          ),
        );
      }),
    );
  }
}

class WelcomeText extends StatefulWidget {
  final String clientName;

  const WelcomeText({super.key, required this.clientName});

  @override
  State<WelcomeText> createState() => _WelcomeTextState();
}

class _WelcomeTextState extends State<WelcomeText> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    // Trigger animation on screen load
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _visible = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOut,
      opacity: _visible ? 1.0 : 0.0,
      child: AnimatedSlide(
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeOut,
        offset: _visible ? Offset.zero : const Offset(0, -0.2),
        child: Text(
          'Welcome, ${widget.clientName}',
          style: AppTextStyles.textTheme(context).headlineSmall,
        ),
      ),
    );
  }
}

class ProjectProgressSection extends StatefulWidget {
  final List<Map<String, dynamic>> sdlcStages;

  const ProjectProgressSection({super.key, required this.sdlcStages});

  @override
  State<ProjectProgressSection> createState() => _ProjectProgressSectionState();
}

class _ProjectProgressSectionState extends State<ProjectProgressSection> {
  bool _visibleTitle = false;
  List<bool> _visibleStages = [];

  @override
  void initState() {
    super.initState();

    _visibleStages = List.generate(widget.sdlcStages.length, (_) => false);

    // Animate title first
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        setState(() {
          _visibleTitle = true;
        });
      }
    });

    // Animate stages with staggered delays
    for (int i = 0; i < widget.sdlcStages.length; i++) {
      Future.delayed(Duration(milliseconds: 400 + (i * 150)), () {
        if (mounted) {
          setState(() {
            _visibleStages[i] = true;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title Animation
        AnimatedOpacity(
          opacity: _visibleTitle ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOut,
          child: AnimatedSlide(
            offset: _visibleTitle ? Offset.zero : const Offset(0, -0.2),
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOut,
            child: Text(
              'Project Progress',
              style: AppTextStyles.textTheme(context).headlineSmall,
            ),
          ),
        ),

        SizedBox(height: AppDimensions.padding(context)),

        // Stage Animation
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: widget.sdlcStages.asMap().entries.map((entry) {
            final index = entry.key;
            final stage = entry.value;
            final isCompleted = stage['completed'] as bool;

            return Expanded(
              child: AnimatedOpacity(
                opacity: _visibleStages[index] ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOut,
                child: AnimatedSlide(
                  offset: _visibleStages[index] ? Offset.zero : const Offset(0, 0.1),
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOut,
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: AppDimensions.scale(context, 2.0),
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
                      SizedBox(height: AppDimensions.spacingSmall(context)),
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
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class CampaignChartSection extends StatefulWidget {
  const CampaignChartSection({super.key});

  @override
  State<CampaignChartSection> createState() => _CampaignChartSectionState();
}

class _CampaignChartSectionState extends State<CampaignChartSection> {
  bool _showTitle = false;
  bool _showPie = false;
  bool _showBar = false;

  @override
  void initState() {
    super.initState();

    // Animate elements in sequence
    Future.delayed(const Duration(milliseconds: 300), () => setState(() => _showTitle = true));
    Future.delayed(const Duration(milliseconds: 600), () => setState(() => _showPie = true));
    Future.delayed(const Duration(milliseconds: 900), () => setState(() => _showBar = true));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Title Animation
        AnimatedOpacity(
          duration: const Duration(milliseconds: 600),
          opacity: _showTitle ? 1.0 : 0.0,
          child: AnimatedSlide(
            duration: const Duration(milliseconds: 600),
            offset: _showTitle ? Offset.zero : const Offset(0, -0.2),
            child: Text(
              'Campaign Leads Over Time',
              style: AppTextStyles.textTheme(context).titleMedium,
            ),
          ),
        ),

        SizedBox(height: AppDimensions.padding(context)),

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
                    /// Pie Chart Animation
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 600),
                      opacity: _showPie ? 1.0 : 0.0,
                      child: TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.9, end: 1.0),
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.easeOutBack,
                        builder: (context, scale, child) {
                          return Transform.scale(
                            scale: scale,
                            child: child,
                          );
                        },
                        child: SizedBox(
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
                      ),
                    ),

                    SizedBox(width: AppDimensions.padding(context)),

                    /// Bar Chart Animation
                    AnimatedSlide(
                      offset: _showBar ? Offset.zero : const Offset(0.3, 0),
                      duration: const Duration(milliseconds: 700),
                      curve: Curves.easeOut,
                      child: AnimatedOpacity(
                        opacity: _showBar ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 500),
                        child: SizedBox(
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
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
