-- Análise descritiva da tabela Filmes
-- A tabela apresenta todos os filmes que foram aos cinemas em 2024 

-- Visualização geral
select * from filme;

-- Para cada uma das consultas, irei gerar um csv de saída a fim de facilitar a geração de gráficos posteriormente
-- Quantidade de valores nulos
COPY (
	SELECT * FROM (
		VALUES
			('cpb_roe',       (SELECT COUNT(*) FROM public.filme) - (SELECT COUNT(cpb_roe) FROM public.filme)),
			('titulo_original',(SELECT COUNT(*) FROM public.filme) - (SELECT COUNT(titulo_original) FROM public.filme)),
			('titulo_brasil', (SELECT COUNT(*) FROM public.filme) - (SELECT COUNT(titulo_brasil) FROM public.filme)),
			('pais_obra',     (SELECT COUNT(*) FROM public.filme) - (SELECT COUNT(pais_obra) FROM public.filme))
	) AS resultado(coluna, quantidade_nulos)
) TO 'C:\Users\livia\AppData\Roaming\DBeaverData\workspace6\General\saidas\quantidade_nulos.csv'
WITH (FORMAT CSV, HEADER, DELIMITER ',');



-- Quantidade de nulos em titulo_brasil por pais_obra
COPY (
	SELECT
	    pais_obra,
	    COUNT(*) AS quantidade_com_titulo_brasil_nulo
	FROM
	    public.filme
	WHERE
	    titulo_brasil IS NULL
	GROUP BY
	    pais_obra
	ORDER BY
	    quantidade_com_titulo_brasil_nulo DESC
) TO 'C:\Users\livia\AppData\Roaming\DBeaverData\workspace6\General\saidas\titulo_brasil_nulos_por_pais.csv'
WITH (FORMAT CSV, HEADER, DELIMITER ',');


-- Filmes com pais_obra null
COPY (
	SELECT
	    cpb_roe,
	    titulo_original
	FROM
	    public.filme
	WHERE
	    pais_obra IS NULL
) TO 'C:\Users\livia\AppData\Roaming\DBeaverData\workspace6\General\saidas\filmes_sem_pais.csv'
WITH (FORMAT CSV, HEADER, DELIMITER ',');


-- Quantidade de filmes por país
COPY (
	SELECT
	    COALESCE(pais_obra, 'NÃO INFORMADO') AS pais_obra,
	    COUNT(cpb_roe) AS quantidade_de_filmes
	FROM
	    public.filme
	GROUP BY
	    COALESCE(pais_obra, 'NÃO INFORMADO')
	ORDER BY
	    quantidade_de_filmes DESC
) TO 'C:\Users\livia\AppData\Roaming\DBeaverData\workspace6\General\saidas\filmes_por_pais.csv'
WITH (FORMAT CSV, HEADER, DELIMITER ',');


