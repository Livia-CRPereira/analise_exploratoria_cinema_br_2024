--ANÁLISE OUTLIERS--

---------quantidade de complexos por uf------------------------------------------
COPY (
	SELECT uf_complexo, COUNT(*)
	FROM complexo
	GROUP BY uf_complexo
	ORDER BY COUNT(*) DESC
) TO '/Users/carolinabarcellos/saidas/complexos_por_uf.csv'
WITH (FORMAT CSV, HEADER, DELIMITER ',');

------quantidade de assentos por sala------------------------------------------------------
COPY (
SELECT nome_sala, assentos_sala
from sala
order by assentos_sala desc
) TO '/Users/carolinabarcellos/saidas/sala_assentos.csv'
WITH (FORMAT CSV, HEADER, DELIMITER ',');

-----publico total por filme----------------------------------------------------------------
COPY (
select titulo_original, sum(publico) as publico_total
from filme f natural join secao s
group by titulo_original
order by sum(publico) desc
) TO '/Users/carolinabarcellos/saidas/filme_publico.csv'
WITH (FORMAT CSV, HEADER, DELIMITER ',');

-----quantidade de filmes por distribuidora-------------------------------------------------
COPY (
SELECT 
    d.razao_social_distribuidora, 
    COUNT(DISTINCT s.cpb_roe) AS quantidade_filmes
FROM 
    protocolo p
JOIN 
    distribuidora d ON p.cnpj_distribuidora = d.cnpj_distribuidora
JOIN 
    secao s ON p.nr_protocolo_envio = s.nr_protocolo_envio
GROUP BY 
    d.razao_social_distribuidora
ORDER BY 
    quantidade_filmes DESC
) TO '/Users/carolinabarcellos/saidas/filme_distribuidoras.csv'
WITH (FORMAT CSV, HEADER, DELIMITER ',');

---- publico total por distribuidora----------------------------------------------------------
COPY (
select razao_social_distribuidora, sum(publico) as publico_total
from protocolo p, secao s, distribuidora d 
where p.cnpj_distribuidora =d.cnpj_distribuidora
and p.nr_protocolo_envio =s.nr_protocolo_envio
group by d.razao_social_distribuidora 
order by sum(publico) desc
) TO '/Users/carolinabarcellos/saidas/publico_distribuidoras.csv'
WITH (FORMAT CSV, HEADER, DELIMITER ',');
