-- Analise de Sazonalidade dos Dados de Exibição de Filmes
-- Queremos agr olhar a sazonalidade dos dados, considerando a hipótese de que os meses de férias brasileiros terão maior público
-- ou seja, é esperado que Janeiro, Julho e Dezembro tenho os maiores publicos

SELECT
    EXTRACT(MONTH FROM s.data_exibicao) AS mes_exibicao, -- Extrai o número do mês da data
    SUM(s.publico) AS publico_total_mensal                -- Soma o público para cada mês/ano
FROM
    secao s
WHERE
    publico IS NOT NULL AND publico >= 0 -- Garante que estamos somando apenas valores de público válidos
GROUP BY
    mes_exibicao
ORDER BY
    publico_total_mensal DESC; -- Ordena primeiro por ano, depois pelo público total (do maior para o menor)


--dado isso e visando ver o motivo da sazonalidade inesperada, veremos os filmes mais populares de 2024
SELECT
    --EXTRACT(MONTH FROM s.data_exibicao) AS mes_exibicao, -- Extrai o mês da data de exibição
    f.titulo_original,
    SUM(s.publico) AS publico_total
FROM
    filme f, -- Use o JOIN explícito para melhor leitura e performance
    secao s
WHERE
    f.cpb_roe = s.cpb_roe
    AND s.publico IS NOT NULL -- Garante que o público não é nulo
    AND s.publico >= 0        -- Garante que o público é um valor válido (não negativo)
GROUP BY
    --mes_exibicao,         -- Agrupa pelo mês E pelo título original
    f.titulo_original
ORDER BY
    --mes_exibicao ASC,     -- Primeiro, ordena pelo mês (Janeiro, Fevereiro, etc.)
    publico_total DESC;   -- Dentro de cada mês, ordena pelo público total (do maior para o menor)


--para cada um dos filmes do top 5, veremos os meses em que foram exibidos em todo o Brasil
-- INSIDE OUT 2
SELECT
    f.titulo_original,                         
    EXTRACT(MONTH FROM s.data_exibicao) AS mes_exibicao, -- Mês da exibição
    SUM(s.publico) AS publico_total_no_mes      -- Público total para aquele filme naquele mês
FROM
    public.filme f
JOIN
    public.secao s ON f.cpb_roe = s.cpb_roe
WHERE
    f.titulo_original = 'INSIDE OUT 2' -- <--- FILTRA AQUI PELO NOME EXATO DO FILME
    AND s.publico IS NOT NULL AND s.publico >= 0
GROUP BY
    f.titulo_original,                         
    mes_exibicao
ORDER BY
    mes_exibicao ASC;

--DESPICABLE ME 4
SELECT
    f.titulo_original,                         -- Adicionado: Nome do filme na saída
    EXTRACT(MONTH FROM s.data_exibicao) AS mes_exibicao, -- Mês da exibição
    SUM(s.publico) AS publico_total_no_mes      -- Público total para aquele filme naquele mês
FROM
    public.filme f
JOIN
    public.secao s ON f.cpb_roe = s.cpb_roe
WHERE
    f.titulo_original = 'DESPICABLE ME 4' -- <--- FILTRA AQUI PELO NOME EXATO DO FILME
    AND s.publico IS NOT NULL AND s.publico >= 0
GROUP BY
    f.titulo_original,                         -- Adicionado: Agrupa também pelo nome do filme
    mes_exibicao
ORDER BY
    mes_exibicao ASC;

--MOANA 2
SELECT
    f.titulo_original,                         -- Adicionado: Nome do filme na saída
    EXTRACT(MONTH FROM s.data_exibicao) AS mes_exibicao, -- Mês da exibição
    SUM(s.publico) AS publico_total_no_mes      -- Público total para aquele filme naquele mês
FROM
    public.filme f
JOIN
    public.secao s ON f.cpb_roe = s.cpb_roe
WHERE
    f.titulo_original = 'MOANA 2' -- <--- FILTRA AQUI PELO NOME EXATO DO FILME
    AND s.publico IS NOT NULL AND s.publico >= 0
GROUP BY
    f.titulo_original,                         -- Adicionado: Agrupa também pelo nome do filme
    mes_exibicao
ORDER BY
    mes_exibicao ASC;

--AINDA ESTOU AQUI
SELECT
    f.titulo_original,                         -- Adicionado: Nome do filme na saída
    EXTRACT(MONTH FROM s.data_exibicao) AS mes_exibicao, -- Mês da exibição
    SUM(s.publico) AS publico_total_no_mes      -- Público total para aquele filme naquele mês
FROM
    public.filme f
JOIN
    public.secao s ON f.cpb_roe = s.cpb_roe
WHERE
    f.titulo_original = 'AINDA ESTOU AQUI' -- <--- FILTRA AQUI PELO NOME EXATO DO FILME
    AND s.publico IS NOT NULL AND s.publico >= 0
GROUP BY
    f.titulo_original,                         -- Adicionado: Agrupa também pelo nome do filme
    mes_exibicao
ORDER BY
    mes_exibicao ASC;

--DEADPOOL & WOLVERINE
SELECT
    f.titulo_original,                         -- Adicionado: Nome do filme na saída
    EXTRACT(MONTH FROM s.data_exibicao) AS mes_exibicao, -- Mês da exibição
    SUM(s.publico) AS publico_total_no_mes      -- Público total para aquele filme naquele mês
FROM
    public.filme f
JOIN
    public.secao s ON f.cpb_roe = s.cpb_roe
WHERE
    f.titulo_original = 'DEADPOOL & WOLVERINE' -- <--- FILTRA AQUI PELO NOME EXATO DO FILME
    AND s.publico IS NOT NULL AND s.publico >= 0
GROUP BY
    f.titulo_original,                         -- Adicionado: Agrupa também pelo nome do filme
    mes_exibicao
ORDER BY
    mes_exibicao ASC;

