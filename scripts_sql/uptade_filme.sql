-- Buscando aprimorar nossa tabela, ajustamos a lógica 
-- para que, quando o filme for brasileiro titulo_brasil = titulo_original
UPDATE public.filme
SET titulo_brasil = titulo_original
WHERE pais_obra = 'BRASIL' 
AND titulo_brasil IS NULL; 