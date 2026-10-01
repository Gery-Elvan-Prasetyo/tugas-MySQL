-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Oct 01, 2026 at 12:44 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `armory_pplg`
--

-- --------------------------------------------------------

--
-- Table structure for table `detail_penjualan`
--

CREATE TABLE `detail_penjualan` (
  `no_penjualan` varchar(50) NOT NULL,
  `id_barang` varchar(50) NOT NULL,
  `nama_barang_snapshot` varchar(100) DEFAULT NULL,
  `harga_satuan` decimal(15,2) NOT NULL,
  `QTY` int(11) NOT NULL,
  `subtotal` decimal(15,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `detail_penjualan`
--

INSERT INTO `detail_penjualan` (`no_penjualan`, `id_barang`, `nama_barang_snapshot`, `harga_satuan`, `QTY`, `subtotal`) VALUES
('TX-001', 'ASS-01', 'ASS-01', 12000000.00, 1, 48000000.00),
('TX-001', 'ASS-02', 'ASS-02', 4625000.00, 2, 37000000.00),
('TX-001', 'ASS-03', 'ASS-03', 162500.00, 2, 1300000.00),
('TX-001', 'ASS-04', 'ASS-04', 112500.00, 5, 2250000.00),
('TX-001', 'ASS-05', 'ASS-05', 5250000.00, 2, 42000000.00),
('TX-001', 'ASS-06', 'ASS-06', 2000000.00, 2, 16000000.00),
('TX-001', 'ASS-07', 'ASS-07', 3375000.00, 1, 13500000.00),
('TX-002', 'ASS-02', 'ASS-02', 4625000.00, 4, 74000000.00),
('TX-002', 'ASS-06', 'ASS-06', 2000000.00, 2, 16000000.00),
('TX-003', 'ASS-07', 'ASS-07', 3375000.00, 1, 13500000.00),
('TX-004', 'ASS-01', 'ASS-01', 12000000.00, 2, 96000000.00),
('TX-004', 'ASS-03', 'ASS-03', 162500.00, 4, 2600000.00),
('TX-004', 'ASS-04', 'ASS-04', 112500.00, 2, 900000.00),
('TX-005', 'ASS-05', 'ASS-05', 5250000.00, 2, 42000000.00),
('TX-006', 'ASS-01', 'ASS-01', 12000000.00, 1, 48000000.00),
('TX-007', 'ASS-03', 'ASS-03', 162500.00, 2, 1300000.00),
('TX-007', 'ASS-04', 'ASS-04', 112500.00, 2, 900000.00),
('TX-007', 'ASS-07', 'ASS-07', 3375000.00, 6, 81000000.00),
('TX-008', 'ASS-04', 'ASS-04', 112500.00, 5, 2250000.00),
('TX-009', 'ASS-05', 'ASS-05', 5250000.00, 3, 63000000.00),
('TX-010', 'ASS-01', 'ASS-01', 12000000.00, 1, 48000000.00),
('TX-010', 'ASS-04', 'ASS-04', 112500.00, 4, 1800000.00);

-- --------------------------------------------------------

--
-- Table structure for table `karyawan`
--

CREATE TABLE `karyawan` (
  `id_pegawai` varchar(50) NOT NULL,
  `nama` varchar(50) NOT NULL,
  `passw` varchar(50) NOT NULL,
  `role` varchar(50) NOT NULL,
  `status` enum('Aktif','Non-Aktif') DEFAULT 'Aktif'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `karyawan`
--

INSERT INTO `karyawan` (`id_pegawai`, `nama`, `passw`, `role`, `status`) VALUES
('PEG01', 'Sersan Gery', 'tactical6767', 'Armorer / Kasir', 'Aktif'),
('PEG02', 'Vladimir Alfredo', 'raidersafe', 'Armorer / Kasir', 'Aktif');

-- --------------------------------------------------------

--
-- Table structure for table `pelanggan`
--

CREATE TABLE `pelanggan` (
  `id_pelanggan` varchar(50) NOT NULL,
  `nama_pelanggan` varchar(100) NOT NULL,
  `no_hp` varchar(20) DEFAULT NULL,
  `alamat` varchar(250) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `pelanggan`
--

INSERT INTO `pelanggan` (`id_pelanggan`, `nama_pelanggan`, `no_hp`, `alamat`) VALUES
('CASH', 'UMUM / CASH', '-', '-'),
('STARK', 'TONY STARK (VIP)', '+628199887766', 'Sudirman, Jakarta Selatan'),
('UMJM', 'USAHA MAJU JAYA MANDIRI', '+628123456789', 'Kavling Pertahanan, Jakarta');

-- --------------------------------------------------------

--
-- Table structure for table `penjualan`
--

CREATE TABLE `penjualan` (
  `no_penjualan` varchar(50) NOT NULL,
  `tanggal` datetime NOT NULL,
  `total_harga` decimal(15,2) NOT NULL,
  `metode_bayar` varchar(50) NOT NULL,
  `id_pegawai` varchar(50) DEFAULT NULL,
  `id_toko` int(11) DEFAULT NULL,
  `id_pelanggan` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `penjualan`
--

INSERT INTO `penjualan` (`no_penjualan`, `tanggal`, `total_harga`, `metode_bayar`, `id_pegawai`, `id_toko`, `id_pelanggan`) VALUES
('TX-001', '2026-09-25 10:00:00', 161850000.00, 'Transfer Bank', 'PEG01', 1, 'UMJM'),
('TX-002', '2026-09-25 10:30:00', 90000000.00, 'Transfer Bank', 'PEG01', 1, 'UMJM'),
('TX-003', '2026-09-25 11:15:00', 13500000.00, 'Kartu Kredit', 'PEG02', 1, 'STARK'),
('TX-004', '2026-09-25 12:00:00', 140300000.00, 'Transfer Bank', 'PEG01', 1, 'UMJM'),
('TX-005', '2026-09-25 13:45:00', 42000000.00, 'Kartu Kredit', 'PEG02', 1, 'CASH'),
('TX-006', '2026-09-25 14:20:00', 48000000.00, 'Transfer Bank', 'PEG01', 1, 'CASH'),
('TX-007', '2026-09-25 15:00:00', 84000000.00, 'Kartu Kredit', 'PEG02', 1, 'STARK'),
('TX-008', '2026-09-25 16:10:00', 2250000.00, 'Kartu Kredit', 'PEG01', 1, 'CASH'),
('TX-009', '2026-09-25 17:00:00', 63000000.00, 'Transfer Bank', 'PEG02', 1, 'UMJM'),
('TX-010', '2026-09-25 18:30:00', 49800000.00, 'Kartu Kredit', 'PEG01', 1, 'CASH');

-- --------------------------------------------------------

--
-- Table structure for table `produk`
--

CREATE TABLE `produk` (
  `id_barang` varchar(20) NOT NULL,
  `nama_barang` varchar(100) NOT NULL,
  `harga_beli` decimal(15,2) NOT NULL,
  `harga_jual` decimal(15,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `produk`
--

INSERT INTO `produk` (`id_barang`, `nama_barang`, `harga_beli`, `harga_jual`) VALUES
('ASS-01', 'Senapan Serbu AR-15 Carbine 5.56mm', 35000000.00, 96000000.00),
('ASS-02', 'Pistol Semi-Otomatis Glock 19 Gen 5 9mm', 12000000.00, 37000000.00),
('ASS-03', 'Amunisi Kaliber 5.56x45mm NATO (Box isi 50)', 450000.00, 1300000.00),
('ASS-04', 'Amunisi Kaliber 9x19mm Parabellum (Box isi 50)', 300000.00, 900000.00),
('ASS-05', 'Teropong Bidik Holographic Sight EOTech', 15000000.00, 42000000.00),
('ASS-06', 'Peredam Suara (Suppressor) Taktis 9mm', 5500000.00, 16000000.00),
('ASS-07', 'Rompi Anti Peluru Plate Carrier Level IV', 9000000.00, 27000000.00);

-- --------------------------------------------------------

--
-- Table structure for table `stok`
--

CREATE TABLE `stok` (
  `id_stok` int(11) NOT NULL,
  `id_barang` varchar(50) NOT NULL,
  `stok_awal` int(11) NOT NULL,
  `jumlah_masuk` int(11) DEFAULT 0,
  `jumlah_keluar` int(11) DEFAULT 0,
  `keterangan` varchar(255) DEFAULT NULL,
  `no_penjualan` varchar(50) DEFAULT NULL,
  `tanggal_mutasi` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `stok`
--

INSERT INTO `stok` (`id_stok`, `id_barang`, `stok_awal`, `jumlah_masuk`, `jumlah_keluar`, `keterangan`, `no_penjualan`, `tanggal_mutasi`) VALUES
(1, 'ASS-01', 50, 0, 5, 'Penjualan Armory Harian', 'TX-001', '2026-09-25 08:00:00'),
(2, 'ASS-02', 80, 0, 6, 'Penjualan Armory Harian', 'TX-001', '2026-09-25 08:00:00'),
(3, 'ASS-03', 500, 0, 8, 'Penjualan Armory Harian', 'TX-001', '2026-09-25 08:00:00'),
(4, 'ASS-04', 1000, 0, 21, 'Penjualan Armory Harian', 'TX-001', '2026-09-25 08:00:00'),
(5, 'ASS-05', 40, 0, 7, 'Penjualan Armory Harian', 'TX-001', '2026-09-25 08:00:00'),
(6, 'ASS-06', 60, 0, 4, 'Penjualan Armory Harian', 'TX-001', '2026-09-25 08:00:00'),
(7, 'ASS-07', 35, 0, 8, 'Penjualan Armory Harian', 'TX-001', '2026-09-25 08:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `toko`
--

CREATE TABLE `toko` (
  `id_toko` int(11) NOT NULL,
  `nama_toko` varchar(100) NOT NULL,
  `alamat` varchar(100) NOT NULL,
  `no_telepon` varchar(15) NOT NULL,
  `email` varchar(100) NOT NULL,
  `website` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `toko`
--

INSERT INTO `toko` (`id_toko`, `nama_toko`, `alamat`, `no_telepon`, `email`, `website`) VALUES
(1, 'ARMORY PROTO-1', 'Bunker Pahoman, Enggal, Lampoeng', '+6281199887766', 'infoinfo@armorydefense.com', 'www.armorydefense.com');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `detail_penjualan`
--
ALTER TABLE `detail_penjualan`
  ADD PRIMARY KEY (`no_penjualan`,`id_barang`),
  ADD KEY `id_barang` (`id_barang`);

--
-- Indexes for table `karyawan`
--
ALTER TABLE `karyawan`
  ADD PRIMARY KEY (`id_pegawai`);

--
-- Indexes for table `pelanggan`
--
ALTER TABLE `pelanggan`
  ADD PRIMARY KEY (`id_pelanggan`);

--
-- Indexes for table `penjualan`
--
ALTER TABLE `penjualan`
  ADD PRIMARY KEY (`no_penjualan`),
  ADD KEY `id_pegawai` (`id_pegawai`),
  ADD KEY `id_toko` (`id_toko`),
  ADD KEY `fk_penjualan_pelanggan` (`id_pelanggan`);

--
-- Indexes for table `produk`
--
ALTER TABLE `produk`
  ADD PRIMARY KEY (`id_barang`);

--
-- Indexes for table `stok`
--
ALTER TABLE `stok`
  ADD PRIMARY KEY (`id_stok`),
  ADD KEY `id_barang` (`id_barang`),
  ADD KEY `fk_stok_penjualan` (`no_penjualan`);

--
-- Indexes for table `toko`
--
ALTER TABLE `toko`
  ADD PRIMARY KEY (`id_toko`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `stok`
--
ALTER TABLE `stok`
  MODIFY `id_stok` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `toko`
--
ALTER TABLE `toko`
  MODIFY `id_toko` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `detail_penjualan`
--
ALTER TABLE `detail_penjualan`
  ADD CONSTRAINT `detail_penjualan_ibfk_1` FOREIGN KEY (`no_penjualan`) REFERENCES `penjualan` (`no_penjualan`),
  ADD CONSTRAINT `detail_penjualan_ibfk_2` FOREIGN KEY (`id_barang`) REFERENCES `produk` (`id_barang`);

--
-- Constraints for table `penjualan`
--
ALTER TABLE `penjualan`
  ADD CONSTRAINT `fk_penjualan_pelanggan` FOREIGN KEY (`id_pelanggan`) REFERENCES `pelanggan` (`id_pelanggan`),
  ADD CONSTRAINT `penjualan_ibfk_1` FOREIGN KEY (`id_pegawai`) REFERENCES `karyawan` (`id_pegawai`),
  ADD CONSTRAINT `penjualan_ibfk_2` FOREIGN KEY (`id_toko`) REFERENCES `toko` (`id_toko`);

--
-- Constraints for table `stok`
--
ALTER TABLE `stok`
  ADD CONSTRAINT `fk_stok_penjualan` FOREIGN KEY (`no_penjualan`) REFERENCES `penjualan` (`no_penjualan`) ON DELETE SET NULL,
  ADD CONSTRAINT `stok_ibfk_1` FOREIGN KEY (`id_barang`) REFERENCES `produk` (`id_barang`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
