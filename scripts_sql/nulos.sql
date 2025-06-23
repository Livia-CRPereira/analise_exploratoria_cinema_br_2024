----quantidade de nulos distribuidora --------
COPY (
	SELECT * 
	FROM (
		SELECT * 
		FROM (
			VALUES
				('cnpj_distribuidora', (SELECT COUNT(*) FROM public.distribuidora) - (SELECT COUNT(cnpj_distribuidora) FROM public.distribuidora)),
				('razao_social_distribuidora', (SELECT COUNT(*) FROM public.distribuidora) - (SELECT COUNT(razao_social_distribuidora) FROM public.distribuidora))
		) AS resultado(coluna, quantidade_nulos)
	) AS ordenado
	ORDER BY quantidade_nulos DESC
) TO '/Users/carolinabarcellos/saidas/quantidade_nulos_distribuidora.csv'
WITH (FORMAT CSV, HEADER, DELIMITER ',');

-----quantidade nulos complexo-------

COPY (
	SELECT * FROM (
		VALUES
			('registro_complexo',         (SELECT COUNT(*) FROM public.complexo) - (SELECT COUNT(registro_complexo) FROM public.complexo)),
			('nome_complexo',             (SELECT COUNT(*) FROM public.complexo) - (SELECT COUNT(nome_complexo) FROM public.complexo)),
			('banheiros_acessiveis',      (SELECT COUNT(*) FROM public.complexo) - (SELECT COUNT(banheiros_acessiveis) FROM public.complexo)),
			('situacao_complexo',         (SELECT COUNT(*) FROM public.complexo) - (SELECT COUNT(situacao_complexo) FROM public.complexo)),
			('data_situacao_complexo',    (SELECT COUNT(*) FROM public.complexo) - (SELECT COUNT(data_situacao_complexo) FROM public.complexo)),
			('pagina_eletronica_complexo',(SELECT COUNT(*) FROM public.complexo) - (SELECT COUNT(pagina_eletronica_complexo) FROM public.complexo)),
			('endereco_complexo',         (SELECT COUNT(*) FROM public.complexo) - (SELECT COUNT(endereco_complexo) FROM public.complexo)),
			('numero_endereco_complexo',  (SELECT COUNT(*) FROM public.complexo) - (SELECT COUNT(numero_endereco_complexo) FROM public.complexo)),
			('complemento_complexo',      (SELECT COUNT(*) FROM public.complexo) - (SELECT COUNT(complemento_complexo) FROM public.complexo)),
			('bairro_complexo',           (SELECT COUNT(*) FROM public.complexo) - (SELECT COUNT(bairro_complexo) FROM public.complexo)),
			('municipio_complexo',        (SELECT COUNT(*) FROM public.complexo) - (SELECT COUNT(municipio_complexo) FROM public.complexo)),
			('cep_complexo',              (SELECT COUNT(*) FROM public.complexo) - (SELECT COUNT(cep_complexo) FROM public.complexo)),
			('uf_complexo',               (SELECT COUNT(*) FROM public.complexo) - (SELECT COUNT(uf_complexo) FROM public.complexo)),
			('complexo_itinerante',       (SELECT COUNT(*) FROM public.complexo) - (SELECT COUNT(complexo_itinerante) FROM public.complexo)),
			('registro_exibidor',         (SELECT COUNT(*) FROM public.complexo) - (SELECT COUNT(registro_exibidor) FROM public.complexo))
	) AS resultado(coluna, quantidade_nulos)
	ORDER BY quantidade_nulos DESC
) TO '/Users/carolinabarcellos/saidas/quantidade_nulos_complexo.csv'
WITH (FORMAT CSV, HEADER, DELIMITER ',');

---quantidade nulos sala------
COPY (
	SELECT * 
	FROM (
		SELECT * 
		FROM (
			VALUES
				('registro_sala',             (SELECT COUNT(*) FROM public.sala) - (SELECT COUNT(registro_sala) FROM public.sala)),
				('nome_sala',                 (SELECT COUNT(*) FROM public.sala) - (SELECT COUNT(nome_sala) FROM public.sala)),
				('situacao_sala',             (SELECT COUNT(*) FROM public.sala) - (SELECT COUNT(situacao_sala) FROM public.sala)),
				('data_inicio_funcionamento', (SELECT COUNT(*) FROM public.sala) - (SELECT COUNT(data_inicio_funcionamento) FROM public.sala)),
				('assentos_sala',             (SELECT COUNT(*) FROM public.sala) - (SELECT COUNT(assentos_sala) FROM public.sala)),
				('assentos_cadeirantes',      (SELECT COUNT(*) FROM public.sala) - (SELECT COUNT(assentos_cadeirantes) FROM public.sala)),
				('assentos_mobilidade_reduzida', (SELECT COUNT(*) FROM public.sala) - (SELECT COUNT(assentos_mobilidade_reduzida) FROM public.sala)),
				('assentos_obesidade',        (SELECT COUNT(*) FROM public.sala) - (SELECT COUNT(assentos_obesidade) FROM public.sala)),
				('acesso_assentos_com_rampa', (SELECT COUNT(*) FROM public.sala) - (SELECT COUNT(acesso_assentos_com_rampa) FROM public.sala)),
				('acesso_sala_com_rampa',     (SELECT COUNT(*) FROM public.sala) - (SELECT COUNT(acesso_sala_com_rampa) FROM public.sala)),
				('registro_complexo',         (SELECT COUNT(*) FROM public.sala) - (SELECT COUNT(registro_complexo) FROM public.sala))
		) AS resultado(coluna, quantidade_nulos)
	) AS ordenado
	ORDER BY quantidade_nulos DESC
) TO '/Users/carolinabarcellos/saidas/quantidade_nulos_sala.csv'
WITH (FORMAT CSV, HEADER, DELIMITER ',');

---quantidade nulos da tabela seção-------
COPY (
	SELECT * 
	FROM (
		SELECT * 
		FROM (
			VALUES
				('id_secao',           (SELECT COUNT(*) FROM public.secao) - (SELECT COUNT(id_secao) FROM public.secao)),
				('data_exibicao',      (SELECT COUNT(*) FROM public.secao) - (SELECT COUNT(data_exibicao) FROM public.secao)),
				('publico',            (SELECT COUNT(*) FROM public.secao) - (SELECT COUNT(publico) FROM public.secao)),
				('cpb_roe',            (SELECT COUNT(*) FROM public.secao) - (SELECT COUNT(cpb_roe) FROM public.secao)),
				('registro_sala',      (SELECT COUNT(*) FROM public.secao) - (SELECT COUNT(registro_sala) FROM public.secao)),
				('nr_protocolo_envio', (SELECT COUNT(*) FROM public.secao) - (SELECT COUNT(nr_protocolo_envio) FROM public.secao))
		) AS resultado(coluna, quantidade_nulos)
	) AS ordenado
	ORDER BY quantidade_nulos DESC
) TO '/Users/carolinabarcellos/saidas/quantidade_nulos_secao.csv'
WITH (FORMAT CSV, HEADER, DELIMITER ',');

---quantidade de nulos da tabela protocolo------
COPY (
	SELECT * 
	FROM (
		SELECT * 
		FROM (
			VALUES
				('nr_protocolo_envio', (SELECT COUNT(*) FROM public.protocolo) - (SELECT COUNT(nr_protocolo_envio) FROM public.protocolo)),
				('data_hora_envio_protocolo', (SELECT COUNT(*) FROM public.protocolo) - (SELECT COUNT(data_hora_envio_protocolo) FROM public.protocolo)),
				('cnpj_distribuidora', (SELECT COUNT(*) FROM public.protocolo) - (SELECT COUNT(cnpj_distribuidora) FROM public.protocolo))
		) AS resultado(coluna, quantidade_nulos)
	) AS ordenado
	ORDER BY quantidade_nulos DESC
) TO '/Users/carolinabarcellos/saidas/quantidade_nulos_protocolo.csv'
WITH (FORMAT CSV, HEADER, DELIMITER ',');

--quantidade de nulos na tabela grupo_exibidor------
COPY (
	SELECT * 
	FROM (
		SELECT * 
		FROM (
			VALUES
				('registro_grupo_exibidor', (SELECT COUNT(*) FROM public.grupo_exibidor) - (SELECT COUNT(registro_grupo_exibidor) FROM public.grupo_exibidor)),
				('nome_grupo_exibidor',     (SELECT COUNT(*) FROM public.grupo_exibidor) - (SELECT COUNT(nome_grupo_exibidor) FROM public.grupo_exibidor))
		) AS resultado(coluna, quantidade_nulos)
	) AS ordenado
	ORDER BY quantidade_nulos DESC
) TO '/Users/carolinabarcellos/saidas/quantidade_nulos_grupo_exibidor.csv'
WITH (FORMAT CSV, HEADER, DELIMITER ',');

---quantidade de nulos na tabela exibidor-------------
COPY (
	SELECT * 
	FROM (
		SELECT * 
		FROM (
			VALUES
				('registro_exibidor', (SELECT COUNT(*) FROM public.exibidor) - (SELECT COUNT(registro_exibidor) FROM public.exibidor)),
				('nome_exibidor',     (SELECT COUNT(*) FROM public.exibidor) - (SELECT COUNT(nome_exibidor) FROM public.exibidor)),
				('cnpj_exibidor',     (SELECT COUNT(*) FROM public.exibidor) - (SELECT COUNT(cnpj_exibidor) FROM public.exibidor)),
				('registro_grupo_exibidor', (SELECT COUNT(*) FROM public.exibidor) - (SELECT COUNT(registro_grupo_exibidor) FROM public.exibidor))
		) AS resultado(coluna, quantidade_nulos)
	) AS ordenado
	ORDER BY quantidade_nulos DESC
) TO '/Users/carolinabarcellos/saidas/quantidade_nulos_exibidor.csv'
WITH (FORMAT CSV, HEADER, DELIMITER ',');

----quantidade de nulos na tabela filme----------------
COPY (
	SELECT * 
	FROM (
		SELECT * 
		FROM (
			VALUES
				('cpb_roe',           (SELECT COUNT(*) FROM public.filme) - (SELECT COUNT(cpb_roe) FROM public.filme)),
				('titulo_original',   (SELECT COUNT(*) FROM public.filme) - (SELECT COUNT(titulo_original) FROM public.filme)),
				('titulo_brasil',     (SELECT COUNT(*) FROM public.filme) - (SELECT COUNT(titulo_brasil) FROM public.filme)),
				('pais_obra',         (SELECT COUNT(*) FROM public.filme) - (SELECT COUNT(pais_obra) FROM public.filme))
		) AS resultado(coluna, quantidade_nulos)
	) AS ordenado
	ORDER BY quantidade_nulos DESC
) TO '/Users/carolinabarcellos/saidas/quantidade_nulos_filme.csv'
WITH (FORMAT CSV, HEADER, DELIMITER ',');

