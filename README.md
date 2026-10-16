# RELOOP — PWA Marketplace MVP

Prototype marketplace barang bekas berbasis komunitas, berbahasa Indonesia. Dibangun dengan React + Vite, dapat dipasang sebagai PWA.

## Yang sudah bekerja
- Beranda responsif, pencarian, filter kategori dan Graduation Mode
- Detail barang, wishlist, form unggah barang dengan foto lokal, catatan minat transaksi
- Dashboard profil, manifest dan service worker PWA
- Mode demo tanpa konfigurasi: data tersimpan di `localStorage` browser (tidak tersinkron antar perangkat)
- Integrasi Supabase **parsial/opsional**: autentikasi email, baca dan buat listing teks menggunakan `supabase/schema.sql`

## Belum diimplementasikan (jangan diklaim saat demo)
AI Smart Listing sungguhan, Smart Matching berbasis algoritma, upload foto cloud, chat penjual, escrow/pembayaran, pengiriman, notifikasi, analytics dampak terverifikasi, sinkronisasi wishlist/minat ke Supabase. Dalam mode Supabase, foto baru hanya tampil lokal sementara; belum tersimpan ke cloud. Ini MVP untuk validasi, bukan marketplace produksi.

## Menjalankan di laptop (pemula)
1. Instal Node.js LTS dari https://nodejs.org/ .
2. Ekstrak ZIP proyek. Buka folder `reloop` di VS Code.
3. Buka menu **Terminal > New Terminal**.
4. Jalankan `npm install`, tunggu selesai.
5. Jalankan `npm run dev`.
6. Buka URL lokal yang ditampilkan (umumnya http://localhost:5173).
7. Coba cari barang, filter Graduation Mode, tekan **Jual barang**, simpan produk, dan buka **Profil**.
8. Untuk menghentikan server tekan Ctrl+C.

## Supabase (opsional, butuh akun)
1. Buat proyek di https://supabase.com/ dan buka **SQL Editor**.
2. Jalankan isi `supabase/schema.sql` pada proyek baru (kebijakan dibuat untuk skema baru; jangan jalankan berulang pada database yang sudah punya policy).
3. Di **Project Settings > API**, salin Project URL dan **anon/publishable key**. JANGAN gunakan `service_role`/secret key di frontend.
4. Duplikat `.env.example` menjadi `.env` dan isi kedua nilai `VITE_...`.
5. Restart `npm run dev`. Login dan listing teks sekarang menggunakan Supabase; fitur demo lain masih lokal. Atur Site URL/redirect di Authentication untuk deployment.
6. Gunakan akun penguji, jangan unggah data pribadi atau melakukan pembayaran nyata.

## Build dan deployment
- Uji: `npm run build` kemudian `npm run preview`.
- Impor repository ke Vercel, framework Vite, build `npm run build`, output `dist`. Jika memakai Supabase, tambahkan dua environment variables yang sama di dashboard Vercel.
- Hubungkan domain `.id` milikmu sesuai ketentuan lomba. Domain dan deployment memerlukan tindakan pemilik akun.
- PWA memerlukan HTTPS (Vercel menyediakan HTTPS); fitur offline hanya cache shell dasar dan bukan offline-first penuh.

## Demo untuk juri
Cari 'meja' > buka detail > simpan > buka profil > tambah barang pindahan > aktifkan Graduation Mode. Sebutkan secara transparan bahwa contoh produk adalah data simulasi dan fitur AI/matching masih roadmap.

## Privasi dan keamanan
Data demo tersimpan pada browser, tidak cocok untuk transaksi nyata. RLS disiapkan pada skema Supabase, namun perlu audit dan pengujian lanjutan sebelum produksi. Hindari memasukkan alamat rumah, nomor telepon, kata sandi, atau informasi sensitif ke deskripsi produk.
