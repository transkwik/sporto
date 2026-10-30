# Sporto API and functionality audit

Reviewed: 27 October 2026. This is a source audit, not a live-backend certification.

## Scope and verification

- Scanned all 292 Dart files under `lib/` (57,975 lines at audit time), including 112 files ending in `_screen.dart` and nine provider files. Some additional screens use other filenames.
- Traced all 45 methods in `UserApis` to direct callers, inspected shared networking/authentication, and reviewed feature actions, navigation, dummy data, persistence, and refresh/pagination handling.
- Checked local import resolution, dependency declarations, asset declarations, Android/iOS permission configuration, and the existing test source.
- Flutter analysis was attempted, but Flutter required writes to its SDK cache outside the workspace. The requested permission was declined. Analysis, compilation, widget tests, and device interaction remain unverified.
- No live endpoint requests, OTP messages, payments, withdrawals, or account mutations were performed. No backend schema or API collection is present in the reviewed material. “Connected” below means the client has a call path, not that the server response was tested.
- Application code was left unchanged. The accompanying source inventory records per-file integration signals; signals alone do not prove a feature is complete.

## Architecture and existing integration conventions

`main.dart` initializes `GetStorage`, registers nine application-wide `ChangeNotifier` providers, and builds `Sizer` → `GetMaterialApp`. The initial route is splash. Routing mixes named routes, `MaterialPageRoute`, and GetX navigation.

The common request path is screen → provider → `UserApis` → `ApiHelper` → HTTP. Several screens call `UserApis` directly and manage loading/error state with `setState`. Models are mixed: presentation models and demo datasets coexist with raw API maps and a few dedicated parsers such as `MatchDataParser` and `TournamentPrizes`.

Base URL: `https://app.spotoapp.in/api/v1/user/`. Uploads use the absolute common upload endpoint. `ApiHelper` attaches the stored `authToken` as a bearer token, decodes JSON, catches network/other exceptions, and clears the token/navigates to login on both 401 and 403. The existing layer supports GET, JSON POST/PUT, DELETE, multipart upload, and absolute-URL requests.

Typical envelope: `{success, message, data}` with optional `errors`, `meta`, or local `{error}` / `{session_expired}` results. List parsing varies between root `data` + `meta`, nested `data.data`, and `data.items`. These variations must be confirmed against actual response examples for each endpoint.

### Provider responsibilities

| Provider | Responsibility |
|---|---|
| `AuthProvider` | OTP session key, device identifiers, token persistence, current user response, logout |
| `ProfileProvider` | Gallery image upload and profile completion |
| `PermissionProvider` | Notification/location permission requests, GPS, reverse geocoding, location update |
| `LocationProvider` | In-memory coordinates and display address |
| `HomeProvider` | Sports, tournaments, team CRUD, available teams/join requests, my teams, match feeds/scores, invitations |
| `MyPrizesProvider` | Fetch prize pages, status filters, amount/count summaries |
| `PrizeDistributionProvider` | Tournament payout distribution; includes a tournament-ID stale-response check |
| `WalletProvider` | Balance and transaction pages, loaded concurrently |
| `BankProvider` | Saved accounts, selection, add/edit/default/delete, merge and server resync |

## Feature coverage

| Feature | Implementation today | Remaining integration or behavior |
|---|---|---|
| Splash/session restore | Reads token, requests profile, routes to onboarding/login/profile/permissions | Normalize profile response shape with login and profile consumers; simplify unnecessary service-account token startup step |
| Onboarding | Animated local introduction and stored seen flag | No API needed for slides unless backend requirements change |
| Mobile OTP | Send/resend/verify calls, session key, device ID/name, token save, error UI | Confirm returning-user profile completeness and location routing; authentication tests |
| Separate signup screen | Validates a form, waits locally, navigates home | Does not create an account or obtain a token; determine whether this route should be retained |
| Complete profile | Name/email/DOB/gender/city/state and optional uploaded photo path submitted; profile refreshed | Standardize profile data and validation contract; profile editing is not implemented as an authenticated update flow |
| Permissions/location | OS permission requests, GPS/reverse geocode, PUT location | No FCM token registration/message listeners found; tournament coordinate filtering is disabled by a feature flag |
| Home dashboard | API sports, tournaments, live/upcoming matches, invitations and prize banner | Some static promotional content, dummy sport fallback, shared-tab request state, incomplete tap handlers |
| Tournament browsing/detail | Paginated list, detail API, filters, navigation into registration | Confirm list envelope and filters; isolate list state from other tabs |
| Team creation/edit/delete | API team CRUD, logo upload, invitations; two very similar creation implementations | Fix success handling, invitation outcome handling, and consolidate duplicated behavior when changing this feature |
| Team roster/add players | Team/roster reads, phone-based invitation, remove-player API | `addTeamPlayer` wrapper has no direct caller; clarify direct add versus invitation semantics |
| Squad selection/registration | Reads owned teams and roster, selects team-player IDs, registration/payment calls | Robust response IDs/counts, roster eligibility, partial-failure handling; real payment gateway |
| Team invitations | List/search/pagination, accept/reject through API, home summary refresh | Notification-inbox invitation buttons are a different local demo flow; keep server actions consistent across surfaces |
| Playground teams | Available-team API with sport/location/role/radius, join request, my teams/detail | Broken import; requested-team status is partly session-local; filters/search need server-contract review |
| Player discovery/invite browser | Demo player list, local filtering and success messages | Player discovery/search API and actual invite action; phone-based invite elsewhere already has API support |
| Live/upcoming/all matches | API lists, pagination and sport selection; live-feed search | Root pagination metadata handling, shared filter state, request races; search currently only passed to live endpoint |
| Live scorecard | GET score on entry and pull-to-refresh; parses innings/runtime/events and roster names | No automatic polling/subscription; reaction counters, predictor/hype/check-in portions remain static/local |
| Completed scorecard | Main match feed passes parsed API match data into completed detail | Profile tournament result detail is a separate screen with hardcoded innings; do not mistake it for the same implementation |
| Stadium badges/predictor | Local zone selections, fixed leaderboard/points, result navigation | Server eligibility/check-in, badge minting, prediction submission/results and leaderboard APIs |
| Rankings | Dummy ranking entries and sport filters; local detail screens | Rankings and player/team ranking detail data |
| My Teams/team history | API my-team list/detail, invitation action, detail/history presentation | Verify nested tournament/match contracts; match list currently casts incoming entries to presentation objects |
| My Tournaments | Paginated API list and detail request | Detail maps scores to “Yet to bat”; full result detail remains demo innings; improve failure/mounted handling |
| Profile All Tournaments | Separate dummy list | Connect to tournament browsing API or unify with existing browse flow |
| Profile summary/details | Basic identity derived from auth response | Sports, role chips, career stats/journey remain static; no profile-edit API flow |
| My Sports | Local add/remove/toggle/role selection | Persist user sports and roles, restore them from server |
| My Statistics/achievements/awards | Static statistics, demo badges and awards | Statistics, achievement and award contracts and detail reads |
| Prizes | API my-prizes, tournament prizes and distribution; status/currency helpers | Large-history totals/partial failures; older prize-calculation/distribution/credited screens still default to dummy details |
| Wallet/transactions | API balance/history, client display filtering and detail | Withdrawal submit/status/history and statement download are not implemented |
| Bank accounts | API list/add/update/set-default/delete, active filtering and resync | Actual withdrawal is separate and absent; integration tests for mutations and validation |
| Sponsorship | Local tournament/category selection, identity, delayed fake payment, receipt/pass screens and demo history | Sponsorable inventory, pricing, create/payment/verify, receipt/history/pass, export/share |
| Team Up | Demo event lists, local registration fields, delayed fake payment, confirmation and assigned team | Event/eligibility, registration/payment, assignment and status APIs |
| Celebrate/fan tipping | Demo campaigns/players, amount validation, identity, delayed fake payment and demo tip history | Campaign/recipient APIs, create tip/payment/verify, receipt/history and totals |
| Referees | Demo officials/assignments/availability; local location, schedule, booking/payment/confirmation | Discovery, venues/geolocation, availability/quote, booking/payment/status APIs |
| Notifications/settings | Demo inbox; local accept/dismiss and category toggles | Inbox/read/delete actions, preferences persistence, push token registration and delivery handling |
| Support/promotional actions | Several empty handlers; sponsor pass export and wallet statement explicitly unavailable | Define destinations/actions; configured policy/support URLs reference another app domain |
| Logout | Server call, removes token and auth response on success | Clear all account-scoped provider state and define offline/expired-session behavior |

## Findings to address before expanding integration

### Build and credential handling

1. **Broken Playground import.** `lib/screens/playground/playground_screen.dart:4` imports `../../../core/constants/app_colors.dart`. From that directory this resolves outside `lib/`; the existing file is `lib/core/constants/app_colors.dart`. This is a source-level build blocker. The local import scan found no other missing local Dart targets.
2. **Service-account private key exists locally.** `assets/firebase/sporto_firebase.json` contains service-account credentials including a private key. `AuthService` attempts to obtain a cloud-platform access token on the client and logs it. The Firebase asset directory is not in `pubspec.yaml`'s asset list. `git ls-files` did not list this JSON, so this audit does not establish that the key was committed or shipped. Move privileged credential use to a backend; assess any prior distribution before deciding on rotation. No key values are included here.
3. **Sensitive request logging.** `ApiHelper` logs bearer tokens, request bodies and full responses, including flows carrying OTPs, profile data and bank details. Remove/redact these logs before production use.
4. **Undeclared direct dependency.** `package:http` is imported by the API helper and Firebase service but is not a direct dependency in `pubspec.yaml`; it currently relies on transitive resolution.

### Incorrect or incomplete action outcomes

5. **Team creation can navigate to success after failure.** In `create_team_screen.dart:343` and `playground_create_team_screen.dart:338`, `_handleSaveTeam` calls `_finishFlow()` even when `_createdTeamId` remains null after `_handleCreateTeam`.
6. **Bulk invitation failure is ignored.** Both creation screens await `inviteTeamPlayersList` without checking the returned success/errors, catch exceptions without surfacing failure, then display “Team created and invitations sent successfully!”. Team creation and invitation outcomes need separate handling.
7. **Withdrawal confirmation has no request.** `withdraw_to_bank_screen.dart:106` only displays a toast when selected. There is no withdrawal endpoint wrapper or money-transfer call.
8. **Payments are not production integrations.** Tournament registration explicitly requests method `mock`; sponsorship/Team Up/tipping use short delays before success. Referee payment advances through local navigation. Payment method controls do not imply that a gateway is connected.
9. **Match team fallback can show the same team twice.** In `MatchDataParser.team`, when `team_a` and `team_b` are absent and only `teams` is supplied, both calls can select the first list element because the opposite direct ID is null. Use stable side/ID mapping and test this response shape.
10. **Fallback match ID can open an unrelated match.** `Matches_screen.dart` and `live_matches_screen.dart` use `3665` if an item's ID is absent. Missing IDs should disable navigation or show an error.

### State, response contracts and lifecycle

11. **Profile envelope assumptions differ.** Splash checks `check['data']['profile']`, whereas home/profile/team creation consume `checkResponse['user']['profile']`. Both can only be correct if the actual responses explicitly support those shapes. Normalize OTP/profile responses at the auth boundary after checking real payloads. OTP returning users go directly home, while restored sessions go through permissions/profile checks.
12. **Cross-tab request races.** `HomeScreen` mounts five `IndexedStack` children, and multiple tabs initialize/fetch against the same lists/page counters in `HomeProvider`. Refreshes have no request-generation/filter guard. A slower response for a previous sport/search can replace the current list, and overlapping requests can advance shared page counters. Isolate query state and reject obsolete responses.
13. **Pagination contracts are inconsistent.** Live/upcoming/all feed methods read last-page information inside nested data but do not read root `meta` for list data. Other features do read root metadata. If feed responses use root metadata, pagination stops at the default first page. Verify each list contract rather than assuming one envelope.
14. **Incomplete refresh futures.** Live Matches `_fetchAll` and Playground `_fetchAvailableTeams` return void and are wrapped in immediate async refresh callbacks; home refresh does not await most dispatched loads. The refresh indicator can finish before network work does.
15. **Network handling is uneven.** Shared calls have no explicit timeout; splash alone adds a 10-second profile timeout. Both 401 and 403 force logout, even though some 403 responses may represent forbidden actions for a valid session. Empty/non-JSON error bodies often fall into generic decode errors, and most helpers only special-case authentication statuses. Confirm server semantics before changing behavior.
16. **Session state survives logout.** Global providers outlive routes; logout clears only auth state/token. HomeProvider's requested-team IDs and cached sports, plus other user state, have no coordinated logout reset. Some feature screens reset their own providers on entry, which does not provide a full session boundary or prevent older in-flight responses from completing later.
17. **Async screens need lifecycle/error review.** Examples: `SelectTeamScreen._fetchTeamDetails` calls `setState` after awaiting without a mounted guard around the success path; `MyTournamentDetailsScreen._fetchDetails` lacks a try/catch and mounted checks. Switching teams also has no selected-team request guard, so the wrong roster can win a race.
18. **Financial lists can look complete when partial.** Wallet and My Prizes fetch at most 20 pages × 50 items, calculate values from loaded records, and keep partial pages without showing truncation/later-page errors. Wallet hides a failed subrequest when the other succeeds. For complete histories/totals, use server aggregates or explicit pagination and partial/error indicators.
19. **Team history match type mismatch needs contract confirmation.** `TeamTournamentMatchesScreen` casts `tournament['matches']` elements to `MyTournamentMatchResult`. Team history merges raw API data into its map; raw JSON objects would not satisfy that cast. Map the server entries explicitly before rendering.

## Integration approach for the next APIs

1. First resolve build blockers, remove false success paths, normalize auth/session handling and prevent obsolete responses from overwriting active state.
2. For each next feature obtain its method/path, authentication requirements, request example, success and validation/error examples, pagination/filter metadata, enum meanings, IDs and action eligibility. The missing-feature categories above are requirements, not invented endpoint paths.
3. Add endpoint calls in `UserApis` and reuse the shared HTTP layer. Keep state in the feature provider or the existing screen state consistently with nearby code; make loading, empty, retry and failure behavior explicit. Avoid unrelated architectural migration while integrating one feature.
4. Replace demo sources at the entry screen, pass real IDs/data through every downstream screen, and implement the mutation/receipt/history paths too. Replacing only the list does not complete sponsorship, tipping, Team Up or booking.
5. Invalidate or refresh every affected surface after a mutation: invitations → team/home counts; roster change → squad selection; payment → registration/my tournaments/wallet; bank mutations → payout selectors; withdrawal → balance/history/status.
6. Use actual server outcomes for success screens. Confirm payment server-side and implement pending/failure/cancel/retry states using the chosen backend/gateway contract.
7. Validate each integration with recorded response fixtures and focused tests for meaningful contract branches, then a device walkthrough using test accounts and a test payment environment.

Suggested sequence: shared networking/auth fixes → profile/sports and player discovery → match detail/results/refresh → notifications/preferences → withdrawal/payment gateway → sponsorship → Team Up → tipping → referee booking → rankings/statistics/awards. Product priorities can change this order.

## Verification still required

- Run `flutter analyze --no-pub`, then targeted tests/builds when SDK cache access is available.
- Replace/update `test/widget_test.dart`: it mounts `SportoApp` without production provider/storage setup, expects old splash strings (`SPORTO`, `Play. Track. Compete.`), and uses `pumpAndSettle` while splash has repeating animations. Its comment also predates backend integration.
- `lib/test_live_matches.dart` and `lib/test_tournaments.dart` are standalone live-request probes, not automated assertions. They were inspected, not executed.
- Walk through first launch, OTP resend/failure, incomplete profile, location denied/service disabled, expired session, and logout/login to a different account.
- Verify list searches/filter switches/pagination under slow and out-of-order responses, empty results and network failures.
- Exercise team creation plus invitation failure, roster changes, duplicate join/invite actions and registration retries.
- Confirm actual backend payloads for the identified profile, pagination, team-history and score-parser mismatches.
- Test real gateway pending/failure/success and withdrawal transitions only after their API contracts are integrated.

See [API_ENDPOINT_INVENTORY.md](API_ENDPOINT_INVENTORY.md) for all endpoint wrappers and direct callers, and [APP_SOURCE_INVENTORY.md](APP_SOURCE_INVENTORY.md) for every Dart file's static integration signals.
