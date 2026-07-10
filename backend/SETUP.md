# Phase 1 Setup — Lead Capture (15 minutes, R0/month)

After this setup, every enquiry from the website is saved to your own cloud database, and the office app pulls new leads straight into your pipeline with one tap — even leads that never messaged you on WhatsApp.

## Step 1 — Create your free Supabase project (5 min)

1. Go to **supabase.com** → Sign up (use info@v8soundmachine.co.za or your Gmail).
2. Click **New project**. Name: `v8-sound-machine`. Region: **Europe West (London)** is closest to SA. Set a strong database password (save it somewhere — you rarely need it again).
3. Wait ~2 minutes for the project to spin up.

## Step 2 — Create the enquiries table (2 min)

1. In Supabase, open **SQL Editor** (left sidebar) → **New query**.
2. Open `schema.sql` (in this folder), copy ALL of it, paste, press **Run**.
3. You should see "Success. No rows returned". Done — table + security rules exist.

## Step 3 — Create your login for the office app (2 min)

1. Left sidebar → **Authentication** → **Users** → **Add user** → **Create new user**.
2. Email: your email. Password: choose one (this is what you'll type into the office app).
3. Untick "send email invite" if offered — just create it directly.

## Step 4 — Get your two keys (1 min)

1. Left sidebar → **Project Settings** (gear) → **API**.
2. Copy two values:
   - **Project URL** — looks like `https://abcdefgh.supabase.co`
   - **anon public** key — long string starting `eyJ...`

(The anon key is safe to put in the website — the security rules only allow it to *submit* enquiries, never read them.)

## Step 5 — Paste them into the two files (2 min)

**Website** — open `index.html`, find near the bottom:
```js
const SUPABASE_URL = "";   // paste Project URL here
const SUPABASE_KEY = "";   // paste anon key here
```
Paste your values between the quotes. If you leave them empty, the site simply works WhatsApp-only like before — nothing breaks.

**Office app** — the app is pre-configured with the project URL and key. Just open the app → **More** (settings) → **Cloud sync** → sign in with the email/password from Step 3 → **Sign In & Sync**.

## Step 6 — Test it

1. Open the website, fill in the booking form with your own details, submit.
2. Open the office app → Dashboard → tap **Sync** (or reopen the app).
3. Your test enquiry should appear as a New enquiry. 🎉

## Optional: email alerts for new leads

The app pulls leads whenever you open it. If you also want an email the moment a lead arrives: Supabase → **Database** → **Webhooks** can call a service like Zapier/Make (free tiers) to send you an email. We can wire this up together later — or skip it, since serious clients WhatsApp you anyway.

## Costs

Supabase free tier: 500MB database, 50,000 monthly users — years of headroom for enquiry volumes. R0/month.
