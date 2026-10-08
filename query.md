# Query Toko Maju Jaya
```sql
USE penjualan_lengkap;
```

---

## 1. Kasus & Tugas Utama (Study Case Toko)

### 1.1 Tugas 1 — Kasir Aktif Saja (Penerapan Soft Delete)
Menampilkan kasir yang saat ini masih aktif bekerja di toko.

```sql
SELECT id_kasir, nama_kasir, status
FROM kasir
WHERE status = 'aktif';
```

### 1.2 Tugas 2 — Kasir Nonaktif & Bukti Integritas Data
Membuktikan kasir yang sudah nonaktif (Budi) riwayat notanya tidak hilang karena menggunakan *soft delete* (bukan `DELETE`).

```sql
-- Daftar kasir nonaktif beserta tanggal keluarnya
SELECT id_kasir, nama_kasir, tanggal_keluar
FROM kasir
WHERE status = 'nonaktif';

-- Bukti nota lama milik Budi tetap aman dan utuh
SELECT p.no_penjualan, p.tanggal, k.nama_kasir, k.status
FROM penjualan p
JOIN kasir k ON k.id_kasir = p.id_kasir
WHERE k.nama_kasir = 'Budi';
```

### 1.3 Tugas 3 — Snapshot Riwayat Perubahan Nama & Harga Produk (BRG001)
Produk `BRG001` mengalami kenaikan harga dan perubahan nama pada 10 September 2026. Nilai pada nota lama tetap memakai snapshot harga saat transaksi berlangsung.

```sql
-- Riwayat transaksi BRG001 (nama & harga sebelum vs sesudah 10 Sep)
SELECT p.tanggal, d.no_penjualan, d.nama_produk, d.harga_satuan, d.jumlah,
       (d.jumlah * d.harga_satuan) AS subtotal
FROM detail_penjualan d
JOIN penjualan p ON p.no_penjualan = d.no_penjualan
WHERE d.kode_produk = 'BRG001'
ORDER BY p.tanggal;

-- Komparasi omzet BRG001 sebelum vs sesudah kenaikan harga
SELECT 
    CASE 
        WHEN p.tanggal < '2026-09-10' THEN 'Sebelum 10 Sep (@Rp 3.500)'
        ELSE 'Sesudah 10 Sep (@Rp 4.200)'
    END AS periode,
    SUM(d.jumlah) AS total_unit,
    SUM(d.jumlah * d.harga_satuan) AS total_omzet
FROM detail_penjualan d
JOIN penjualan p ON p.no_penjualan = d.no_penjualan
WHERE d.kode_produk = 'BRG001'
GROUP BY periode;
```

### 1.4 Tugas 4 — Total Penjualan Nota (Header + Detail)
Tabel header `penjualan` tidak menyimpan kolom total bayar; total dihitung secara dinamis dari `detail_penjualan`.

```sql
SELECT p.no_penjualan, p.tanggal, k.nama_kasir, p.metode_bayar,
       SUM(d.jumlah * d.harga_satuan) AS total_belanja
FROM penjualan p
JOIN kasir k            ON k.id_kasir     = p.id_kasir
JOIN detail_penjualan d ON d.no_penjualan = p.no_penjualan
GROUP BY p.no_penjualan, p.tanggal, k.nama_kasir, p.metode_bayar
ORDER BY p.tanggal, p.no_penjualan;
```

### 1.5 Tugas 5 — Jejak Audit Mutasi Stok (Traceability)
Menelusuri ke mana barang keluar (terjual lewat nota apa, kasir siapa) dan dari mana barang masuk (kulakan nota apa, dari supplier mana).

```sql
-- Jejak stok keluar: nomor nota & kasir yang bertugas
SELECT s.tanggal, s.kode_produk, pr.nama_produk, s.jumlah_keluar,
       s.no_penjualan, k.nama_kasir, p.metode_bayar
FROM stok s
JOIN produk pr   ON pr.kode_produk = s.kode_produk
JOIN penjualan p ON p.no_penjualan = s.no_penjualan
JOIN kasir k     ON k.id_kasir     = p.id_kasir
WHERE s.no_penjualan IS NOT NULL
ORDER BY s.tanggal, s.id_stok;

-- Jejak stok masuk: nomor pembelian & asal supplier
SELECT s.tanggal, s.kode_produk, pr.nama_produk, s.jumlah_masuk,
       s.no_pembelian, sup.nama_supplier
FROM stok s
JOIN produk pr    ON pr.kode_produk = s.kode_produk
JOIN pembelian b  ON b.no_pembelian = s.no_pembelian
JOIN supplier sup ON sup.id_supplier = b.id_supplier
WHERE s.no_pembelian IS NOT NULL
ORDER BY s.tanggal, s.id_stok;
```

---

## 2. Laporan Penjualan & Analisis Bisnis

### 2.1 Omzet Harian
```sql
SELECT p.tanggal, 
       COUNT(DISTINCT p.no_penjualan) AS jumlah_nota,
       SUM(d.jumlah * d.harga_satuan) AS omzet_harian
FROM penjualan p
JOIN detail_penjualan d ON d.no_penjualan = p.no_penjualan
GROUP BY p.tanggal
ORDER BY p.tanggal;
```

### 2.2 Performa Omzet per Kasir
```sql
SELECT k.nama_kasir, k.status,
       COUNT(DISTINCT p.no_penjualan) AS jumlah_nota,
       SUM(d.jumlah * d.harga_satuan) AS total_omzet
FROM kasir k
JOIN penjualan p        ON p.id_kasir     = k.id_kasir
JOIN detail_penjualan d ON d.no_penjualan = p.no_penjualan
GROUP BY k.id_kasir, k.nama_kasir, k.status
ORDER BY total_omzet DESC;
```

### 2.3 Omzet Berdasarkan Metode Pembayaran
```sql
SELECT p.metode_bayar,
       COUNT(DISTINCT p.no_penjualan) AS jumlah_transaksi,
       SUM(d.jumlah * d.harga_satuan) AS total_omzet
FROM penjualan p
JOIN detail_penjualan d ON d.no_penjualan = p.no_penjualan
GROUP BY p.metode_bayar
ORDER BY total_omzet DESC;
```

### 2.4 Top 5 Produk Terlaris
```sql
SELECT pr.kode_produk, pr.nama_produk,
       SUM(d.jumlah) AS total_terjual,
       SUM(d.jumlah * d.harga_satuan) AS total_omzet
FROM detail_penjualan d
JOIN produk pr ON pr.kode_produk = d.kode_produk
GROUP BY pr.kode_produk, pr.nama_produk
ORDER BY total_terjual DESC
LIMIT 5;
```

### 2.5 Laba / Margin Kotor per Produk
```sql
SELECT pr.kode_produk, pr.nama_produk,
       SUM(d.jumlah) AS unit_terjual,
       SUM(d.jumlah * (d.harga_satuan - pr.harga_beli)) AS estimasi_laba_kotor
FROM detail_penjualan d
JOIN produk pr ON pr.kode_produk = d.kode_produk
GROUP BY pr.kode_produk, pr.nama_produk
ORDER BY estimasi_laba_kotor DESC;
```

### 2.6 Total Omzet & Total Laba Kotor Toko
```sql
SELECT 
    SUM(d.jumlah * d.harga_satuan) AS grand_total_omzet,
    SUM(d.jumlah * (d.harga_satuan - pr.harga_beli)) AS grand_total_laba_kotor
FROM detail_penjualan d
JOIN produk pr ON pr.kode_produk = d.kode_produk;
```

---

## 3. Laporan Pembelian & Supplier (Kulakan)

### 3.1 Rekap Pembelian per Nota
```sql
SELECT b.no_pembelian, b.tanggal, s.nama_supplier, k.nama_kasir,
       COUNT(d.id_detail) AS variasi_barang,
       SUM(d.jumlah) AS total_unit,
       SUM(d.jumlah * d.harga_beli) AS total_biaya
FROM pembelian b
JOIN supplier s         ON s.id_supplier  = b.id_supplier
JOIN kasir k            ON k.id_kasir     = b.id_kasir
JOIN detail_pembelian d ON d.no_pembelian = b.no_pembelian
GROUP BY b.no_pembelian, b.tanggal, s.nama_supplier, k.nama_kasir
ORDER BY b.tanggal;
```

### 3.2 Total Belanja per Supplier
```sql
SELECT s.nama_supplier, s.kota,
       COUNT(DISTINCT b.no_pembelian) AS frekuensi_pembelian,
       SUM(d.jumlah * d.harga_beli)   AS total_belanja
FROM supplier s
JOIN pembelian b        ON b.id_supplier  = s.id_supplier
JOIN detail_pembelian d ON d.no_pembelian = b.no_pembelian
GROUP BY s.id_supplier, s.nama_supplier, s.kota
ORDER BY total_belanja DESC;
```

---

## 4. Manajemen Persediaan & Kartu Stok

### 4.1 Stok Akhir Terkini Tiap Produk
```sql
SELECT s.kode_produk, pr.nama_produk, s.saldo_akhir AS stok_akhir
FROM stok s
JOIN produk pr ON pr.kode_produk = s.kode_produk
WHERE s.id_stok = (
    SELECT MAX(x.id_stok) 
    FROM stok x 
    WHERE x.kode_produk = s.kode_produk
)
ORDER BY s.kode_produk;
```

### 4.2 Kartu Stok Lengkap Satu Produk (Contoh: `BRG001`)
```sql
SELECT tanggal, keterangan, 
       saldo_awal, jumlah_masuk, jumlah_keluar, saldo_akhir,
       no_penjualan, no_pembelian
FROM stok
WHERE kode_produk = 'BRG001'
ORDER BY id_stok;
```

### 4.3 Peringatan Stok Menipis (< 30 Unit)
```sql
SELECT s.kode_produk, pr.nama_produk, s.saldo_akhir AS stok_tersisa
FROM stok s
JOIN produk pr ON pr.kode_produk = s.kode_produk
WHERE s.id_stok = (
    SELECT MAX(x.id_stok) 
    FROM stok x 
    WHERE x.kode_produk = s.kode_produk
)
AND s.saldo_akhir < 30
ORDER BY s.saldo_akhir ASC;
```

### 4.4 Valuasi Total Nilai Aset Persediaan Barang
```sql
SELECT 
    SUM(s.saldo_akhir * pr.harga_beli) AS total_nilai_aset_persediaan
FROM stok s
JOIN produk pr ON pr.kode_produk = s.kode_produk
WHERE s.id_stok = (
    SELECT MAX(x.id_stok) 
    FROM stok x 
    WHERE x.kode_produk = s.kode_produk
);
```

---

## 5. View Laporan Siap Pakai

### 5.1 Definisi VIEW
```sql
-- View untuk total per nota
CREATE OR REPLACE VIEW v_total_nota AS
SELECT p.no_penjualan, p.tanggal, k.nama_kasir, p.metode_bayar,
       SUM(d.jumlah * d.harga_satuan) AS total
FROM penjualan p
JOIN kasir k            ON k.id_kasir     = p.id_kasir
JOIN detail_penjualan d ON d.no_penjualan = p.no_penjualan
GROUP BY p.no_penjualan, p.tanggal, k.nama_kasir, p.metode_bayar;

-- View untuk stok akhir tiap produk
CREATE OR REPLACE VIEW v_stok_akhir AS
SELECT s.kode_produk, pr.nama_produk, s.saldo_akhir AS stok_akhir
FROM stok s
JOIN produk pr ON pr.kode_produk = s.kode_produk
WHERE s.id_stok = (
    SELECT MAX(x.id_stok) 
    FROM stok x 
    WHERE x.kode_produk = s.kode_produk
);
```

### 5.2 Cara Pemakaian VIEW
```sql
-- Memanggil laporan total nota secara sederhana
SELECT * FROM v_total_nota ORDER BY tanggal;

-- Memanggil laporan stok akhir
SELECT * FROM v_stok_akhir ORDER BY kode_produk;
```
