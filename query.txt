#STRUK 
USE armory_pplg;

SELECT 
    t.nama_toko AS 'Nama Toko',
    p.no_penjualan AS 'No Nota',
    p.tanggal AS 'Waktu Transaksi',
    k.nama AS 'Nama Kasir',
    p.id_pelanggan AS 'Pel.',                      -- Kode Pelanggan (UMJM, STARK, CASH)
    pl.nama_pelanggan AS 'Nama Pelanggan',
    
    -- Memanggil nama barang sejarah dari kolom snapshot (Jawaban PR Pak Ega)
    dp.nama_barang_snapshot AS 'Item Senjata/Amunisi',
    
    dp.harga_satuan AS 'Harga Satuan',
    dp.QTY AS 'Jumlah Beli',
    dp.subtotal AS 'Subtotal Item',
    p.total_harga AS 'TOTAL AKHIR NOTA',
    p.metode_bayar AS 'Metode Pembayaran'          -- Sudah non-tunai (Transfer/Kartu Kredit)
FROM detail_penjualan dp
JOIN penjualan p ON dp.no_penjualan = p.no_penjualan
JOIN produk pr ON dp.id_barang = pr.id_barang
JOIN karyawan k ON p.id_pegawai = k.id_pegawai
JOIN toko t ON p.id_toko = t.id_toko
LEFT JOIN pelanggan pl ON p.id_pelanggan = pl.id_pelanggan
ORDER BY p.no_penjualan ASC;


#INNER JOIN
USE armory_pplg;

SELECT 
    p.no_penjualan AS 'No Nota',
    p.tanggal AS 'Waktu Transaksi',
    p.id_pelanggan AS 'Kode Pelapor',
    pl.nama_pelanggan AS 'Nama Pembeli',
    p.total_harga AS 'Total Belanja'
FROM penjualan p
INNER JOIN pelanggan pl ON p.id_pelanggan = pl.id_pelanggan;

#LEFT JOIN
USE armory_pplg;

SELECT 
    p.no_penjualan AS 'No Nota',
    p.tanggal AS 'Waktu Transaksi',
    p.id_pelanggan AS 'Kode Pelapor',
    pl.nama_pelanggan AS 'Nama Pembeli',
    p.total_harga AS 'Total Belanja'
FROM penjualan p
LEFT JOIN pelanggan pl ON p.id_pelanggan = pl.id_pelanggan;

#RIGHT JOIN
USE armory_pplg;

SELECT 
    p.no_penjualan AS 'No Nota',
    p.tanggal AS 'Waktu Transaksi',
    pl.id_pelanggan AS 'Kode Pelapor',
    pl.nama_pelanggan AS 'Nama Pembeli',
    p.total_harga AS 'Total Belanja'
FROM penjualan p
RIGHT JOIN pelanggan pl ON p.id_pelanggan = pl.id_pelanggan;

#STOK
SELECT 
    pr.id_barang AS 'Kode Barang',
    pr.nama_barang AS 'Nama Senjata/Perlengkapan',
    pr.harga_jual AS 'Harga Satuan Jual',
    s.stok_awal AS 'Stok Awal Gudang',
    s.jumlah_masuk AS 'Barang Masuk',
    s.jumlah_keluar AS 'Total Terjual',
    (s.stok_awal + s.jumlah_masuk - s.jumlah_keluar) AS 'SISA STOK DISPLAY',
    pr.harga_jual * (s.stok_awal + s.jumlah_masuk - s.jumlah_keluar) as 'nilai stok akhir'
FROM produk pr
JOIN stok s ON pr.id_barang = s.id_barang;

#STOK + TRACKING
USE armory_pplg;

SELECT 
    pr.id_barang AS 'Kode Barang',
    pr.nama_barang AS 'Nama Senjata/Perlengkapan',
    pr.harga_jual AS 'Harga Jual Saat Ini',
    s.stok_awal AS 'Stok Awal Gudang',
    s.jumlah_masuk AS 'Barang Masuk',
    s.jumlah_keluar AS 'Total Terjual',
    
    -- Menghitung sisa stok display secara otomatis lewat rumus
    (s.stok_awal + s.jumlah_masuk - s.jumlah_keluar) AS 'SISA STOK DISPLAY',
    
    -- TRACKING NOTA: Menunjukkan dari transaksi mana stok ini berkurang
    s.no_penjualan AS 'Terlacak Dari Nota',
    s.tanggal_mutasi AS 'Waktu Update Stok',
    s.keterangan AS 'Keterangan Mutasi'
FROM produk pr
JOIN stok s ON pr.id_barang = s.id_barang;


