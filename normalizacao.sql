-- #############################################################################
-- # SCRIPT DE MIGRAÇÃO DE DADOS PARA BANCO DE DADOS NORMALIZADO
-- #############################################################################
-- ORDEM DE EXECUÇÃO:
-- 1. grupo_exibidor
-- 2. exibidor
-- 3. complexo
-- 4. sala
-- 5. filme
-- 6. distribuidora
-- 7. protocolo
-- 8. secao 
-- 9. Definição das Foreign Keys (Opcional, mas recomendado)
-- #############################################################################


-- =============================================================================
-- 1. Tabela: grupo_exibidor
-- =============================================================================
-- Primeiro, criamos a tabela grupo_exibidor, pois ela é uma dimensão independente.

CREATE TABLE IF NOT EXISTS public.grupo_exibidor (
    registro_grupo_exibidor INTEGER PRIMARY KEY,
    nome_grupo_exibidor VARCHAR(150) NOT NULL
);

-- Inserimos os dados, garantindo que sejam únicos.
-- A cláusula DISTINCT garante que não haja linhas duplicadas.
-- O WHERE filtra os registros nulos e a string padrão para "não pertence".
INSERT into grupo_exibidor (registro_grupo_exibidor, nome_grupo_exibidor)
WITH NomesGrupo AS (
    -- Passo 1: Cria uma mini-tabela com os nomes únicos de grupo vindos de 'salascomplexos'.
    SELECT DISTINCT 
        registro_exibidor, 
        nome_grupo_exibidor
    FROM public.salascomplexos
    WHERE nome_grupo_exibidor IS NOT NULL 
      AND nome_grupo_exibidor != 'NÃO PERTENCE A NENHUM GRUPO EXIBIDOR'
),
IDsGrupo AS (
    -- Passo 2: Cria uma mini-tabela com os IDs de grupo únicos vindos de 'bilheteria'.
    SELECT DISTINCT 
        registro_exibidor, 
        registro_grupo_exibidor
    FROM public.bilheteriafilmes2024
    WHERE registro_grupo_exibidor IS NOT NULL
)
-- Passo 3: Faz o JOIN entre as duas mini-tabelas.
SELECT DISTINCT
    ig.registro_grupo_exibidor,
    ng.nome_grupo_exibidor
FROM 
    NomesGrupo ng
JOIN 
    IDsGrupo ig ON ng.registro_exibidor = ig.registro_exibidor;


-- =============================================================================
-- 2. Tabela: exibidor
-- =============================================================================
-- Esta tabela depende de 'grupo_exibidor'.

CREATE TABLE IF NOT EXISTS public.exibidor (
    registro_exibidor INTEGER PRIMARY KEY,
    nome_exibidor VARCHAR(150) NOT NULL,
    cnpj_exibidor VARCHAR(18) NOT NULL UNIQUE,
    registro_grupo_exibidor INTEGER NULL -- Permite nulos, como definido
    -- A Foreign Key será adicionada no final
);

-- Inserimos os exibidores únicos.
INSERT INTO exibidor (registro_exibidor, nome_exibidor, cnpj_exibidor, registro_grupo_exibidor)
WITH ExibidorBase AS (
    -- Passo 1: Pega os dados base e únicos do exibidor de 'salascomplexos'.
    SELECT DISTINCT
        registro_exibidor,
        nome_exibidor,
        cnpj_exibidor
    FROM public.salascomplexos
    WHERE registro_exibidor IS NOT NULL -- Remove os que você pediu para remover.
),
GrupoLink AS (
    -- Passo 2: Pega o mapeamento único de exibidor para ID de grupo de 'bilheteria'.
    SELECT DISTINCT
        registro_exibidor,
        registro_grupo_exibidor
    FROM public.bilheteriafilmes2024
    WHERE registro_grupo_exibidor IS NOT NULL
)
-- Passo 3: Faz o LEFT JOIN para garantir que todos os exibidores sejam inseridos,
-- mesmo que não tenham um grupo associado nos dados de bilheteria.
SELECT
    eb.registro_exibidor,
    eb.nome_exibidor,
    eb.cnpj_exibidor,
    gl.registro_grupo_exibidor -- Será NULL se não houver correspondência
FROM
    ExibidorBase eb
LEFT JOIN 
    GrupoLink gl ON eb.registro_exibidor = gl.registro_exibidor;

-- =============================================================================
-- 3. Tabela: complexo
-- =============================================================================
-- Esta tabela depende de 'exibidor'.

CREATE TABLE IF NOT EXISTS public.complexo (
    registro_complexo INTEGER PRIMARY KEY,
    nome_complexo VARCHAR(150) NOT NULL,
    banheiros_acessiveis VARCHAR(3) NULL,
    situacao_complexo VARCHAR(50) NULL,
    data_situacao_complexo DATE NULL,
    pagina_eletronica_complexo VARCHAR(255) NULL,
    endereco_complexo VARCHAR(255) NULL,
    numero_endereco_complexo VARCHAR(50) NULL,
    complemento_complexo VARCHAR(100) NULL,
    bairro_complexo VARCHAR(100) NULL,
    municipio_complexo VARCHAR(100) NULL,
    cep_complexo VARCHAR(10) NULL,
    uf_complexo VARCHAR(2) NULL,
    complexo_itinerante VARCHAR(3) NULL,
    registro_exibidor INTEGER NOT NULL
    -- A Foreign Key será adicionada no final
);

-- Inserimos os complexos únicos. GROUP BY na chave primária é a chave.
INSERT INTO complexo
SELECT
    registro_complexo,
    MAX(nome_complexo),
    MAX(banheiros_acessiveis),
    MAX(situacao_complexo),
    MAX(data_situacao_complexo),
    MAX(pagina_eletronica_complexo),
    MAX(endereco_complexo),
    MAX(numero_endereco_complexo),
    MAX(complemento_complexo),
    MAX(bairro_complexo),
    MAX(municipio_complexo),
    MAX(cep_complexo),
    MAX(uf_complexo),
    MAX(complexo_itinerante),
    MAX(registro_exibidor)
FROM 
    public.salascomplexos
WHERE
    registro_complexo IS NOT NULL
GROUP BY
    registro_complexo;


-- =============================================================================
-- 4. Tabela: sala
-- =============================================================================
-- Esta tabela depende de 'complexo'.

CREATE TABLE IF NOT EXISTS public.sala (
    registro_sala INTEGER PRIMARY KEY,
    nome_sala VARCHAR(150) NOT NULL,
    situacao_sala VARCHAR(50) NULL,
    data_inicio_funcionamento DATE NULL,
    assentos_sala INTEGER NULL,
    assentos_cadeirantes INTEGER NULL,
    assentos_mobilidade_reduzida INTEGER NULL,
    assentos_obesidade INTEGER NULL,
    acesso_assentos_com_rampa VARCHAR(3) NULL,
    acesso_sala_com_rampa VARCHAR(3) NULL,
    registro_complexo INTEGER NOT NULL
    -- A Foreign Key será adicionada no final
);

-- Inserimos as salas únicas.
INSERT INTO sala
SELECT
    registro_sala,
    MAX(nome_sala),
    MAX(situacao_sala),
    MAX(data_inicio_funcionamento_sala),
    MAX(assentos_sala),
    MAX(assentos_cadeirantes),
    MAX(assentos_mobilidade_reduzida),
    MAX(assentos_obesidade),
    MAX(acesso_assentos_com_rampa),
    MAX(acesso_sala_com_rampa),
    MAX(registro_complexo)
FROM 
    public.salascomplexos
WHERE 
    registro_sala IS NOT NULL -- Filtra salas sem registro
GROUP BY
    registro_sala;


-- =============================================================================
-- 5. Tabela: filme
-- =============================================================================
-- Dimensão independente, populada a partir da bilheteria.

CREATE TABLE IF NOT EXISTS public.filme (
    cpb_roe VARCHAR(20) PRIMARY KEY,
    titulo_original VARCHAR(255) NOT NULL,
    titulo_brasil VARCHAR(255) NULL, -- Permite nulos como no seu dicionário
    pais_obra VARCHAR(50) NULL
);

-- Inserimos os filmes únicos.
INSERT INTO filme (cpb_roe, titulo_original, titulo_brasil, pais_obra)
SELECT
    cpb_roe,
    MAX(titulo_original),
    MAX(titulo_brasil),
    MAX(pais_obra)
FROM
    public.bilheteriafilmes2024
WHERE
    cpb_roe IS NOT NULL
GROUP BY
    cpb_roe;

-- =============================================================================
-- 6. Tabela: distribuidora
-- =============================================================================
-- Dimensão independente.

CREATE TABLE IF NOT EXISTS public.distribuidora (
    cnpj_distribuidora VARCHAR(18) PRIMARY KEY,
    razao_social_distribuidora VARCHAR(150) NOT NULL
);

-- Inserimos as distribuidoras únicas.
INSERT INTO distribuidora (cnpj_distribuidora, razao_social_distribuidora)
SELECT
    cnpj_distribuidora,
    MAX(razao_social_distribuidora)
FROM
    public.bilheteriafilmes2024
WHERE
    cnpj_distribuidora IS NOT NULL
GROUP BY
    cnpj_distribuidora;

-- =============================================================================
-- 7. Tabela: protocolo
-- =============================================================================
-- Depende da 'distribuidora'.

CREATE TABLE IF NOT EXISTS public.protocolo (
    nr_protocolo_envio BIGINT PRIMARY KEY,
    data_hora_envio_protocolo TIMESTAMP NOT NULL,
    cnpj_distribuidora VARCHAR(18) NOT NULL
    -- A Foreign Key será adicionada no final
);

-- Inserimos os protocolos únicos.
INSERT INTO protocolo (nr_protocolo_envio, data_hora_envio_protocolo, cnpj_distribuidora)
SELECT
    nr_protocolo_envio,
    MAX(data_hora_envio_protocolo),
    MAX(cnpj_distribuidora)
FROM
    public.bilheteriafilmes2024
WHERE
    nr_protocolo_envio IS NOT NULL
GROUP BY
    nr_protocolo_envio;


-- =============================================================================
-- 8. Tabela Fato: secao
-- =============================================================================
-- A tabela principal, criada por último.

CREATE TABLE IF NOT EXISTS public.secao (
    id_secao BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, -- Chave primária auto-incremental
    data_exibicao DATE NOT NULL,
    publico INTEGER NOT NULL,
    cpb_roe VARCHAR(20) NOT NULL,
    registro_sala INTEGER NOT NULL,
    nr_protocolo_envio BIGINT NOT NULL
    -- As Foreign Keys serão adicionadas no final
);

-- Inserimos os dados da bilheteria. Aqui não usamos DISTINCT ou GROUP BY,
-- pois cada linha da fonte é um fato único (uma exibição).
-- Apenas selecionamos as colunas relevantes.
INSERT INTO secao (data_exibicao, publico, cpb_roe, registro_sala, nr_protocolo_envio)
SELECT
    data_exibicao,
    publico,
    cpb_roe,
    registro_sala,
    nr_protocolo_envio
FROM
    public.bilheteriafilmes2024
WHERE -- Garantimos que as chaves que serão FKs não são nulas
    cpb_roe IS NOT NULL
    AND registro_sala IS NOT NULL
    AND nr_protocolo_envio IS NOT NULL;


-- =============================================================================
-- 9. Definição das Foreign Keys (Constraints)
-- =============================================================================
-- É uma boa prática adicionar as FKs após a inserção dos dados,
-- pois acelera o processo de carga inicial.

ALTER TABLE public.exibidor ADD CONSTRAINT fk_exibidor_grupo_exibidor
FOREIGN KEY (registro_grupo_exibidor) REFERENCES public.grupo_exibidor (registro_grupo_exibidor);

ALTER TABLE public.complexo ADD CONSTRAINT fk_complexo_exibidor
FOREIGN KEY (registro_exibidor) REFERENCES public.exibidor (registro_exibidor);

ALTER TABLE public.sala ADD CONSTRAINT fk_sala_complexo
FOREIGN KEY (registro_complexo) REFERENCES public.complexo (registro_complexo);

ALTER TABLE public.protocolo ADD CONSTRAINT fk_protocolo_distribuidora
FOREIGN KEY (cnpj_distribuidora) REFERENCES public.distribuidora (cnpj_distribuidora);

ALTER TABLE public.secao ADD CONSTRAINT fk_secao_filme
FOREIGN KEY (cpb_roe) REFERENCES public.filme (cpb_roe);

ALTER TABLE public.secao ADD CONSTRAINT fk_secao_sala
FOREIGN KEY (registro_sala) REFERENCES public.sala (registro_sala);

ALTER TABLE public.secao ADD CONSTRAINT fk_secao_protocolo
FOREIGN KEY (nr_protocolo_envio) REFERENCES public.protocolo (nr_protocolo_envio);
----------------------------------------------------------------------------------------------------