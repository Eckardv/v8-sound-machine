-- ============================================================
-- V8 Sound Machine — Phase 1: lead capture
-- Run this once in Supabase: SQL Editor → New query → paste → Run
-- ============================================================

create table if not exists public.enquiries (
  id          uuid primary key default gen_random_uuid(),
  created_at  timestamptz not null default now(),
  source      text not null default 'booking',   -- 'booking' | 'quote'
  name        text,
  phone       text,
  email       text,
  event_type  text,
  event_date  date,
  venue       text,
  package     text,
  guests      int,
  hours       int,
  addons      text,
  estimate    numeric,
  notes       text,
  status      text not null default 'new'        -- 'new' | 'imported'
);

-- Row Level Security: the public website may ONLY insert.
-- Reading/updating requires you to be logged in (the office app).
alter table public.enquiries enable row level security;

drop policy if exists "public can submit enquiries" on public.enquiries;
create policy "public can submit enquiries"
  on public.enquiries for insert
  to anon
  with check (true);

drop policy if exists "owner can read enquiries" on public.enquiries;
create policy "owner can read enquiries"
  on public.enquiries for select
  to authenticated
  using (true);

drop policy if exists "owner can update enquiries" on public.enquiries;
create policy "owner can update enquiries"
  on public.enquiries for update
  to authenticated
  using (true);

-- Helpful index for the app's "fetch new leads" query
create index if not exists enquiries_status_created_idx
  on public.enquiries (status, created_at desc);
