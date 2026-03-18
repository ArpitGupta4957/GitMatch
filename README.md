<div align="center">

# 🐙 GitMatch – Swipe. Match. Code.

**A premium, swipe-based discovery platform for developers**

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart)](https://dart.dev/)
[![Provider](https://img.shields.io/badge/State-Provider-6.1.2-8E44AD)](.)
[![Supabase](https://img.shields.io/badge/Supabase-Postgres-3FCF8E?logo=supabase&logoColor=white)](https://supabase.com/)
[![Material 3](https://img.shields.io/badge/Design-Material%203-6750A4?logo=materialdesign&logoColor=white)](https://m3.material.io/)

*GitHub OAuth • Swipeable Discovery • Mentorship • Hackathon Teammates • GitHub Dark Theme*

</div>

---

## 🎯 Overview

GitMatch is a clean-architecture Flutter application designed for developers to discover repositories, find hackathon teammates, and seek or offer mentorship. With an intuitive, swipe-based interface and a sleek GitHub dark-mode aesthetic, GitMatch makes networking and contributing to open source engaging and accessible.

---

## 📸 App Preview

| Onboarding | Home Dashboard | Repo Feed (Swipe) | Hackathon Feed | Mentorship |
|---|---|---|---|---|
| ![Onboarding](docs/screens/onboarding.png) | ![Dashboard](docs/screens/home.png) | ![Swipe](docs/screens/swipe.png) | ![Hackathon](docs/screens/hackathon.png) | ![Mentorship](docs/screens/mentorship.png) |


---

## 🏗️ App Architecture

```text
┌─────────────────────────────────────────────────────────────────────────────┐
│                              Flutter App UI                                │
│   Splash → Login ─┬→ Onboarding ─┬→ Home Dashboard ──┬→ Repo Feed          │
│                   │              │                   ├→ Hackathon Feed     │
│                   │              │                   └→ Mentorship Feed    │
│                   │              │                                         │
│                   └──────────────┴→ Saved Items ← Nav → Profile / Detail   │
└──────────────────────────────────┬────────────────────────────────────────┘
                                   │
                     Provider State Layer
          (AuthProvider, FeedProvider, SwipeProvider, SavedProvider, ProfileProvider)
                                   │
                   ┌───────────────┼───────────────┐
                   │               │               │
             AuthService     RepoService    HackathonService
        (GitHub / Email)   (Fetch / Swipe)    (Matches)
                   │               │               │
  (RecommendationService / Demo Mode Fallbacks for offline testing)
                   │               │               │
                   └───────────────┼───────────────┘
                                   │
                             Supabase DB
              (authentication + database + storage via RLS)
```

---

## ✨ Features

### 🔐 Multi-Auth & Onboarding
- **GitHub OAuth integration** for seamless developer onboarding
- Standard email/password registration fallback
- 3-step personalized onboarding flow (Role → Interests → Tech Stack)
- Demo mode for local testing without backend configuring

### 🃏 Swipe-Based Discovery
- Engaging Tinder-style swipe cards for Repositories
- Drag physics with dynamic rotation and color overlays (SAVE vs REJECT)
- **Rate limiting** enforced (e.g., 10 swipes per hour) with countdown timers
- Action buttons for quick interactions

### 💻 Repository Feed & Details
- Discover trending and recommended open-source projects
- Detail pages packed with commit activity charts, tech stack chips, and README snippets
- Star and Fork counts beautifully formatted
- Direct deep-links to "Star on GitHub"

### 🏆 Hackathon & Mentorship Matching
- Dedicated tabs for "For You", "Remote", and "Nearby" hackathons
- Matching indicators showing alignment with your tech stack
- Mentorship feed segmented by "Mentors", "Mentees", and "Explore"
- Featured mentor cards showcasing "Offering" or "Seeking" status

### 📊 Comprehensive User State
- **Saved Items Dashboard:** Tabbed view of all swiped-right Repos, Hackathons, and Mentors
- **User Profile:** Track active modes (Hackathon Mode, Mentorship Mode), skills, and saved stats
- Edit Profile functionality to update bio, GitHub link, and Social IDs.

### 🎨 Premium Design System
- Material 3 tailored with a strict **GitHub Dark Theme**
- Google Fonts (Inter) typography for maximum readability
- Reusable UI widgets: Loading shimmers, rate limit notices, glassmorphic cards, and animated buttons
- Smooth transitions and micro-animations throughout

---

## 🛠️ Technology Stack

| Category | Technology |
|---|---|
| **Framework** | Flutter (latest stable, null-safe) |
| **State Management** | Provider (5 discrete providers) |
| **Backend / Auth** | Supabase (Auth + Database + Storage) |
| **Design System** | Material 3 + Custom GitHub Dark Theme |
| **Typography** | Google Fonts (Inter) |
| **Architecture** | Clean Architecture (models → services → providers → screens) |

---

## 📁 Project Structure

```text
lib/
 ├── main.dart                              # Entry point + MultiProvider setup
 ├── core/
 │   ├── constants/                         # Colors, Spacing, Typography, Strings
 │   ├── theme/                             # AppTheme (Dark mode configuration)
 │   └── utils/                             # Animations, Rate Limiter, Validators
 ├── models/
 │   ├── user_model.dart                    # Core user entity
 │   ├── repo_model.dart                    # Repository entity
 │   ├── hackathon_model.dart               # Hackathon entity
 │   ├── mentor_model.dart                  # Mentorship entity
 │   └── swipe_model.dart                   # Swipe action tracking
 ├── services/
 │   ├── supabase_service.dart              # Backend initialization
 │   ├── auth_service.dart                  # Authentication & OAuth
 │   ├── repo_service.dart                  # Repo feeds (with demo data)
 │   ├── hackathon_service.dart             # Hackathon feeds (with demo data)
 │   └── recommendation_service.dart        # Content sorting algorithms
 ├── providers/
 │   ├── auth_provider.dart                 # Manages session state
 │   ├── feed_provider.dart                 # Manages feeds & rate limits
 │   ├── swipe_provider.dart                # Manages swipe arrays
 │   ├── saved_provider.dart                # Manages saved/bookmarked items
 │   └── profile_provider.dart              # Manages active user profile
 ├── screens/
 │   ├── splash/                            # App initialization visuals
 │   ├── auth/                              # Login & GitHub OAuth handling
 │   ├── onboarding/                        # 3-step feature introduction
 │   ├── home/                              # Central dashboard
 │   ├── feeds/                             # Swipeable Repos, Hackathons, Mentors
 │   ├── detail/                            # Expanded item views
 │   ├── saved/                             # Bookmarked items tabs
 │   └── profile/                           # User settings and stats
 └── widgets/
     ├── animated_button.dart               # Scale-on-tap CTA buttons
     ├── github_card.dart                   # Themed container elements
     ├── swipe_indicator.dart               # Feedback overlays for swipe logic
     └── loading_widget.dart                # Shimmers and progress indicators
```

---

## 🚀 Quick Start

### Prerequisites
- Flutter SDK (latest stable)
- Supabase project (Optional if using embedded Demo Mode)

### 1) Install dependencies

```bash
flutter pub get
```

### 2) Configure Environment

Update `lib/services/supabase_service.dart` with your Supabase credentials if running on production data:

```dart
static const String _supabaseUrl = 'YOUR_SUPABASE_URL';
static const String _anonKey = 'YOUR_SUPABASE_ANON_KEY';
```

*(Note: The app ships with demo mode data baked into the Services by default to allow UI testing without backend setup)*

### 3) Run app

```bash
flutter run
```

---

## 🔐 Security & State Handling

| Mechanism | Implementation |
|---|---|
| Rate Limiting | Shared Preferences + FeedProvider checks (Max 10 per hour) |
| State Immutability | Provider read/watch models |
| OAuth Handling | Native URL launching + Supabase deep links |
| UI State | Fallback shimmers and explicit error boundaries |

---

## 🧪 Quality Checks

```bash
flutter analyze    # Static analysis — 0 errors ✅
flutter test       # Core app initialization logic
```

---

## 📱 Screen Routes

| Route | Feature Area |
|---|---|
| `SplashScreen` | Initialization |
| `LoginScreen` | Authentication & GitHub OAuth |
| `OnboardingScreen` | Value Prop & Feature Walkthrough |
| `RoleSelectionScreen` | Profile Initialization |
| `InterestSelectionScreen` | Preference Tagging |
| `TechStackSelectionScreen` | Skils Initialization |
| `HomeDashboard` | Core Hub & Activity |
| `RepoFeedScreen` | Swipeable Repository Discovery |
| `HackathonFeedScreen` | Upcoming Events & Matching |
| `MentorshipFeedScreen` | Connection Discovery |
| `DetailPage` | Deep-dive metrics and logs |
| `SavedItemsScreen` | Bookmarked Content |
| `ProfileScreen` | User Stats & App Configurations |
| `EditProfileScreen` | Metadata updates |

---

<div align="center">

**Built for developers, by developers.**

Made with ❤️ using Flutter & Supabase

</div>
