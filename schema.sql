-- GitMatch Supabase Schema Setup
-- Run this entire script in your Supabase SQL Editor

-- 1. Create Profiles Table (extends auth.users)
CREATE TABLE public.profiles (
  id UUID REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
  username TEXT UNIQUE NOT NULL,
  email TEXT NOT NULL,
  display_name TEXT,
  avatar_url TEXT,
  bio TEXT,
  role TEXT,
  skills TEXT[] DEFAULT '{}',
  interests TEXT[] DEFAULT '{}',
  experience_level TEXT,
  availability TEXT,
  github_url TEXT,
  twitter_handle TEXT,
  hackathon_mode BOOLEAN DEFAULT FALSE,
  mentorship_mode BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable RLS for profiles
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Public profiles are viewable by everyone." ON public.profiles FOR SELECT USING (true);
CREATE POLICY "Users can update own profile." ON public.profiles FOR UPDATE USING (auth.uid() = id);

-- Trigger to create profile on sign up
CREATE OR REPLACE FUNCTION public.handle_new_user() 
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, username, email, display_name, avatar_url)
  VALUES (
    NEW.id,
    COALESCE(NEW.raw_user_meta_data->>'preferred_username', split_part(NEW.email, '@', 1)),
    NEW.email,
    NEW.raw_user_meta_data->>'full_name',
    NEW.raw_user_meta_data->>'avatar_url'
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();


-- 2. Create Repositories Table (Optional: App fetches from GitHub API if empty)
CREATE TABLE public.repositories (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  owner TEXT NOT NULL,
  description TEXT,
  long_description TEXT,
  stars INTEGER DEFAULT 0,
  forks INTEGER DEFAULT 0,
  watchers INTEGER DEFAULT 0,
  tech_stack TEXT[] DEFAULT '{}',
  is_verified BOOLEAN DEFAULT FALSE,
  is_public BOOLEAN DEFAULT TRUE,
  license TEXT,
  version TEXT,
  commit_growth NUMERIC,
  github_url TEXT,
  readme_snippet TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE public.repositories ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Repos viewable by everyone" ON public.repositories FOR SELECT USING (true);



-- 5. Create Swipe History Table
CREATE TABLE public.swipe_history (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  user_id TEXT NOT NULL,
  item_id TEXT NOT NULL,
  item_type TEXT NOT NULL, -- 'repo', 'hackathon', 'mentor'
  direction TEXT NOT NULL, -- 'left', 'right'
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, item_id, item_type)
);
ALTER TABLE public.swipe_history ENABLE ROW LEVEL SECURITY;
-- For demo purposes allowing easy writes, in production tie user_id to auth.uid()
CREATE POLICY "Anyone can insert swipe" ON public.swipe_history FOR INSERT WITH CHECK (true);
CREATE POLICY "Anyone can view swipe" ON public.swipe_history FOR SELECT USING (true);


-- 6. Create Saved Items Table
CREATE TABLE public.saved_items (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  user_id TEXT NOT NULL,
  item_id TEXT NOT NULL,
  item_type TEXT NOT NULL, -- 'repo', 'hackathon', 'mentor'
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, item_id, item_type)
);
ALTER TABLE public.saved_items ENABLE ROW LEVEL SECURITY;
-- For demo purposes allowing easy writes, in production tie user_id to auth.uid()
CREATE POLICY "Anyone can insert saved items" ON public.saved_items FOR INSERT WITH CHECK (true);
CREATE POLICY "Anyone can view saved items" ON public.saved_items FOR SELECT USING (true);
CREATE POLICY "Anyone can delete saved items" ON public.saved_items FOR DELETE USING (true);


-- 7. Create Keepalive Ping Table
CREATE TABLE public.keepalive_pings (
  id BIGSERIAL PRIMARY KEY,
  source TEXT NOT NULL DEFAULT 'scheduled',
  created_at TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE public.keepalive_pings ENABLE ROW LEVEL SECURITY;
