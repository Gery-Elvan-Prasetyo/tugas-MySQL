```sql
USE penjualan_lengkap;
```

## A. SELECT DASAR PER TABEL


```sql
SELECT * FROM kasir;
SELECT * FROM supplier;
SELECT * FROM produk;
SELECT * FROM penjualan;
SELECT * FROM detail_penjualan;
SELECT * FROM pembelian;
SELECT * FROM detail_pembelian;
SELECT * FROM stok;

-- Struktur tabel
SHOW TABLES;
DESCRIBE kasir;
DESCRIBE supplier;
DESCRIBE produk;
DESCRIBE penjualan;
DESCRIBE detail_penjualan;
DESCRIBE pembelian;
DESCRIBE detail_pembelian;
DESCRIBE stok;

-- Kolom tertentu + alias
SELECT kode_produk AS kode, nama_produk AS nama, harga_jual AS harga FROM produk;

-- Nilai unik
SELECT DISTINCT metode_bayar FROM penjualan;
SELECT DISTINCT kota FROM supplier;
SELECT DISTINCT status FROM kasir;

-- Hitung kolom (margin per produk)
SELECT kode_produk, nama_produk, harga_beli, harga_jual,
       harga_jual - harga_beli                                   AS margin_rp,
       ROUND((harga_jual - harga_beli) / harga_beli * 100, 2)    AS margin_persen
FROM produk;
```

## B. FILTER, URUTAN, LIMIT


### B1 — WHERE perbandingan

```sql
SELECT * FROM produk WHERE harga_jual > 10000;
SELECT * FROM produk WHERE harga_jual <= 5000;
SELECT * FROM produk WHERE kode_produk = 'BRG001';
SELECT * FROM produk WHERE stok_awal <> 30;
```

### B2 — AND / OR / NOT

```sql
SELECT * FROM produk WHERE harga_jual > 5000 AND stok_awal < 30;
SELECT * FROM produk WHERE harga_jual > 50000 OR stok_awal > 80;
SELECT * FROM produk WHERE NOT (harga_jual > 5000);
```

### B3 — BETWEEN

```sql
SELECT * FROM produk WHERE harga_jual BETWEEN 5000 AND 15000;
SELECT * FROM penjualan WHERE tanggal BETWEEN '2026-09-01' AND '2026-09-10';
```

### B4 — IN / NOT IN

```sql
SELECT * FROM penjualan WHERE metode_bayar IN ('QRIS', 'Debit');
SELECT * FROM penjualan WHERE metode_bayar NOT IN ('Tunai');
SELECT * FROM penjualan WHERE id_kasir IN (1, 3);
```

### B5 — LIKE (pencarian teks)

```sql
SELECT * FROM produk WHERE nama_produk LIKE 'Indomie%';      -- diawali
SELECT * FROM produk WHERE nama_produk LIKE '%Goreng%';      -- mengandung
SELECT * FROM produk WHERE nama_produk LIKE '%ml';           -- diakhiri
SELECT * FROM produk WHERE nama_produk LIKE '%kg%';
SELECT * FROM produk WHERE nama_produk NOT LIKE '%Indomie%';
SELECT * FROM detail_penjualan WHERE nama_produk LIKE 'Indomie Goreng%';  -- nama lama & baru
```

### B6 — IS NULL / IS NOT NULL

```sql
SELECT * FROM kasir WHERE tanggal_keluar IS NULL;
SELECT * FROM kasir WHERE tanggal_keluar IS NOT NULL;
SELECT * FROM stok  WHERE no_penjualan IS NOT NULL;   -- stok keluar
SELECT * FROM stok  WHERE no_pembelian IS NOT NULL;   -- stok masuk
SELECT * FROM stok  WHERE no_penjualan IS NULL AND no_pembelian IS NULL;  -- stok awal
```

### B7 — Kasir aktif / nonaktif

```sql
SELECT * FROM kasir WHERE status = 'aktif';
SELECT * FROM kasir WHERE status = 'nonaktif';
```

### B8 — ORDER BY

```sql
SELECT * FROM produk ORDER BY harga_jual DESC;
SELECT * FROM produk ORDER BY nama_produk ASC;
SELECT * FROM produk ORDER BY harga_jual DESC, nama_produk ASC;
SELECT * FROM penjualan ORDER BY tanggal DESC, no_penjualan DESC;
```

### B9 — LIMIT / TOP N

```sql
SELECT * FROM produk ORDER BY harga_jual DESC LIMIT 5;     -- 5 termahal
SELECT * FROM produk ORDER BY harga_jual ASC  LIMIT 5;     -- 5 termurah
SELECT * FROM produk ORDER BY harga_jual DESC LIMIT 5 OFFSET 5;  -- halaman 2
```

### B10 — Filter tanggal

```sql
SELECT * FROM penjualan WHERE tanggal = '2026-09-02';
SELECT * FROM penjualan WHERE tanggal >= '2026-09-10';
SELECT * FROM penjualan WHERE tanggal < '2026-09-10';
SELECT * FROM penjualan WHERE MONTH(tanggal) = 9 AND YEAR(tanggal) = 2026;
SELECT *, DAYNAME(tanggal) AS hari FROM penjualan;
SELECT * FROM penjualan WHERE DAYOFWEEK(tanggal) IN (1, 7);  -- Minggu & Sabtu
```

## C. AGREGAT, GROUP BY, HAVING


### C1 — Agregat sederhana

```sql
SELECT COUNT(*) AS jumlah_produk      FROM produk;
SELECT COUNT(*) AS jumlah_nota        FROM penjualan;
SELECT COUNT(*) AS jumlah_pembelian   FROM pembelian;
SELECT COUNT(*) AS jumlah_baris_detail FROM detail_penjualan;
SELECT COUNT(DISTINCT kode_produk) AS produk_pernah_terjual FROM detail_penjualan;
SELECT SUM(jumlah)                    AS total_unit_terjual FROM detail_penjualan;
SELECT SUM(jumlah * harga_satuan)     AS total_omzet       FROM detail_penjualan;
SELECT AVG(harga_jual) AS rata_harga, MIN(harga_jual) AS termurah, MAX(harga_jual) AS termahal FROM produk;
SELECT MIN(tanggal) AS nota_pertama, MAX(tanggal) AS nota_terakhir FROM penjualan;
```

### C2 — GROUP BY

```sql
-- Jumlah nota per metode bayar
SELECT metode_bayar, COUNT(*) AS jumlah_nota
FROM penjualan GROUP BY metode_bayar;

-- Jumlah nota per tanggal
SELECT tanggal, COUNT(*) AS jumlah_nota
FROM penjualan GROUP BY tanggal ORDER BY tanggal;

-- Jumlah nota per kasir (id saja)
SELECT id_kasir, COUNT(*) AS jumlah_nota
FROM penjualan GROUP BY id_kasir;

-- Jumlah produk terjual per kode (pakai nama dari master)
SELECT kode_produk, SUM(jumlah) AS total_terjual
FROM detail_penjualan GROUP BY kode_produk ORDER BY total_terjual DESC;

-- Jumlah pembelian per supplier
SELECT id_supplier, COUNT(*) AS jumlah_pembelian
FROM pembelian GROUP BY id_supplier;
```

### C3 — HAVING

```sql
SELECT kode_produk, SUM(jumlah) AS total_terjual
FROM detail_penjualan
GROUP BY kode_produk
HAVING SUM(jumlah) >= 5
ORDER BY total_terjual DESC;

SELECT no_penjualan, SUM(jumlah * harga_satuan) AS total
FROM detail_penjualan
GROUP BY no_penjualan
HAVING total > 50000;
```

### C4 — GROUP BY lebih dari satu kolom

```sql
SELECT id_kasir, metode_bayar, COUNT(*) AS jumlah_nota
FROM penjualan GROUP BY id_kasir, metode_bayar ORDER BY id_kasir;
```

### C5 — ROLLUP (total keseluruhan)

```sql
SELECT metode_bayar, COUNT(*) AS jumlah_nota
FROM penjualan GROUP BY metode_bayar WITH ROLLUP;
```

## D. JOIN


### D1 — INNER JOIN: nota + nama kasir

```sql
SELECT p.no_penjualan, p.tanggal, k.nama_kasir, p.metode_bayar
FROM penjualan p
JOIN kasir k ON k.id_kasir = p.id_kasir
ORDER BY p.tanggal, p.no_penjualan;
```

### D2 — Pembelian + kasir + supplier

```sql
SELECT b.no_pembelian, b.tanggal, k.nama_kasir, s.nama_supplier, s.kota
FROM pembelian b
JOIN kasir    k ON k.id_kasir    = b.id_kasir
JOIN supplier s ON s.id_supplier = b.id_supplier
ORDER BY b.tanggal;
```

### D3 — Isi nota lengkap (kepala + detail + kasir) dengan subtotal

```sql
SELECT p.no_penjualan, p.tanggal, k.nama_kasir, p.metode_bayar,
       d.kode_produk, d.nama_produk, d.jumlah, d.harga_satuan,
       d.jumlah * d.harga_satuan AS subtotal
FROM penjualan p
JOIN kasir k            ON k.id_kasir      = p.id_kasir
JOIN detail_penjualan d ON d.no_penjualan  = p.no_penjualan
ORDER BY p.no_penjualan, d.id_detail;
```

### D4 — Isi pembelian lengkap

```sql
SELECT b.no_pembelian, b.tanggal, s.nama_supplier, k.nama_kasir,
       d.kode_produk, d.nama_produk, d.jumlah, d.harga_beli,
       d.jumlah * d.harga_beli AS subtotal
FROM pembelian b
JOIN supplier s          ON s.id_supplier  = b.id_supplier
JOIN kasir k             ON k.id_kasir     = b.id_kasir
JOIN detail_pembelian d  ON d.no_pembelian = b.no_pembelian
ORDER BY b.no_pembelian, d.id_detail;
```

### D5 — Detail penjualan + master produk (bandingkan snapshot vs master)

```sql
SELECT d.no_penjualan, d.kode_produk,
       d.nama_produk AS nama_snapshot, pr.nama_produk AS nama_master_sekarang,
       d.harga_satuan AS harga_snapshot, pr.harga_jual AS harga_master_sekarang
FROM detail_penjualan d
JOIN produk pr ON pr.kode_produk = d.kode_produk
ORDER BY d.no_penjualan;
```

### D6 — LEFT JOIN: semua produk, termasuk yang belum pernah terjual

```sql
SELECT pr.kode_produk, pr.nama_produk, COALESCE(SUM(d.jumlah), 0) AS total_terjual
FROM produk pr
LEFT JOIN detail_penjualan d ON d.kode_produk = pr.kode_produk
GROUP BY pr.kode_produk, pr.nama_produk
ORDER BY total_terjual DESC;
```

### D7 — LEFT JOIN + IS NULL: produk yang belum pernah terjual

```sql
SELECT pr.kode_produk, pr.nama_produk
FROM produk pr
LEFT JOIN detail_penjualan d ON d.kode_produk = pr.kode_produk
WHERE d.id_detail IS NULL;
```

### D8 — Produk yang belum pernah dibeli dari supplier

```sql
SELECT pr.kode_produk, pr.nama_produk
FROM produk pr
LEFT JOIN detail_pembelian d ON d.kode_produk = pr.kode_produk
WHERE d.id_detail IS NULL;
```

### D9 — Kasir yang belum pernah membuat nota

```sql
SELECT k.id_kasir, k.nama_kasir
FROM kasir k
LEFT JOIN penjualan p ON p.id_kasir = k.id_kasir
WHERE p.no_penjualan IS NULL;
```

### D10 — Kasir yang belum pernah melakukan pembelian

```sql
SELECT k.id_kasir, k.nama_kasir
FROM kasir k
LEFT JOIN pembelian b ON b.id_kasir = k.id_kasir
WHERE b.no_pembelian IS NULL;
```

### D11 — Supplier + jumlah pembelian (termasuk yang belum pernah)

```sql
SELECT s.nama_supplier, s.kota, COUNT(b.no_pembelian) AS jumlah_pembelian
FROM supplier s
LEFT JOIN pembelian b ON b.id_supplier = s.id_supplier
GROUP BY s.id_supplier, s.nama_supplier, s.kota;
```

### D12 — RIGHT JOIN (kebalikan LEFT JOIN, hasil sama dengan D6)

```sql
SELECT pr.kode_produk, pr.nama_produk, COALESCE(SUM(d.jumlah), 0) AS total_terjual
FROM detail_penjualan d
RIGHT JOIN produk pr ON pr.kode_produk = d.kode_produk
GROUP BY pr.kode_produk, pr.nama_produk;
```

### D13 — FULL OUTER JOIN (MySQL tidak punya, gabung LEFT + RIGHT dengan UNION)

```sql
SELECT pr.kode_produk, d.no_penjualan
FROM produk pr LEFT JOIN detail_penjualan d ON d.kode_produk = pr.kode_produk
UNION
SELECT pr.kode_produk, d.no_penjualan
FROM produk pr RIGHT JOIN detail_penjualan d ON d.kode_produk = pr.kode_produk;
```

### D14 — SELF JOIN: pasangan nota di hari yang sama oleh kasir berbeda

```sql
SELECT a.no_penjualan AS nota_a, b.no_penjualan AS nota_b, a.tanggal
FROM penjualan a
JOIN penjualan b ON a.tanggal = b.tanggal AND a.no_penjualan < b.no_penjualan
                AND a.id_kasir <> b.id_kasir;
```

### D15 — CROSS JOIN: semua kombinasi kasir x metode bayar

```sql
SELECT k.nama_kasir, m.metode_bayar
FROM kasir k
CROSS JOIN (SELECT DISTINCT metode_bayar FROM penjualan) m
ORDER BY k.nama_kasir, m.metode_bayar;
```

### D16 — Stok + produk + nota/pembelian penyebabnya

```sql
SELECT s.tanggal, s.kode_produk, pr.nama_produk,
       s.jumlah_masuk, s.jumlah_keluar, s.saldo_awal, s.saldo_akhir,
       s.no_penjualan, s.no_pembelian, s.keterangan
FROM stok s
JOIN produk pr ON pr.kode_produk = s.kode_produk
ORDER BY s.kode_produk, s.id_stok;
```

## E. SUBQUERY, EXISTS, CTE


### E1 — Produk lebih mahal dari rata-rata

```sql
SELECT * FROM produk
WHERE harga_jual > (SELECT AVG(harga_jual) FROM produk);
```

### E2 — Produk termahal

```sql
SELECT * FROM produk
WHERE harga_jual = (SELECT MAX(harga_jual) FROM produk);
```

### E3 — Nota dengan total di atas rata-rata total nota

```sql
SELECT no_penjualan, SUM(jumlah * harga_satuan) AS total
FROM detail_penjualan
GROUP BY no_penjualan
HAVING total > (
  SELECT AVG(t) FROM (
    SELECT SUM(jumlah * harga_satuan) AS t
    FROM detail_penjualan GROUP BY no_penjualan
  ) x
);
```

### E4 — IN: produk yang pernah terjual

```sql
SELECT * FROM produk
WHERE kode_produk IN (SELECT DISTINCT kode_produk FROM detail_penjualan);
```

### E5 — NOT IN: produk yang belum pernah terjual

```sql
SELECT * FROM produk
WHERE kode_produk NOT IN (SELECT DISTINCT kode_produk FROM detail_penjualan);
```

### E6 — EXISTS: kasir yang pernah membuat nota QRIS

```sql
SELECT * FROM kasir k
WHERE EXISTS (SELECT 1 FROM penjualan p
              WHERE p.id_kasir = k.id_kasir AND p.metode_bayar = 'QRIS');
```

### E7 — NOT EXISTS: kasir yang tidak pernah pakai QRIS

```sql
SELECT * FROM kasir k
WHERE NOT EXISTS (SELECT 1 FROM penjualan p
                  WHERE p.id_kasir = k.id_kasir AND p.metode_bayar = 'QRIS');
```

### E8 — Subquery di SELECT: total terjual tiap produk

```sql
SELECT pr.kode_produk, pr.nama_produk,
       (SELECT COALESCE(SUM(d.jumlah), 0)
        FROM detail_penjualan d WHERE d.kode_produk = pr.kode_produk) AS total_terjual
FROM produk pr;
```

### E9 — Nota yang berisi BRG001

```sql
SELECT * FROM penjualan
WHERE no_penjualan IN (SELECT no_penjualan FROM detail_penjualan WHERE kode_produk = 'BRG001');
```

### E10 — Nota yang berisi BRG001 DAN BRG003 sekaligus

```sql
SELECT no_penjualan FROM detail_penjualan
WHERE kode_produk IN ('BRG001', 'BRG003')
GROUP BY no_penjualan
HAVING COUNT(DISTINCT kode_produk) = 2;
```

### E11 — CTE: total per nota lalu dipakai ulang

```sql
WITH total_nota AS (
  SELECT no_penjualan, SUM(jumlah * harga_satuan) AS total
  FROM detail_penjualan GROUP BY no_penjualan
)
SELECT p.no_penjualan, p.tanggal, k.nama_kasir, t.total
FROM total_nota t
JOIN penjualan p ON p.no_penjualan = t.no_penjualan
JOIN kasir k     ON k.id_kasir     = p.id_kasir
ORDER BY t.total DESC;
```

### E12 — UNION: gabung semua transaksi (jual + beli) dalam satu daftar

```sql
SELECT tanggal, no_penjualan AS no_transaksi, 'Penjualan' AS jenis FROM penjualan
UNION ALL
SELECT tanggal, no_pembelian, 'Pembelian' FROM pembelian
ORDER BY tanggal, no_transaksi;
```

## F. LAPORAN PENJUALAN


### F1 — Total tiap nota (Total dihitung dari detail)

```sql
SELECT p.no_penjualan, p.tanggal, k.nama_kasir, p.metode_bayar,
       COUNT(d.id_detail)           AS jenis_barang,
       SUM(d.jumlah)                AS total_unit,
       SUM(d.jumlah * d.harga_satuan) AS total_nota
FROM penjualan p
JOIN kasir k            ON k.id_kasir     = p.id_kasir
JOIN detail_penjualan d ON d.no_penjualan = p.no_penjualan
GROUP BY p.no_penjualan, p.tanggal, k.nama_kasir, p.metode_bayar
ORDER BY p.no_penjualan;
```

### F2 — Omzet harian

```sql
SELECT p.tanggal, COUNT(DISTINCT p.no_penjualan) AS jumlah_nota,
       SUM(d.jumlah * d.harga_satuan) AS omzet
FROM penjualan p
JOIN detail_penjualan d ON d.no_penjualan = p.no_penjualan
GROUP BY p.tanggal ORDER BY p.tanggal;
```

### F3 — Omzet per kasir

```sql
SELECT k.nama_kasir, k.status,
       COUNT(DISTINCT p.no_penjualan) AS jumlah_nota,
       SUM(d.jumlah * d.harga_satuan) AS omzet
FROM kasir k
JOIN penjualan p        ON p.id_kasir     = k.id_kasir
JOIN detail_penjualan d ON d.no_penjualan = p.no_penjualan
GROUP BY k.id_kasir, k.nama_kasir, k.status
ORDER BY omzet DESC;
```

### F4 — Omzet per metode bayar

```sql
SELECT p.metode_bayar, COUNT(DISTINCT p.no_penjualan) AS jumlah_nota,
       SUM(d.jumlah * d.harga_satuan) AS omzet
FROM penjualan p
JOIN detail_penjualan d ON d.no_penjualan = p.no_penjualan
GROUP BY p.metode_bayar ORDER BY omzet DESC;
```

### F5 — Omzet per produk (pakai kode, nama dari master)

```sql
SELECT pr.kode_produk, pr.nama_produk,
       SUM(d.jumlah) AS unit_terjual,
       SUM(d.jumlah * d.harga_satuan) AS omzet
FROM detail_penjualan d
JOIN produk pr ON pr.kode_produk = d.kode_produk
GROUP BY pr.kode_produk, pr.nama_produk
ORDER BY omzet DESC;
```

### F6 — 5 produk terlaris (unit)

```sql
SELECT pr.kode_produk, pr.nama_produk, SUM(d.jumlah) AS unit_terjual
FROM detail_penjualan d
JOIN produk pr ON pr.kode_produk = d.kode_produk
GROUP BY pr.kode_produk, pr.nama_produk
ORDER BY unit_terjual DESC LIMIT 5;
```

### F7 — 5 produk paling sedikit terjual (yang pernah terjual)

```sql
SELECT pr.kode_produk, pr.nama_produk, SUM(d.jumlah) AS unit_terjual
FROM detail_penjualan d
JOIN produk pr ON pr.kode_produk = d.kode_produk
GROUP BY pr.kode_produk, pr.nama_produk
ORDER BY unit_terjual ASC LIMIT 5;
```

### F8 — Nota terbesar & terkecil

```sql
SELECT no_penjualan, SUM(jumlah * harga_satuan) AS total
FROM detail_penjualan GROUP BY no_penjualan ORDER BY total DESC LIMIT 1;
SELECT no_penjualan, SUM(jumlah * harga_satuan) AS total
FROM detail_penjualan GROUP BY no_penjualan ORDER BY total ASC LIMIT 1;
```

### F9 — Rata-rata nilai per nota

```sql
SELECT ROUND(AVG(total), 2) AS rata_rata_nota
FROM (SELECT SUM(jumlah * harga_satuan) AS total
      FROM detail_penjualan GROUP BY no_penjualan) x;
```

### F10 — Laba kotor per baris (harga snapshot jual - harga beli master)

```sql
SELECT d.no_penjualan, d.nama_produk, d.jumlah,
       d.harga_satuan, pr.harga_beli,
       d.jumlah * (d.harga_satuan - pr.harga_beli) AS laba
FROM detail_penjualan d
JOIN produk pr ON pr.kode_produk = d.kode_produk
ORDER BY d.no_penjualan;
```

### F11 — Laba kotor total & per produk

```sql
SELECT pr.kode_produk, pr.nama_produk,
       SUM(d.jumlah * (d.harga_satuan - pr.harga_beli)) AS laba
FROM detail_penjualan d
JOIN produk pr ON pr.kode_produk = d.kode_produk
GROUP BY pr.kode_produk, pr.nama_produk
ORDER BY laba DESC;

SELECT SUM(d.jumlah * (d.harga_satuan - pr.harga_beli)) AS laba_total
FROM detail_penjualan d
JOIN produk pr ON pr.kode_produk = d.kode_produk;
```

### F12 — Omzet per minggu & per hari dalam seminggu

```sql
SELECT WEEK(p.tanggal, 1) AS minggu_ke, SUM(d.jumlah * d.harga_satuan) AS omzet
FROM penjualan p JOIN detail_penjualan d ON d.no_penjualan = p.no_penjualan
GROUP BY WEEK(p.tanggal, 1) ORDER BY minggu_ke;

SELECT DAYNAME(p.tanggal) AS hari, SUM(d.jumlah * d.harga_satuan) AS omzet
FROM penjualan p JOIN detail_penjualan d ON d.no_penjualan = p.no_penjualan
GROUP BY DAYNAME(p.tanggal), DAYOFWEEK(p.tanggal)
ORDER BY DAYOFWEEK(p.tanggal);
```

### F13 — Omzet per bulan

```sql
SELECT DATE_FORMAT(p.tanggal, '%Y-%m') AS bulan, SUM(d.jumlah * d.harga_satuan) AS omzet
FROM penjualan p JOIN detail_penjualan d ON d.no_penjualan = p.no_penjualan
GROUP BY DATE_FORMAT(p.tanggal, '%Y-%m');
```

### F14 — Satu nota tertentu (struk)

```sql
SELECT d.nama_produk, d.jumlah, d.harga_satuan, d.jumlah * d.harga_satuan AS subtotal
FROM detail_penjualan d WHERE d.no_penjualan = 'PJ-0001';

SELECT SUM(jumlah * harga_satuan) AS total_bayar
FROM detail_penjualan WHERE no_penjualan = 'PJ-0001';
```

### F15 — Penjualan produk tertentu per nota

```sql
SELECT p.tanggal, d.no_penjualan, d.nama_produk, d.jumlah, d.harga_satuan
FROM detail_penjualan d JOIN penjualan p ON p.no_penjualan = d.no_penjualan
WHERE d.kode_produk = 'BRG001' ORDER BY p.tanggal;
```

### F16 — Omzet kumulatif harian (running total)

```sql
SELECT tanggal, omzet,
       SUM(omzet) OVER (ORDER BY tanggal) AS omzet_kumulatif
FROM (
  SELECT p.tanggal, SUM(d.jumlah * d.harga_satuan) AS omzet
  FROM penjualan p JOIN detail_penjualan d ON d.no_penjualan = p.no_penjualan
  GROUP BY p.tanggal
) h;
```

## G. LAPORAN PEMBELIAN


### G1 — Total tiap pembelian

```sql
SELECT b.no_pembelian, b.tanggal, s.nama_supplier, k.nama_kasir,
       COUNT(d.id_detail) AS jenis_barang, SUM(d.jumlah) AS total_unit,
       SUM(d.jumlah * d.harga_beli) AS total_pembelian
FROM pembelian b
JOIN supplier s         ON s.id_supplier  = b.id_supplier
JOIN kasir k            ON k.id_kasir     = b.id_kasir
JOIN detail_pembelian d ON d.no_pembelian = b.no_pembelian
GROUP BY b.no_pembelian, b.tanggal, s.nama_supplier, k.nama_kasir
ORDER BY b.no_pembelian;
```

### G2 — Total belanja per supplier

```sql
SELECT s.nama_supplier, s.kota,
       COUNT(DISTINCT b.no_pembelian) AS jumlah_pembelian,
       SUM(d.jumlah * d.harga_beli)   AS total_belanja
FROM supplier s
JOIN pembelian b        ON b.id_supplier  = s.id_supplier
JOIN detail_pembelian d ON d.no_pembelian = b.no_pembelian
GROUP BY s.id_supplier, s.nama_supplier, s.kota
ORDER BY total_belanja DESC;
```

### G3 — Total unit dibeli per produk

```sql
SELECT pr.kode_produk, pr.nama_produk, SUM(d.jumlah) AS unit_dibeli,
       SUM(d.jumlah * d.harga_beli) AS total_belanja
FROM detail_pembelian d
JOIN produk pr ON pr.kode_produk = d.kode_produk
GROUP BY pr.kode_produk, pr.nama_produk
ORDER BY total_belanja DESC;
```

### G4 — Produk apa saja yang dipasok tiap supplier

```sql
SELECT s.nama_supplier, d.kode_produk, pr.nama_produk, SUM(d.jumlah) AS unit
FROM supplier s
JOIN pembelian b        ON b.id_supplier  = s.id_supplier
JOIN detail_pembelian d ON d.no_pembelian = b.no_pembelian
JOIN produk pr          ON pr.kode_produk = d.kode_produk
GROUP BY s.nama_supplier, d.kode_produk, pr.nama_produk
ORDER BY s.nama_supplier, d.kode_produk;
```

### G5 — Pembelian per kasir

```sql
SELECT k.nama_kasir, COUNT(DISTINCT b.no_pembelian) AS jumlah_pembelian,
       SUM(d.jumlah * d.harga_beli) AS total
FROM kasir k
JOIN pembelian b        ON b.id_kasir     = k.id_kasir
JOIN detail_pembelian d ON d.no_pembelian = b.no_pembelian
GROUP BY k.id_kasir, k.nama_kasir;
```

### G6 — Total belanja keseluruhan

```sql
SELECT SUM(jumlah * harga_beli) AS total_belanja FROM detail_pembelian;
```

### G7 — Perbedaan harga beli snapshot vs master

```sql
SELECT d.no_pembelian, d.kode_produk, d.harga_beli AS beli_snapshot, pr.harga_beli AS beli_master
FROM detail_pembelian d JOIN produk pr ON pr.kode_produk = d.kode_produk
WHERE d.harga_beli <> pr.harga_beli;   -- kosong = tidak ada selisih
```

## H. STOK & KARTU STOK


### H1 — Kartu stok satu produk

```sql
SELECT tanggal, jumlah_masuk, jumlah_keluar, saldo_awal, saldo_akhir,
       no_penjualan, no_pembelian, keterangan
FROM stok WHERE kode_produk = 'BRG001' ORDER BY id_stok;
```

### H2 — Stok akhir tiap produk (saldo_akhir baris terakhir)

```sql
SELECT s.kode_produk, pr.nama_produk, s.saldo_akhir AS stok_akhir
FROM stok s
JOIN produk pr ON pr.kode_produk = s.kode_produk
WHERE s.id_stok = (SELECT MAX(id_stok) FROM stok x WHERE x.kode_produk = s.kode_produk)
ORDER BY s.kode_produk;
```

### H3 — Stok akhir dihitung dari total masuk - keluar

```sql
SELECT s.kode_produk, pr.nama_produk,
       SUM(s.jumlah_masuk)  AS total_masuk,
       SUM(s.jumlah_keluar) AS total_keluar,
       SUM(s.jumlah_masuk) - SUM(s.jumlah_keluar) AS stok_akhir
FROM stok s JOIN produk pr ON pr.kode_produk = s.kode_produk
GROUP BY s.kode_produk, pr.nama_produk ORDER BY s.kode_produk;
```

### H4 — Stok pada tanggal tertentu (mis. posisi 2026-09-10)

```sql
SELECT s.kode_produk, s.saldo_akhir AS stok_per_10_sep
FROM stok s
WHERE s.id_stok = (SELECT MAX(id_stok) FROM stok x
                   WHERE x.kode_produk = s.kode_produk AND x.tanggal <= '2026-09-10')
ORDER BY s.kode_produk;
```

### H5 — Stok menipis (di bawah 30)

```sql
SELECT s.kode_produk, pr.nama_produk, s.saldo_akhir AS stok_akhir
FROM stok s JOIN produk pr ON pr.kode_produk = s.kode_produk
WHERE s.id_stok = (SELECT MAX(id_stok) FROM stok x WHERE x.kode_produk = s.kode_produk)
  AND s.saldo_akhir < 30
ORDER BY s.saldo_akhir;
```

### H6 — Nilai persediaan (stok akhir x harga beli)

```sql
SELECT s.kode_produk, pr.nama_produk, s.saldo_akhir, pr.harga_beli,
       s.saldo_akhir * pr.harga_beli AS nilai_persediaan
FROM stok s JOIN produk pr ON pr.kode_produk = s.kode_produk
WHERE s.id_stok = (SELECT MAX(id_stok) FROM stok x WHERE x.kode_produk = s.kode_produk)
ORDER BY nilai_persediaan DESC;

SELECT SUM(s.saldo_akhir * pr.harga_beli) AS total_nilai_persediaan
FROM stok s JOIN produk pr ON pr.kode_produk = s.kode_produk
WHERE s.id_stok = (SELECT MAX(id_stok) FROM stok x WHERE x.kode_produk = s.kode_produk);
```

### H7 — Mutasi stok per tanggal

```sql
SELECT tanggal, SUM(jumlah_masuk) AS masuk, SUM(jumlah_keluar) AS keluar
FROM stok GROUP BY tanggal ORDER BY tanggal;
```

### H8 — Hanya mutasi masuk / hanya keluar

```sql
SELECT * FROM stok WHERE jumlah_masuk  > 0 AND keterangan <> 'Stok awal';
SELECT * FROM stok WHERE jumlah_keluar > 0;
```

### H9 — Perputaran: unit keluar vs stok awal

```sql
SELECT s.kode_produk, pr.nama_produk,
       SUM(s.jumlah_keluar) AS terjual,
       pr.stok_awal,
       ROUND(SUM(s.jumlah_keluar) / pr.stok_awal * 100, 1) AS persen_dari_stok_awal
FROM stok s JOIN produk pr ON pr.kode_produk = s.kode_produk
GROUP BY s.kode_produk, pr.nama_produk, pr.stok_awal
ORDER BY persen_dari_stok_awal DESC;
```

## I. TUGAS 1-5 (CERITA PERUBAHAN & SOFT DELETE)


### TUGAS 1 — Daftar kasir aktif saja (Budi sudah nonaktif)

```sql
SELECT id_kasir, nama_kasir FROM kasir WHERE status = 'aktif';
```

### TUGAS 2 — Kasir nonaktif beserta tanggal keluar

```sql
SELECT id_kasir, nama_kasir, tanggal_keluar FROM kasir WHERE status = 'nonaktif';
```

### TUGAS 2b — Nota Budi tetap utuh walau sudah nonaktif

```sql
SELECT p.no_penjualan, p.tanggal, k.nama_kasir, k.status
FROM penjualan p JOIN kasir k ON k.id_kasir = p.id_kasir
WHERE k.nama_kasir = 'Budi';
```

### TUGAS 2c — Nota Budi setelah tanggal keluar (harusnya kosong)

```sql
SELECT p.*
FROM penjualan p JOIN kasir k ON k.id_kasir = p.id_kasir
WHERE k.status = 'nonaktif' AND p.tanggal > k.tanggal_keluar;
```

### TUGAS 3 — Snapshot nama & harga BRG001 sebelum/sesudah 10 Sep

```sql
SELECT p.tanggal, d.no_penjualan, d.nama_produk, d.harga_satuan, d.jumlah
FROM detail_penjualan d JOIN penjualan p ON p.no_penjualan = d.no_penjualan
WHERE d.kode_produk = 'BRG001' ORDER BY p.tanggal;
```

### TUGAS 3b — Riwayat harga/nama unik BRG001 (dari snapshot nota)

```sql
SELECT d.nama_produk, d.harga_satuan,
       MIN(p.tanggal) AS mulai_dipakai, MAX(p.tanggal) AS terakhir_dipakai
FROM detail_penjualan d JOIN penjualan p ON p.no_penjualan = d.no_penjualan
WHERE d.kode_produk = 'BRG001'
GROUP BY d.nama_produk, d.harga_satuan ORDER BY mulai_dipakai;
```

### TUGAS 3c — Nota BRG001 sebelum perubahan (nama & harga lama)

```sql
SELECT d.* FROM detail_penjualan d JOIN penjualan p ON p.no_penjualan = d.no_penjualan
WHERE d.kode_produk = 'BRG001' AND p.tanggal < '2026-09-10';
```

### TUGAS 3d — Nota BRG001 sesudah perubahan (nama & harga baru)

```sql
SELECT d.* FROM detail_penjualan d JOIN penjualan p ON p.no_penjualan = d.no_penjualan
WHERE d.kode_produk = 'BRG001' AND p.tanggal >= '2026-09-10';
```

### TUGAS 3e — Omzet BRG001 sebelum vs sesudah perubahan harga

```sql
SELECT CASE WHEN p.tanggal < '2026-09-10' THEN 'Sebelum 10 Sep (3500)'
            ELSE 'Sesudah 10 Sep (4200)' END AS periode,
       SUM(d.jumlah) AS unit, SUM(d.jumlah * d.harga_satuan) AS omzet
FROM detail_penjualan d JOIN penjualan p ON p.no_penjualan = d.no_penjualan
WHERE d.kode_produk = 'BRG001' GROUP BY periode;
```

### TUGAS 3f — Pembelian BRG001 dengan nama lama vs baru

```sql
SELECT b.tanggal, d.no_pembelian, d.nama_produk, d.jumlah, d.harga_beli
FROM detail_pembelian d JOIN pembelian b ON b.no_pembelian = d.no_pembelian
WHERE d.kode_produk = 'BRG001' ORDER BY b.tanggal;
```

### TUGAS 3g — Semua baris dimana snapshot nama beda dengan master

```sql
SELECT 'penjualan' AS sumber, d.no_penjualan AS no_transaksi, d.kode_produk,
       d.nama_produk AS nama_snapshot, pr.nama_produk AS nama_master
FROM detail_penjualan d JOIN produk pr ON pr.kode_produk = d.kode_produk
WHERE d.nama_produk <> pr.nama_produk
UNION ALL
SELECT 'pembelian', d.no_pembelian, d.kode_produk, d.nama_produk, pr.nama_produk
FROM detail_pembelian d JOIN produk pr ON pr.kode_produk = d.kode_produk
WHERE d.nama_produk <> pr.nama_produk;
```

### TUGAS 3h — Semua baris dimana harga snapshot beda dengan master

```sql
SELECT d.no_penjualan, d.kode_produk, d.harga_satuan AS harga_snapshot, pr.harga_jual AS harga_master
FROM detail_penjualan d JOIN produk pr ON pr.kode_produk = d.kode_produk
WHERE d.harga_satuan <> pr.harga_jual;
```

### TUGAS 4 — Total penjualan nota (header + detail) — "Total dihitung dari detail"

```sql
SELECT p.no_penjualan, p.tanggal, k.nama_kasir, p.metode_bayar,
       SUM(d.jumlah * d.harga_satuan) AS total
FROM penjualan p
JOIN kasir k            ON k.id_kasir     = p.id_kasir
JOIN detail_penjualan d ON d.no_penjualan = p.no_penjualan
GROUP BY p.no_penjualan, p.tanggal, k.nama_kasir, p.metode_bayar;
```

### TUGAS 5 — Jejak stok keluar: barang X keluar karena nota apa, siapa kasirnya

```sql
SELECT s.tanggal, s.kode_produk, pr.nama_produk, s.jumlah_keluar,
       s.no_penjualan, k.nama_kasir, p.metode_bayar
FROM stok s
JOIN produk pr   ON pr.kode_produk = s.kode_produk
JOIN penjualan p ON p.no_penjualan = s.no_penjualan
JOIN kasir k     ON k.id_kasir     = p.id_kasir
WHERE s.no_penjualan IS NOT NULL
ORDER BY s.tanggal, s.id_stok;
```

### TUGAS 5b — Jejak stok masuk: barang masuk karena pembelian apa, dari supplier mana

```sql
SELECT s.tanggal, s.kode_produk, pr.nama_produk, s.jumlah_masuk,
       s.no_pembelian, sp.nama_supplier, k.nama_kasir
FROM stok s
JOIN produk pr    ON pr.kode_produk = s.kode_produk
JOIN pembelian b  ON b.no_pembelian = s.no_pembelian
JOIN supplier sp  ON sp.id_supplier = b.id_supplier
JOIN kasir k      ON k.id_kasir     = b.id_kasir
WHERE s.no_pembelian IS NOT NULL
ORDER BY s.tanggal, s.id_stok;
```

### TUGAS 5c — Jejak lengkap satu nota: nota -> detail -> mutasi stok

```sql
SELECT p.no_penjualan, p.tanggal, d.kode_produk, d.nama_produk, d.jumlah,
       s.saldo_awal, s.saldo_akhir
FROM penjualan p
JOIN detail_penjualan d ON d.no_penjualan = p.no_penjualan
JOIN stok s             ON s.no_penjualan = d.no_penjualan AND s.kode_produk = d.kode_produk
WHERE p.no_penjualan = 'PJ-0008';
```

### TUGAS 5d — Jejak lengkap satu pembelian: pembelian -> detail -> mutasi stok

```sql
SELECT b.no_pembelian, b.tanggal, d.kode_produk, d.nama_produk, d.jumlah,
       s.saldo_awal, s.saldo_akhir
FROM pembelian b
JOIN detail_pembelian d ON d.no_pembelian = b.no_pembelian
JOIN stok s             ON s.no_pembelian = d.no_pembelian AND s.kode_produk = d.kode_produk
WHERE b.no_pembelian = 'PB-0004';
```

### TUGAS 5e — Kasir mana saja yang menyebabkan stok BRG001 keluar

```sql
SELECT k.nama_kasir, SUM(s.jumlah_keluar) AS total_keluar
FROM stok s
JOIN penjualan p ON p.no_penjualan = s.no_penjualan
JOIN kasir k     ON k.id_kasir     = p.id_kasir
WHERE s.kode_produk = 'BRG001'
GROUP BY k.nama_kasir;
```

## J. WINDOW FUNCTION (MySQL 8 / MariaDB 10.2+)


### J1 — Ranking produk berdasarkan omzet

```sql
SELECT kode_produk, omzet,
       RANK()       OVER (ORDER BY omzet DESC) AS peringkat,
       DENSE_RANK() OVER (ORDER BY omzet DESC) AS peringkat_rapat
FROM (SELECT kode_produk, SUM(jumlah * harga_satuan) AS omzet
      FROM detail_penjualan GROUP BY kode_produk) t;
```

### J2 — Ranking kasir berdasarkan omzet

```sql
SELECT nama_kasir, omzet, RANK() OVER (ORDER BY omzet DESC) AS peringkat
FROM (
  SELECT k.nama_kasir, SUM(d.jumlah * d.harga_satuan) AS omzet
  FROM kasir k
  JOIN penjualan p        ON p.id_kasir     = k.id_kasir
  JOIN detail_penjualan d ON d.no_penjualan = p.no_penjualan
  GROUP BY k.nama_kasir
) t;
```

### J3 — Produk terlaris per kasir (ranking dalam grup)

```sql
SELECT * FROM (
  SELECT k.nama_kasir, d.kode_produk, SUM(d.jumlah) AS unit,
         ROW_NUMBER() OVER (PARTITION BY k.nama_kasir ORDER BY SUM(d.jumlah) DESC) AS rn
  FROM kasir k
  JOIN penjualan p        ON p.id_kasir     = k.id_kasir
  JOIN detail_penjualan d ON d.no_penjualan = p.no_penjualan
  GROUP BY k.nama_kasir, d.kode_produk
) t WHERE rn = 1;
```

### J4 — Selisih omzet dengan hari sebelumnya (LAG)

```sql
SELECT tanggal, omzet,
       LAG(omzet) OVER (ORDER BY tanggal)          AS omzet_sebelumnya,
       omzet - LAG(omzet) OVER (ORDER BY tanggal)  AS selisih
FROM (
  SELECT p.tanggal, SUM(d.jumlah * d.harga_satuan) AS omzet
  FROM penjualan p JOIN detail_penjualan d ON d.no_penjualan = p.no_penjualan
  GROUP BY p.tanggal
) h;
```

### J5 — Persentase kontribusi tiap produk terhadap total omzet

```sql
SELECT kode_produk, omzet,
       ROUND(omzet / SUM(omzet) OVER () * 100, 2) AS persen_kontribusi
FROM (SELECT kode_produk, SUM(jumlah * harga_satuan) AS omzet
      FROM detail_penjualan GROUP BY kode_produk) t
ORDER BY omzet DESC;
```

### J6 — Saldo berjalan stok dihitung ulang (bandingkan dengan kolom saldo_akhir)

```sql
SELECT kode_produk, tanggal, jumlah_masuk, jumlah_keluar, saldo_akhir,
       SUM(jumlah_masuk - jumlah_keluar) OVER (PARTITION BY kode_produk ORDER BY id_stok) AS saldo_hitung_ulang
FROM stok ORDER BY kode_produk, id_stok;
```

### J7 — Nomor urut nota per kasir

```sql
SELECT id_kasir, no_penjualan, tanggal,
       ROW_NUMBER() OVER (PARTITION BY id_kasir ORDER BY tanggal, no_penjualan) AS nota_ke
FROM penjualan;
```

## K. VALIDASI / CEK KONSISTENSI DATA

(hasil yang diharapkan: KOSONG = data aman)  

### K1 — saldo_akhir harus = saldo_awal + masuk - keluar

```sql
SELECT * FROM stok WHERE saldo_akhir <> saldo_awal + jumlah_masuk - jumlah_keluar;
```

### K2 — saldo_awal harus = saldo_akhir baris sebelumnya

```sql
SELECT s.id_stok, s.kode_produk, s.saldo_awal, prev.saldo_akhir AS saldo_akhir_sebelumnya
FROM stok s
JOIN stok prev ON prev.kode_produk = s.kode_produk
              AND prev.id_stok = (SELECT MAX(id_stok) FROM stok x
                                  WHERE x.kode_produk = s.kode_produk AND x.id_stok < s.id_stok)
WHERE s.saldo_awal <> prev.saldo_akhir;
```

### K3 — Stok awal di kartu stok harus sama dengan produk.stok_awal

```sql
SELECT pr.kode_produk, pr.stok_awal, s.jumlah_masuk AS stok_awal_di_kartu
FROM produk pr JOIN stok s ON s.kode_produk = pr.kode_produk AND s.keterangan = 'Stok awal'
WHERE pr.stok_awal <> s.jumlah_masuk;
```

### K4 — Setiap detail_penjualan harus punya mutasi stok keluar yang cocok

```sql
SELECT d.no_penjualan, d.kode_produk, d.jumlah, s.jumlah_keluar
FROM detail_penjualan d
LEFT JOIN stok s ON s.no_penjualan = d.no_penjualan AND s.kode_produk = d.kode_produk
WHERE s.id_stok IS NULL OR s.jumlah_keluar <> d.jumlah;
```

### K5 — Setiap detail_pembelian harus punya mutasi stok masuk yang cocok

```sql
SELECT d.no_pembelian, d.kode_produk, d.jumlah, s.jumlah_masuk
FROM detail_pembelian d
LEFT JOIN stok s ON s.no_pembelian = d.no_pembelian AND s.kode_produk = d.kode_produk
WHERE s.id_stok IS NULL OR s.jumlah_masuk <> d.jumlah;
```

### K6 — Mutasi stok yang menunjuk nota/pembelian yang tidak ada (orphan)

```sql
SELECT s.* FROM stok s LEFT JOIN penjualan p ON p.no_penjualan = s.no_penjualan
WHERE s.no_penjualan IS NOT NULL AND p.no_penjualan IS NULL;
SELECT s.* FROM stok s LEFT JOIN pembelian b ON b.no_pembelian = s.no_pembelian
WHERE s.no_pembelian IS NOT NULL AND b.no_pembelian IS NULL;
```

### K7 — Detail yang kode_produk-nya tidak ada di master (orphan)

```sql
SELECT d.* FROM detail_penjualan d LEFT JOIN produk pr ON pr.kode_produk = d.kode_produk
WHERE pr.kode_produk IS NULL;
SELECT d.* FROM detail_pembelian d LEFT JOIN produk pr ON pr.kode_produk = d.kode_produk
WHERE pr.kode_produk IS NULL;
```

### K8 — Detail yang no_penjualan / no_pembelian-nya tidak ada di header

```sql
SELECT d.* FROM detail_penjualan d LEFT JOIN penjualan p ON p.no_penjualan = d.no_penjualan
WHERE p.no_penjualan IS NULL;
SELECT d.* FROM detail_pembelian d LEFT JOIN pembelian b ON b.no_pembelian = d.no_pembelian
WHERE b.no_pembelian IS NULL;
```

### K9 — Nota/pembelian yang menunjuk kasir atau supplier yang tidak ada

```sql
SELECT p.* FROM penjualan p LEFT JOIN kasir k ON k.id_kasir = p.id_kasir WHERE k.id_kasir IS NULL;
SELECT b.* FROM pembelian b LEFT JOIN kasir k ON k.id_kasir = b.id_kasir WHERE k.id_kasir IS NULL;
SELECT b.* FROM pembelian b LEFT JOIN supplier s ON s.id_supplier = b.id_supplier WHERE s.id_supplier IS NULL;
```

### K10 — Nota tanpa detail (kosong) & header tanpa isi

```sql
SELECT p.* FROM penjualan p LEFT JOIN detail_penjualan d ON d.no_penjualan = p.no_penjualan
WHERE d.id_detail IS NULL;
SELECT b.* FROM pembelian b LEFT JOIN detail_pembelian d ON d.no_pembelian = b.no_pembelian
WHERE d.id_detail IS NULL;
```

### K11 — Stok minus

```sql
SELECT * FROM stok WHERE saldo_akhir < 0;
```

### K12 — Penjualan melebihi stok (saldo_awal < jumlah_keluar)

```sql
SELECT * FROM stok WHERE jumlah_keluar > saldo_awal;
```

### K13 — Kasir nonaktif yang masih bertransaksi setelah tanggal keluar

```sql
SELECT 'penjualan' AS jenis, p.no_penjualan AS no, p.tanggal, k.nama_kasir
FROM penjualan p JOIN kasir k ON k.id_kasir = p.id_kasir
WHERE k.status = 'nonaktif' AND p.tanggal > k.tanggal_keluar
UNION ALL
SELECT 'pembelian', b.no_pembelian, b.tanggal, k.nama_kasir
FROM pembelian b JOIN kasir k ON k.id_kasir = b.id_kasir
WHERE k.status = 'nonaktif' AND b.tanggal > k.tanggal_keluar;
```

### K14 — Harga jual di bawah harga beli (rugi)

```sql
SELECT * FROM produk WHERE harga_jual < harga_beli;
SELECT * FROM detail_penjualan d JOIN produk pr ON pr.kode_produk = d.kode_produk
WHERE d.harga_satuan < pr.harga_beli;
```

### K15 — Nota ganda (duplikat per baris produk dalam satu nota)

```sql
SELECT no_penjualan, kode_produk, COUNT(*) AS jml
FROM detail_penjualan GROUP BY no_penjualan, kode_produk HAVING COUNT(*) > 1;
```

### K16 — Ringkasan jumlah baris semua tabel

```sql
SELECT 'kasir' AS tabel, COUNT(*) AS baris FROM kasir
UNION ALL SELECT 'supplier',         COUNT(*) FROM supplier
UNION ALL SELECT 'produk',           COUNT(*) FROM produk
UNION ALL SELECT 'penjualan',        COUNT(*) FROM penjualan
UNION ALL SELECT 'detail_penjualan', COUNT(*) FROM detail_penjualan
UNION ALL SELECT 'pembelian',        COUNT(*) FROM pembelian
UNION ALL SELECT 'detail_pembelian', COUNT(*) FROM detail_pembelian
UNION ALL SELECT 'stok',             COUNT(*) FROM stok;
```

## L. VIEW (laporan siap pakai)


```sql
CREATE OR REPLACE VIEW v_total_nota AS
SELECT p.no_penjualan, p.tanggal, k.nama_kasir, p.metode_bayar,
       SUM(d.jumlah * d.harga_satuan) AS total
FROM penjualan p
JOIN kasir k            ON k.id_kasir     = p.id_kasir
JOIN detail_penjualan d ON d.no_penjualan = p.no_penjualan
GROUP BY p.no_penjualan, p.tanggal, k.nama_kasir, p.metode_bayar;

CREATE OR REPLACE VIEW v_stok_akhir AS
SELECT s.kode_produk, pr.nama_produk, s.saldo_akhir AS stok_akhir
FROM stok s
JOIN produk pr ON pr.kode_produk = s.kode_produk
WHERE s.id_stok = (SELECT MAX(id_stok) FROM stok x WHERE x.kode_produk = s.kode_produk);

CREATE OR REPLACE VIEW v_kasir_aktif AS
SELECT id_kasir, nama_kasir FROM kasir WHERE status = 'aktif';

CREATE OR REPLACE VIEW v_jejak_stok AS
SELECT s.id_stok, s.tanggal, s.kode_produk, pr.nama_produk,
       s.jumlah_masuk, s.jumlah_keluar, s.saldo_awal, s.saldo_akhir,
       s.keterangan, s.no_penjualan, s.no_pembelian
FROM stok s JOIN produk pr ON pr.kode_produk = s.kode_produk;

-- Pemakaian view
SELECT * FROM v_total_nota ORDER BY tanggal;
SELECT * FROM v_stok_akhir ORDER BY kode_produk;
SELECT * FROM v_kasir_aktif;
SELECT * FROM v_jejak_stok WHERE kode_produk = 'BRG001' ORDER BY id_stok;
SELECT tanggal, SUM(total) AS omzet FROM v_total_nota GROUP BY tanggal;

-- DROP VIEW v_total_nota, v_stok_akhir, v_kasir_aktif, v_jejak_stok;   -- hapus view
```

## M. DML: INSERT, UPDATE, DELETE

Semua dibungkus transaksi + ROLLBACK, jadi data asli TIDAK berubah.  
Ganti ROLLBACK jadi COMMIT kalau memang mau disimpan.  

```sql
START TRANSACTION;

-- M1. Tambah master
INSERT INTO kasir (nama_kasir) VALUES ('Eka');
INSERT INTO supplier (nama_supplier, kota) VALUES ('UD Maju Bersama', 'Bandung');
INSERT INTO produk (kode_produk, nama_produk, harga_beli, harga_jual, stok_awal)
VALUES ('BRG021', 'Susu Bendera 200ml', 3000, 4000, 0);

-- M2. Transaksi penjualan baru (nota + detail + kartu stok) utuh
INSERT INTO penjualan (no_penjualan, tanggal, id_kasir, metode_bayar)
VALUES ('PJ-0015', '2026-09-22', 1, 'Tunai');

INSERT INTO detail_penjualan (no_penjualan, kode_produk, nama_produk, jumlah, harga_satuan)
SELECT 'PJ-0015', kode_produk, nama_produk, 2, harga_jual
FROM produk WHERE kode_produk = 'BRG002';       -- snapshot diambil dari master

INSERT INTO stok (kode_produk, tanggal, jumlah_masuk, jumlah_keluar,
                  saldo_awal, saldo_akhir, no_penjualan, keterangan)
SELECT 'BRG002', '2026-09-22', 0, 2, saldo_akhir, saldo_akhir - 2, 'PJ-0015', 'Terjual (PJ-0015)'
FROM stok WHERE kode_produk = 'BRG002' ORDER BY id_stok DESC LIMIT 1;

-- M3. Transaksi pembelian baru
INSERT INTO pembelian (no_pembelian, tanggal, id_kasir, id_supplier)
VALUES ('PB-0005', '2026-09-22', 1, 1);

INSERT INTO detail_pembelian (no_pembelian, kode_produk, nama_produk, jumlah, harga_beli)
SELECT 'PB-0005', kode_produk, nama_produk, 10, harga_beli
FROM produk WHERE kode_produk = 'BRG010';

INSERT INTO stok (kode_produk, tanggal, jumlah_masuk, jumlah_keluar,
                  saldo_awal, saldo_akhir, no_pembelian, keterangan)
SELECT 'BRG010', '2026-09-22', 10, 0, saldo_akhir, saldo_akhir + 10, 'PB-0005', 'Beli dari supplier'
FROM stok WHERE kode_produk = 'BRG010' ORDER BY id_stok DESC LIMIT 1;

-- M4. UPDATE harga / nama produk (master berubah, snapshot lama tidak ikut berubah)
UPDATE produk SET harga_jual = 3800 WHERE kode_produk = 'BRG002';
UPDATE produk SET nama_produk = 'Aqua Botol 600ml Baru', harga_jual = 3700 WHERE kode_produk = 'BRG004';
UPDATE produk SET harga_jual = harga_jual * 1.05 WHERE harga_jual < 5000;   -- naik 5%

-- M5. Cek dampaknya: master berubah tapi nota lama tetap
SELECT pr.nama_produk AS nama_master, pr.harga_jual AS harga_master,
       d.nama_produk AS nama_snapshot, d.harga_satuan AS harga_snapshot
FROM produk pr JOIN detail_penjualan d ON d.kode_produk = pr.kode_produk
WHERE pr.kode_produk IN ('BRG002', 'BRG004') LIMIT 5;

-- M6. SOFT DELETE kasir (jangan DELETE baris)
UPDATE kasir SET status = 'nonaktif', tanggal_keluar = '2026-09-30' WHERE nama_kasir = 'Dewi';
-- Mengaktifkan kembali
UPDATE kasir SET status = 'aktif', tanggal_keluar = NULL WHERE nama_kasir = 'Dewi';

-- M7. DELETE hanya untuk data yang baru dibuat / salah input
DELETE FROM stok             WHERE no_penjualan = 'PJ-0015';
DELETE FROM detail_penjualan WHERE no_penjualan = 'PJ-0015';
DELETE FROM penjualan        WHERE no_penjualan = 'PJ-0015';
DELETE FROM produk           WHERE kode_produk  = 'BRG021';

-- M8. Hapus lewat JOIN (contoh: detail milik nota tertentu)
DELETE d FROM detail_pembelian d
JOIN pembelian b ON b.no_pembelian = d.no_pembelian
WHERE b.no_pembelian = 'PB-0005';

-- M9. Catatan: DELETE kasir yang sudah punya nota BERBAHAYA (nota jadi yatim),
--     makanya pakai soft delete (M6). Contoh yang JANGAN dijalankan:
-- DELETE FROM kasir WHERE nama_kasir = 'Budi';

-- M10. Kosongkan tabel (hati-hati! TRUNCATE tidak bisa di-ROLLBACK di MySQL)
-- TRUNCATE TABLE stok;

ROLLBACK;   -- batalkan semua perubahan di atas (data asli aman)

-- Cek: data kembali seperti semula
SELECT COUNT(*) AS jumlah_kasir FROM kasir;          -- 4
SELECT COUNT(*) AS jumlah_produk FROM produk;        -- 20
SELECT COUNT(*) AS jumlah_nota FROM penjualan;       -- 14

-- SELESAI
```
