# App source inventory

Reviewed: 27 October 2026. All 292 Dart files under `lib/` were scanned for the signals below. This is a source index, not a compilation report or an assertion that every widget was exercised.

“API” lists direct `UserApis().method(...)` calls. Provider calls show selected fetch/mutation references, including declarations, to help trace indirect integrations. Demo signals are referenced `dummy*` symbols or explicit mock markers. No API signal in a widget often means it receives data/callbacks from a parent; it does not necessarily mean the feature is disconnected. Empty handlers can also be intentional placeholders. Consult the main audit for reviewed feature status.

## app entry and utilities

| File | Lines | Role | Integration signals |
|---|---:|---|---|
| [lib/main.dart](../lib/main.dart) | 59 | Shared / utility | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/responsive.dart](../lib/responsive.dart) | 10 | Shared / utility | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/test_live_matches.dart](../lib/test_live_matches.dart) | 13 | Shared / utility | API: `getLiveMatches` |
| [lib/test_tournaments.dart](../lib/test_tournaments.dart) | 12 | Shared / utility | API: `getMyTournaments` |

## core

| File | Lines | Role | Integration signals |
|---|---:|---|---|
| [lib/core/Firebase/auth_servises.dart](../lib/core/Firebase/auth_servises.dart) | 46 | Shared / utility | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/core/Firebase/firebase_options.dart](../lib/core/Firebase/firebase_options.dart) | 68 | Shared / utility | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/core/apiServices/api_constants.dart](../lib/core/apiServices/api_constants.dart) | 14 | Shared / utility | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/core/apiServices/api_helpers.dart](../lib/core/apiServices/api_helpers.dart) | 539 | Shared / utility | Delayed task (inspect context); Storage mutation |
| [lib/core/apiServices/user_api.dart](../lib/core/apiServices/user_api.dart) | 357 | Shared / utility | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/core/constants/app_assets.dart](../lib/core/constants/app_assets.dart) | 13 | Shared / utility | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/core/constants/app_colors.dart](../lib/core/constants/app_colors.dart) | 262 | Shared / utility | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/core/constants/app_dimens.dart](../lib/core/constants/app_dimens.dart) | 22 | Shared / utility | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/core/generated/intl/messages_all.dart](../lib/core/generated/intl/messages_all.dart) | 63 | Shared / utility | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/core/generated/intl/messages_en.dart](../lib/core/generated/intl/messages_en.dart) | 25 | Shared / utility | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/core/generated/l10n.dart](../lib/core/generated/l10n.dart) | 78 | Shared / utility | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/core/globalefunction/globalAppbar.dart](../lib/core/globalefunction/globalAppbar.dart) | 45 | Shared / utility | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/core/globalefunction/global_coupon_card.dart](../lib/core/globalefunction/global_coupon_card.dart) | 46 | Shared / utility | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/core/globalefunction/global_functions.dart](../lib/core/globalefunction/global_functions.dart) | 558 | Shared / utility | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/core/theme/app_text_styles.dart](../lib/core/theme/app_text_styles.dart) | 69 | Shared / utility | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/core/theme/app_theme.dart](../lib/core/theme/app_theme.dart) | 168 | Shared / utility | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/core/utils/bank_utils.dart](../lib/core/utils/bank_utils.dart) | 102 | Shared / utility | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/core/utils/prize_utils.dart](../lib/core/utils/prize_utils.dart) | 167 | Shared / utility | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/core/utils/validators.dart](../lib/core/utils/validators.dart) | 50 | Shared / utility | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/core/utils/wallet_utils.dart](../lib/core/utils/wallet_utils.dart) | 97 | Shared / utility | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/core/widgets/auth_footer_link.dart](../lib/core/widgets/auth_footer_link.dart) | 34 | Widget | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/core/widgets/custom_button.dart](../lib/core/widgets/custom_button.dart) | 62 | Widget | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/core/widgets/custom_text_field.dart](../lib/core/widgets/custom_text_field.dart) | 81 | Widget | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/core/widgets/glass_back_button.dart](../lib/core/widgets/glass_back_button.dart) | 27 | Widget | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/core/widgets/section_divider.dart](../lib/core/widgets/section_divider.dart) | 26 | Widget | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/core/widgets/social_icon_button.dart](../lib/core/widgets/social_icon_button.dart) | 31 | Widget | Presentation, received data/callbacks, or shared definitions; inspect callers |

## models

| File | Lines | Role | Integration signals |
|---|---:|---|---|
| [lib/models/achievement_info.dart](../lib/models/achievement_info.dart) | 42 | Model / demo data | Demo: `dummyAchievements` |
| [lib/models/award_info.dart](../lib/models/award_info.dart) | 228 | Model / demo data | Demo: `dummyAwardSports`, `dummyAwards`, `dummyAwardsBalance` |
| [lib/models/celebrate_info.dart](../lib/models/celebrate_info.dart) | 191 | Model / demo data | Demo: `dummyCelebrateCampaigns`, `dummyCelebratePlayers`, `dummyCelebrateSports` |
| [lib/models/completed_match_detail_info.dart](../lib/models/completed_match_detail_info.dart) | 115 | Model / demo data | Demo: `dummyCompletedMatchDetail` |
| [lib/models/fan_tip_info.dart](../lib/models/fan_tip_info.dart) | 131 | Model / demo data | Demo: `dummyFanTips` |
| [lib/models/inbox_notification.dart](../lib/models/inbox_notification.dart) | 133 | Model / demo data | Demo: `dummyInboxNotifications` |
| [lib/models/match_data_parser.dart](../lib/models/match_data_parser.dart) | 145 | Model / demo data | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/models/match_info.dart](../lib/models/match_info.dart) | 110 | Model / demo data | Demo: `dummyLiveMatch`, `dummyLiveMatches` |
| [lib/models/my_sport_info.dart](../lib/models/my_sport_info.dart) | 71 | Model / demo data | Demo: `dummyMySports` |
| [lib/models/my_tournament_info.dart](../lib/models/my_tournament_info.dart) | 404 | Model / demo data | Demo: `dummyAllTournaments`, `dummyMyTournaments` |
| [lib/models/next_match_info.dart](../lib/models/next_match_info.dart) | 41 | Model / demo data | Demo: `dummyNextMatch` |
| [lib/models/payment_info.dart](../lib/models/payment_info.dart) | 41 | Model / demo data | Demo: `dummyPaymentBreakdown`, `dummyPaymentMatch` |
| [lib/models/playground_player_info.dart](../lib/models/playground_player_info.dart) | 86 | Model / demo data | Demo: `dummyPlaygroundPlayers` |
| [lib/models/playground_team_info.dart](../lib/models/playground_team_info.dart) | 115 | Model / demo data | Demo: `dummyPlaygroundTeams` |
| [lib/models/prize_details_info.dart](../lib/models/prize_details_info.dart) | 137 | Model / demo data | Demo: `dummyPrizeDetails` |
| [lib/models/profile_info.dart](../lib/models/profile_info.dart) | 259 | Model / demo data | Demo: `dummyProfile`, `dummyProfileDetailStats`, `dummyProfileMainMenu`, `dummyProfileSportRoles`, `dummyProfileSports`, `dummyProfileStats`, `dummyProfileSupportMenu` |
| [lib/models/ranking_info.dart](../lib/models/ranking_info.dart) | 135 | Model / demo data | Demo: `dummyRankings` |
| [lib/models/referee_info.dart](../lib/models/referee_info.dart) | 196 | Model / demo data | Demo: `dummyAvailableReferees`, `dummyLastAssignedReferees`, `dummyRefereeAssignments` |
| [lib/models/sponsor_info.dart](../lib/models/sponsor_info.dart) | 520 | Model / demo data | Demo: `dummyBadmintonPrizeCategories`, `dummyCricketPrizeCategories`, `dummyFootballPrizeCategories`, `dummyHoopsTournament`, `dummySponsorHistoryStats`, `dummySponsorReceipts`, `dummySponsorSports`, `dummySponsorTournaments` |
| [lib/models/sport_category.dart](../lib/models/sport_category.dart) | 27 | Model / demo data | Demo: `dummySportCategories` |
| [lib/models/team_info.dart](../lib/models/team_info.dart) | 49 | Model / demo data | Demo: `dummyTeams` |
| [lib/models/team_invitation.dart](../lib/models/team_invitation.dart) | 43 | Model / demo data | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/models/team_player_info.dart](../lib/models/team_player_info.dart) | 10 | Model / demo data | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/models/team_up_info.dart](../lib/models/team_up_info.dart) | 266 | Model / demo data | Demo: `dummyTeamUpAssignedTeam`, `dummyTeamUpBattingStyles`, `dummyTeamUpBowlingStyles`, `dummyTeamUpChipSports`, `dummyTeamUpExperienceLevels`, `dummyTeamUpFilters`, `dummyTeamUpHowItWorks`, `dummyTeamUpPlatformFee`, `dummyTeamUpPlayingRoles`, `dummyTeamUpSports`, `dummyTeamUpTournaments` |
| [lib/models/tournament_info.dart](../lib/models/tournament_info.dart) | 83 | Model / demo data | Demo: `dummyTournaments` |
| [lib/models/tournament_prizes_info.dart](../lib/models/tournament_prizes_info.dart) | 125 | Model / demo data | Presentation, received data/callbacks, or shared definitions; inspect callers |

## routes

| File | Lines | Role | Integration signals |
|---|---:|---|---|
| [lib/routes/app_router.dart](../lib/routes/app_router.dart) | 96 | Shared / utility | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/routes/app_routes.dart](../lib/routes/app_routes.dart) | 17 | Shared / utility | Presentation, received data/callbacks, or shared definitions; inspect callers |

## screens/Matches

| File | Lines | Role | Integration signals |
|---|---:|---|---|
| [lib/screens/Matches/Matches_screen.dart](../lib/screens/Matches/Matches_screen.dart) | 352 | Screen | Provider/load: `fetchAllMatches`, `fetchLiveMatches`, `fetchSports`, `fetchUpcomingMatches`; Empty actions: 1 |
| [lib/screens/Matches/completed_match_detail_screen.dart](../lib/screens/Matches/completed_match_detail_screen.dart) | 482 | Screen | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/Matches/lmatch_detail_screen.dart](../lib/screens/Matches/lmatch_detail_screen.dart) | 779 | Screen | API: `getTeamPlayers`; Provider/load: `fetchLiveScore`; Empty actions: 1 |
| [lib/screens/Matches/predictor_leaderboard_screen.dart](../lib/screens/Matches/predictor_leaderboard_screen.dart) | 100 | Screen | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/Matches/stadium_check_in_screen.dart](../lib/screens/Matches/stadium_check_in_screen.dart) | 156 | Screen | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/Matches/widgets/ball_indicator.dart](../lib/screens/Matches/widgets/ball_indicator.dart) | 41 | Widget | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/Matches/widgets/batsman_stats_table.dart](../lib/screens/Matches/widgets/batsman_stats_table.dart) | 112 | Widget | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/Matches/widgets/bowler_stats_table.dart](../lib/screens/Matches/widgets/bowler_stats_table.dart) | 108 | Widget | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/Matches/widgets/fan_reactions_row.dart](../lib/screens/Matches/widgets/fan_reactions_row.dart) | 70 | Widget | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/Matches/widgets/foil_badge_minted_sheet.dart](../lib/screens/Matches/widgets/foil_badge_minted_sheet.dart) | 181 | Widget | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/Matches/widgets/leaderboard_row_card.dart](../lib/screens/Matches/widgets/leaderboard_row_card.dart) | 56 | Widget | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/Matches/widgets/live_score_panel.dart](../lib/screens/Matches/widgets/live_score_panel.dart) | 129 | Widget | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/Matches/widgets/match_feed_card.dart](../lib/screens/Matches/widgets/match_feed_card.dart) | 969 | Widget | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/Matches/widgets/match_feed_tabs.dart](../lib/screens/Matches/widgets/match_feed_tabs.dart) | 113 | Widget | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/Matches/widgets/match_status_pills.dart](../lib/screens/Matches/widgets/match_status_pills.dart) | 53 | Widget | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/Matches/widgets/outline_action_button.dart](../lib/screens/Matches/widgets/outline_action_button.dart) | 34 | Widget | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/Matches/widgets/predict_earn_card.dart](../lib/screens/Matches/widgets/predict_earn_card.dart) | 84 | Widget | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/Matches/widgets/predictor_challenge_button.dart](../lib/screens/Matches/widgets/predictor_challenge_button.dart) | 33 | Widget | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/Matches/widgets/predictor_prize_card.dart](../lib/screens/Matches/widgets/predictor_prize_card.dart) | 45 | Widget | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/Matches/widgets/predictor_sheet.dart](../lib/screens/Matches/widgets/predictor_sheet.dart) | 214 | Widget | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/Matches/widgets/sporto_hype_meter_card.dart](../lib/screens/Matches/widgets/sporto_hype_meter_card.dart) | 107 | Widget | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/Matches/widgets/stadium_zone_card.dart](../lib/screens/Matches/widgets/stadium_zone_card.dart) | 65 | Widget | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/Matches/widgets/team_matchup_row.dart](../lib/screens/Matches/widgets/team_matchup_row.dart) | 49 | Widget | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/Matches/widgets/view_bracket_tile.dart](../lib/screens/Matches/widgets/view_bracket_tile.dart) | 34 | Widget | Presentation, received data/callbacks, or shared definitions; inspect callers |

## screens/auth

| File | Lines | Role | Integration signals |
|---|---:|---|---|
| [lib/screens/auth/login_screen.dart](../lib/screens/auth/login_screen.dart) | 363 | Screen | Empty actions: 1 |
| [lib/screens/auth/otp_screen.dart](../lib/screens/auth/otp_screen.dart) | 241 | Screen | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/auth/providers/auth_provider.dart](../lib/screens/auth/providers/auth_provider.dart) | 223 | Provider | API: `getSendOtp`, `getVerifyOtp`, `logout`; Storage mutation |
| [lib/screens/auth/providers/location_provider.dart](../lib/screens/auth/providers/location_provider.dart) | 19 | Provider | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/auth/signup_screen.dart](../lib/screens/auth/signup_screen.dart) | 169 | Screen | Delayed task (inspect context) |
| [lib/screens/auth/widgets/auth_pill_buttons.dart](../lib/screens/auth/widgets/auth_pill_buttons.dart) | 103 | Widget | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/auth/widgets/glass_phone_field.dart](../lib/screens/auth/widgets/glass_phone_field.dart) | 67 | Widget | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/auth/widgets/india_flag_icon.dart](../lib/screens/auth/widgets/india_flag_icon.dart) | 46 | Widget | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/auth/widgets/otp_input_row.dart](../lib/screens/auth/widgets/otp_input_row.dart) | 137 | Widget | Presentation, received data/callbacks, or shared definitions; inspect callers |

## screens/celebrate

| File | Lines | Role | Integration signals |
|---|---:|---|---|
| [lib/screens/celebrate/celebrate_champion_screen.dart](../lib/screens/celebrate/celebrate_champion_screen.dart) | 411 | Screen | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/celebrate/celebrate_confirm_tip_screen.dart](../lib/screens/celebrate/celebrate_confirm_tip_screen.dart) | 147 | Screen | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/celebrate/celebrate_identity_screen.dart](../lib/screens/celebrate/celebrate_identity_screen.dart) | 222 | Screen | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/celebrate/celebrate_pick_player_screen.dart](../lib/screens/celebrate/celebrate_pick_player_screen.dart) | 223 | Screen | Demo: `dummyCelebratePlayers` |
| [lib/screens/celebrate/celebrate_screen.dart](../lib/screens/celebrate/celebrate_screen.dart) | 161 | Screen | Demo: `dummyCelebrateCampaigns`, `dummyCelebrateSports` |
| [lib/screens/celebrate/celebrate_tip_payment_screen.dart](../lib/screens/celebrate/celebrate_tip_payment_screen.dart) | 150 | Screen | Empty actions: 2; Delayed task (inspect context) |
| [lib/screens/celebrate/celebrate_tip_screen.dart](../lib/screens/celebrate/celebrate_tip_screen.dart) | 534 | Screen | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/celebrate/celebrate_tip_success_screen.dart](../lib/screens/celebrate/celebrate_tip_success_screen.dart) | 272 | Screen | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/celebrate/widgets/celebrate_campaign_card.dart](../lib/screens/celebrate/widgets/celebrate_campaign_card.dart) | 270 | Widget | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/celebrate/widgets/celebrate_team_hero.dart](../lib/screens/celebrate/widgets/celebrate_team_hero.dart) | 102 | Widget | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/celebrate/widgets/celebrate_tip_summary.dart](../lib/screens/celebrate/widgets/celebrate_tip_summary.dart) | 151 | Widget | Presentation, received data/callbacks, or shared definitions; inspect callers |

## screens/home

| File | Lines | Role | Integration signals |
|---|---:|---|---|
| [lib/screens/home/attention_hub_screen.dart](../lib/screens/home/attention_hub_screen.dart) | 294 | Screen | Provider/load: `fetchInvitations` |
| [lib/screens/home/home_screen.dart](../lib/screens/home/home_screen.dart) | 636 | Screen | Provider/load: `fetchInvitations`, `fetchLiveMatches`, `fetchSports`, `fetchTournaments`, `fetchUpcomingMatches`; Demo: `dummySportCategories`; Empty actions: 2 |
| [lib/screens/home/player_ranking_detail_screen.dart](../lib/screens/home/player_ranking_detail_screen.dart) | 290 | Screen | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/home/prize_calculation_screen.dart](../lib/screens/home/prize_calculation_screen.dart) | 380 | Screen | Demo: `dummyPrizeDetails` |
| [lib/screens/home/prize_credited_screen.dart](../lib/screens/home/prize_credited_screen.dart) | 338 | Screen | Demo: `dummyPrizeDetails` |
| [lib/screens/home/prize_details_screen.dart](../lib/screens/home/prize_details_screen.dart) | 472 | Screen | API: `getTournamentPrizes` |
| [lib/screens/home/prize_distribution_screen.dart](../lib/screens/home/prize_distribution_screen.dart) | 420 | Screen | Demo: `dummyPrizeDetails` |
| [lib/screens/home/providers/home_provider.dart](../lib/screens/home/providers/home_provider.dart) | 858 | Provider | API: `acceptInvitation`, `createTeam`, `deleteTeam`, `getAllMatches`, `getAvailableTeams`, `getInvitations`, `getLiveMatches`, `getLiveScore`, `getMyTeams`, `getSports`, `getTeams`, `getTournamentDetail`, `getTournaments`, `getUpcomingMatches`, `joinTeamRequest`, `rejectInvitation`, `updateTeam`; Provider/load: `fetchAllMatches`, `fetchAvailableTeams`, `fetchInvitations`, `fetchLiveMatches`, `fetchLiveScore`, `fetchMyTeams`, `fetchSports`, `fetchTeams`, `fetchTournamentDetail`, `fetchTournaments`, `fetchUpcomingMatches` |
| [lib/screens/home/rankings_screen.dart](../lib/screens/home/rankings_screen.dart) | 385 | Screen | Demo: `dummyProfileSports`, `dummyRankings` |
| [lib/screens/home/team_invitations_screen.dart](../lib/screens/home/team_invitations_screen.dart) | 393 | Screen | API: `getInvitations` |
| [lib/screens/home/team_ranking_detail_screen.dart](../lib/screens/home/team_ranking_detail_screen.dart) | 268 | Screen | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/home/widgets/ads_banner.dart](../lib/screens/home/widgets/ads_banner.dart) | 28 | Widget | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/home/widgets/attention_banner.dart](../lib/screens/home/widgets/attention_banner.dart) | 84 | Widget | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/home/widgets/home_bottom_nav.dart](../lib/screens/home/widgets/home_bottom_nav.dart) | 95 | Widget | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/home/widgets/home_header.dart](../lib/screens/home/widgets/home_header.dart) | 98 | Widget | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/home/widgets/home_search_bar.dart](../lib/screens/home/widgets/home_search_bar.dart) | 51 | Widget | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/home/widgets/home_shortcut_strip.dart](../lib/screens/home/widgets/home_shortcut_strip.dart) | 123 | Widget | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/home/widgets/live_match_spotlight_card.dart](../lib/screens/home/widgets/live_match_spotlight_card.dart) | 133 | Widget | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/home/widgets/next_match_card.dart](../lib/screens/home/widgets/next_match_card.dart) | 180 | Widget | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/home/widgets/prize_details_banner.dart](../lib/screens/home/widgets/prize_details_banner.dart) | 250 | Widget | API: `getMyPrizes` |
| [lib/screens/home/widgets/quick_action_button.dart](../lib/screens/home/widgets/quick_action_button.dart) | 43 | Widget | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/home/widgets/ranking_detail_bits.dart](../lib/screens/home/widgets/ranking_detail_bits.dart) | 128 | Widget | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/home/widgets/section_header.dart](../lib/screens/home/widgets/section_header.dart) | 30 | Widget | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/home/widgets/sport_icon_button.dart](../lib/screens/home/widgets/sport_icon_button.dart) | 67 | Widget | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/home/widgets/tournament_card.dart](../lib/screens/home/widgets/tournament_card.dart) | 256 | Widget | Presentation, received data/callbacks, or shared definitions; inspect callers |

## screens/live_matches

| File | Lines | Role | Integration signals |
|---|---:|---|---|
| [lib/screens/live_matches/live_matches_screen.dart](../lib/screens/live_matches/live_matches_screen.dart) | 433 | Screen | Provider/load: `fetchAllMatches`, `fetchLiveMatches`, `fetchSports`, `fetchTournaments`, `fetchUpcomingMatches` |
| [lib/screens/live_matches/widgets/dashed_divider.dart](../lib/screens/live_matches/widgets/dashed_divider.dart) | 29 | Widget | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/live_matches/widgets/live_match_list_card.dart](../lib/screens/live_matches/widgets/live_match_list_card.dart) | 108 | Widget | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/live_matches/widgets/tournament_hub_tabs.dart](../lib/screens/live_matches/widgets/tournament_hub_tabs.dart) | 156 | Widget | Presentation, received data/callbacks, or shared definitions; inspect callers |

## screens/onboarding

| File | Lines | Role | Integration signals |
|---|---:|---|---|
| [lib/screens/onboarding/complete_profile_screen.dart](../lib/screens/onboarding/complete_profile_screen.dart) | 394 | Screen | API: `getCheck`; Provider/load: `pickAndUploadImage` |
| [lib/screens/onboarding/onboarding_flow_screen.dart](../lib/screens/onboarding/onboarding_flow_screen.dart) | 135 | Screen | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/onboarding/onboarding_intro_screen.dart](../lib/screens/onboarding/onboarding_intro_screen.dart) | 311 | Screen | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/onboarding/onboarding_sponsor_screen.dart](../lib/screens/onboarding/onboarding_sponsor_screen.dart) | 407 | Screen | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/onboarding/onboarding_watch_screen.dart](../lib/screens/onboarding/onboarding_watch_screen.dart) | 402 | Screen | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/onboarding/permission_screen.dart](../lib/screens/onboarding/permission_screen.dart) | 190 | Screen | Provider/load: `requestPermissionsAndLocation` |
| [lib/screens/onboarding/providers/permission_provider.dart](../lib/screens/onboarding/providers/permission_provider.dart) | 106 | Provider | API: `updateLatLong`; Provider/load: `requestPermissionsAndLocation` |
| [lib/screens/onboarding/providers/profile_provider.dart](../lib/screens/onboarding/providers/profile_provider.dart) | 125 | Provider | API: `completeProfile`, `uploadProfileImage`; Provider/load: `pickAndUploadImage` |
| [lib/screens/onboarding/welcome_screen.dart](../lib/screens/onboarding/welcome_screen.dart) | 91 | Screen | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/onboarding/widgets/cricket_hero_animation.dart](../lib/screens/onboarding/widgets/cricket_hero_animation.dart) | 294 | Widget | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/onboarding/widgets/gender_selector.dart](../lib/screens/onboarding/widgets/gender_selector.dart) | 72 | Widget | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/onboarding/widgets/interest_tile.dart](../lib/screens/onboarding/widgets/interest_tile.dart) | 48 | Widget | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/onboarding/widgets/neon_kicker_animation.dart](../lib/screens/onboarding/widgets/neon_kicker_animation.dart) | 181 | Widget | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/onboarding/widgets/onboarding_continue_button.dart](../lib/screens/onboarding/widgets/onboarding_continue_button.dart) | 33 | Widget | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/onboarding/widgets/permission_tile.dart](../lib/screens/onboarding/widgets/permission_tile.dart) | 69 | Widget | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/onboarding/widgets/profile_photo_picker.dart](../lib/screens/onboarding/widgets/profile_photo_picker.dart) | 70 | Widget | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/onboarding/widgets/profile_text_field.dart](../lib/screens/onboarding/widgets/profile_text_field.dart) | 70 | Widget | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/onboarding/widgets/rising_bubbles.dart](../lib/screens/onboarding/widgets/rising_bubbles.dart) | 162 | Widget | Presentation, received data/callbacks, or shared definitions; inspect callers |

## screens/payment

| File | Lines | Role | Integration signals |
|---|---:|---|---|
| [lib/screens/payment/payment_method_screen.dart](../lib/screens/payment/payment_method_screen.dart) | 230 | Screen | API: `initiatePayment`, `registerTournament`, `verifyPayment`; Empty actions: 2; Explicit mock marker |
| [lib/screens/payment/payment_success_screen.dart](../lib/screens/payment/payment_success_screen.dart) | 123 | Screen | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/payment/tournament_registered_screen.dart](../lib/screens/payment/tournament_registered_screen.dart) | 149 | Screen | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/payment/widgets/cost_breakdown_card.dart](../lib/screens/payment/widgets/cost_breakdown_card.dart) | 83 | Widget | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/payment/widgets/payable_amount_card.dart](../lib/screens/payment/widgets/payable_amount_card.dart) | 32 | Widget | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/payment/widgets/payment_match_card.dart](../lib/screens/payment/widgets/payment_match_card.dart) | 114 | Widget | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/payment/widgets/payment_method_tabs.dart](../lib/screens/payment/widgets/payment_method_tabs.dart) | 76 | Widget | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/payment/widgets/payment_option_tile.dart](../lib/screens/payment/widgets/payment_option_tile.dart) | 72 | Widget | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/payment/widgets/payment_success_card.dart](../lib/screens/payment/widgets/payment_success_card.dart) | 72 | Widget | Presentation, received data/callbacks, or shared definitions; inspect callers |

## screens/playground

| File | Lines | Role | Integration signals |
|---|---:|---|---|
| [lib/screens/playground/find_player_screen.dart](../lib/screens/playground/find_player_screen.dart) | 158 | Screen | Demo: `dummyPlaygroundPlayers` |
| [lib/screens/playground/join_team_list_screen.dart](../lib/screens/playground/join_team_list_screen.dart) | 286 | Screen | Provider/load: `fetchAvailableTeams`, `fetchSports` |
| [lib/screens/playground/my_team_detail_screen.dart](../lib/screens/playground/my_team_detail_screen.dart) | 360 | Screen | API: `getMyTeamDetails` |
| [lib/screens/playground/my_team_screen.dart](../lib/screens/playground/my_team_screen.dart) | 247 | Screen | Provider/load: `fetchMyTeams` |
| [lib/screens/playground/playground_screen.dart](../lib/screens/playground/playground_screen.dart) | 309 | Screen | Provider/load: `fetchAvailableTeams`, `fetchSports`; Demo: `dummyPlaygroundPlayers`; Empty actions: 1 |
| [lib/screens/playground/widgets/playground_action_button.dart](../lib/screens/playground/widgets/playground_action_button.dart) | 50 | Widget | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/playground/widgets/playground_browse_chrome.dart](../lib/screens/playground/widgets/playground_browse_chrome.dart) | 282 | Widget | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/playground/widgets/playground_filter_chip.dart](../lib/screens/playground/widgets/playground_filter_chip.dart) | 48 | Widget | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/playground/widgets/playground_header.dart](../lib/screens/playground/widgets/playground_header.dart) | 102 | Widget | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/playground/widgets/playground_player_card.dart](../lib/screens/playground/widgets/playground_player_card.dart) | 119 | Widget | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/playground/widgets/playground_team_card.dart](../lib/screens/playground/widgets/playground_team_card.dart) | 269 | Widget | Presentation, received data/callbacks, or shared definitions; inspect callers |

## screens/profile

| File | Lines | Role | Integration signals |
|---|---:|---|---|
| [lib/screens/profile/achievements/my_achievements_screen.dart](../lib/screens/profile/achievements/my_achievements_screen.dart) | 121 | Screen | Demo: `dummyAchievements` |
| [lib/screens/profile/awards/award_details_screen.dart](../lib/screens/profile/awards/award_details_screen.dart) | 446 | Screen | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/profile/awards/my_awards_screen.dart](../lib/screens/profile/awards/my_awards_screen.dart) | 475 | Screen | Demo: `dummyAwardSports`, `dummyAwards`, `dummyAwardsBalance` |
| [lib/screens/profile/bank/add_bank_account_screen.dart](../lib/screens/profile/bank/add_bank_account_screen.dart) | 439 | Screen | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/profile/bank/bank_account_screen.dart](../lib/screens/profile/bank/bank_account_screen.dart) | 278 | Screen | Provider/load: `fetchBanks` |
| [lib/screens/profile/bank/bank_actions.dart](../lib/screens/profile/bank/bank_actions.dart) | 200 | Shared / utility | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/profile/bank/bank_card.dart](../lib/screens/profile/bank/bank_card.dart) | 148 | Shared / utility | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/profile/bank/providers/bank_provider.dart](../lib/screens/profile/bank/providers/bank_provider.dart) | 301 | Provider | API: `addBankDetails`, `deleteBankDetails`, `getBankList`, `setDefaultBank`, `updateBankDetails`; Provider/load: `fetchBanks` |
| [lib/screens/profile/bank/withdraw_to_bank_screen.dart](../lib/screens/profile/bank/withdraw_to_bank_screen.dart) | 482 | Screen | Provider/load: `fetchBanks` |
| [lib/screens/profile/details/profile_details_screen.dart](../lib/screens/profile/details/profile_details_screen.dart) | 180 | Screen | Demo: `dummyProfile`, `dummyProfileDetailStats`, `dummyProfileMainMenu`, `dummyProfileSportRoles` |
| [lib/screens/profile/fan_tips/fan_tip_details_screen.dart](../lib/screens/profile/fan_tips/fan_tip_details_screen.dart) | 317 | Screen | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/profile/fan_tips/my_fan_tips_screen.dart](../lib/screens/profile/fan_tips/my_fan_tips_screen.dart) | 237 | Screen | Demo: `dummyFanTips` |
| [lib/screens/profile/my_statastics/my_statastics.dart](../lib/screens/profile/my_statastics/my_statastics.dart) | 492 | Screen | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/profile/notifications/notification_category_screen.dart](../lib/screens/profile/notifications/notification_category_screen.dart) | 105 | Screen | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/profile/notifications/notification_settings_screen.dart](../lib/screens/profile/notifications/notification_settings_screen.dart) | 264 | Screen | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/profile/notifications/notifications_screen.dart](../lib/screens/profile/notifications/notifications_screen.dart) | 375 | Screen | Demo: `dummyInboxNotifications` |
| [lib/screens/profile/notifications/widgets/notification_toggle_tile.dart](../lib/screens/profile/notifications/widgets/notification_toggle_tile.dart) | 70 | Widget | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/profile/prizes/my_prizes_screen.dart](../lib/screens/profile/prizes/my_prizes_screen.dart) | 487 | Screen | Provider/load: `fetchMyPrizes` |
| [lib/screens/profile/prizes/prize_status_style.dart](../lib/screens/profile/prizes/prize_status_style.dart) | 40 | Shared / utility | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/profile/prizes/prize_transaction_details_screen.dart](../lib/screens/profile/prizes/prize_transaction_details_screen.dart) | 617 | Screen | Provider/load: `fetchDistribution` |
| [lib/screens/profile/prizes/providers/my_prizes_provider.dart](../lib/screens/profile/prizes/providers/my_prizes_provider.dart) | 129 | Provider | API: `getMyPrizes`; Provider/load: `fetchMyPrizes` |
| [lib/screens/profile/prizes/providers/prize_distribution_provider.dart](../lib/screens/profile/prizes/providers/prize_distribution_provider.dart) | 85 | Provider | API: `getPrizeDistribution`; Provider/load: `fetchDistribution` |
| [lib/screens/profile/profile_screen.dart](../lib/screens/profile/profile_screen.dart) | 174 | Screen | Demo: `dummyProfileMainMenu`, `dummyProfileSports`, `dummyProfileStats`, `dummyProfileSupportMenu`; Empty actions: 1 |
| [lib/screens/profile/settings/settings_screen.dart](../lib/screens/profile/settings/settings_screen.dart) | 133 | Screen | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/profile/sports/my_sports_screen.dart](../lib/screens/profile/sports/my_sports_screen.dart) | 161 | Screen | Demo: `dummyMySports` |
| [lib/screens/profile/sports/widgets/add_sport_sheet.dart](../lib/screens/profile/sports/widgets/add_sport_sheet.dart) | 384 | Widget | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/profile/sports/widgets/add_sport_tile.dart](../lib/screens/profile/sports/widgets/add_sport_tile.dart) | 72 | Widget | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/profile/sports/widgets/selected_sport_card.dart](../lib/screens/profile/sports/widgets/selected_sport_card.dart) | 83 | Widget | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/profile/teams/my_teams_screen.dart](../lib/screens/profile/teams/my_teams_screen.dart) | 348 | Screen | API: `getMyTeams`, `inviteTeamPlayer`; Demo: `dummyProfileSports` |
| [lib/screens/profile/teams/team_history_screen.dart](../lib/screens/profile/teams/team_history_screen.dart) | 748 | Screen | API: `getMyTeamDetails`, `inviteTeamPlayer` |
| [lib/screens/profile/teams/team_tournament_matches_screen.dart](../lib/screens/profile/teams/team_tournament_matches_screen.dart) | 196 | Screen | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/profile/teams/widgets/my_team_card.dart](../lib/screens/profile/teams/widgets/my_team_card.dart) | 145 | Widget | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/profile/tournaments/all_tournaments_screen.dart](../lib/screens/profile/tournaments/all_tournaments_screen.dart) | 163 | Screen | Demo: `dummyAllTournaments`, `dummyProfileSports` |
| [lib/screens/profile/tournaments/match_result_details_screen.dart](../lib/screens/profile/tournaments/match_result_details_screen.dart) | 508 | Screen | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/profile/tournaments/my_tournament_details_screen.dart](../lib/screens/profile/tournaments/my_tournament_details_screen.dart) | 450 | Screen | API: `getTournamentDetail` |
| [lib/screens/profile/tournaments/my_tournaments_screen.dart](../lib/screens/profile/tournaments/my_tournaments_screen.dart) | 318 | Screen | API: `getMyTournaments`; Demo: `dummyProfileSports` |
| [lib/screens/profile/tournaments/widgets/my_tournament_card.dart](../lib/screens/profile/tournaments/widgets/my_tournament_card.dart) | 381 | Widget | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/profile/tournaments/widgets/squad_player_stat_card.dart](../lib/screens/profile/tournaments/widgets/squad_player_stat_card.dart) | 60 | Widget | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/profile/wallet/providers/wallet_provider.dart](../lib/screens/profile/wallet/providers/wallet_provider.dart) | 115 | Provider | API: `getWallet`, `getWalletTransactions`; Provider/load: `fetchWallet` |
| [lib/screens/profile/wallet/transaction_details_screen.dart](../lib/screens/profile/wallet/transaction_details_screen.dart) | 249 | Screen | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/profile/wallet/wallet_transactions_screen.dart](../lib/screens/profile/wallet/wallet_transactions_screen.dart) | 409 | Screen | Provider/load: `fetchWallet`; Empty actions: 1 |
| [lib/screens/profile/widgets/championship_journey_card.dart](../lib/screens/profile/widgets/championship_journey_card.dart) | 181 | Widget | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/profile/widgets/profile_detail_stats_row.dart](../lib/screens/profile/widgets/profile_detail_stats_row.dart) | 54 | Widget | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/profile/widgets/profile_header.dart](../lib/screens/profile/widgets/profile_header.dart) | 71 | Widget | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/profile/widgets/profile_id_card.dart](../lib/screens/profile/widgets/profile_id_card.dart) | 128 | Widget | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/profile/widgets/profile_menu_tile.dart](../lib/screens/profile/widgets/profile_menu_tile.dart) | 91 | Widget | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/profile/widgets/profile_role_chips.dart](../lib/screens/profile/widgets/profile_role_chips.dart) | 40 | Widget | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/profile/widgets/profile_sport_chips.dart](../lib/screens/profile/widgets/profile_sport_chips.dart) | 60 | Widget | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/profile/widgets/profile_stats_row.dart](../lib/screens/profile/widgets/profile_stats_row.dart) | 55 | Widget | Presentation, received data/callbacks, or shared definitions; inspect callers |

## screens/referees

| File | Lines | Role | Integration signals |
|---|---:|---|---|
| [lib/screens/referees/referee_booking_summary_screen.dart](../lib/screens/referees/referee_booking_summary_screen.dart) | 436 | Screen | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/referees/referee_browse_screen.dart](../lib/screens/referees/referee_browse_screen.dart) | 77 | Screen | Demo: `dummyAvailableReferees` |
| [lib/screens/referees/referee_choose_list_screen.dart](../lib/screens/referees/referee_choose_list_screen.dart) | 207 | Screen | Demo: `dummyLastAssignedReferees` |
| [lib/screens/referees/referee_choose_mode_screen.dart](../lib/screens/referees/referee_choose_mode_screen.dart) | 287 | Screen | Demo: `dummyAvailableReferees` |
| [lib/screens/referees/referee_confirmed_screen.dart](../lib/screens/referees/referee_confirmed_screen.dart) | 157 | Screen | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/referees/referee_detail_screen.dart](../lib/screens/referees/referee_detail_screen.dart) | 383 | Screen | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/referees/referee_found_screen.dart](../lib/screens/referees/referee_found_screen.dart) | 356 | Screen | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/referees/referee_game_location_screen.dart](../lib/screens/referees/referee_game_location_screen.dart) | 409 | Screen | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/referees/referee_hub_screen.dart](../lib/screens/referees/referee_hub_screen.dart) | 277 | Screen | Demo: `dummyLastAssignedReferees`, `dummyRefereeAssignments` |
| [lib/screens/referees/referee_payment_screen.dart](../lib/screens/referees/referee_payment_screen.dart) | 430 | Screen | Empty actions: 2 |
| [lib/screens/referees/referee_schedule_screen.dart](../lib/screens/referees/referee_schedule_screen.dart) | 322 | Screen | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/referees/referee_sport_location_screen.dart](../lib/screens/referees/referee_sport_location_screen.dart) | 166 | Screen | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/referees/referees_screen.dart](../lib/screens/referees/referees_screen.dart) | 249 | Screen | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/referees/widgets/referee_assignment_card.dart](../lib/screens/referees/widgets/referee_assignment_card.dart) | 254 | Widget | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/referees/widgets/referee_cta_button.dart](../lib/screens/referees/widgets/referee_cta_button.dart) | 41 | Widget | Presentation, received data/callbacks, or shared definitions; inspect callers |

## screens/splash

| File | Lines | Role | Integration signals |
|---|---:|---|---|
| [lib/screens/splash/splash_screen.dart](../lib/screens/splash/splash_screen.dart) | 617 | Screen | API: `getCheck`; Delayed task (inspect context); Storage mutation |

## screens/sponsor

| File | Lines | Role | Integration signals |
|---|---:|---|---|
| [lib/screens/sponsor/digital_sponsor_pass_screen.dart](../lib/screens/sponsor/digital_sponsor_pass_screen.dart) | 270 | Screen | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/sponsor/my_sponsor_details_screen.dart](../lib/screens/sponsor/my_sponsor_details_screen.dart) | 515 | Screen | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/sponsor/my_sponsorships_screen.dart](../lib/screens/sponsor/my_sponsorships_screen.dart) | 428 | Screen | Demo: `dummySponsorHistoryStats`, `dummySponsorReceipts` |
| [lib/screens/sponsor/sponsor_details_screen.dart](../lib/screens/sponsor/sponsor_details_screen.dart) | 282 | Screen | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/sponsor/sponsor_format.dart](../lib/screens/sponsor/sponsor_format.dart) | 21 | Shared / utility | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/sponsor/sponsor_screen.dart](../lib/screens/sponsor/sponsor_screen.dart) | 157 | Screen | Demo: `dummySponsorSports`, `dummySponsorTournaments` |
| [lib/screens/sponsor/sponsorship_confirmed_screen.dart](../lib/screens/sponsor/sponsorship_confirmed_screen.dart) | 226 | Screen | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/sponsor/sponsorship_identity_screen.dart](../lib/screens/sponsor/sponsorship_identity_screen.dart) | 253 | Screen | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/sponsor/sponsorship_payment_screen.dart](../lib/screens/sponsor/sponsorship_payment_screen.dart) | 212 | Screen | Empty actions: 2; Delayed task (inspect context) |
| [lib/screens/sponsor/sponsorship_screen.dart](../lib/screens/sponsor/sponsorship_screen.dart) | 411 | Screen | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/sponsor/widgets/sponsor_tournament_banner.dart](../lib/screens/sponsor/widgets/sponsor_tournament_banner.dart) | 54 | Widget | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/sponsor/widgets/sponsor_tournament_card.dart](../lib/screens/sponsor/widgets/sponsor_tournament_card.dart) | 173 | Widget | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/sponsor/your_sponsorship_screen.dart](../lib/screens/sponsor/your_sponsorship_screen.dart) | 260 | Screen | Presentation, received data/callbacks, or shared definitions; inspect callers |

## screens/team

| File | Lines | Role | Integration signals |
|---|---:|---|---|
| [lib/screens/team/add_players_screen.dart](../lib/screens/team/add_players_screen.dart) | 450 | Screen | API: `getTeamPlayers`, `inviteTeamPlayer`, `removeTeamPlayer` |
| [lib/screens/team/create_team_screen.dart](../lib/screens/team/create_team_screen.dart) | 750 | Screen | API: `getSports`, `inviteTeamPlayer`, `inviteTeamPlayersList`, `uploadProfileImage` |
| [lib/screens/team/invite_player_screen.dart](../lib/screens/team/invite_player_screen.dart) | 301 | Screen | Demo: `dummyPlaygroundPlayers` |
| [lib/screens/team/join_request_sent_screen.dart](../lib/screens/team/join_request_sent_screen.dart) | 102 | Screen | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/team/join_team_payment_screen.dart](../lib/screens/team/join_team_payment_screen.dart) | 143 | Screen | Empty actions: 2 |
| [lib/screens/team/playground_create_team_screen.dart](../lib/screens/team/playground_create_team_screen.dart) | 739 | Screen | API: `getSports`, `inviteTeamPlayer`, `inviteTeamPlayersList`, `uploadProfileImage` |
| [lib/screens/team/register_tournament.dart](../lib/screens/team/register_tournament.dart) | 149 | Shared / utility | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/team/select_team_screen.dart](../lib/screens/team/select_team_screen.dart) | 687 | Screen | API: `getMyTeamDetails`; Provider/load: `fetchTeams`; Demo: `dummy_tournament_nav_data` |
| [lib/screens/team/team_created_screen.dart](../lib/screens/team/team_created_screen.dart) | 100 | Screen | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/team/team_detail_screen.dart](../lib/screens/team/team_detail_screen.dart) | 210 | Screen | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/team/team_roster_screen.dart](../lib/screens/team/team_roster_screen.dart) | 298 | Screen | API: `getTeamDetails` |
| [lib/screens/team/widgets/add_player_sheet.dart](../lib/screens/team/widgets/add_player_sheet.dart) | 136 | Widget | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/team/widgets/captain_card.dart](../lib/screens/team/widgets/captain_card.dart) | 65 | Widget | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/team/widgets/edit_team_dialog.dart](../lib/screens/team/widgets/edit_team_dialog.dart) | 128 | Widget | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/team/widgets/entry_fee_card.dart](../lib/screens/team/widgets/entry_fee_card.dart) | 45 | Widget | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/team/widgets/join_request_sent_card.dart](../lib/screens/team/widgets/join_request_sent_card.dart) | 68 | Widget | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/team/widgets/player_entry_card.dart](../lib/screens/team/widgets/player_entry_card.dart) | 71 | Widget | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/team/widgets/registration_stepper.dart](../lib/screens/team/widgets/registration_stepper.dart) | 114 | Widget | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/team/widgets/remove_player_dialog.dart](../lib/screens/team/widgets/remove_player_dialog.dart) | 96 | Widget | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/team/widgets/squad_list_card.dart](../lib/screens/team/widgets/squad_list_card.dart) | 47 | Widget | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/team/widgets/squad_member_status_card.dart](../lib/screens/team/widgets/squad_member_status_card.dart) | 78 | Widget | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/team/widgets/team_card.dart](../lib/screens/team/widgets/team_card.dart) | 223 | Widget | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/team/widgets/team_created_success_card.dart](../lib/screens/team/widgets/team_created_success_card.dart) | 105 | Widget | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/team/widgets/team_detail_hero_card.dart](../lib/screens/team/widgets/team_detail_hero_card.dart) | 101 | Widget | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/team/widgets/team_needs_banner.dart](../lib/screens/team/widgets/team_needs_banner.dart) | 66 | Widget | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/team/widgets/team_roster_card.dart](../lib/screens/team/widgets/team_roster_card.dart) | 196 | Widget | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/team/widgets/team_stats_pill.dart](../lib/screens/team/widgets/team_stats_pill.dart) | 41 | Widget | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/team/widgets/warning_notice_banner.dart](../lib/screens/team/widgets/warning_notice_banner.dart) | 33 | Widget | Presentation, received data/callbacks, or shared definitions; inspect callers |

## screens/team_up

| File | Lines | Role | Integration signals |
|---|---:|---|---|
| [lib/screens/team_up/team_up_assigned_team_screen.dart](../lib/screens/team_up/team_up_assigned_team_screen.dart) | 253 | Screen | Demo: `dummyTeamUpAssignedTeam` |
| [lib/screens/team_up/team_up_browse_screen.dart](../lib/screens/team_up/team_up_browse_screen.dart) | 96 | Screen | Demo: `dummyTeamUpTournaments` |
| [lib/screens/team_up/team_up_confirm_screen.dart](../lib/screens/team_up/team_up_confirm_screen.dart) | 237 | Screen | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/team_up/team_up_event_screen.dart](../lib/screens/team_up/team_up_event_screen.dart) | 464 | Screen | Demo: `dummyTeamUpHowItWorks`, `dummyTeamUpSports`, `dummyTeamUpTournaments` |
| [lib/screens/team_up/team_up_in_screen.dart](../lib/screens/team_up/team_up_in_screen.dart) | 337 | Screen | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/team_up/team_up_payment_screen.dart](../lib/screens/team_up/team_up_payment_screen.dart) | 232 | Screen | Demo: `dummyTeamUpPlatformFee`; Empty actions: 2; Delayed task (inspect context) |
| [lib/screens/team_up/team_up_register_screen.dart](../lib/screens/team_up/team_up_register_screen.dart) | 451 | Screen | Demo: `dummyTeamUpBattingStyles`, `dummyTeamUpBowlingStyles`, `dummyTeamUpExperienceLevels`, `dummyTeamUpPlayingRoles` |
| [lib/screens/team_up/team_up_screen.dart](../lib/screens/team_up/team_up_screen.dart) | 305 | Screen | Demo: `dummyTeamUpChipSports`, `dummyTeamUpFilters`, `dummyTeamUpTournaments` |
| [lib/screens/team_up/widgets/team_up_featured_card.dart](../lib/screens/team_up/widgets/team_up_featured_card.dart) | 231 | Widget | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/team_up/widgets/team_up_tournament_card.dart](../lib/screens/team_up/widgets/team_up_tournament_card.dart) | 189 | Widget | Presentation, received data/callbacks, or shared definitions; inspect callers |

## screens/tournament

| File | Lines | Role | Integration signals |
|---|---:|---|---|
| [lib/screens/tournament/dummy_tournament_nav_data.dart](../lib/screens/tournament/dummy_tournament_nav_data.dart) | 11 | Shared / utility | Demo: `dummyNavSquadPlayers` |
| [lib/screens/tournament/tournament_detail_screen.dart](../lib/screens/tournament/tournament_detail_screen.dart) | 636 | Screen | Provider/load: `fetchTournamentDetail` |
| [lib/screens/tournament/tournaments_list_screen.dart](../lib/screens/tournament/tournaments_list_screen.dart) | 124 | Screen | Provider/load: `fetchTournaments` |
| [lib/screens/tournament/widgets/award_box.dart](../lib/screens/tournament/widgets/award_box.dart) | 31 | Widget | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/tournament/widgets/format_info_box.dart](../lib/screens/tournament/widgets/format_info_box.dart) | 46 | Widget | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/tournament/widgets/prize_rank_row.dart](../lib/screens/tournament/widgets/prize_rank_row.dart) | 59 | Widget | Presentation, received data/callbacks, or shared definitions; inspect callers |
| [lib/screens/tournament/widgets/tournament_stat_box.dart](../lib/screens/tournament/widgets/tournament_stat_box.dart) | 32 | Widget | Presentation, received data/callbacks, or shared definitions; inspect callers |

