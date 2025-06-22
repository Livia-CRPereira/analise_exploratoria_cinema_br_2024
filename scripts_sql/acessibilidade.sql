-----quantidade de complexos com banheiros acessíveis -----------------------------------------------------
COPY (
SELECT banheiros_acessiveis, count(*) as quantidade
from complexo
group by banheiros_acessiveis
order by count(*) desc
) TO '/Users/carolinabarcellos/saidas/banheiros_acessiveis.csv'
WITH (FORMAT CSV, HEADER, DELIMITER ',');

------salas com acesso a assentos com rampa------------------------------------------------------
COPY (
	SELECT acesso_assentos_com_rampa, COUNT(*) as Quantidade
	FROM sala
	group by acesso_assentos_com_rampa
	ORDER BY COUNT(*) DESC
) TO '/Users/carolinabarcellos/saidas/salas_acesso_assentos.csv'
WITH (FORMAT CSV, HEADER, DELIMITER ',');

------salas com acesso com rampa------------------------------------------------------------------
COPY (
	SELECT acesso_sala_com_rampa, COUNT(*) as Quantidade
	FROM sala
	group by acesso_sala_com_rampa
	ORDER BY COUNT(*) DESC
) TO '/Users/carolinabarcellos/saidas/salas_acesso.csv'
WITH (FORMAT CSV, HEADER, DELIMITER ',');

------quantidade de assentos mobilidade reduzida por sala-------------------------------------------
COPY (
SELECT nome_sala, assentos_mobilidade_reduzida
from sala
order by assentos_mobilidade_reduzida 
) TO '/Users/carolinabarcellos/saidas/sala_assentos_mobilidadereduzida.csv'
WITH (FORMAT CSV, HEADER, DELIMITER ',');

------quantidade de assentos obesidade por sala-----------------------------------------------------
COPY (
SELECT nome_sala, assentos_obesidade
from sala
order by assentos_obesidade
) TO '/Users/carolinabarcellos/saidas/sala_assentos_obesidade.csv'
WITH (FORMAT CSV, HEADER, DELIMITER ',');

-----quantidade de complexos com um certo número de assentos_cadeirantes ----------------------------
COPY (
SELECT assentos_cadeirantes, count(*) as quantidade
from sala
group by assentos_cadeirantes
order by assentos_cadeirantes desc
) TO '/Users/carolinabarcellos/saidas/assentos_cadeirante.csv'
WITH (FORMAT CSV, HEADER, DELIMITER ',');

--do total de complexos de cinema do brasil, quantos tem a estrutura de acessibilidade completa?-----

--TOTAL = 2087293
select COUNT(*) as total_complexos 
from complexo c, sala s, secao s2 
where c.registro_complexo = s.registro_complexo 
and s2.registro_sala = s.registro_sala

-- COM ACESSIBILIDADE COMPLETA = 10533
select COUNT(*) as complexos_acessiveis 
from complexo c, sala s, secao s2 
where c.registro_complexo = s.registro_complexo 
and s2.registro_sala = s.registro_sala
and c.banheiros_acessiveis = 'SIM'
and s.assentos_cadeirantes > 0
and s.assentos_mobilidade_reduzida > 0
and s.assentos_obesidade > 0
and s.acesso_assentos_com_rampa = 'SIM'
and s.acesso_sala_com_rampa  = 'SIM'
