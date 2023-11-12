/*NOMOR 1
  Selama transaksi yang terjadi selama 2021, pada bulan apa total nilai transaksi
  (after_discount) paling besar? Gunakan is_valid=1 untuk memfilter data transaksi.
  Source = order_detail*/
SELECT 
	SUM(after_discount) AS total_transaksi,
	EXTRACT (MONTH FROM order_date) AS bulan
FROM order_detail
WHERE is_valid=1 AND
EXTRACT (YEAR FROM order_date) = 2021
GROUP BY 2
ORDER BY 1 DESC
LIMIT 1

/*NOMOR 2
	Selama transaksi pada tahun 2022, kategori apa yang menghasilkan nilai transaksi paling
	besar? Gunakan is_valid=1 untuk memfilter data transaksi.
	Source = order_detail, sku_detail
*/
SELECT
	SUM(od.after_discount) AS nilai_transaksi,
	sd.category 
FROM order_detail od
INNER JOIN sku_detail sd ON od.sku_id = sd.id
WHERE od.is_valid=1 AND
EXTRACT (YEAR FROM od.order_date) = 2022
GROUP BY 2
ORDER BY 1 DESC
LIMIT 1

/*NOMOR 3
  Bandingkan nilai transaksi dari masing-masing kategori pada tahun 2021 dengan 2022.
  Sebutkan kategori apa saja yang mengalami penikatan dan kategori apa yang mengalami
  penurunan nilai transaksi dari tahun 2021 ke 2022. Gunakan is_valid=1 untuk memfilter data 
  transaksi.
  Source = order_detail, sku_detail*/

WITH cte AS (
	SELECT
		sd.category AS category,
		SUM(CASE WHEN EXTRACT(YEAR FROM od.order_date)=2021 THEN od.after_discount END) total_sales2021,
		SUM(CASE WHEN EXTRACT(YEAR FROM od.order_date)=2022 THEN od.after_discount END) total_sales2022
	FROM order_detail od
	INNER JOIN sku_detail sd
		ON od.sku_id = sd.id
	WHERE od.is_valid = 1
	GROUP BY 1
)
SELECT 
	cte.category,
	cte.total_sales2022,
	cte.total_sales2021,
	cte.total_sales2022 - cte.total_sales2021 AS Different,
	CASE	WHEN cte.total_sales2022 > cte.total_sales2021 THEN 'peningkatan' 
			WHEN cte.total_sales2022 < cte.total_sales2021 THEN 'penurunan'
	END as growth_value
FROM cte
ORDER BY 2 DESC

/*NOMOR 4
  Tampilkan top 5 metode pembayaran yang paling populer digunakan selama tahun 2022
  (berdasarkan total unique_order). Gunakan is_valid=1 untuk memfilter data transaksi.
  Source = order_detail, payment_detail*/
  
SELECT
	COUNT(DISTINCT od.id) AS Total_Penggunaan,
	pd.payment_method
FROM order_detail od
INNER JOIN payment_detail pd 
	ON od.payment_id = pd.id
WHERE 
	od.is_valid=1 AND
	EXTRACT(YEAR FROM od.order_date)=2022
GROUP BY 2
ORDER BY 1 DESC
LIMIT 5

/*NOMOR 5
  Urutkan dari ke-5 produk ini berdasarkan nilai transaksinya
  1.Samsung
  2.Apple
  3.Sony
  4.Huawei
  5.Lenovo
  Gunakan is_valid=1 untuk memfilter data transaksi
  Source = order_detail, sku_detail*/
SELECT 
	CASE
		WHEN LOWER(sd.sku_name) LIKE '%samsung%' THEN 'Samsung'
		WHEN LOWER(sd.sku_name) LIKE '%apple%' THEN 'Apple'
		WHEN LOWER(sd.sku_name) LIKE '%sony%' THEN 'Sony'
		WHEN LOWER(sd.sku_name) LIKE '%huawei%' THEN 'Huawei'
		WHEN LOWER(sd.sku_name) LIKE '%lenovo%' THEN 'Lenovo'
	END AS item_name,
	SUM(
		CASE
			WHEN LOWER (sd.sku_name) LIKE '%samsung%' THEN od.after_discount
			WHEN LOWER (sd.sku_name) LIKE '%apple%' THEN od.after_discount
			WHEN LOWER (sd.sku_name) LIKE '%sony%' THEN od.after_discount
			WHEN LOWER (sd.sku_name) LIKE '%huawei%' THEN od.after_discount
			WHEN LOWER (sd.sku_name) LIKE '%lenovo%' THEN od.after_discount
			ELSE 0 
		END
	)AS transaction_value
FROM order_detail od
INNER JOIN sku_detail sd
	ON od.sku_id = sd.id
WHERE od.is_valid = 1
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5