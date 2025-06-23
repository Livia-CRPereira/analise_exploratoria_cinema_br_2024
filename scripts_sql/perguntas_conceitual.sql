-- Engenharia reversa: Perguntas para se criar o esquema conceitual de forma adequada

-- COMPLEXOS E EXIBIDOR
-- Verifica se há complexos sem um exibidor associado
SELECT COUNT(*)
FROM salasComplexos
WHERE registro_exibidor IS NULL;
-- Resultado: Todo complexo precisa de um exibidor (a consulta retorna 0)

-- EXIBIDOR E GRUPO EXIBIDOR
-- Verifica que nem todo exibidor faz parte de um grupo
SELECT COUNT(*) from (select distinct registro_exibidor 
FROM salasComplexos
WHERE nome_grupo_exibidor = 'NÃO PERTENCE A NENHUM GRUPO EXIBIDOR');
-- 579 exibidores não pertencem a nenhum grupo. 

-- SALAS
-- Exibições com nome sala e registro sala nulo
select *
from bilheteriafilmes2024 b
where b.nome_sala IS null and b.registro_sala  is null;
-- Resultado:  2
-- 2024-09-05	THE SILK ROAD RALLY	CORRIDA MALUCA	E2400248900000	CANADÁ			8						CLUBE FILMES LTDA	46.401.439/0001-27	214229062000424	2024-12-17 16:12:33.000
-- 2024-10-17	THE SILK ROAD RALLY	CORRIDA MALUCA	E2400248900000	CANADÁ			50						CLUBE FILMES LTDA	46.401.439/0001-27	214229062000524	2024-12-17 16:13:13.000

-- Conta quantos registros de salas são nulos em bilheteria, apesar de nomeSala não ser: 280 salas não tem valor em registro sala mas tem nomeSala
select count (*) from (SELECT DISTINCT nome_sala
FROM bilheteriafilmes2024
WHERE registro_sala IS null
	and  nome_sala is not NULL);

-- Linhas com salas sem registro (registro null)
select count(*) from bilheteriafilmes2024 b where b.registro_sala is null;
-- Resultado: 6376

-- Linhas de salas com registro
select count(*) from bilheteriafilmes2024 b where b.registro_sala is not null;
-- Resultado: 2087293

-- Linhas totais 
select count(*) from bilheteriafilmes2024;
-- Resultado: 2093699

-- Retirando todas as linhas de salas sem registro, ainda sobram o que corresponde a 99,7 % dos dados.
-- Decisão de negócio: apagar os registros das salas que não têm correspondência em salasComplexos (não tem registroSala), para esse trabalho. 

-- CONSIDERANDO SALAS REGISTRADAS PELA ANCINE (QUE TÊM REGISTRO_SALA)
-- Verifica se há salas sem um complexo associado: 
SELECT COUNT(*)
FROM salasComplexos
WHERE registro_complexo IS NULL;
-- Resultado: Todas as salas registradas pela Ancine precisam de um complexo

-- Procura por registros onde o município ou a UF são diferentes entre as tabelas: 
SELECT
	b.registro_sala,
	b.municipio_sala_complexo,
	s.municipio_complexo,
	b.uf_sala_complexo,
	s.uf_complexo
FROM
	bilheteriafilmes2024 b
JOIN salasComplexos s ON
	b.registro_sala = s.registro_sala
WHERE
	b.municipio_sala_complexo <> s.municipio_complexo
	OR b.uf_sala_complexo <> s.uf_complexo;
-- Resultado: Não há necessidade das colunas municipio_sala_complexo e uf_sala_complexo, que são iguais aos valores dos complexos aos quais as salas estão associadas

-- PROTOCOLO
-- Encontra distribuidoras e filmes com mais de um número de protocolo diferente
SELECT
	cnpj_distribuidora,
	cpb_roe,
	COUNT(DISTINCT nr_protocolo_envio) as total_protocolos
FROM
	bilheteriafilmes2024
GROUP BY
	cnpj_distribuidora,
	cpb_roe
HAVING
	COUNT(DISTINCT nr_protocolo_envio) > 1
order by total_protocolos desc;
-- Resultado: Protocolo é entidade única (cada par filme/dist tem mais de 1 protocolo)

-- Então protocolo depende de que? Se relaciona ao que? O que é? Depende da data? Tem frequencia? 
SELECT
  cnpj_distribuidora,
  cpb_roe,
  COUNT(DISTINCT nr_protocolo_envio) as protocolos,
  MIN(data_hora_envio_protocolo) as primeiro_envio,
  MAX(data_hora_envio_protocolo) as ultimo_envio
FROM
  bilheteriafilmes2024
GROUP BY
  cnpj_distribuidora, cpb_roe
HAVING
  COUNT(DISTINCT nr_protocolo_envio) > 1
ORDER BY
  protocolos DESC;
-- Cada protocolo é uma "declaração de exibição" feita pela distribuidora para a Ancine
-- O que acontece é o seguinte: a distribuidora envia N protocolos autorizando N seções e cada seção exibe 1 filme, exibido em N seções 
-- (filme e protocolo tem uma relação complexa, então a melhor escolha aqui é relacionar seção a filme e protocolo a seção)
-- Ou seja, temos uma relação com Distribuidora --> Protocolo --> Seção --> Filme

-- Protocolo é unico? Tenho um mesmo número de protocolo para diferentes distribuidoras? 
SELECT
    nr_protocolo_envio,
    COUNT(DISTINCT cnpj_distribuidora) AS numero_de_distribuidoras
from bilheteriafilmes2024 b 
group by nr_protocolo_envio
having COUNT(DISTINCT cnpj_distribuidora) > 1;
-- Resultado: Não tenho! Logo não precisa ser entidade fraca de distribuidora. 




