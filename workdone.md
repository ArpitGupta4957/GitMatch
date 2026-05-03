**Work Done (Summary)**

**Overview:**
- **Project:** GitMatch (Flutter app using Supabase backend).
- **Date:** 2026-05-03 (latest update).

**Features Implemented:**
- **Keepalive automation:** Cron job that pings Supabase every 2 days to prevent free-tier pausing. See [.github/workflows/supabase-keepalive.yml](.github/workflows/supabase-keepalive.yml).
- **OAuth / Auth flow fixes:** GitHub OAuth sign-in flow corrected with explicit navigation and splash auth gating; GitHub avatar saved and shown in profile.
- **UI polish:** Splash and login logos added; collaborators icons; removed footer and notification bell icons across screens.
- **Navigation / UX:** Bottom navigation converted to floating translucent style; `Mentors` tab removed.
- **Swipe history:** Explore (Repo Feed) shows swipe history, now persisted and loaded from DB.
- **Recent activity:** App records recent repository visits and displays them in Home Activity (DB-backed).
- **Profile editing:** Editable `Skills` and `Interests`; saved count fixed to reflect DB; profile shows network avatar from GitHub.


**Database (schema changes / tables):**
- **keepalive_pings**: Table used by GitHub Actions keepalive cron to insert periodic rows and keep project active. See [schema.sql](schema.sql).
- **swipe_history**: Stores user swipe actions (left/right) used to render Swipe History.
- **saved_items**: Stores saved repositories; SavedProvider now reads from this table.
- **recent_repo_visits**: (Added) Records recent repo visits for Activity panel. Ensure you run the updated [schema.sql](schema.sql) in Supabase to create this table remotely.
- **profiles, repositories, etc.**: Existing app tables remain in use.

**Providers & State:**
- **AuthProvider:** Handles auth state, loads profile on startup, triggers dependent provider loads.
- **SwipeProvider:** Persists and loads swipe history from DB.
- **SavedProvider:** Loads saved items from `saved_items` table (replaced demo fallback).
- **ActivityProvider:** (New) Loads and records `recent_repo_visits`.
- **ProfileProvider / other providers:** Manage profile, feeds, and app state.

**Services:**
- **SupabaseService:** Initializes Supabase client using `.env` keys. [lib/services/supabase_service.dart](lib/services/supabase_service.dart)
- **AuthService:** OAuth sign-in (GitHub), `getOrCreateProfile()`, `updateProfile()` including `avatar_url` handling. [lib/services/auth_service.dart](lib/services/auth_service.dart)
- **RepoService:** Repo-related DB operations (save, fetch saved repos, record visits).

**Key Files Created / Modified:**
- **Schema:** [schema.sql](schema.sql) (added `recent_repo_visits`, `keepalive_pings` previously)
- **CI workflow:** [.github/workflows/supabase-keepalive.yml](.github/workflows/supabase-keepalive.yml)
- **Auth flow:** [lib/services/auth_service.dart](lib/services/auth_service.dart), [lib/providers/auth_provider.dart](lib/providers/auth_provider.dart)
- **Activity model/provider:** [lib/models/recent_repo_visit.dart](lib/models/recent_repo_visit.dart), [lib/providers/activity_provider.dart](lib/providers/activity_provider.dart)
- **UI updates:** [lib/screens/home/home_dashboard.dart](lib/screens/home/home_dashboard.dart), [lib/screens/feeds/repo_feed_screen.dart](lib/screens/feeds/repo_feed_screen.dart), [lib/screens/profile/profile_screen.dart](lib/screens/profile/profile_screen.dart), [lib/screens/profile/edit_profile_screen.dart](lib/screens/profile/edit_profile_screen.dart), [lib/screens/auth/login_screen.dart](lib/screens/auth/login_screen.dart), [lib/screens/splash/splash_screen.dart](lib/screens/splash/splash_screen.dart)
- **Assets:** [assets/logo.png](assets/logo.png), [assets/logo_half.png](assets/logo_half.png)

**CI / Automation:**
- **GitHub Actions keepalive:** Scheduled workflow posts to Supabase REST (`/rest/v1/keepalive_pings`) every 2 days to keep free-tier projects awake; uses `SUPABASE_SERVICE_ROLE_KEY` stored in GitHub Secrets. See [.github/workflows/supabase-keepalive.yml](.github/workflows/supabase-keepalive.yml).
