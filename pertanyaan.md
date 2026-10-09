# Bank Soal & Daftar Pertanyaan Query SQL
## Basis Data: `penjualan_lengkap` (Toko Maju Jaya)

Dokumen ini berisi seluruh kemungkinan pertanyaan query SQL yang dapat diajukan terhadap basis data **Toko Maju Jaya (`penjualan_lengkap`)**. Soal disusun secara berjenjang dari tingkat **Dasar (Basic)**, **Menengah (Intermediate)**, hingga **Lanjutan (Advanced & Analytic)**, mencakup studi kasus integritas data (*soft delete*, *snapshot*, *kartu stok audit*), fungsi analitik (*window functions*), dan audit kualitas data.

Setiap butir pertanyaan dilengkapi dengan:
- **Skenario / Pertanyaan Bisnis:** Rumusan instruksi dalam bahasa bisnis yang jelas.
- **Kunci Query SQL:** Solusi query standar MySQL/MariaDB yang siap dijalankan.
- **Tujuan & Output:** Penjelasan kolom dan hasil yang diharapkan.

```sql
USE penjualan_lengkap;
```

---

## Daftar Isi

1. [Bagian 1: Eksplorasi Skema & SELECT Dasar](#bagian-1-eksplorasi-skema--select-dasar)
2. [Bagian 2: Filtering, Kondisi Logika & Pencarian Data](#bagian-2-filtering-kondisi-logika--pencarian-data)
3. [Bagian 3: Pengurutan & Pembatasan Data (Sorting & Pagination)](#bagian-3-pengurutan--pembatasan-data-sorting--pagination)
4. [Bagian 4: Agregasi, Pengelompokan & Filter Grup (GROUP BY & HAVING)](#bagian-4-agregasi-pengelompokan--filter-grup-group-by--having)
5. [Bagian 5: Relasi Tabel (INNER JOIN & Multi-Table JOIN)](#bagian-5-relasi-tabel-inner-join--multi-table-join)
6. [Bagian 6: Relasi Lanjutan (LEFT, RIGHT, FULL OUTER, CROSS & SELF JOIN)](#bagian-6-relasi-lanjutan-left-right-full-outer-cross--self-join)
7. [Bagian 7: Subquery, Operator Keberadaan & CTE (Common Table Expressions)](#bagian-7-subquery-operator-keberadaan--cte-common-table-expressions)
8. [Bagian 8: Studi Kasus Khusus Toko Maju Jaya](#bagian-8-studi-kasus-khusus-toko-maju-jaya)
   - 8.1 Penerapan Soft Delete Kasir & Integritas Transaksi
   - 8.2 Snapshot Harga & Nama Produk (Kasus BRG001)
   - 8.3 Kalkulasi Total Transaksi Dinamis
   - 8.4 Jejak Audit Mutasi Stok (Traceability)
9. [Bagian 9: Analisis Bisnis & Laporan Penjualan](#bagian-9-analisis-bisnis--laporan-penjualan)
10. [Bagian 10: Laporan Pembelian & Supplier (Kulakan)](#bagian-10-laporan-pembelian--supplier-kulakan)
11. [Bagian 11: Manajemen Persediaan & Kartu Stok](#bagian-11-manajemen-persediaan--kartu-stok)
12. [Bagian 12: Fungsi Analitik & Window Functions (MySQL 8+)](#bagian-12-fungsi-analitik--window-functions-mysql-8)
13. [Bagian 13: Audit, Validasi Integritas & Deteksi Anomali Data](#bagian-13-audit-validasi-integritas--deteksi-anomali-data)
14. [Bagian 14: Database Object (VIEW)](#bagian-14-database-object-view)
15. [Bagian 15: Manipulasi Data Lanjutan (DML)](#bagian-15-manipulasi-data-lanjutan-dml)

---

## Bagian 1: Eksplorasi Skema & SELECT Dasar

### Pertanyaan 1.1: Menampilkan Daftar Tabel
**Pertanyaan:** Tampilkan semua tabel yang terdaftar di dalam database `penjualan_lengkap` saat ini.
```sql
SHOW TABLES;
```

### Pertanyaan 1.2: Memeriksa Struktur Tabel Produk
**Pertanyaan:** Bagaimana cara melihat struktur kolom, tipe data, nilai bawaan, dan kunci dari tabel `produk`?
```sql
DESCRIBE produk;
```

### Pertanyaan 1.3: Menampilkan Seluruh Data Master Kasir
**Pertanyaan:** Tampilkan seluruh baris dan kolom yang ada pada tabel master `kasir`.
```sql
SELECT * FROM kasir;
```

### Pertanyaan 1.4: Proyeksi Kolom Tertentu dengan Alias
**Pertanyaan:** Tampilkan daftar produk dengan hanya menampilkan kolom kode produk, nama produk, dan harga jual, kemudian berikan alias kolom masing-masing menjadi `kode`, `nama`, dan `harga`.
```sql
SELECT 
    kode_produk AS kode, 
    nama_produk AS nama, 
    harga_jual AS harga 
FROM produk;
```

### Pertanyaan 1.5: Menampilkan Nilai Unik Metode Pembayaran
**Pertanyaan:** Tampilkan variasi metode pembayaran apa saja yang pernah digunakan pada transaksi penjualan tanpa ada duplikasi nilai.
```sql
SELECT DISTINCT metode_bayar 
FROM penjualan;
```

### Pertanyaan 1.6: Menampilkan Kota Unik Asal Supplier
**Pertanyaan:** Dari kota mana saja supplier Toko Maju Jaya berasal? Tampilkan daftar kota uniknya.
```sql
SELECT DISTINCT kota 
FROM supplier;
```

### Pertanyaan 1.7: Kalkulasi Margin Keuntungan Per Produk
**Pertanyaan:** Tampilkan kode produk, nama produk, harga beli, harga jual, serta hitung selisih nominal margin (harga jual dikurangi harga beli) dan persentase margin labanya dibulatkan 2 digit desimal.
```sql
SELECT 
    kode_produk, 
    nama_produk, 
    harga_beli, 
    harga_jual,
    (harga_jual - harga_beli) AS margin_rp,
    ROUND((harga_jual - harga_beli) / harga_beli * 100, 2) AS margin_persen
FROM produk;
```

---

## Bagian 2: Filtering, Kondisi Logika & Pencarian Data

### Pertanyaan 2.1: Filter Produk Berdasarkan Rentang Harga (> Rp 10.000)
**Pertanyaan:** Tampilkan semua produk yang memiliki harga jual lebih besar dari Rp 10.000.
```sql
SELECT * 
FROM produk 
WHERE harga_jual > 10000;
```

### Pertanyaan 2.2: Filter Produk Murah (<= Rp 5.000)
**Pertanyaan:** Tampilkan produk-produk yang harga jualnya tidak melebihi Rp 5.000.
```sql
SELECT * 
FROM produk 
WHERE harga_jual <= 5000;
```

### Pertanyaan 2.3: Pencarian Spesifik Kode Produk
**Pertanyaan:** Tampilkan informasi produk yang memiliki kode `'BRG001'`.
```sql
SELECT * 
FROM produk 
WHERE kode_produk = 'BRG001';
```

### Pertanyaan 2.4: Operator Logika Kombinasi (AND)
**Pertanyaan:** Tampilkan produk yang harganya di atas Rp 5.000 dan memiliki stok awal kurang dari 30 unit.
```sql
SELECT * 
FROM produk 
WHERE harga_jual > 5000 AND stok_awal < 30;
```

### Pertanyaan 2.5: Operator Logika Kombinasi (OR)
**Pertanyaan:** Tampilkan produk yang harga jualnya di atas Rp 50.000 atau memiliki stok awal lebih dari 80 unit.
```sql
SELECT * 
FROM produk 
WHERE harga_jual > 50000 OR stok_awal > 80;
```

### Pertanyaan 2.6: Filter Rentang Nilai dengan BETWEEN (Harga)
**Pertanyaan:** Tampilkan produk yang harga jualnya berada di antara Rp 5.000 sampai dengan Rp 15.000 (inklusif).
```sql
SELECT * 
FROM produk 
WHERE harga_jual BETWEEN 5000 AND 15000;
```

### Pertanyaan 2.7: Filter Rentang Tanggal Penjualan
**Pertanyaan:** Tampilkan seluruh nota penjualan yang terjadi pada kurun waktu tanggal 1 September 2026 hingga 10 September 2026.
```sql
SELECT * 
FROM penjualan 
WHERE tanggal BETWEEN '2026-09-01' AND '2026-09-10';
```

### Pertanyaan 2.8: Filter Menggunakan Operator IN
**Pertanyaan:** Tampilkan nota penjualan yang pembayarannya menggunakan metode non-tunai yaitu `'QRIS'` atau `'Debit'`.
```sql
SELECT * 
FROM penjualan 
WHERE metode_bayar IN ('QRIS', 'Debit');
```

### Pertanyaan 2.9: Filter Menggunakan Operator NOT IN
**Pertanyaan:** Tampilkan transaksi penjualan yang pembayarannya tidak menggunakan uang tunai.
```sql
SELECT * 
FROM penjualan 
WHERE metode_bayar NOT IN ('Tunai');
```

### Pertanyaan 2.10: Pencarian Pola String Diawali Teks Tertentu (LIKE 'Indomie%')
**Pertanyaan:** Tampilkan semua produk yang namanya diawali dengan merek `'Indomie'`.
```sql
SELECT * 
FROM produk 
WHERE nama_produk LIKE 'Indomie%';
```

### Pertanyaan 2.11: Pencarian Pola String Mengandung Substring (LIKE '%Goreng%')
**Pertanyaan:** Tampilkan semua produk yang mengandung kata `'Goreng'` pada namanya.
```sql
SELECT * 
FROM produk 
WHERE nama_produk LIKE '%Goreng%';
```

### Pertanyaan 2.12: Pencarian Pola String Diakhiri Teks Tertentu (LIKE '%ml')
**Pertanyaan:** Tampilkan semua produk minuman yang satuan volume kemasannya diakhiri dengan `'ml'`.
```sql
SELECT * 
FROM produk 
WHERE nama_produk LIKE '%ml';
```

### Pertanyaan 2.13: Filter Nilai Kosong (IS NULL)
**Pertanyaan:** Tampilkan daftar kasir yang saat ini masih aktif (kolom `tanggal_keluar` bernilai NULL).
```sql
SELECT * 
FROM kasir 
WHERE tanggal_keluar IS NULL;
```

### Pertanyaan 2.14: Filter Nilai Tidak Kosong (IS NOT NULL)
**Pertanyaan:** Tampilkan kasir yang sudah berhenti/keluar dari Toko Maju Jaya (`tanggal_keluar` terisi / tidak NULL).
```sql
SELECT * 
FROM kasir 
WHERE tanggal_keluar IS NOT NULL;
```

### Pertanyaan 2.15: Memisahkan Jenis Mutasi Kartu Stok Berdasarkan Nilai NULL
**Pertanyaan:** 
a) Tampilkan mutasi stok yang merupakan barang keluar (memiliki `no_penjualan`).
b) Tampilkan mutasi stok yang merupakan barang masuk (memiliki `no_pembelian`).
c) Tampilkan baris mutasi stok pembuka/saldo awal (kedua kolom nomor referensi bernilai NULL).
```sql
-- a) Stok keluar
SELECT * FROM stok WHERE no_penjualan IS NOT NULL;

-- b) Stok masuk
SELECT * FROM stok WHERE no_pembelian IS NOT NULL;

-- c) Stok awal
SELECT * FROM stok WHERE no_penjualan IS NULL AND no_pembelian IS NULL;
```

---

## Bagian 3: Pengurutan & Pembatasan Data (Sorting & Pagination)

### Pertanyaan 3.1: Mengurutkan Produk Berdasarkan Harga Tertinggi ke Terendah
**Pertanyaan:** Tampilkan daftar seluruh produk diurutkan dari yang harga jualnya paling mahal ke yang paling murah.
```sql
SELECT kode_produk, nama_produk, harga_jual 
FROM produk 
ORDER BY harga_jual DESC;
```

### Pertanyaan 3.2: Pengurutan Ganda (Berdasarkan Tanggal & Kasir)
**Pertanyaan:** Tampilkan nota penjualan diurutkan kronologis tanggal paling awal ke terbaru, lalu jika tanggalnya sama urutkan berdasarkan `id_kasir` terkecil.
```sql
SELECT * 
FROM penjualan 
ORDER BY tanggal ASC, id_kasir ASC;
```

### Pertanyaan 3.3: Menampilkan 3 Produk Termahal (LIMIT)
**Pertanyaan:** Tampilkan 3 produk dengan harga jual tertinggi di toko.
```sql
SELECT kode_produk, nama_produk, harga_jual 
FROM produk 
ORDER BY harga_jual DESC 
LIMIT 3;
```

### Pertanyaan 3.4: Paginasi Data dengan LIMIT dan OFFSET
**Pertanyaan:** Tampilkan 5 baris data produk urutan halaman kedua (produk ke-6 hingga ke-10) diurutkan berdasarkan `kode_produk`.
```sql
SELECT kode_produk, nama_produk, harga_jual 
FROM produk 
ORDER BY kode_produk ASC 
LIMIT 5 OFFSET 5;
```

---

## Bagian 4: Agregasi, Pengelompokan & Filter Grup (GROUP BY & HAVING)

### Pertanyaan 4.1: Menghitung Statistik Ringkasan Master Produk
**Pertanyaan:** Hitung total ragam produk yang dimiliki toko, harga jual termurah, harga jual termahal, serta rata-rata harga jual seluruh produk.
```sql
SELECT 
    COUNT(*) AS total_ragam_produk,
    MIN(harga_jual) AS harga_termurah,
    MAX(harga_jual) AS harga_termahal,
    ROUND(AVG(harga_jual), 2) AS rata_rata_harga_jual
FROM produk;
```

### Pertanyaan 4.2: Menghitung Total Transaksi Penjualan per Metode Bayar
**Pertanyaan:** Hitung berapa kali masing-masing metode pembayaran (`Tunai`, `QRIS`, `Debit`) digunakan dalam transaksi penjualan.
```sql
SELECT 
    metode_bayar, 
    COUNT(*) AS frekuensi_transaksi 
FROM penjualan 
GROUP BY metode_bayar;
```

### Pertanyaan 4.3: Menghitung Total Unit Terjual per Kode Produk
**Pertanyaan:** Hitung total kuantitas (jumlah unit) yang berhasil terjual untuk masing-masing kode produk dari tabel `detail_penjualan`.
```sql
SELECT 
    kode_produk, 
    SUM(jumlah) AS total_unit_terjual 
FROM detail_penjualan 
GROUP BY kode_produk 
ORDER BY total_unit_terjual DESC;
```

### Pertanyaan 4.4: Menyaring Hasil Agregasi Menggunakan HAVING (> 5 Unit)
**Pertanyaan:** Tampilkan kode produk yang total kuantitas penjualannya secara keseluruhan telah mencapai lebih dari 5 unit.
```sql
SELECT 
    kode_produk, 
    SUM(jumlah) AS total_unit_terjual 
FROM detail_penjualan 
GROUP BY kode_produk 
HAVING SUM(jumlah) > 5;
```

### Pertanyaan 4.5: Menghitung Jumlah Transaksi per Kasir dan Metode Bayar (Multi-Column Grouping)
**Pertanyaan:** Hitung frekuensi transaksi nota penjualan yang dilayani oleh setiap kasir berdasarkan masing-masing metode bayar yang digunakan.
```sql
SELECT 
    id_kasir, 
    metode_bayar, 
    COUNT(*) AS jumlah_transaksi 
FROM penjualan 
GROUP BY id_kasir, metode_bayar 
ORDER BY id_kasir, metode_bayar;
```

### Pertanyaan 4.6: Pengelompokan dengan Subtotal Keseluruhan (WITH ROLLUP)
**Pertanyaan:** Tampilkan rekapitulasi frekuensi transaksi per metode pembayaran sekaligus baris total keseluruhan menggunakan klausa `WITH ROLLUP`.
```sql
SELECT 
    IFNULL(metode_bayar, 'TOTAL KESELURUHAN') AS metode_bayar, 
    COUNT(*) AS jumlah_transaksi 
FROM penjualan 
GROUP BY metode_bayar WITH ROLLUP;
```

---

## Bagian 5: Relasi Tabel (INNER JOIN & Multi-Table JOIN)

### Pertanyaan 5.1: Menggabungkan Nota Penjualan dengan Nama Kasir
**Pertanyaan:** Tampilkan nomor penjualan, tanggal, metode bayar, dan nama kasir yang melayani setiap transaksi penjualan.
```sql
SELECT 
    p.no_penjualan, 
    p.tanggal, 
    p.metode_bayar, 
    k.nama_kasir 
FROM penjualan p
INNER JOIN kasir k ON k.id_kasir = p.id_kasir
ORDER BY p.no_penjualan;
```

### Pertanyaan 5.2: Menggabungkan Pembelian dengan Kasir dan Supplier (3 Tabel)
**Pertanyaan:** Tampilkan nomor pembelian, tanggal kulakan, nama kasir penerima barang, dan nama supplier tempat barang dibeli.
```sql
SELECT 
    b.no_pembelian, 
    b.tanggal, 
    k.nama_kasir, 
    s.nama_supplier 
FROM pembelian b
INNER JOIN kasir k ON k.id_kasir = b.id_kasir
INNER JOIN supplier s ON s.id_supplier = b.id_supplier
ORDER BY b.tanggal;
```

### Pertanyaan 5.3: Menampilkan Rincian Isi Nota Lengkap dengan Subtotal
**Pertanyaan:** Tampilkan rincian transaksi penjualan yang mencakup nomor nota, tanggal, nama kasir, nama produk, kuantitas, harga satuan, dan hitung subtotal belanja per item barang.
```sql
SELECT 
    p.no_penjualan, 
    p.tanggal, 
    k.nama_kasir, 
    d.nama_produk, 
    d.jumlah, 
    d.harga_satuan,
    (d.jumlah * d.harga_satuan) AS subtotal
FROM detail_penjualan d
INNER JOIN penjualan p ON p.no_penjualan = d.no_penjualan
INNER JOIN kasir k ON k.id_kasir = p.id_kasir
ORDER BY p.no_penjualan, d.id_detail;
```

### Pertanyaan 5.4: Menampilkan Rincian Faktur Pembelian Lengkap
**Pertanyaan:** Tampilkan rincian barang yang dibeli pada setiap nota pembelian, meliputi nomor pembelian, tanggal, nama supplier, nama produk yang dibeli, jumlah unit, harga beli satuan, dan subtotal biaya pembelian.
```sql
SELECT 
    b.no_pembelian, 
    b.tanggal, 
    s.nama_supplier, 
    dp.nama_produk, 
    dp.jumlah, 
    dp.harga_beli,
    (dp.jumlah * dp.harga_beli) AS subtotal_biaya
FROM detail_pembelian dp
INNER JOIN pembelian b ON b.no_pembelian = dp.no_pembelian
INNER JOIN supplier s ON s.id_supplier = b.id_supplier
ORDER BY b.no_pembelian, dp.id_detail;
```

### Pertanyaan 5.5: Komparasi Harga Transaksi Penjualan vs Harga Master Produk Terkini
**Pertanyaan:** Hubungkan tabel `detail_penjualan` dengan tabel master `produk` untuk membandingkan nama dan harga satuan yang tercatat saat transaksi dengan nama dan harga jual master saat ini.
```sql
SELECT 
    d.no_penjualan,
    d.kode_produk,
    d.nama_produk AS nama_pada_nota,
    pr.nama_produk AS nama_pada_master,
    d.harga_satuan AS harga_transaksi,
    pr.harga_jual AS harga_master_saat_ini,
    (d.harga_satuan - pr.harga_jual) AS selisih_harga
FROM detail_penjualan d
INNER JOIN produk pr ON pr.kode_produk = d.kode_produk;
```

---

## Bagian 6: Relasi Lanjutan (LEFT, RIGHT, FULL OUTER, CROSS & SELF JOIN)

### Pertanyaan 6.1: Menampilkan Seluruh Produk dan Penjualannya (Termasuk yang Belum Pernah Laku)
**Pertanyaan:** Tampilkan semua produk yang ada di master katalog beserta total unit terjualnya, termasuk produk yang sama sekali belum pernah terjual (tampilkan 0 jika belum ada penjualan).
```sql
SELECT 
    pr.kode_produk, 
    pr.nama_produk, 
    IFNULL(SUM(d.jumlah), 0) AS total_unit_terjual
FROM produk pr
LEFT JOIN detail_penjualan d ON d.kode_produk = pr.kode_produk
GROUP BY pr.kode_produk, pr.nama_produk
ORDER BY total_unit_terjual ASC;
```

### Pertanyaan 6.2: Mencari Produk yang Belum Pernah Terjual Sama Sekali (LEFT JOIN + IS NULL)
**Pertanyaan:** Tampilkan produk mana saja di dalam katalog toko yang sama sekali belum pernah terjual pada transaksi penjualan manapun.
```sql
SELECT 
    pr.kode_produk, 
    pr.nama_produk, 
    pr.stok_awal
FROM produk pr
LEFT JOIN detail_penjualan d ON d.kode_produk = pr.kode_produk
WHERE d.kode_produk IS NULL;
```

### Pertanyaan 6.3: Mencari Produk yang Belum Pernah Dibeli dari Supplier
**Pertanyaan:** Produk mana saja yang tidak pernah memiliki riwayat pembelian masuk dari supplier?
```sql
SELECT 
    pr.kode_produk, 
    pr.nama_produk
FROM produk pr
LEFT JOIN detail_pembelian dp ON dp.kode_produk = pr.kode_produk
WHERE dp.kode_produk IS NULL;
```

### Pertanyaan 6.4: Mencari Kasir yang Belum Pernah Menangani Transaksi Penjualan
**Pertanyaan:** Tampilkan apakah ada kasir yang terdaftar di tabel master tetapi belum pernah membuat/menangani nota penjualan.
```sql
SELECT 
    k.id_kasir, 
    k.nama_kasir, 
    k.status
FROM kasir k
LEFT JOIN penjualan p ON p.id_kasir = k.id_kasir
WHERE p.no_penjualan IS NULL;
```

### Pertanyaan 6.5: Menampilkan Seluruh Supplier Beserta Frekuensi Pasokannya
**Pertanyaan:** Tampilkan semua supplier dan hitung berapa kali mereka telah memasok barang ke toko, termasuk supplier yang belum pernah memasok sama sekali.
```sql
SELECT 
    s.id_supplier, 
    s.nama_supplier, 
    s.kota, 
    COUNT(b.no_pembelian) AS frekuensi_pasok
FROM supplier s
LEFT JOIN pembelian b ON b.id_supplier = s.id_supplier
GROUP BY s.id_supplier, s.nama_supplier, s.kota;
```

### Pertanyaan 6.6: Penggunaan RIGHT JOIN
**Pertanyaan:** Tuliskan query yang menghasilkan daftar seluruh produk dan total unit terjualnya menggunakan klausa `RIGHT JOIN`.
```sql
SELECT 
    pr.kode_produk, 
    pr.nama_produk, 
    IFNULL(SUM(d.jumlah), 0) AS total_terjual
FROM detail_penjualan d
RIGHT JOIN produk pr ON pr.kode_produk = d.kode_produk
GROUP BY pr.kode_produk, pr.nama_produk;
```

### Pertanyaan 6.7: Simulasi FULL OUTER JOIN (UNION Antara LEFT dan RIGHT JOIN)
**Pertanyaan:** Bagaimana cara mensimulasikan FULL OUTER JOIN di MySQL antara tabel `produk` dan `detail_penjualan` untuk melihat semua relasi yang ada beserta data yang tidak berelasi dari kedua sisi?
```sql
SELECT pr.kode_produk, pr.nama_produk, d.no_penjualan, d.jumlah
FROM produk pr
LEFT JOIN detail_penjualan d ON d.kode_produk = pr.kode_produk
UNION
SELECT pr.kode_produk, pr.nama_produk, d.no_penjualan, d.jumlah
FROM produk pr
RIGHT JOIN detail_penjualan d ON d.kode_produk = pr.kode_produk;
```

### Pertanyaan 6.8: SELF JOIN (Mencari Pasangan Transaksi di Hari yang Sama oleh Kasir Berbeda)
**Pertanyaan:** Tampilkan pasangan nomor nota penjualan yang diterbitkan pada hari yang sama tetapi dilayani oleh kasir yang berbeda.
```sql
SELECT 
    p1.tanggal,
    p1.no_penjualan AS nota_1,
    k1.nama_kasir   AS kasir_1,
    p2.no_penjualan AS nota_2,
    k2.nama_kasir   AS kasir_2
FROM penjualan p1
JOIN penjualan p2 ON p1.tanggal = p2.tanggal AND p1.no_penjualan < p2.no_penjualan
JOIN kasir k1     ON k1.id_kasir = p1.id_kasir
JOIN kasir k2     ON k2.id_kasir = p2.id_kasir
WHERE p1.id_kasir <> p2.id_kasir
ORDER BY p1.tanggal;
```

### Pertanyaan 6.9: CROSS JOIN (Matriks Kombinasi Kasir dan Metode Bayar)
**Pertanyaan:** Buat matriks seluruh kombinasi teoretis antara semua kasir yang ada dan semua metode pembayaran yang tersedia di sistem.
```sql
SELECT 
    k.nama_kasir, 
    m.metode_bayar
FROM kasir k
CROSS JOIN (SELECT DISTINCT metode_bayar FROM penjualan) m
ORDER BY k.nama_kasir, m.metode_bayar;
```

---

## Bagian 7: Subquery, Operator Keberadaan & CTE (Common Table Expressions)

### Pertanyaan 7.1: Produk dengan Harga di Atas Rata-rata (Scalar Subquery)
**Pertanyaan:** Tampilkan produk-produk yang harga jualnya berada di atas rata-rata harga jual seluruh produk di toko.
```sql
SELECT kode_produk, nama_produk, harga_jual 
FROM produk 
WHERE harga_jual > (SELECT AVG(harga_jual) FROM produk);
```

### Pertanyaan 7.2: Produk dengan Harga Paling Mahal
**Pertanyaan:** Tampilkan detail produk yang memiliki harga jual paling tinggi di katalog tanpa menggunakan pengurutan `ORDER BY ... LIMIT 1`.
```sql
SELECT kode_produk, nama_produk, harga_jual 
FROM produk 
WHERE harga_jual = (SELECT MAX(harga_jual) FROM produk);
```

### Pertanyaan 7.3: Transaksi Nota dengan Total Belanja di Atas Rata-rata Nota
**Pertanyaan:** Tampilkan nomor nota penjualan yang total belanjanya melebihi rata-rata nilai total nota belanja di toko.
```sql
SELECT p.no_penjualan, SUM(d.jumlah * d.harga_satuan) AS total_nota
FROM penjualan p
JOIN detail_penjualan d ON d.no_penjualan = p.no_penjualan
GROUP BY p.no_penjualan
HAVING total_nota > (
    SELECT AVG(total_per_nota)
    FROM (
        SELECT SUM(jumlah * harga_satuan) AS total_per_nota
        FROM detail_penjualan
        GROUP BY no_penjualan
    ) AS ringkasan_nota
);
```

### Pertanyaan 7.4: Filter dengan Subquery IN (Produk yang Pernah Terjual)
**Pertanyaan:** Tampilkan kode dan nama produk dari master `produk` yang kodenya terdapat di dalam tabel `detail_penjualan`.
```sql
SELECT kode_produk, nama_produk 
FROM produk 
WHERE kode_produk IN (SELECT DISTINCT kode_produk FROM detail_penjualan);
```

### Pertanyaan 7.5: Filter dengan Subquery NOT IN (Produk yang Belum Pernah Terjual)
**Pertanyaan:** Tampilkan produk yang kodenya tidak pernah tercatat di tabel `detail_penjualan` menggunakan operator `NOT IN`.
```sql
SELECT kode_produk, nama_produk 
FROM produk 
WHERE kode_produk NOT IN (SELECT DISTINCT kode_produk FROM detail_penjualan);
```

### Pertanyaan 7.6: Correlated Subquery dengan EXISTS (Kasir Pengguna QRIS)
**Pertanyaan:** Tampilkan nama kasir yang pernah melayani transaksi dengan metode pembayaran `'QRIS'` menggunakan klausa `EXISTS`.
```sql
SELECT k.id_kasir, k.nama_kasir
FROM kasir k
WHERE EXISTS (
    SELECT 1 
    FROM penjualan p 
    WHERE p.id_kasir = k.id_kasir AND p.metode_bayar = 'QRIS'
);
```

### Pertanyaan 7.7: Correlated Subquery dengan NOT EXISTS (Kasir Tanpa QRIS)
**Pertanyaan:** Tampilkan kasir yang tidak pernah sama sekali melayani transaksi dengan metode `'QRIS'` menggunakan klausa `NOT EXISTS`.
```sql
SELECT k.id_kasir, k.nama_kasir
FROM kasir k
WHERE NOT EXISTS (
    SELECT 1 
    FROM penjualan p 
    WHERE p.id_kasir = k.id_kasir AND p.metode_bayar = 'QRIS'
);
```

### Pertanyaan 7.8: Subquery pada Bagian SELECT (Scalar Correlated Subquery)
**Pertanyaan:** Tampilkan kode produk, nama produk, dan kolom hitungan total unit terjual yang diperoleh dari subquery di klausa `SELECT`.
```sql
SELECT 
    pr.kode_produk,
    pr.nama_produk,
    (
        SELECT IFNULL(SUM(d.jumlah), 0)
        FROM detail_penjualan d
        WHERE d.kode_produk = pr.kode_produk
    ) AS total_terjual
FROM produk pr;
```

### Pertanyaan 7.9: Transaksi yang Membeli Dua Produk Tertentu Sekaligus (Market Basket Analysis Sederhana)
**Pertanyaan:** Cari nomor nota penjualan mana saja yang pelanggan membeli produk `'BRG001'` DAN `'BRG003'` di dalam nota yang sama.
```sql
SELECT no_penjualan
FROM detail_penjualan
WHERE kode_produk IN ('BRG001', 'BRG003')
GROUP BY no_penjualan
HAVING COUNT(DISTINCT kode_produk) = 2;
```

### Pertanyaan 7.10: Common Table Expression (CTE) untuk Analisis Nilai Nota
**Pertanyaan:** Gunakan klausa `WITH` (CTE) untuk menghitung total belanja per nota terlebih dahulu, kemudian dari hasil CTE tersebut tampilkan nota yang nilainya di atas Rp 50.000.
```sql
WITH rekap_nota AS (
    SELECT 
        p.no_penjualan, 
        p.tanggal, 
        k.nama_kasir, 
        SUM(d.jumlah * d.harga_satuan) AS total_belanja
    FROM penjualan p
    JOIN kasir k ON k.id_kasir = p.id_kasir
    JOIN detail_penjualan d ON d.no_penjualan = p.no_penjualan
    GROUP BY p.no_penjualan, p.tanggal, k.nama_kasir
)
SELECT * 
FROM rekap_nota 
WHERE total_belanja > 50000
ORDER BY total_belanja DESC;
```

### Pertanyaan 7.11: Menggabungkan Aliran Transaksi Penjualan dan Pembelian (UNION)
**Pertanyaan:** Buat laporan gabungan kronologis yang mencatat aktivitas transaksi kasir toko, baik saat menerbitkan nota penjualan maupun saat menerima barang pembelian dari supplier.
```sql
SELECT 
    p.tanggal, 
    'PENJUALAN' AS jenis_transaksi, 
    p.no_penjualan AS no_referensi, 
    k.nama_kasir
FROM penjualan p
JOIN kasir k ON k.id_kasir = p.id_kasir

UNION ALL

SELECT 
    b.tanggal, 
    'PEMBELIAN' AS jenis_transaksi, 
    b.no_pembelian AS no_referensi, 
    k.nama_kasir
FROM pembelian b
JOIN kasir k ON k.id_kasir = b.id_kasir

ORDER BY tanggal ASC, no_referensi ASC;
```

---

## Bagian 8: Studi Kasus Khusus Toko Maju Jaya

### 8.1 Penerapan Soft Delete Kasir & Integritas Transaksi

#### Pertanyaan 8.1.1: Menampilkan Kasir yang Berstatus Aktif
**Pertanyaan:** Tampilkan daftar kasir yang saat ini berstatus `'aktif'` bekerja di Toko Maju Jaya.
```sql
SELECT id_kasir, nama_kasir, status
FROM kasir
WHERE status = 'aktif';
```

#### Pertanyaan 8.1.2: Menampilkan Kasir Nonaktif Beserta Tanggal PHK/Keluar
**Pertanyaan:** Tampilkan kasir yang berstatus `'nonaktif'` beserta informasi kapan kasir tersebut resmi berhenti bekerja.
```sql
SELECT id_kasir, nama_kasir, status, tanggal_keluar
FROM kasir
WHERE status = 'nonaktif';
```

#### Pertanyaan 8.1.3: Pembuktian Integritas Data Riwayat Nota Kasir Nonaktif
**Pertanyaan:** Buktikan bahwa meskipun kasir "Budi" telah dinonaktifkan (*soft delete*), seluruh nota penjualan historis yang pernah dibuat oleh Budi tetap tersimpan rapi dan tidak hilang.
```sql
SELECT 
    p.no_penjualan, 
    p.tanggal, 
    k.nama_kasir, 
    k.status, 
    p.metode_bayar
FROM penjualan p
JOIN kasir k ON k.id_kasir = p.id_kasir
WHERE k.nama_kasir = 'Budi';
```

#### Pertanyaan 8.1.4: Validasi Integritas Tanggal Transaksi Kasir Nonaktif
**Pertanyaan:** Buktikan bahwa seluruh nota yang dilayani oleh kasir Budi terjadi SEBELUM tanggal keluarnya (tidak ada nota yang dibuat setelah Budi dinonaktifkan).
```sql
SELECT 
    p.no_penjualan, 
    p.tanggal AS tgl_transaksi, 
    k.nama_kasir, 
    k.tanggal_keluar AS tgl_resmi_keluar,
    CASE 
        WHEN p.tanggal <= k.tanggal_keluar THEN 'Valid (Sebelum Keluar)'
        ELSE 'ANOMALI (Transaksi Setelah Keluar)'
    END AS status_validasi
FROM penjualan p
JOIN kasir k ON k.id_kasir = p.id_kasir
WHERE k.status = 'nonaktif';
```

---

### 8.2 Snapshot Harga & Nama Produk (Kasus BRG001)

#### Pertanyaan 8.2.1: Riwayat Transaksi Penjualan Produk BRG001 Sebelum vs Sesudah Kenaikan Harga
**Pertanyaan:** Tampilkan riwayat seluruh transaksi penjualan untuk produk `BRG001` secara kronologis. Tunjukkan bagaimana nama produk dan harga satuannya terekam pada detail nota sebelum tanggal 10 September 2026 (@Rp 3.500) dan sesudah 10 September 2026 (@Rp 4.200).
```sql
SELECT 
    p.tanggal, 
    d.no_penjualan, 
    d.nama_produk, 
    d.harga_satuan, 
    d.jumlah,
    (d.jumlah * d.harga_satuan) AS subtotal
FROM detail_penjualan d
JOIN penjualan p ON p.no_penjualan = d.no_penjualan
WHERE d.kode_produk = 'BRG001'
ORDER BY p.tanggal;
```

#### Pertanyaan 8.2.2: Menampilkan Nilai Snapshot Unik yang Pernah Berlaku untuk BRG001
**Pertanyaan:** Tampilkan variasi kombinasi nama produk dan harga satuan yang pernah tercatat untuk kode `BRG001` di tabel penjualan.
```sql
SELECT DISTINCT 
    kode_produk, 
    nama_produk, 
    harga_satuan 
FROM detail_penjualan 
WHERE kode_produk = 'BRG001';
```

#### Pertanyaan 8.2.3: Komparasi Omzet BRG001 Periode Lama vs Periode Baru
**Pertanyaan:** Bandingkan total unit yang terjual dan total omzet yang dihasilkan oleh produk `BRG001` antara periode sebelum kenaikan harga (< 10 Sep 2026) dengan periode setelah kenaikan harga (>= 10 Sep 2026).
```sql
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

#### Pertanyaan 8.2.4: Snapshot Riwayat Pembelian Produk BRG001 dari Supplier
**Pertanyaan:** Tampilkan riwayat transaksi pembelian produk `BRG001` dari supplier pada tabel `detail_pembelian`, buktikan bahwa nama produk lama ('Indomie Goreng') dan nama produk baru ('Indomie Goreng Rasa Ayam') juga tercatat sesuai snapshot tanggal kulakan.
```sql
SELECT 
    b.tanggal, 
    dp.no_pembelian, 
    dp.nama_produk, 
    dp.jumlah, 
    dp.harga_beli
FROM detail_pembelian dp
JOIN pembelian b ON b.no_pembelian = dp.no_pembelian
WHERE dp.kode_produk = 'BRG001'
ORDER BY b.tanggal;
```

#### Pertanyaan 8.2.5: Menemukan Seluruh Transaksi yang Menggunakan Nama Snapshot Berbeda dari Katalog Terkini
**Pertanyaan:** Tampilkan semua baris transaksi penjualan di mana `nama_produk` pada detail nota berbeda dengan `nama_produk` yang saat ini tercatat di master tabel `produk`.
```sql
SELECT 
    d.no_penjualan, 
    p.tanggal, 
    d.kode_produk, 
    d.nama_produk AS nama_di_nota, 
    pr.nama_produk AS nama_di_master
FROM detail_penjualan d
JOIN penjualan p ON p.no_penjualan = d.no_penjualan
JOIN produk pr ON pr.kode_produk = d.kode_produk
WHERE d.nama_produk <> pr.nama_produk;
```

---

### 8.3 Kalkulasi Total Transaksi Dinamis

#### Pertanyaan 8.3.1: Menghitung Total Belanja Tiap Nota Penjualan
**Pertanyaan:** Karena tabel `penjualan` tidak menyimpan kolom grand total, hitung total belanja setiap nota penjualan secara dinamis dari tabel `detail_penjualan`. Tampilkan nomor nota, tanggal, nama kasir, metode pembayaran, dan grand total belanja.
```sql
SELECT 
    p.no_penjualan, 
    p.tanggal, 
    k.nama_kasir, 
    p.metode_bayar,
    SUM(d.jumlah * d.harga_satuan) AS total_belanja
FROM penjualan p
JOIN kasir k            ON k.id_kasir     = p.id_kasir
JOIN detail_penjualan d ON d.no_penjualan = p.no_penjualan
GROUP BY p.no_penjualan, p.tanggal, k.nama_kasir, p.metode_bayar
ORDER BY p.tanggal, p.no_penjualan;
```

#### Pertanyaan 8.3.2: Menghitung Total Biaya Tiap Faktur Pembelian Supplier
**Pertanyaan:** Hitung total biaya kulakan setiap nota pembelian secara dinamis dari tabel `detail_pembelian`. Tampilkan nomor pembelian, tanggal, nama supplier, kasir penerima, dan total biaya pembelian.
```sql
SELECT 
    b.no_pembelian, 
    b.tanggal, 
    s.nama_supplier, 
    k.nama_kasir,
    SUM(dp.jumlah * dp.harga_beli) AS total_biaya_kulakan
FROM pembelian b
JOIN supplier s         ON s.id_supplier  = b.id_supplier
JOIN kasir k            ON k.id_kasir     = b.id_kasir
JOIN detail_pembelian dp ON dp.no_pembelian = b.no_pembelian
GROUP BY b.no_pembelian, b.tanggal, s.nama_supplier, k.nama_kasir
ORDER BY b.tanggal;
```

---

### 8.4 Jejak Audit Mutasi Stok (Traceability)

#### Pertanyaan 8.4.1: Jejak Audit Barang Keluar (Alur Penjualan)
**Pertanyaan:** Lakukan audit jejak barang keluar pada tabel `stok`: barang apa yang keluar, berapa jumlahnya, dikeluarkan lewat nota penjualan nomor berapa, dan kasir siapa yang bertanggung jawab saat transaksi terjadi?
```sql
SELECT 
    s.tanggal, 
    s.kode_produk, 
    pr.nama_produk, 
    s.jumlah_keluar,
    s.no_penjualan, 
    k.nama_kasir, 
    p.metode_bayar
FROM stok s
JOIN produk pr   ON pr.kode_produk = s.kode_produk
JOIN penjualan p ON p.no_penjualan = s.no_penjualan
JOIN kasir k     ON k.id_kasir     = p.id_kasir
WHERE s.no_penjualan IS NOT NULL
ORDER BY s.tanggal, s.id_stok;
```

#### Pertanyaan 8.4.2: Jejak Audit Barang Masuk (Alur Pasokan Supplier)
**Pertanyaan:** Lakukan audit jejak barang masuk pada tabel `stok`: barang apa yang masuk, berapa unit, dibeli berdasarkan nomor pembelian apa, dan dari supplier mana barang tersebut didatangkan?
```sql
SELECT 
    s.tanggal, 
    s.kode_produk, 
    pr.nama_produk, 
    s.jumlah_masuk,
    s.no_pembelian, 
    sup.nama_supplier,
    sup.kota
FROM stok s
JOIN produk pr    ON pr.kode_produk = s.kode_produk
JOIN pembelian b  ON b.no_pembelian = s.no_pembelian
JOIN supplier sup ON sup.id_supplier = b.id_supplier
WHERE s.no_pembelian IS NOT NULL
ORDER BY s.tanggal, s.id_stok;
```

#### Pertanyaan 8.4.3: Jejak Aliran Penuh Satu Nota Penjualan Tertentu
**Pertanyaan:** Lakukan pelacakan lengkap untuk nota `'PJ-0001'`: tampilkan data header nota, barang detail yang dibeli, dan baris mutasi stok yang terpotong akibat transaksi tersebut.
```sql
SELECT 
    p.no_penjualan,
    p.tanggal,
    k.nama_kasir,
    d.kode_produk,
    d.nama_produk,
    d.jumlah AS jumlah_terjual,
    st.saldo_awal,
    st.jumlah_keluar,
    st.saldo_akhir
FROM penjualan p
JOIN kasir k            ON k.id_kasir = p.id_kasir
JOIN detail_penjualan d ON d.no_penjualan = p.no_penjualan
JOIN stok st            ON st.no_penjualan = p.no_penjualan AND st.kode_produk = d.kode_produk
WHERE p.no_penjualan = 'PJ-0001';
```

#### Pertanyaan 8.4.4: Kasir Mana Saja yang Mengeluarkan Stok BRG001
**Pertanyaan:** Tampilkan daftar kasir yang pernah melakukan transaksi penjualan yang menyebabkan stok produk `BRG001` keluar dari gudang beserta total unit yang mereka keluarkan.
```sql
SELECT 
    k.nama_kasir, 
    COUNT(s.no_penjualan) AS frekuensi_transaksi,
    SUM(s.jumlah_keluar) AS total_unit_keluar
FROM stok s
JOIN penjualan p ON p.no_penjualan = s.no_penjualan
JOIN kasir k     ON k.id_kasir     = p.id_kasir
WHERE s.kode_produk = 'BRG001'
GROUP BY k.id_kasir, k.nama_kasir
ORDER BY total_unit_keluar DESC;
```

---

## Bagian 9: Analisis Bisnis & Laporan Penjualan

### Pertanyaan 9.1: Laporan Omzet Penjualan Harian
**Pertanyaan:** Tampilkan ringkasan omzet penjualan per hari yang mencakup tanggal transaksi, jumlah nota yang diterbitkan, total unit barang terjual, dan total omzet pendapatan harian toko.
```sql
SELECT 
    p.tanggal, 
    COUNT(DISTINCT p.no_penjualan) AS jumlah_nota,
    SUM(d.jumlah) AS total_unit_terjual,
    SUM(d.jumlah * d.harga_satuan) AS omzet_harian
FROM penjualan p
JOIN detail_penjualan d ON d.no_penjualan = p.no_penjualan
GROUP BY p.tanggal
ORDER BY p.tanggal;
```

### Pertanyaan 9.2: Evaluasi Kinerja Penjualan per Kasir
**Pertanyaan:** Buat laporan perbandingan kinerja antar kasir: tampilkan nama kasir, status keaktifan, jumlah nota yang diselesaikan, dan total kontribusi omzet penjualan yang dihasilkan. Urutkan dari kasir dengan omzet terbesar.
```sql
SELECT 
    k.nama_kasir, 
    k.status,
    COUNT(DISTINCT p.no_penjualan) AS jumlah_nota,
    SUM(d.jumlah * d.harga_satuan) AS total_omzet
FROM kasir k
JOIN penjualan p        ON p.id_kasir     = k.id_kasir
JOIN detail_penjualan d ON d.no_penjualan = p.no_penjualan
GROUP BY k.id_kasir, k.nama_kasir, k.status
ORDER BY total_omzet DESC;
```

### Pertanyaan 9.3: Analisis Proporsi Omzet Berdasarkan Metode Pembayaran
**Pertanyaan:** Tampilkan rekapitulasi penjualan berdasarkan metode bayar (`Tunai`, `QRIS`, `Debit`) yang menyajikan frekuensi penggunaan dan total nilai uang yang masuk per metode bayar.
```sql
SELECT 
    p.metode_bayar,
    COUNT(DISTINCT p.no_penjualan) AS jumlah_transaksi,
    SUM(d.jumlah * d.harga_satuan) AS total_omzet,
    ROUND(
        SUM(d.jumlah * d.harga_satuan) / 
        (SELECT SUM(jumlah * harga_satuan) FROM detail_penjualan) * 100, 
        2
    ) AS persentase_kontribusi
FROM penjualan p
JOIN detail_penjualan d ON d.no_penjualan = p.no_penjualan
GROUP BY p.metode_bayar
ORDER BY total_omzet DESC;
```

### Pertanyaan 9.4: Top 5 Produk Terlaris Berdasarkan Kuantitas Terjual
**Pertanyaan:** Tampilkan 5 produk yang paling laris dibeli pelanggan berdasarkan jumlah unit terjual beserta omzet yang dihasilkannya.
```sql
SELECT 
    pr.kode_produk, 
    pr.nama_produk,
    SUM(d.jumlah) AS total_terjual,
    SUM(d.jumlah * d.harga_satuan) AS total_omzet
FROM detail_penjualan d
JOIN produk pr ON pr.kode_produk = d.kode_produk
GROUP BY pr.kode_produk, pr.nama_produk
ORDER BY total_terjual DESC
LIMIT 5;
```

### Pertanyaan 9.5: 5 Produk Paling Sedikit Terjual (Slow Moving)
**Pertanyaan:** Tampilkan 5 produk yang penjualannya paling sedikit di antara barang-barang yang pernah terjual.
```sql
SELECT 
    pr.kode_produk, 
    pr.nama_produk,
    SUM(d.jumlah) AS total_terjual
FROM detail_penjualan d
JOIN produk pr ON pr.kode_produk = d.kode_produk
GROUP BY pr.kode_produk, pr.nama_produk
ORDER BY total_terjual ASC
LIMIT 5;
```

### Pertanyaan 9.6: Analisis Laba Kotor per Produk
**Pertanyaan:** Hitung estimasi laba kotor (*gross profit*) per produk dengan rumus: `SUM(jumlah * (harga_satuan_jual - harga_beli_master))`. Urutkan dari produk yang memberikan keuntungan nominal terbesar.
```sql
SELECT 
    pr.kode_produk, 
    pr.nama_produk,
    SUM(d.jumlah) AS unit_terjual,
    SUM(d.jumlah * d.harga_satuan) AS total_omzet,
    SUM(d.jumlah * pr.harga_beli) AS total_hpp,
    SUM(d.jumlah * (d.harga_satuan - pr.harga_beli)) AS estimasi_laba_kotor
FROM detail_penjualan d
JOIN produk pr ON pr.kode_produk = d.kode_produk
GROUP BY pr.kode_produk, pr.nama_produk
ORDER BY estimasi_laba_kotor DESC;
```

### Pertanyaan 9.7: Total Omzet dan Grand Total Laba Kotor Toko
**Pertanyaan:** Hitung ringkasan performa finansial Toko Maju Jaya secara keseluruhan: total omzet pendapatan, total modal pengadaan (HPP), dan total laba kotor yang diperoleh toko.
```sql
SELECT 
    SUM(d.jumlah * d.harga_satuan) AS grand_total_omzet,
    SUM(d.jumlah * pr.harga_beli) AS grand_total_hpp,
    SUM(d.jumlah * (d.harga_satuan - pr.harga_beli)) AS grand_total_laba_kotor,
    ROUND(
        SUM(d.jumlah * (d.harga_satuan - pr.harga_beli)) / 
        SUM(d.jumlah * d.harga_satuan) * 100, 
        2
    ) AS margin_keuntungan_persen
FROM detail_penjualan d
JOIN produk pr ON pr.kode_produk = d.kode_produk;
```

### Pertanyaan 9.8: Identifikasi Transaksi Nota Terbesar dan Terkecil
**Pertanyaan:** Tampilkan informasi nota yang memiliki nilai total belanja tertinggi dan nota dengan nilai total belanja terendah.
```sql
(
    SELECT 'NOTA TERBESAR' AS kategori, p.no_penjualan, p.tanggal, k.nama_kasir, SUM(d.jumlah * d.harga_satuan) AS total
    FROM penjualan p
    JOIN kasir k ON k.id_kasir = p.id_kasir
    JOIN detail_penjualan d ON d.no_penjualan = p.no_penjualan
    GROUP BY p.no_penjualan, p.tanggal, k.nama_kasir
    ORDER BY total DESC
    LIMIT 1
)
UNION ALL
(
    SELECT 'NOTA TERKECIL' AS kategori, p.no_penjualan, p.tanggal, k.nama_kasir, SUM(d.jumlah * d.harga_satuan) AS total
    FROM penjualan p
    JOIN kasir k ON k.id_kasir = p.id_kasir
    JOIN detail_penjualan d ON d.no_penjualan = p.no_penjualan
    GROUP BY p.no_penjualan, p.tanggal, k.nama_kasir
    ORDER BY total ASC
    LIMIT 1
);
```

### Pertanyaan 9.9: Rata-rata Nilai Transaksi per Nota (Basket Size)
**Pertanyaan:** Hitung rata-rata nilai rupiah yang dibelanjakan pelanggan dalam setiap transaksi (rata-rata nilai per nota).
```sql
SELECT 
    ROUND(AVG(total_nota), 2) AS rata_rata_nilai_per_nota
FROM (
    SELECT SUM(jumlah * harga_satuan) AS total_nota
    FROM detail_penjualan
    GROUP BY no_penjualan
) AS rekap;
```

### Pertanyaan 9.10: Mencetak Tampilan Struk Transaksi Tunggal (Contoh: 'PJ-0002')
**Pertanyaan:** Susun query untuk menampilkan data satu struk belanja spesifik (misal `'PJ-0002'`) lengkap dengan baris-baris item barang, jumlah, harga satuan, dan subtotalnya.
```sql
SELECT 
    d.no_penjualan,
    p.tanggal,
    k.nama_kasir,
    p.metode_bayar,
    d.kode_produk,
    d.nama_produk,
    d.jumlah,
    d.harga_satuan,
    (d.jumlah * d.harga_satuan) AS subtotal
FROM detail_penjualan d
JOIN penjualan p ON p.no_penjualan = d.no_penjualan
JOIN kasir k     ON k.id_kasir     = p.id_kasir
WHERE d.no_penjualan = 'PJ-0002';
```

---

## Bagian 10: Laporan Pembelian & Supplier (Kulakan)

### Pertanyaan 10.1: Rekapitulasi Pembelian per Nota
**Pertanyaan:** Tampilkan daftar rekapitulasi setiap nota pembelian dari supplier yang menyajikan nomor faktur, tanggal, nama supplier, nama kasir penerima, jumlah variasi barang yang dibeli, total unit barang, dan total nominal biaya pembelian.
```sql
SELECT 
    b.no_pembelian, 
    b.tanggal, 
    s.nama_supplier, 
    k.nama_kasir,
    COUNT(dp.id_detail) AS variasi_barang,
    SUM(dp.jumlah) AS total_unit,
    SUM(dp.jumlah * dp.harga_beli) AS total_biaya
FROM pembelian b
JOIN supplier s          ON s.id_supplier  = b.id_supplier
JOIN kasir k             ON k.id_kasir     = b.id_kasir
JOIN detail_pembelian dp ON dp.no_pembelian = b.no_pembelian
GROUP BY b.no_pembelian, b.tanggal, s.nama_supplier, k.nama_kasir
ORDER BY b.tanggal;
```

### Pertanyaan 10.2: Total Belanja Kulakan per Supplier
**Pertanyaan:** Berapa total biaya yang telah dibelanjakan toko ke masing-masing supplier? Tampilkan nama supplier, kota, frekuensi faktur pembelian, dan total rupiah pembelanjaan diurutkan dari supplier dengan nilai belanja terbesar.
```sql
SELECT 
    s.nama_supplier, 
    s.kota,
    COUNT(DISTINCT b.no_pembelian) AS frekuensi_pembelian,
    SUM(dp.jumlah * dp.harga_beli)  AS total_belanja
FROM supplier s
JOIN pembelian b         ON b.id_supplier  = s.id_supplier
JOIN detail_pembelian dp ON dp.no_pembelian = b.no_pembelian
GROUP BY s.id_supplier, s.nama_supplier, s.kota
ORDER BY total_belanja DESC;
```

### Pertanyaan 10.3: Total Kuantitas Barang yang Pernah Dipesan per Produk
**Pertanyaan:** Hitung berapa total unit barang yang pernah dibeli/dipasok dari supplier untuk setiap produk dari tabel `detail_pembelian`.
```sql
SELECT 
    dp.kode_produk, 
    dp.nama_produk, 
    SUM(dp.jumlah) AS total_unit_dibeli
FROM detail_pembelian dp
GROUP BY dp.kode_produk, dp.nama_produk
ORDER BY total_unit_dibeli DESC;
```

### Pertanyaan 10.4: Pemetaan Produk yang Dipasok oleh Masing-masing Supplier
**Pertanyaan:** Tampilkan daftar produk apa saja yang pernah dipasok oleh masing-masing supplier beserta harga beli yang disepakati.
```sql
SELECT DISTINCT 
    s.nama_supplier, 
    dp.kode_produk, 
    dp.nama_produk, 
    dp.harga_beli
FROM supplier s
JOIN pembelian b         ON b.id_supplier = s.id_supplier
JOIN detail_pembelian dp ON dp.no_pembelian = b.no_pembelian
ORDER BY s.nama_supplier, dp.kode_produk;
```

### Pertanyaan 10.5: Total Pengeluaran Kulakan Keseluruhan Toko
**Pertanyaan:** Hitung berapa total anggaran belanja (modal kulakan) yang telah dikeluarkan oleh Toko Maju Jaya secara keseluruhan.
```sql
SELECT 
    COUNT(DISTINCT no_pembelian) AS total_faktur,
    SUM(jumlah) AS total_unit_kulakan,
    SUM(jumlah * harga_beli) AS total_biaya_kulakan
FROM detail_pembelian;
```

---

## Bagian 11: Manajemen Persediaan & Kartu Stok

### Pertanyaan 11.1: Menampilkan Kartu Stok Lengkap Satu Produk Tertentu (Contoh: 'BRG001')
**Pertanyaan:** Tampilkan riwayat kartu stok produk `'BRG001'` secara kronologis lengkap dari saldo awal, setiap transaksi barang masuk/keluar, saldo akhir berjalan, serta nomor referensi dokumen terkait.
```sql
SELECT 
    id_stok,
    tanggal, 
    keterangan, 
    saldo_awal, 
    jumlah_masuk, 
    jumlah_keluar, 
    saldo_akhir,
    no_penjualan, 
    no_pembelian
FROM stok
WHERE kode_produk = 'BRG001'
ORDER BY id_stok ASC;
```

### Pertanyaan 11.2: Posisi Stok Akhir Terkini Seluruh Produk (Mengambil Baris Mutasi Terakhir)
**Pertanyaan:** Tampilkan posisi stok fisik terkini untuk seluruh produk di toko dengan mengambil `saldo_akhir` dari baris mutasi kartu stok dengan `id_stok` tertinggi pada masing-masing produk.
```sql
SELECT 
    s.kode_produk, 
    pr.nama_produk, 
    s.saldo_akhir AS stok_akhir_terkini
FROM stok s
JOIN produk pr ON pr.kode_produk = s.kode_produk
WHERE s.id_stok = (
    SELECT MAX(x.id_stok) 
    FROM stok x 
    WHERE x.kode_produk = s.kode_produk
)
ORDER BY s.kode_produk;
```

### Pertanyaan 11.3: Rekalkulasi Stok Akhir Berdasarkan Rumus Mutasi (Stok Awal + Masuk - Keluar)
**Pertanyaan:** Buktikan kebenaran stok akhir dengan menghitung langsung dari formula: `stok_awal + total_masuk - total_keluar`, kemudian bandingkan hasilnya dengan master katalog.
```sql
SELECT 
    pr.kode_produk,
    pr.nama_produk,
    pr.stok_awal,
    IFNULL(beli.total_masuk, 0) AS total_masuk,
    IFNULL(jual.total_keluar, 0) AS total_keluar,
    (pr.stok_awal + IFNULL(beli.total_masuk, 0) - IFNULL(jual.total_keluar, 0)) AS stok_akhir_kalkulasi
FROM produk pr
LEFT JOIN (
    SELECT kode_produk, SUM(jumlah) AS total_masuk 
    FROM detail_pembelian 
    GROUP BY kode_produk
) beli ON beli.kode_produk = pr.kode_produk
LEFT JOIN (
    SELECT kode_produk, SUM(jumlah) AS total_keluar 
    FROM detail_penjualan 
    GROUP BY kode_produk
) jual ON jual.kode_produk = pr.kode_produk
ORDER BY pr.kode_produk;
```

### Pertanyaan 11.4: Peringatan Persediaan Menipis (Stok Kurang dari 30 Unit)
**Pertanyaan:** Tampilkan daftar produk yang saat ini persediaan fisiknya menipis (stok akhir < 30 unit) untuk diprioritaskan melakukan kulakan ulang (*reorder*).
```sql
SELECT 
    s.kode_produk, 
    pr.nama_produk, 
    s.saldo_akhir AS stok_tersisa
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

### Pertanyaan 11.5: Valuasi Total Nilai Aset Persediaan Barang Gudang
**Pertanyaan:** Hitung total valuasi nilai rupiah dari seluruh persediaan barang yang masih tersisa di gudang toko (stok akhir dikalikan harga beli per unit).
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

### Pertanyaan 11.6: Rekapitulasi Mutasi Stok per Tanggal
**Pertanyaan:** Hitung total kuantitas barang masuk dan total kuantitas barang keluar yang terjadi pada seluruh gudang untuk setiap tanggal transaksi.
```sql
SELECT 
    tanggal,
    SUM(jumlah_masuk)  AS total_masuk,
    SUM(jumlah_keluar) AS total_keluar
FROM stok
WHERE keterangan <> 'Stok awal'
GROUP BY tanggal
ORDER BY tanggal;
```

### Pertanyaan 11.7: Analisis Perputaran Persediaan (Turnover: Unit Keluar vs Stok Awal)
**Pertanyaan:** Hitung rasio persentase barang yang berhasil terjual keluar dibandingkan dengan kapasitas persediaan awalnya untuk melihat produk mana yang memiliki perputaran paling cepat.
```sql
SELECT 
    pr.kode_produk,
    pr.nama_produk,
    pr.stok_awal,
    IFNULL(SUM(s.jumlah_keluar), 0) AS total_keluar,
    ROUND(IFNULL(SUM(s.jumlah_keluar), 0) / pr.stok_awal * 100, 2) AS rasio_keluar_persen
FROM produk pr
LEFT JOIN stok s ON s.kode_produk = pr.kode_produk AND s.jumlah_keluar > 0
GROUP BY pr.kode_produk, pr.nama_produk, pr.stok_awal
ORDER BY rasio_keluar_persen DESC;
```

---

## Bagian 12: Fungsi Analitik & Window Functions (MySQL 8+)

### Pertanyaan 12.1: Pemeringkatan Produk Berdasarkan Omzet (RANK & DENSE_RANK)
**Pertanyaan:** Gunakan fungsi jendela `DENSE_RANK()` untuk mengurutkan dan memberi peringkat seluruh produk berdasarkan total omzet penjualan yang dihasilkannya.
```sql
SELECT 
    pr.kode_produk,
    pr.nama_produk,
    SUM(d.jumlah * d.harga_satuan) AS omzet,
    DENSE_RANK() OVER (ORDER BY SUM(d.jumlah * d.harga_satuan) DESC) AS peringkat_omzet
FROM detail_penjualan d
JOIN produk pr ON pr.kode_produk = d.kode_produk
GROUP BY pr.kode_produk, pr.nama_produk;
```

### Pertanyaan 12.2: Pemeringkatan Kasir Berdasarkan Nilai Penjualan
**Pertanyaan:** Berikan nomor urut peringkat (ranking 1, 2, 3, ...) pada kasir berdasarkan perolehan total omzet yang berhasil mereka kumpulkan.
```sql
SELECT 
    k.nama_kasir,
    SUM(d.jumlah * d.harga_satuan) AS total_omzet,
    RANK() OVER (ORDER BY SUM(d.jumlah * d.harga_satuan) DESC) AS rank_kasir
FROM kasir k
JOIN penjualan p        ON p.id_kasir     = k.id_kasir
JOIN detail_penjualan d ON d.no_penjualan = p.no_penjualan
GROUP BY k.id_kasir, k.nama_kasir;
```

### Pertanyaan 12.3: Produk Terlaris per Kasir (Partitioned Ranking)
**Pertanyaan:** Tampilkan produk terlaris nomor satu yang paling banyak dijual oleh masing-masing kasir menggunakan `ROW_NUMBER() OVER (PARTITION BY ...)`:
```sql
WITH rekap_kasir_produk AS (
    SELECT 
        k.nama_kasir,
        d.nama_produk,
        SUM(d.jumlah) AS unit_terjual,
        ROW_NUMBER() OVER (
            PARTITION BY k.id_kasir 
            ORDER BY SUM(d.jumlah) DESC
        ) AS urutan
    FROM kasir k
    JOIN penjualan p        ON p.id_kasir = k.id_kasir
    JOIN detail_penjualan d ON d.no_penjualan = p.no_penjualan
    GROUP BY k.id_kasir, k.nama_kasir, d.nama_produk
)
SELECT nama_kasir, nama_produk, unit_terjual
FROM rekap_kasir_produk
WHERE urutan = 1;
```

### Pertanyaan 12.4: Analisis Pertumbuhan Omzet Harian (Fungsi LAG)
**Pertanyaan:** Tampilkan perbandingan omzet harian dengan omzet pada hari transaksi sebelumnya menggunakan fungsi `LAG()`, serta hitung nominal kenaikan atau penurunannya.
```sql
WITH omzet_harian AS (
    SELECT 
        p.tanggal,
        SUM(d.jumlah * d.harga_satuan) AS omzet
    FROM penjualan p
    JOIN detail_penjualan d ON d.no_penjualan = p.no_penjualan
    GROUP BY p.tanggal
)
SELECT 
    tanggal,
    omzet,
    LAG(omzet, 1) OVER (ORDER BY tanggal) AS omzet_hari_sebelumnya,
    (omzet - LAG(omzet, 1) OVER (ORDER BY tanggal)) AS perubahan_nominal
FROM omzet_harian;
```

### Pertanyaan 12.5: Running Total Omzet Penjualan Kumulatif
**Pertanyaan:** Hitung akumulasi omzet harian berjalan (*cumulative running total*) dari hari ke hari sepanjang bulan September 2026.
```sql
WITH omzet_per_hari AS (
    SELECT 
        p.tanggal,
        SUM(d.jumlah * d.harga_satuan) AS omzet
    FROM penjualan p
    JOIN detail_penjualan d ON d.no_penjualan = p.no_penjualan
    GROUP BY p.tanggal
)
SELECT 
    tanggal,
    omzet,
    SUM(omzet) OVER (ORDER BY tanggal ASC) AS omzet_kumulatif_berjalan
FROM omzet_per_hari;
```

### Pertanyaan 12.6: Nomor Urut Transaksi per Kasir
**Pertanyaan:** Berikan nomor urut nota transaksi (transaksi ke-1, ke-2, dst.) untuk masing-masing kasir secara kronologis menggunakan `ROW_NUMBER()`.
```sql
SELECT 
    p.no_penjualan,
    p.tanggal,
    k.nama_kasir,
    ROW_NUMBER() OVER (
        PARTITION BY p.id_kasir 
        ORDER BY p.tanggal, p.no_penjualan
    ) AS transaksi_ke
FROM penjualan p
JOIN kasir k ON k.id_kasir = p.id_kasir;
```

---

## Bagian 13: Audit, Validasi Integritas & Deteksi Anomali Data

### Pertanyaan 13.1: Validasi Rumus Saldo Akhir Tiap Baris Kartu Stok
**Pertanyaan:** Periksa apakah ada baris pada tabel `stok` yang perhitungannya salah (`saldo_akhir` tidak sama dengan `saldo_awal + jumlah_masuk - jumlah_keluar`). Query harus menghasilkan 0 baris jika data konsisten.
```sql
SELECT * 
FROM stok 
WHERE saldo_akhir <> (saldo_awal + jumlah_masuk - jumlah_keluar);
```

### Pertanyaan 13.2: Validasi Kontinuitas Saldo Kartu Stok Antar Baris Kronologis
**Pertanyaan:** Gunakan fungsi `LAG()` untuk memeriksa apakah `saldo_awal` pada setiap baris kartu stok selalu sama persis dengan `saldo_akhir` dari baris mutasi tepat sebelumnya untuk produk yang sama.
```sql
WITH cek_kontinuitas AS (
    SELECT 
        id_stok, 
        kode_produk, 
        tanggal, 
        saldo_awal, 
        saldo_akhir,
        LAG(saldo_akhir) OVER (
            PARTITION BY kode_produk 
            ORDER BY id_stok
        ) AS saldo_akhir_sebelumnya
    FROM stok
)
SELECT * 
FROM cek_kontinuitas
WHERE saldo_akhir_sebelumnya IS NOT NULL 
  AND saldo_awal <> saldo_akhir_sebelumnya;
```

### Pertanyaan 13.3: Pencocokan Nilai Saldo Awal Kartu Stok dengan Master Produk
**Pertanyaan:** Periksa apakah nilai `saldo_akhir` pada baris pertama kartu stok ('Stok awal') untuk setiap barang sama persis dengan kolom `stok_awal` yang tersimpan pada tabel master `produk`.
```sql
SELECT 
    s.kode_produk, 
    pr.nama_produk, 
    s.saldo_akhir AS stok_awal_kartu, 
    pr.stok_awal AS stok_awal_master
FROM stok s
JOIN produk pr ON pr.kode_produk = s.kode_produk
WHERE s.keterangan = 'Stok awal'
  AND s.saldo_akhir <> pr.stok_awal;
```

### Pertanyaan 13.4: Verifikasi Sinkronisasi Kuantitas Penjualan dengan Mutasi Stok Keluar
**Pertanyaan:** Periksa apakah setiap baris di `detail_penjualan` memiliki baris pencatatan mutasi pengurangan stok di tabel `stok` dengan jumlah keluar yang cocok.
```sql
SELECT 
    d.no_penjualan, 
    d.kode_produk, 
    d.jumlah AS qty_nota, 
    IFNULL(s.jumlah_keluar, 0) AS qty_stok_keluar
FROM detail_penjualan d
LEFT JOIN stok s ON s.no_penjualan = d.no_penjualan AND s.kode_produk = d.kode_produk
WHERE s.id_stok IS NULL OR d.jumlah <> s.jumlah_keluar;
```

### Pertanyaan 13.5: Verifikasi Sinkronisasi Kuantitas Pembelian dengan Mutasi Stok Masuk
**Pertanyaan:** Periksa apakah setiap baris di `detail_pembelian` tercatat penambahan stoknya di tabel `stok` dengan jumlah masuk yang cocok.
```sql
SELECT 
    dp.no_pembelian, 
    dp.kode_produk, 
    dp.jumlah AS qty_faktur_beli, 
    IFNULL(s.jumlah_masuk, 0) AS qty_stok_masuk
FROM detail_pembelian dp
LEFT JOIN stok s ON s.no_pembelian = dp.no_pembelian AND s.kode_produk = dp.kode_produk
WHERE s.id_stok IS NULL OR dp.jumlah <> s.jumlah_masuk;
```

### Pertanyaan 13.6: Deteksi Record Yatim (Orphan Records) pada Tabel Detail
**Pertanyaan:** Karena basis data ini dirancang tanpa FOREIGN KEY fisik, tuliskan query untuk mendeteksi:
a) Apakah ada baris di `detail_penjualan` yang `no_penjualan`-nya tidak ada di tabel header `penjualan`?
b) Apakah ada produk di `detail_penjualan` yang `kode_produk`-nya tidak ada di master `produk`?
```sql
-- a) Detail penjualan tanpa header penjualan
SELECT d.* 
FROM detail_penjualan d
LEFT JOIN penjualan p ON p.no_penjualan = d.no_penjualan
WHERE p.no_penjualan IS NULL;

-- b) Detail penjualan dengan produk tidak terdaftar di master
SELECT d.* 
FROM detail_penjualan d
LEFT JOIN produk pr ON pr.kode_produk = d.kode_produk
WHERE pr.kode_produk IS NULL;
```

### Pertanyaan 13.7: Deteksi Transaksi Kasir Setelah Tanggal PHK/Keluar (Pelanggaran Integritas)
**Pertanyaan:** Periksa apakah ada kasir yang sudah nonaktif tetapi masih tercatat menerbitkan nota penjualan atau memproses faktur pembelian setelah tanggal keluarnya.
```sql
SELECT 
    p.no_penjualan, 
    p.tanggal, 
    k.nama_kasir, 
    k.tanggal_keluar
FROM penjualan p
JOIN kasir k ON k.id_kasir = p.id_kasir
WHERE k.status = 'nonaktif' AND p.tanggal > k.tanggal_keluar;
```

### Pertanyaan 13.8: Deteksi Potensi Stok Minus
**Pertanyaan:** Periksa apakah pernah terjadi saldo persediaan barang bernilai negatif (`saldo_akhir < 0`) pada kartu stok.
```sql
SELECT * 
FROM stok 
WHERE saldo_akhir < 0;
```

### Pertanyaan 13.9: Deteksi Penjualan Rugi (Harga Jual < Harga Beli)
**Pertanyaan:** Tampilkan jika ada transaksi penjualan di mana harga jual per unit lebih rendah daripada harga beli produk tersebut (transaksi merugi).
```sql
SELECT 
    d.no_penjualan, 
    d.kode_produk, 
    d.nama_produk, 
    d.harga_satuan, 
    pr.harga_beli
FROM detail_penjualan d
JOIN produk pr ON pr.kode_produk = d.kode_produk
WHERE d.harga_satuan < pr.harga_beli;
```

### Pertanyaan 13.10: Ringkasan Total Baris (Row Count) Seluruh Tabel Database
**Pertanyaan:** Tampilkan ringkasan jumlah baris yang ada pada masing-masing dari ke-8 tabel yang terdapat di database `penjualan_lengkap`.
```sql
SELECT 'kasir' AS nama_tabel, COUNT(*) AS total_baris FROM kasir
UNION ALL
SELECT 'supplier', COUNT(*) FROM supplier
UNION ALL
SELECT 'produk', COUNT(*) FROM produk
UNION ALL
SELECT 'penjualan', COUNT(*) FROM penjualan
UNION ALL
SELECT 'detail_penjualan', COUNT(*) FROM detail_penjualan
UNION ALL
SELECT 'pembelian', COUNT(*) FROM pembelian
UNION ALL
SELECT 'detail_pembelian', COUNT(*) FROM detail_pembelian
UNION ALL
SELECT 'stok', COUNT(*) FROM stok;
```

---

## Bagian 14: Database Object (VIEW)

### Pertanyaan 14.1: Pembuatan VIEW Ringkasan Total Penjualan per Nota
**Pertanyaan:** Buat sebuah objek VIEW bernama `v_total_nota` yang merangkum header penjualan beserta total nilai belanjanya sehingga pengguna tidak perlu menuliskan query JOIN dan GROUP BY berulang kali.
```sql
CREATE OR REPLACE VIEW v_total_nota AS
SELECT 
    p.no_penjualan, 
    p.tanggal, 
    k.nama_kasir, 
    p.metode_bayar,
    SUM(d.jumlah * d.harga_satuan) AS total_belanja
FROM penjualan p
JOIN kasir k            ON k.id_kasir     = p.id_kasir
JOIN detail_penjualan d ON d.no_penjualan = p.no_penjualan
GROUP BY p.no_penjualan, p.tanggal, k.nama_kasir, p.metode_bayar;
```

### Pertanyaan 14.2: Pembuatan VIEW Posisi Stok Akhir Terkini
**Pertanyaan:** Buat sebuah objek VIEW bernama `v_stok_akhir` yang secara otomatis menampilkan stok akhir terkini seluruh produk toko.
```sql
CREATE OR REPLACE VIEW v_stok_akhir AS
SELECT 
    s.kode_produk, 
    pr.nama_produk, 
    s.saldo_akhir AS stok_akhir
FROM stok s
JOIN produk pr ON pr.kode_produk = s.kode_produk
WHERE s.id_stok = (
    SELECT MAX(x.id_stok) 
    FROM stok x 
    WHERE x.kode_produk = s.kode_produk
);
```

### Pertanyaan 14.3: Mengakses dan Memanfaatkan Objek VIEW
**Pertanyaan:** Bagaimana cara menggunakan VIEW `v_total_nota` untuk mencari nota dengan nilai belanja di atas Rp 50.000, dan menggunakan `v_stok_akhir` untuk melihat stok yang kurang dari 25 unit?
```sql
-- Penggunaan VIEW total nota
SELECT * 
FROM v_total_nota 
WHERE total_belanja > 50000 
ORDER BY total_belanja DESC;

-- Penggunaan VIEW stok akhir
SELECT * 
FROM v_stok_akhir 
WHERE stok_akhir < 25 
ORDER BY stok_akhir ASC;
```

---

## Bagian 15: Manipulasi Data Lanjutan (DML)

### Pertanyaan 15.1: Menambahkan Kasir Baru (INSERT)
**Pertanyaan:** Tuliskan perintah SQL untuk menambahkan kasir baru bernama `'Eka'` dengan status langsung aktif.
```sql
INSERT INTO kasir (nama_kasir, status, tanggal_keluar) 
VALUES ('Eka', 'aktif', NULL);
```

### Pertanyaan 15.2: Menonaktifkan Kasir dengan Soft Delete (UPDATE)
**Pertanyaan:** Tuliskan perintah SQL untuk menonaktifkan kasir dengan nama `'Dewi'` yang berhenti bekerja per tanggal hari ini tanpa menghapus baris datanya dari database.
```sql
UPDATE kasir 
SET status = 'nonaktif', tanggal_keluar = CURRENT_DATE() 
WHERE nama_kasir = 'Dewi';
```

### Pertanyaan 15.3: Menyesuaikan Harga Master Produk Baru (UPDATE Katalog)
**Pertanyaan:** Tuliskan perintah untuk menaikkan harga jual produk `'BRG002'` (Indomie Kuah Soto) menjadi Rp 3.800 di tabel master `produk`.
```sql
UPDATE produk 
SET harga_jual = 3800.00 
WHERE kode_produk = 'BRG002';
```

### Pertanyaan 15.4: Simulasi Transaksi Penjualan Lengkap (INSERT Multi-Tabel & Stok)
**Pertanyaan:** Tuliskan urutan query SQL untuk mensimulasikan pencatatan satu transaksi penjualan baru (`'PJ-0015'`) tanggal 22 September 2026 oleh kasir Anna (id=1), metode bayar Tunai, untuk pembelian 2 unit Teh Botol Sosro (`BRG003` @Rp 5.000) beserta pemotongan kartu stoknya secara sinkron.
```sql
-- 1. Tambah header penjualan
INSERT INTO penjualan (no_penjualan, tanggal, id_kasir, metode_bayar)
VALUES ('PJ-0015', '2026-09-22', 1, 'Tunai');

-- 2. Tambah detail penjualan (snapshot nama & harga saat ini)
INSERT INTO detail_penjualan (no_penjualan, kode_produk, nama_produk, jumlah, harga_satuan)
VALUES ('PJ-0015', 'BRG003', 'Teh Botol Sosro 350ml', 2, 5000.00);

-- 3. Catat kartu stok keluar (mengambil saldo akhir sebelumnya)
INSERT INTO stok (kode_produk, tanggal, jumlah_masuk, jumlah_keluar, saldo_awal, saldo_akhir, no_penjualan, no_pembelian, keterangan)
SELECT 
    'BRG003', 
    '2026-09-22', 
    0, 
    2, 
    s.saldo_akhir, 
    (s.saldo_akhir - 2), 
    'PJ-0015', 
    NULL, 
    'Terjual (PJ-0015)'
FROM stok s
WHERE s.kode_produk = 'BRG003'
ORDER BY s.id_stok DESC
LIMIT 1;
```
