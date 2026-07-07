-- Run this in your Supabase SQL editor

-- 1. Sessions table
create table if not exists player_sessions (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  layout jsonb not null,
  created_at timestamptz default now()
);
alter table player_sessions enable row level security;
create policy "allow all" on player_sessions for all using (true) with check (true);

-- 2. Storage bucket for audio files (public)
insert into storage.buckets (id, name, public)
values ('audio-files', 'audio-files', true)
on conflict (id) do nothing;

-- 3. Storage policy — allow all reads and uploads
create policy "public read" on storage.objects for select using (bucket_id = 'audio-files');
create policy "public upload" on storage.objects for insert with check (bucket_id = 'audio-files');
create policy "public delete" on storage.objects for delete using (bucket_id = 'audio-files');
