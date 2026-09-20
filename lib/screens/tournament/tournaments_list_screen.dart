import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../home/providers/home_provider.dart';
import '../home/widgets/tournament_card.dart';
import 'tournament_detail_screen.dart';

class TournamentsListScreen extends StatefulWidget {
  const TournamentsListScreen({super.key});

  @override
  State<TournamentsListScreen> createState() => _TournamentsListScreenState();
}

class _TournamentsListScreenState extends State<TournamentsListScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final homeProvider = context.read<HomeProvider>();
      if (!homeProvider.isFetchingMoreTournaments && !homeProvider.isLoading) {
        homeProvider.fetchTournaments(isRefresh: false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.authBackgroundBottom,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'All Tournaments',
          style: GoogleFonts.quicksand(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.authBackgroundGradient),
        child: SafeArea(
          child: Consumer<HomeProvider>(
        builder: (context, homeProvider, child) {
          final list = homeProvider.tournamentsList;

          if (homeProvider.isLoading && list.isEmpty) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }

          if (list.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text('No tournaments found',
                    style: GoogleFonts.quicksand(color: Colors.white54)),
              ),
            );
          }

          return ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(20),
            itemCount: list.length + (homeProvider.isFetchingMoreTournaments ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == list.length) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Center(child: CircularProgressIndicator(color: AppColors.primary)),
                );
              }
              final t = list[index] as Map<String, dynamic>;
              return TournamentCard(
                tournament: t,
                onTap: () {
                  final id = t['id'];
                  if (id != null) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => TournamentDetailScreen(tournamentId: id),
                      ),
                    );
                  }
                },
              );
            },
          );
        },
      ),
        ),
      ),
    );
  }
}
