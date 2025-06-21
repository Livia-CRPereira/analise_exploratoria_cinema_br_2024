--CONSULTAS EXTRAS--

-----quantidade de complexos itinerantes e não itinerantes-------------------
COPY (
	SELECT complexo_itinerante, COUNT(*)
	FROM complexo
	GROUP BY complexo_itinerante
	ORDER BY COUNT(*) DESC
) TO '/Users/carolinabarcellos/saidas/complexos_itinerantes_comparacao.csv'
WITH (FORMAT CSV, HEADER, DELIMITER ',');


-----quantidade de complexos em funcionamento, fechados e fechados temporariamente ----------------------
COPY (
SELECT situacao_complexo, count(*) as quantidade
from complexo
group by situacao_complexo
order by count(*) desc
) TO '/Users/carolinabarcellos/saidas/situacao_complexo.csv'
WITH (FORMAT CSV, HEADER, DELIMITER ',');
