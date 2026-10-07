-- ============================================================
-- bangun_database_penjualan.sql
-- Pertemuan 7: database_penjualan_lengkap (Toko Maju Jaya)
--
-- TINGGAL COPAS — file ini cukup ditempel SELURUH ISI ke tab SQL
-- phpMyAdmin (atau menu Import) => database + SEMUA data langsung jadi.
-- Setelah itu baru jalankan file kunci_query_penjualan.sql.
--
-- ISI DATANYA (biar terlihat ramai):
--   4 kasir, 3 supplier, 20 produk (barang Indomaret), 4 pembelian
--   (30 baris detail), 14 nota penjualan (41 baris detail),
--   91 baris stok (20 pembuka 'Stok awal' + 71 baris mutasi).
--
-- CERITA 5 TUGAS:
--   Produk BRG001 (Indomie Goreng) harga & nama BERUBAH pada 10-Sep-2026.
--   Nota sebelum 10-Sep menyimpan SNAPSHOT lama ('Indomie Goreng' @3500),
--   nota sesudahnya menyimpan snapshot baru ('Indomie Goreng Rasa Ayam' @4200).
--   Kasir Budi PHK -> soft delete (status 'nonaktif'). dst.
--
-- DESAIN: CREATE TABLE TANPA FOREIGN KEY — relasi dibuktikan lewat JOIN.
-- ============================================================

CREATE DATABASE IF NOT EXISTS penjualan_lengkap CHARACTER SET utf8mb4;
USE penjualan_lengkap;

DROP TABLE IF EXISTS stok;
DROP TABLE IF EXISTS detail_pembelian;
DROP TABLE IF EXISTS pembelian;
DROP TABLE IF EXISTS detail_penjualan;
DROP TABLE IF EXISTS penjualan;
DROP TABLE IF EXISTS produk;
DROP TABLE IF EXISTS supplier;
DROP TABLE IF EXISTS kasir;

-- 1) KASIR : PHK/pensiun -> status 'nonaktif' (SOFT DELETE), jangan DELETE baris.
CREATE TABLE kasir (
  id_kasir       INT AUTO_INCREMENT PRIMARY KEY,
  nama_kasir     VARCHAR(50) NOT NULL,
  status         ENUM('aktif','nonaktif') DEFAULT 'aktif',
  tanggal_keluar DATE NULL
);

-- 2) SUPPLIER : pemasok barang.
CREATE TABLE supplier (
  id_supplier   INT AUTO_INCREMENT PRIMARY KEY,
  nama_supplier VARCHAR(50) NOT NULL,
  kota          VARCHAR(30)
);

-- 3) PRODUK : katalog barang (master). BRG001 sudah kondisi SETELAH berubah.
CREATE TABLE produk (
  kode_produk VARCHAR(10) PRIMARY KEY,
  nama_produk VARCHAR(50) NOT NULL,
  harga_beli  DECIMAL(10, 2) NOT NULL,
  harga_jual  DECIMAL(10, 2) NOT NULL,
  stok_awal   INT DEFAULT 0
);

-- 4) PENJUALAN : kepala SATU nota (Total dihitung dari detail).
CREATE TABLE penjualan (
  no_penjualan VARCHAR(12) PRIMARY KEY,
  tanggal      DATE NOT NULL,
  id_kasir     INT NOT NULL,
  metode_bayar VARCHAR(20)
);

-- 5) DETAIL PENJUALAN : isi nota. SNAPSHOT harga & nama saat transaksi.
CREATE TABLE detail_penjualan (
  id_detail    INT AUTO_INCREMENT PRIMARY KEY,
  no_penjualan VARCHAR(12) NOT NULL,
  kode_produk  VARCHAR(10) NOT NULL,
  nama_produk  VARCHAR(50) NOT NULL,
  jumlah       INT NOT NULL,
  harga_satuan DECIMAL(10, 2) NOT NULL
);

-- 6) PEMBELIAN : kepala SATU kali pembelian ke supplier.
CREATE TABLE pembelian (
  no_pembelian VARCHAR(12) PRIMARY KEY,
  tanggal      DATE NOT NULL,
  id_kasir     INT NOT NULL,
  id_supplier  INT NOT NULL
);

-- 7) DETAIL PEMBELIAN : isi pembelian (harga_beli + nama ikut snapshot).
CREATE TABLE detail_pembelian (
  id_detail    INT AUTO_INCREMENT PRIMARY KEY,
  no_pembelian VARCHAR(12) NOT NULL,
  kode_produk  VARCHAR(10) NOT NULL,
  nama_produk  VARCHAR(50) NOT NULL,
  jumlah       INT NOT NULL,
  harga_beli   DECIMAL(10, 2) NOT NULL
);

-- 8) STOK : KARTU STOK per barang (seperti buku tabungan gudang).
--    Setiap barang dibuka baris pertama 'Stok awal' (tanggal 31-08),
--    lalu mutasi disusun KRONOLOGIS. Tiap baris menyimpan saldonya:
--      * saldo_awal  = sisa sebelum baris ini
--      * saldo_akhir = sisa setelah baris ini = saldo_awal + masuk - keluar
--    * no_pembelian -> penyebab stok MASUK
--    * no_penjualan -> penyebab stok KELUAR (jejak = tugas 5)
CREATE TABLE stok (
  id_stok       INT AUTO_INCREMENT PRIMARY KEY,
  kode_produk   VARCHAR(10) NOT NULL,
  tanggal       DATE NOT NULL,
  jumlah_masuk  INT DEFAULT 0,
  jumlah_keluar INT DEFAULT 0,
  saldo_awal    INT DEFAULT 0,
  saldo_akhir   INT DEFAULT 0,
  no_penjualan  VARCHAR(12) NULL,
  no_pembelian  VARCHAR(12) NULL,
  keterangan    VARCHAR(50)
);

-- ============================================================
-- DATA MASTER
-- ============================================================

INSERT INTO kasir (nama_kasir, status, tanggal_keluar) VALUES
('Anna',  'aktif',    NULL),
('Budi',  'nonaktif', '2026-09-15'),
('Citra', 'aktif',    NULL),
('Dewi',  'aktif',    NULL);

INSERT INTO supplier (nama_supplier, kota) VALUES
('PT Sinar Pangan',    'Surabaya'),
('CV Nusantara Dagang','Jakarta'),
('PT Berkah Makmur',   'Semarang');

INSERT INTO produk (kode_produk, nama_produk, harga_beli, harga_jual, stok_awal) VALUES
('BRG001', 'Indomie Goreng Rasa Ayam', 2500.00,  4200.00, 100),  -- nama & harga SUDAH berubah
('BRG002', 'Indomie Kuah Soto',        3000.00,  3500.00,  80),
('BRG003', 'Teh Botol Sosro 350ml',    4000.00,  5000.00,  40),
('BRG004', 'Aqua Botol 600ml',         2500.00,  3500.00,  60),
('BRG005', 'Chitato Sapi Panggang',    8500.00,  10500.00, 30),
('BRG006', 'SilverQueen Cashew 62g',   13500.00, 16000.00, 20),
('BRG007', 'Energen Cokelat',          2000.00,  2800.00,  40),
('BRG008', 'Roma Kelapa 13 pcs',       10000.00, 12500.00, 25),
('BRG009', 'Roti Sobek Cokelat',       10500.00, 13000.00, 20),
('BRG010', 'Beras 5 kg',               55000.00, 62000.00, 20),
('BRG011', 'Minyak Goreng 1 L',        13000.00, 15000.00, 30),
('BRG012', 'Telur 1 kg',               24000.00, 28000.00, 25),
('BRG013', 'Gula Pasir 1 kg',          15500.00, 18000.00, 30),
('BRG014', 'Tepung Terigu 1 kg',       18000.00, 21000.00, 20),
('BRG015', 'Ultra Milk Cokelat 250ml', 4500.00,  5500.00,  35),
('BRG016', 'Pocari Sweat 500ml',       5500.00,  7000.00,  30),
('BRG017', 'Indomilk Kental Manis',    12000.00, 14500.00, 15),
('BRG018', 'Kopi Kapal Api 250g',      9000.00,  11000.00, 25),
('BRG019', 'Mi Sedaap Goreng',         2500.00,  3300.00,  60),
('BRG020', 'Sari Roti Tawar',          12000.00, 14500.00, 15);

-- ============================================================
-- PEMBELIAN (gudang masuk)
-- ============================================================

INSERT INTO pembelian (no_pembelian, tanggal, id_kasir, id_supplier) VALUES
('PB-0001', '2026-09-01', 1, 1),   -- Anna, PT Sinar Pangan (sembako)
('PB-0002', '2026-09-05', 1, 2),   -- Anna, CV Nusantara (mie/snack/minuman) -> BRG001 masih nama lama
('PB-0003', '2026-09-12', 3, 1),   -- Citra, PT Sinar Pangan (sembako lagi)
('PB-0004', '2026-09-15', 4, 2);   -- Dewi, CV Nusantara -> BRG001 SUDAH nama baru

INSERT INTO detail_pembelian (no_pembelian, kode_produk, nama_produk, jumlah, harga_beli) VALUES
-- PB-0001 (09-01): sembako
('PB-0001', 'BRG010', 'Beras 5 kg',          10, 55000.00),
('PB-0001', 'BRG011', 'Minyak Goreng 1 L',   20, 13000.00),
('PB-0001', 'BRG012', 'Telur 1 kg',          15, 24000.00),
('PB-0001', 'BRG013', 'Gula Pasir 1 kg',     20, 15500.00),
('PB-0001', 'BRG014', 'Tepung Terigu 1 kg',  10, 18000.00),
-- PB-0002 (09-05): mie, snack, minuman (nama BRG001 masih lama)
('PB-0002', 'BRG001', 'Indomie Goreng',           50, 2500.00),
('PB-0002', 'BRG002', 'Indomie Kuah Soto',        40, 3000.00),
('PB-0002', 'BRG003', 'Teh Botol Sosro 350ml',    25, 4000.00),
('PB-0002', 'BRG004', 'Aqua Botol 600ml',         30, 2500.00),
('PB-0002', 'BRG005', 'Chitato Sapi Panggang',    15, 8500.00),
('PB-0002', 'BRG006', 'SilverQueen Cashew 62g',   10, 13500.00),
('PB-0002', 'BRG007', 'Energen Cokelat',          25, 2000.00),
('PB-0002', 'BRG008', 'Roma Kelapa 13 pcs',       20, 10000.00),
('PB-0002', 'BRG015', 'Ultra Milk Cokelat 250ml', 15, 4500.00),
('PB-0002', 'BRG016', 'Pocari Sweat 500ml',       20, 5500.00),
('PB-0002', 'BRG017', 'Indomilk Kental Manis',    10, 12000.00),
('PB-0002', 'BRG018', 'Kopi Kapal Api 250g',      15, 9000.00),
('PB-0002', 'BRG019', 'Mi Sedaap Goreng',         30, 2500.00),
('PB-0002', 'BRG020', 'Sari Roti Tawar',          10, 12000.00),
-- PB-0003 (09-12): sembako lagi
('PB-0003', 'BRG010', 'Beras 5 kg',          15, 55000.00),
('PB-0003', 'BRG011', 'Minyak Goreng 1 L',   15, 13000.00),
('PB-0003', 'BRG012', 'Telur 1 kg',          10, 24000.00),
('PB-0003', 'BRG013', 'Gula Pasir 1 kg',     15, 15500.00),
('PB-0003', 'BRG014', 'Tepung Terigu 1 kg',  10, 18000.00),
-- PB-0004 (09-15): restok mie/snack (BRG001 SUDAH nama baru)
('PB-0004', 'BRG001', 'Indomie Goreng Rasa Ayam', 30, 2500.00),
('PB-0004', 'BRG002', 'Indomie Kuah Soto',        20, 3000.00),
('PB-0004', 'BRG005', 'Chitato Sapi Panggang',    10, 8500.00),
('PB-0004', 'BRG007', 'Energen Cokelat',          20, 2000.00),
('PB-0004', 'BRG009', 'Roti Sobek Cokelat',       10, 10500.00),
('PB-0004', 'BRG019', 'Mi Sedaap Goreng',         20, 2500.00);

-- ============================================================
-- PENJUALAN (nota) — SEBELUM + SESUDAH perubahan BRG001
-- ============================================================

INSERT INTO penjualan (no_penjualan, tanggal, id_kasir, metode_bayar) VALUES
('PJ-0001', '2026-09-01', 1, 'Tunai'),   -- Anna
('PJ-0002', '2026-09-02', 2, 'Tunai'),   -- Budi
('PJ-0003', '2026-09-02', 2, 'QRIS'),    -- Budi
('PJ-0004', '2026-09-03', 1, 'Tunai'),   -- Anna
('PJ-0005', '2026-09-05', 3, 'Debit'),   -- Citra
('PJ-0006', '2026-09-07', 1, 'Tunai'),   -- Anna
('PJ-0007', '2026-09-09', 2, 'Tunai'),   -- Budi
('PJ-0008', '2026-09-10', 3, 'QRIS'),    -- Citra  <- HARI PERUBAHAN harga & nama BRG001
('PJ-0009', '2026-09-12', 4, 'Debit'),   -- Dewi
('PJ-0010', '2026-09-15', 1, 'Tunai'),   -- Anna
('PJ-0011', '2026-09-17', 3, 'Tunai'),   -- Citra
('PJ-0012', '2026-09-18', 4, 'QRIS'),    -- Dewi
('PJ-0013', '2026-09-20', 1, 'Tunai'),   -- Anna
('PJ-0014', '2026-09-21', 3, 'Tunai');   -- Citra

INSERT INTO detail_penjualan (no_penjualan, kode_produk, nama_produk, jumlah, harga_satuan) VALUES
-- PJ-0001 (09-01, Anna) — pakai SNAPSHOT LAMA
('PJ-0001', 'BRG001', 'Indomie Goreng',         2, 3500.00),
('PJ-0001', 'BRG003', 'Teh Botol Sosro 350ml',  1, 5000.00),
('PJ-0001', 'BRG012', 'Telur 1 kg',             1, 28000.00),
-- PJ-0002 (09-02, Budi) — pakai SNAPSHOT LAMA
('PJ-0002', 'BRG001', 'Indomie Goreng',        1, 3500.00),
('PJ-0002', 'BRG010', 'Beras 5 kg',            1, 62000.00),
('PJ-0002', 'BRG004', 'Aqua Botol 600ml',      2, 3500.00),
-- PJ-0003 (09-02, Budi)
('PJ-0003', 'BRG011', 'Minyak Goreng 1 L',    2, 15000.00),
('PJ-0003', 'BRG013', 'Gula Pasir 1 kg',      1, 18000.00),
-- PJ-0004 (09-03, Anna)
('PJ-0004', 'BRG005', 'Chitato Sapi Panggang',    1, 10500.00),
('PJ-0004', 'BRG007', 'Energen Cokelat',          2, 2800.00),
('PJ-0004', 'BRG015', 'Ultra Milk Cokelat 250ml', 1, 5500.00),
-- PJ-0005 (09-05, Citra)
('PJ-0005', 'BRG002', 'Indomie Kuah Soto',        3, 3500.00),
('PJ-0005', 'BRG019', 'Mi Sedaap Goreng',         2, 3300.00),
('PJ-0005', 'BRG008', 'Roma Kelapa 13 pcs',       1, 12500.00),
-- PJ-0006 (09-07, Anna)
('PJ-0006', 'BRG004', 'Aqua Botol 600ml',         4, 3500.00),
('PJ-0006', 'BRG017', 'Indomilk Kental Manis',    1, 14500.00),
-- PJ-0007 (09-09, Budi)
('PJ-0007', 'BRG014', 'Tepung Terigu 1 kg',       1, 21000.00),
('PJ-0007', 'BRG013', 'Gula Pasir 1 kg',          2, 18000.00),
('PJ-0007', 'BRG020', 'Sari Roti Tawar',          1, 14500.00),
-- PJ-0008 (09-10, Citra) — HARI PERTAMA pakai SNAPSHOT BARU
('PJ-0008', 'BRG001', 'Indomie Goreng Rasa Ayam', 3, 4200.00),
('PJ-0008', 'BRG003', 'Teh Botol Sosro 350ml',    2, 5000.00),
('PJ-0008', 'BRG006', 'SilverQueen Cashew 62g',   1, 16000.00),
-- PJ-0009 (09-12, Dewi)
('PJ-0009', 'BRG001', 'Indomie Goreng Rasa Ayam', 2, 4200.00),
('PJ-0009', 'BRG005', 'Chitato Sapi Panggang',    1, 10500.00),
('PJ-0009', 'BRG016', 'Pocari Sweat 500ml',       1, 7000.00),
-- PJ-0010 (09-15, Anna)
('PJ-0010', 'BRG010', 'Beras 5 kg',               1, 62000.00),
('PJ-0010', 'BRG011', 'Minyak Goreng 1 L',        1, 15000.00),
('PJ-0010', 'BRG012', 'Telur 1 kg',               2, 28000.00),
-- PJ-0011 (09-17, Citra)
('PJ-0011', 'BRG002', 'Indomie Kuah Soto',        2, 3500.00),
('PJ-0011', 'BRG007', 'Energen Cokelat',          3, 2800.00),
('PJ-0011', 'BRG015', 'Ultra Milk Cokelat 250ml', 2, 5500.00),
-- PJ-0012 (09-18, Dewi)
('PJ-0012', 'BRG004', 'Aqua Botol 600ml',         3, 3500.00),
('PJ-0012', 'BRG019', 'Mi Sedaap Goreng',         2, 3300.00),
('PJ-0012', 'BRG018', 'Kopi Kapal Api 250g',      1, 11000.00),
-- PJ-0013 (09-20, Anna)
('PJ-0013', 'BRG001', 'Indomie Goreng Rasa Ayam', 3, 4200.00),
('PJ-0013', 'BRG014', 'Tepung Terigu 1 kg',       1, 21000.00),
('PJ-0013', 'BRG020', 'Sari Roti Tawar',          1, 14500.00),
-- PJ-0014 (09-21, Citra)
('PJ-0014', 'BRG001', 'Indomie Goreng Rasa Ayam', 1, 4200.00),
('PJ-0014', 'BRG003', 'Teh Botol Sosro 350ml',    2, 5000.00),
('PJ-0014', 'BRG013', 'Gula Pasir 1 kg',          1, 18000.00),
('PJ-0014', 'BRG016', 'Pocari Sweat 500ml',       2, 7000.00);

-- ============================================================
-- STOK : KARTU STOK per barang (kronologis, saldo berjalan)
-- ============================================================
-- Tiap produk = 1 blok. Baris pertama 'Stok awal' (31-08), lalu mutasi
-- diurutkan per tanggal. Bila tanggal sama, MASUK (pembelian) didahulukan
-- daripada KELUAR (penjualan). saldo_akhir baris terakhir = stok akhir.

INSERT INTO stok (kode_produk, tanggal, jumlah_masuk, jumlah_keluar,
                  saldo_awal, saldo_akhir, no_penjualan, no_pembelian,
                  keterangan) VALUES
-- ============ BRG001 Indomie Goreng Rasa Ayam (stok awal 100) ============
('BRG001', '2026-08-31', 100, 0, 0,   100,  NULL,     NULL, 'Stok awal'),
('BRG001', '2026-09-01', 0,   2, 100, 98,   'PJ-0001', NULL, 'Terjual (PJ-0001)'),
('BRG001', '2026-09-02', 0,   1, 98,  97,   'PJ-0002', NULL, 'Terjual (PJ-0002)'),
('BRG001', '2026-09-05', 50,  0, 97,  147,  NULL,     'PB-0002', 'Beli dari supplier'),
('BRG001', '2026-09-10', 0,   3, 147, 144,  'PJ-0008', NULL, 'Terjual (PJ-0008)'),
('BRG001', '2026-09-12', 0,   2, 144, 142,  'PJ-0009', NULL, 'Terjual (PJ-0009)'),
('BRG001', '2026-09-15', 30,  0, 142, 172,  NULL,     'PB-0004', 'Beli dari supplier'),
('BRG001', '2026-09-20', 0,   3, 172, 169,  'PJ-0013', NULL, 'Terjual (PJ-0013)'),
('BRG001', '2026-09-21', 0,   1, 169, 168,  'PJ-0014', NULL, 'Terjual (PJ-0014)'),
-- ============ BRG002 Indomie Kuah Soto (stok awal 80) ============
('BRG002', '2026-08-31', 80,  0, 0,   80,   NULL,     NULL, 'Stok awal'),
('BRG002', '2026-09-05', 40,  0, 80,  120,  NULL,     'PB-0002', 'Beli dari supplier'),
('BRG002', '2026-09-05', 0,   3, 120, 117,  'PJ-0005', NULL, 'Terjual (PJ-0005)'),
('BRG002', '2026-09-15', 20,  0, 117, 137,  NULL,     'PB-0004', 'Beli dari supplier'),
('BRG002', '2026-09-17', 0,   2, 137, 135,  'PJ-0011', NULL, 'Terjual (PJ-0011)'),
-- ============ BRG003 Teh Botol Sosro 350ml (stok awal 40) ============
('BRG003', '2026-08-31', 40,  0, 0,   40,   NULL,     NULL, 'Stok awal'),
('BRG003', '2026-09-01', 0,   1, 40,  39,   'PJ-0001', NULL, 'Terjual (PJ-0001)'),
('BRG003', '2026-09-05', 25,  0, 39,  64,   NULL,     'PB-0002', 'Beli dari supplier'),
('BRG003', '2026-09-10', 0,   2, 64,  62,   'PJ-0008', NULL, 'Terjual (PJ-0008)'),
('BRG003', '2026-09-21', 0,   2, 62,  60,   'PJ-0014', NULL, 'Terjual (PJ-0014)'),
-- ============ BRG004 Aqua Botol 600ml (stok awal 60) ============
('BRG004', '2026-08-31', 60,  0, 0,   60,   NULL,     NULL, 'Stok awal'),
('BRG004', '2026-09-02', 0,   2, 60,  58,   'PJ-0002', NULL, 'Terjual (PJ-0002)'),
('BRG004', '2026-09-05', 30,  0, 58,  88,   NULL,     'PB-0002', 'Beli dari supplier'),
('BRG004', '2026-09-07', 0,   4, 88,  84,   'PJ-0006', NULL, 'Terjual (PJ-0006)'),
('BRG004', '2026-09-18', 0,   3, 84,  81,   'PJ-0012', NULL, 'Terjual (PJ-0012)'),
-- ============ BRG005 Chitato Sapi Panggang (stok awal 30) ============
('BRG005', '2026-08-31', 30,  0, 0,   30,   NULL,     NULL, 'Stok awal'),
('BRG005', '2026-09-03', 0,   1, 30,  29,   'PJ-0004', NULL, 'Terjual (PJ-0004)'),
('BRG005', '2026-09-05', 15,  0, 29,  44,   NULL,     'PB-0002', 'Beli dari supplier'),
('BRG005', '2026-09-12', 0,   1, 44,  43,   'PJ-0009', NULL, 'Terjual (PJ-0009)'),
('BRG005', '2026-09-15', 10,  0, 43,  53,   NULL,     'PB-0004', 'Beli dari supplier'),
-- ============ BRG006 SilverQueen Cashew 62g (stok awal 20) ============
('BRG006', '2026-08-31', 20,  0, 0,   20,   NULL,     NULL, 'Stok awal'),
('BRG006', '2026-09-05', 10,  0, 20,  30,   NULL,     'PB-0002', 'Beli dari supplier'),
('BRG006', '2026-09-10', 0,   1, 30,  29,   'PJ-0008', NULL, 'Terjual (PJ-0008)'),
-- ============ BRG007 Energen Cokelat (stok awal 40) ============
('BRG007', '2026-08-31', 40,  0, 0,   40,   NULL,     NULL, 'Stok awal'),
('BRG007', '2026-09-03', 0,   2, 40,  38,   'PJ-0004', NULL, 'Terjual (PJ-0004)'),
('BRG007', '2026-09-05', 25,  0, 38,  63,   NULL,     'PB-0002', 'Beli dari supplier'),
('BRG007', '2026-09-15', 20,  0, 63,  83,   NULL,     'PB-0004', 'Beli dari supplier'),
('BRG007', '2026-09-17', 0,   3, 83,  80,   'PJ-0011', NULL, 'Terjual (PJ-0011)'),
-- ============ BRG008 Roma Kelapa 13 pcs (stok awal 25) ============
('BRG008', '2026-08-31', 25,  0, 0,   25,   NULL,     NULL, 'Stok awal'),
('BRG008', '2026-09-05', 20,  0, 25,  45,   NULL,     'PB-0002', 'Beli dari supplier'),
('BRG008', '2026-09-05', 0,   1, 45,  44,   'PJ-0005', NULL, 'Terjual (PJ-0005)'),
-- ============ BRG009 Roti Sobek Cokelat (stok awal 20) ============
('BRG009', '2026-08-31', 20,  0, 0,   20,   NULL,     NULL, 'Stok awal'),
('BRG009', '2026-09-15', 10,  0, 20,  30,   NULL,     'PB-0004', 'Beli dari supplier'),
-- ============ BRG010 Beras 5 kg (stok awal 20) ============
('BRG010', '2026-08-31', 20,  0, 0,   20,   NULL,     NULL, 'Stok awal'),
('BRG010', '2026-09-01', 10,  0, 20,  30,   NULL,     'PB-0001', 'Beli dari supplier'),
('BRG010', '2026-09-02', 0,   1, 30,  29,   'PJ-0002', NULL, 'Terjual (PJ-0002)'),
('BRG010', '2026-09-12', 15,  0, 29,  44,   NULL,     'PB-0003', 'Beli dari supplier'),
('BRG010', '2026-09-15', 0,   1, 44,  43,   'PJ-0010', NULL, 'Terjual (PJ-0010)'),
-- ============ BRG011 Minyak Goreng 1 L (stok awal 30) ============
('BRG011', '2026-08-31', 30,  0, 0,   30,   NULL,     NULL, 'Stok awal'),
('BRG011', '2026-09-01', 20,  0, 30,  50,   NULL,     'PB-0001', 'Beli dari supplier'),
('BRG011', '2026-09-02', 0,   2, 50,  48,   'PJ-0003', NULL, 'Terjual (PJ-0003)'),
('BRG011', '2026-09-12', 15,  0, 48,  63,   NULL,     'PB-0003', 'Beli dari supplier'),
('BRG011', '2026-09-15', 0,   1, 63,  62,   'PJ-0010', NULL, 'Terjual (PJ-0010)'),
-- ============ BRG012 Telur 1 kg (stok awal 25) ============
('BRG012', '2026-08-31', 25,  0, 0,   25,   NULL,     NULL, 'Stok awal'),
('BRG012', '2026-09-01', 15,  0, 25,  40,   NULL,     'PB-0001', 'Beli dari supplier'),
('BRG012', '2026-09-01', 0,   1, 40,  39,   'PJ-0001', NULL, 'Terjual (PJ-0001)'),
('BRG012', '2026-09-12', 10,  0, 39,  49,   NULL,     'PB-0003', 'Beli dari supplier'),
('BRG012', '2026-09-15', 0,   2, 49,  47,   'PJ-0010', NULL, 'Terjual (PJ-0010)'),
-- ============ BRG013 Gula Pasir 1 kg (stok awal 30) ============
('BRG013', '2026-08-31', 30,  0, 0,   30,   NULL,     NULL, 'Stok awal'),
('BRG013', '2026-09-01', 20,  0, 30,  50,   NULL,     'PB-0001', 'Beli dari supplier'),
('BRG013', '2026-09-02', 0,   1, 50,  49,   'PJ-0003', NULL, 'Terjual (PJ-0003)'),
('BRG013', '2026-09-09', 0,   2, 49,  47,   'PJ-0007', NULL, 'Terjual (PJ-0007)'),
('BRG013', '2026-09-12', 15,  0, 47,  62,   NULL,     'PB-0003', 'Beli dari supplier'),
('BRG013', '2026-09-21', 0,   1, 62,  61,   'PJ-0014', NULL, 'Terjual (PJ-0014)'),
-- ============ BRG014 Tepung Terigu 1 kg (stok awal 20) ============
('BRG014', '2026-08-31', 20,  0, 0,   20,   NULL,     NULL, 'Stok awal'),
('BRG014', '2026-09-01', 10,  0, 20,  30,   NULL,     'PB-0001', 'Beli dari supplier'),
('BRG014', '2026-09-09', 0,   1, 30,  29,   'PJ-0007', NULL, 'Terjual (PJ-0007)'),
('BRG014', '2026-09-12', 10,  0, 29,  39,   NULL,     'PB-0003', 'Beli dari supplier'),
('BRG014', '2026-09-20', 0,   1, 39,  38,   'PJ-0013', NULL, 'Terjual (PJ-0013)'),
-- ============ BRG015 Ultra Milk Cokelat 250ml (stok awal 35) ============
('BRG015', '2026-08-31', 35,  0, 0,   35,   NULL,     NULL, 'Stok awal'),
('BRG015', '2026-09-03', 0,   1, 35,  34,   'PJ-0004', NULL, 'Terjual (PJ-0004)'),
('BRG015', '2026-09-05', 15,  0, 34,  49,   NULL,     'PB-0002', 'Beli dari supplier'),
('BRG015', '2026-09-17', 0,   2, 49,  47,   'PJ-0011', NULL, 'Terjual (PJ-0011)'),
-- ============ BRG016 Pocari Sweat 500ml (stok awal 30) ============
('BRG016', '2026-08-31', 30,  0, 0,   30,   NULL,     NULL, 'Stok awal'),
('BRG016', '2026-09-05', 20,  0, 30,  50,   NULL,     'PB-0002', 'Beli dari supplier'),
('BRG016', '2026-09-12', 0,   1, 50,  49,   'PJ-0009', NULL, 'Terjual (PJ-0009)'),
('BRG016', '2026-09-21', 0,   2, 49,  47,   'PJ-0014', NULL, 'Terjual (PJ-0014)'),
-- ============ BRG017 Indomilk Kental Manis (stok awal 15) ============
('BRG017', '2026-08-31', 15,  0, 0,   15,   NULL,     NULL, 'Stok awal'),
('BRG017', '2026-09-05', 10,  0, 15,  25,   NULL,     'PB-0002', 'Beli dari supplier'),
('BRG017', '2026-09-07', 0,   1, 25,  24,   'PJ-0006', NULL, 'Terjual (PJ-0006)'),
-- ============ BRG018 Kopi Kapal Api 250g (stok awal 25) ============
('BRG018', '2026-08-31', 25,  0, 0,   25,   NULL,     NULL, 'Stok awal'),
('BRG018', '2026-09-05', 15,  0, 25,  40,   NULL,     'PB-0002', 'Beli dari supplier'),
('BRG018', '2026-09-18', 0,   1, 40,  39,   'PJ-0012', NULL, 'Terjual (PJ-0012)'),
-- ============ BRG019 Mi Sedaap Goreng (stok awal 60) ============
('BRG019', '2026-08-31', 60,  0, 0,   60,   NULL,     NULL, 'Stok awal'),
('BRG019', '2026-09-05', 30,  0, 60,  90,   NULL,     'PB-0002', 'Beli dari supplier'),
('BRG019', '2026-09-05', 0,   2, 90,  88,   'PJ-0005', NULL, 'Terjual (PJ-0005)'),
('BRG019', '2026-09-15', 20,  0, 88,  108,  NULL,     'PB-0004', 'Beli dari supplier'),
('BRG019', '2026-09-18', 0,   2, 108, 106,  'PJ-0012', NULL, 'Terjual (PJ-0012)'),
-- ============ BRG020 Sari Roti Tawar (stok awal 15) ============
('BRG020', '2026-08-31', 15,  0, 0,   15,   NULL,     NULL, 'Stok awal'),
('BRG020', '2026-09-05', 10,  0, 15,  25,   NULL,     'PB-0002', 'Beli dari supplier'),
('BRG020', '2026-09-09', 0,   1, 25,  24,   'PJ-0007', NULL, 'Terjual (PJ-0007)'),
('BRG020', '2026-09-20', 0,   1, 24,  23,   'PJ-0013', NULL, 'Terjual (PJ-0013)');

-- ============================================================
-- SELESAI. Database + data jadi. Lanjut ke kunci_query_penjualan.sql
-- ============================================================