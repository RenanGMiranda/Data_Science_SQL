/*PROJETO_SQL*/
/* Query 1: Pega os 20 paises dos clientes que mais gastaram com músicas */
SELECT c.country pais,
	   SUM(i.total) total_gasto
	FROM invoice i
	JOIN customer c
		ON i.customerid = c.customerid
	GROUP BY 1
	ORDER BY 2 DESC
	LIMIT 20;

/* Query 2: Mostra a qtd de cada genero para os 20 paises que mais gastaram com musica */
SELECT g.name genero,
	   COUNT(*) qtd
	FROM track t
	JOIN genre g 
		ON t.genreid = g.genreid
	JOIN invoiceline il 
		ON il.trackid = t.trackid
	JOIN invoice i 
		ON il.invoiceid = i.invoiceid
	WHERE billingcountry IN (SELECT pais
								FROM (SELECT c.country pais,
											 SUM(i.total) total_gasto
										FROM invoice i
										JOIN customer c
											ON i.customerid = c.customerid
										GROUP BY 1
										ORDER BY 2 DESC
										LIMIT 20))
	GROUP BY 1
	ORDER BY 2 DESC
	LIMIT 10;

/* Query 3: Mostra as 10 bandas com quem está escrevendo as músicas de rock */
SELECT art.artistid id_artista,
	   art.name artista,
	   COUNT(t.name) qtd_musicas
	FROM album a
	JOIN artist art
		ON a.artistid = art.artistid 
	JOIN track t
		ON t.albumid = a.albumid
	JOIN genre g
		ON	g.genreid = t.genreid
	WHERE g.name = 'Rock'
	GROUP BY 1, 2
	ORDER BY 3 DESC
	LIMIT 10;

	
/* Query 4: Classifica as TOP 10 bandas de cada gênero (Alternativo & Punk, Latino e Metal) conforme query 2 (tirando o ROCK) como  Banda_baixo_media ou Banda_acima_media conforme média (que foi adquirida conforme query auxiliar) */
SELECT artista,
	   genero,
	   qtd_musicas,
	   CASE WHEN qtd_musicas > 26.2 AND genero = 'Alternative & Punk' THEN 'Banda_acima_media'
			WHEN qtd_musicas < 26.2 AND genero = 'Alternative & Punk' THEN 'Banda_baixo_media'
			WHEN qtd_musicas > 31.8 AND genero = 'Latin' THEN 'Banda_acima_media'
			WHEN qtd_musicas < 31.8 AND genero = 'Latin' THEN 'Banda_baixo_media'
			WHEN qtd_musicas > 31.8 AND genero = 'Metal' THEN 'Banda_acima_media'
			WHEN qtd_musicas < 31.8 AND genero = 'Metal' THEN 'Banda_baixo_media' END AS nivel_banda
	FROM (SELECT * 
			FROM (SELECT art.name artista,
						 g.name genero,
					COUNT(t.name) qtd_musicas
					FROM album a
					JOIN artist art
						ON a.artistid = art.artistid 
					JOIN track t
						ON t.albumid = a.albumid
					JOIN genre g
						ON	g.genreid = t.genreid
					WHERE g.name = 'Latin'
					GROUP BY 1, 2 
					ORDER BY 3 DESC
					LIMIT 10) t1
		  UNION
		  SELECT * 
			FROM (SELECT art.name artista,
						 g.name genero,
					COUNT(t.name) qtd_musicas
					FROM album a
					JOIN artist art
						ON a.artistid = art.artistid 
					JOIN track t
						ON t.albumid = a.albumid
					JOIN genre g
						ON	g.genreid = t.genreid
					WHERE g.name = 'Metal'
					GROUP BY 1, 2 
					ORDER BY 3 DESC
					LIMIT 10) t2
		  UNION
		  SELECT * 
			FROM (SELECT art.name artista,
						 g.name genero,
					COUNT(t.name) qtd_musicas
					FROM album a
					JOIN artist art
						ON a.artistid = art.artistid 
					JOIN track t
						ON t.albumid = a.albumid
					JOIN genre g
						ON	g.genreid = t.genreid
					WHERE g.name = 'Alternative & Punk'
					GROUP BY 1, 2 
					ORDER BY 3 DESC
					LIMIT 10) t3) t4
	ORDER BY 4, 2, 3 DESC
	
/* Query auxiliar : Mostra a média das 30 bandas por genero */
SELECT genero,
	   AVG(qtd_musicas) media_genero
	FROM (SELECT * 
			FROM (SELECT art.name artista,
						 g.name genero,
					COUNT(t.name) qtd_musicas
					FROM album a
					JOIN artist art
						ON a.artistid = art.artistid 
					JOIN track t
						ON t.albumid = a.albumid
					JOIN genre g
						ON	g.genreid = t.genreid
					WHERE g.name = 'Latin'
					GROUP BY 1, 2 
					ORDER BY 3 DESC
					LIMIT 10) t1
		  UNION
		  SELECT * 
			FROM (SELECT art.name artista,
						 g.name genero,
					COUNT(t.name) qtd_musicas
					FROM album a
					JOIN artist art
						ON a.artistid = art.artistid 
					JOIN track t
						ON t.albumid = a.albumid
					JOIN genre g
						ON	g.genreid = t.genreid
					WHERE g.name = 'Metal'
					GROUP BY 1, 2 
					ORDER BY 3 DESC
					LIMIT 10) t2
		  UNION
		  SELECT * 
			FROM (SELECT art.name artista,
						 g.name genero,
					COUNT(t.name) qtd_musicas
					FROM album a
					JOIN artist art
						ON a.artistid = art.artistid 
					JOIN track t
						ON t.albumid = a.albumid
					JOIN genre g
						ON	g.genreid = t.genreid
					WHERE g.name = 'Alternative & Punk'
					GROUP BY 1, 2 
					ORDER BY 3 DESC
					LIMIT 10) t3) t4
	GROUP BY 1;