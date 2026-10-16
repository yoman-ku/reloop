-- Run in Supabase SQL Editor. Enable Email auth in Authentication settings.
create extension if not exists pgcrypto;
create table if not exists public.profiles (
 id uuid primary key references auth.users(id) on delete cascade,
 display_name text not null default 'Anggota RELOOP',
 created_at timestamptz not null default now()
);
create table if not exists public.listings (
 id uuid primary key default gen_random_uuid(),
 user_id uuid not null references auth.users(id) on delete cascade,
 title text not null check (char_length(title) between 3 and 90),
 description text not null default '',
 price numeric(12,0) not null check(price>=0),
 category text not null check(category in ('Furniture','Elektronik','Buku','Fashion','Lainnya')),
 condition text not null check(condition in ('Sangat baik','Baik','Cukup')),
 location text not null,
 graduate boolean not null default false,
 emoji text not null default '📦',
 status text not null default 'active' check(status in ('active','reserved','sold')),
 created_at timestamptz not null default now()
);
create index if not exists listings_active_idx on public.listings(status,created_at desc);
create table if not exists public.favorites (
 user_id uuid not null references auth.users(id) on delete cascade,
 listing_id uuid not null references public.listings(id) on delete cascade,
 created_at timestamptz not null default now(),
 primary key(user_id,listing_id)
);
create table if not exists public.interests (
 id uuid primary key default gen_random_uuid(),
 buyer_id uuid not null references auth.users(id) on delete cascade,
 listing_id uuid not null references public.listings(id) on delete cascade,
 status text not null default 'interested' check(status in ('interested','cancelled','completed')),
 created_at timestamptz not null default now(),
 unique(buyer_id,listing_id)
);
alter table public.profiles enable row level security;
alter table public.listings enable row level security;
alter table public.favorites enable row level security;
alter table public.interests enable row level security;
create policy "Profiles readable" on public.profiles for select using(true);
create policy "Owner inserts profile" on public.profiles for insert to authenticated with check(auth.uid()=id);
create policy "Owner updates profile" on public.profiles for update to authenticated using(auth.uid()=id) with check(auth.uid()=id);
create policy "Active listings readable or owner" on public.listings for select using(status='active' or auth.uid()=user_id);
create policy "Owner creates listing" on public.listings for insert to authenticated with check(auth.uid()=user_id);
create policy "Owner updates listing" on public.listings for update to authenticated using(auth.uid()=user_id) with check(auth.uid()=user_id);
create policy "Owner deletes listing" on public.listings for delete to authenticated using(auth.uid()=user_id);
create policy "Own favorites readable" on public.favorites for select to authenticated using(auth.uid()=user_id);
create policy "Own favorites insert" on public.favorites for insert to authenticated with check(auth.uid()=user_id);
create policy "Own favorites delete" on public.favorites for delete to authenticated using(auth.uid()=user_id);
create policy "Interests visible to buyer or seller" on public.interests for select to authenticated using(auth.uid()=buyer_id or exists(select 1 from public.listings l where l.id=listing_id and l.user_id=auth.uid()));
create policy "Buyer creates interest" on public.interests for insert to authenticated with check(auth.uid()=buyer_id and exists(select 1 from public.listings l where l.id=listing_id and l.user_id<>auth.uid() and l.status='active'));
create policy "Buyer updates own interest" on public.interests for update to authenticated using(auth.uid()=buyer_id) with check(auth.uid()=buyer_id);
create or replace function public.create_profile() returns trigger language plpgsql security definer set search_path=public as $$ begin insert into public.profiles(id,display_name) values(new.id,coalesce(split_part(new.email,'@',1),'Anggota RELOOP')) on conflict(id) do nothing; return new; end; $$;
drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created after insert on auth.users for each row execute procedure public.create_profile();
