# 🎬 Análise de Dados de Cinema no Brasil: Da Coleta e Normalização à Descoberta de Insights

## 🌟 Visão Geral do Projeto

Este projeto é uma jornada de exploração no universo dos dados de bilheteria e salas de cinema do Brasil! Nosso objetivo principal foi mergulhar no ciclo completo de tratamento de dados públicos: desde a **coleta e gerenciamento inicial**, passando pela **integração e normalização**, até a **análise exploratória** e a **geração de insights**, com a possibilidade de **republicação** dos dados transformados.

Iniciamos com conjuntos de dados brutos sobre o mercado cinematográfico brasileiro, os quais, apesar de sua riqueza, apresentavam um cenário comum de **desorganização e inconsistências**. Nossa jornada foi transformar esse "quebra-cabeça" em um **banco de dados relacional limpo, normalizado e eficiente**, pronto para desvendar padrões e responder a perguntas complexas sobre o setor.

## 🎯 Objetivos do Trabalho Prático

Nosso trabalho foi guiado pelos seguintes objetivos detalhados no enunciado:

1.  **Acesso, Coleta e Gerenciamento de Dados Públicos:** Demonstrar a capacidade de obter e organizar dados de fontes abertas.
2.  **Integração e Combinação de Dados:** Carregar múltiplos conjuntos de dados em um SGBD relacional (PostgreSQL) e combiná-los para análises integradas.
3.  **Análise Exploratória de Dados (AED):**
    * **Preparação:** Garantir dados limpos, consistentes e bem estruturados.
    * **Definição de Objetivos:** Formular questões e hipóteses a serem testadas.
    * **Análise Descritiva:** Visualizar dados em gráficos e tabelas, obter características e estatísticas básicas (nulos, valores distintos, distribuição).
    * **Identificação de Outliers:** Detectar e analisar valores discrepantes.
    * **Análise de Correlação:** Entender as relações entre diferentes variáveis.
    * **Conclusões:** Extrair insights e informações para tomada de decisão.

## 📊 Fontes de Dados

Os dados foram integralmente obtidos da **Agência Nacional do Cinema (ANCINE)**, através de seu portal de dados abertos ([https://www.gov.br/ancine/pt-br/oca/dados-abertos](https://www.gov.br/ancine/pt-br/oca/dados-abertos)), especificamente:

* **Relatório de Bilheteria Diária de Obras Informadas pelas Distribuidoras (Ano de 2024):** Acesso a relatórios mensais ([https://dados.gov.br/dados/conjuntos-dados/relatorio-de-bilheteria-diaria-de-obras-informadas-pelas-distribuidoras](https://dados.gov.br/dados/conjuntos-dados/relatorio-de-bilheteria-diaria-de-obras-informadas-pelas-distribuidoras)).
    * **Obtenção:** 29/05/2025.
    * **Atualização Periódica:** Semanal.
* **Salas de Exibição e Complexos Registrados na Ancine:** Dados estruturais dos cinemas ([https://dados.gov.br/dados/conjuntos-dados/salas-de-exibicao-e-complexos-registrados-na-ancine](https://www.gov.br/ancine/pt-br/oca/dados-abertos)).
    * **Obtenção:** 29/05/2025.
    * **Atualização Periódica:** Mensal.

## 🛠️ Metodologia e Processo: Da Qualidade dos Dados à Reestruturação

Nossa metodologia seguiu um ciclo rigoroso de **engenharia reversa e AED**, focado na **qualidade dos dados** como ponto de partida.

1.  **Análise Inicial e Desafios (Qualidade dos Dados):**
    * Ao tentar carregar os CSVs brutos, identificamos **inconsistências severas** nos tipos de dados (o banco identificava tipos diferentes dos reais) e **codificações errôneas** que impediam o carregamento direto.
    * As bases não respeitavam princípios de normalização, contendo dependências parciais e transitivas.
    * Foram observadas **anomalias de atualização, inserção e exclusão**, comuns em dados não normalizados.
    * Os dados brutos apresentavam **atributos multivalorados implícita e explicitamente**, não estando nem na Primeira Forma Normal.

2.  **Criação do Banco de Dados e Importação dos Arquivos:**
    * Utilizamos o **PostgreSQL** e o **DBeaver** como gerenciador de banco de dados e interface gráfica, respectivamente.
    * O primeiro passo foi criar o banco de dados `'CINEMA'`, que armazenaria todas as tabelas e scripts SQL.
    * Para estruturar os arquivos nesse ambiente, foram utilizados os seguintes scripts (disponíveis na pasta `scripts_sql/`):
        * **`cria_tabelas.sql`**: Responsável por criar as tabelas iniciais, correspondentes aos dois arquivos CSV baixados, resultando nas tabelas `BilheteriaFilmes2024` e `SalasComplexos`.
        * **`carrega_tabelas.sql`**: Responsável por carregar os arquivos CSV que continham os dados cinematográficos para as tabelas recém-criadas.
        * **`muda_tipos_tabelas.sql`**: Após a inserção dos dados, notamos que os tipos de alguns atributos estavam incoerentes (por exemplo, inteiros sendo representados como `CHAR`). Este script foi utilizado para adequar os tipos das tabelas.

3.  **Reestruturação e Normalização (Engenharia Reversa e Esquema Conceitual):**
    * A partir de uma engenharia reversa das bases, identificamos a necessidade de reestruturar o esquema de dados. Isso foi feito por meio de uma investigação aprofundada em nossas bases, usando consultas que refletiam questões importantes, buscando e desvendando relações entre atributos.
        * Para essa investigação, utilizamos o script **`perguntas_conceitual.sql`**, que contém toda a exploração realizada.
    * Por meio dos resultados obtidos, foi criado um **Esquema Conceitual no Modelo Entidade-Relacionamento (ERD)**, que reflete a lógica do contexto de cinema e serviu de ponto de partida para a normalização.
    * O script **`normalizacao.sql`** implementa essa reestruturação, criando as seguintes entidades (tabelas): `Distribuidora`, `Protocolo`, `Filme`, `Sala`, `Complexo`, `Exibidor`, `Grupo Exibidor` e a tabela `Secao`.
    * **Desafios na Normalização e Carga:** Dentre os diversos desafios, alguns se destacaram:
        * **`registro_sala` nulo na Bilheteria:** 6376 linhas da bilheteria apresentavam `registro_sala` nulo. Esses registros, correspondendo a menos de 1% do total, foram excluídos para garantir a integridade dos relacionamentos na base normalizada.
        * **Mapeamento de `registro_grupo_exibidor`:** A tabela `salascomplexos` não possuía `registro_grupo_exibidor`, exigindo um `JOIN` intermediário via `registro_exibidor` com a tabela de bilheteria para associar grupos a exibidores.
        * **Chave Primária para `Secao`:** Como a tabela de bilheteria original não possuía uma chave primária explícita para cada seção, uma coluna `id_secao` auto-incremental foi criada na tabela `secao` para garantir a unicidade de cada registro.
    * A definição de chaves primárias e estrangeiras foi crucial para garantir a integridade referencial do novo modelo.

## 🔍 Análises Exploratórias e Insights Obtidos

Com o banco de dados agora limpo, normalizado e estruturado, realizamos análises exploratórias aprofundadas, visualizando dados e calculando estatísticas para extrair insights significativos:

1.  **Quantidade de Nulos:**
    * **Script SQL:** `scripts_sql/nulos.sql` 
    * O primeiro passo foi entender a completude de nossas tabelas, buscando atributos com alta incidência de nulos ou valores incompletos.

2.  **Acessibilidade e Inclusão em Complexos de Cinema:**
    * **Script SQL:** `scripts_sql/acessibilidade.sql`
    * Consideramos relevante avaliar o quanto os cinemas brasileiros estão preparados para acomodar os mais diversos tipos de pessoas.
    * Essa análise revelou um cenário crítico de inclusão:
        * Apenas **0,5% do total de complexos de cinema no Brasil** atende a todos os parâmetros de acessibilidade (banheiros, assentos cadeirantes/mobilidade reduzida/obesidade, rampas de acesso à sala e aos assentos).
        * A distribuição desses poucos complexos acessíveis é alarmante: eles se concentram em apenas **9 estados brasileiros**, evidenciando uma profunda disparidade regional. **Bahia** se destaca, com o maior número de estabelecimentos que cumprem integralmente esses requisitos.
    * Este achado reforça a urgência de ações para tornar o acesso à cultura e ao lazer mais equitativo.

3.  **Análise de Outliers:**
    * **Script SQL:** `scripts_sql/analiseoutliers.sql`
    * Identificamos valores discrepantes em várias dimensões:
        * **Quantidade de Assentos por Sala:** Salas de drive-in se destacam com uma quantidade de assentos significativamente superior à média.
        * **Quantidade de Complexos por UF:** Estados mais populosos (São Paulo, Rio de Janeiro e Minas Gerais) concentram um número desproporcionalmente maior de complexos.
        * **Público Total por Filme e por Distribuidora:** Filmes como *Divertidamente 2* e distribuidoras como The Walt Disney Company demonstraram público muito acima da média, enquanto outros tiveram desempenho muito abaixo.

4.  **Sazonalidade do Público:**
    * **Script SQL:** `scripts_sql/sazonalidade.sql`
    * Investigamos a variação do público total nos cinemas ao longo dos meses de 2024. A análise revelou que, embora as férias escolares pudessem indicar picos, o público é **principalmente orientado pela popularidade dos filmes em exibição**. Meses com grandes lançamentos coincidiram com os maiores públicos (e.g., Junho, Julho, Novembro e Dezembro).

5.  **Análise de Correlação:**
    * Investigamos a correlação entre a **quantidade de filmes lançados por distribuidora e o público total**. Observou-se uma correlação positiva, porém de intensidade moderada a fraca ($R^2 = 0,31$). Isso sugere que, embora lançar mais filmes tenda a aumentar o público, essa relação não é tão expressiva. A quantidade de filmes é apenas um dos fatores que contribuem para o desempenho de público das distribuidoras.

6.  **Descobertas Adicionais na Qualidade dos Dados:**
    * A análise da tabela `filme` revelou que a coluna `titulo_brasil` apresentava nulos significativos para filmes de produção brasileira. Isso ocorre porque filmes brasileiros geralmente têm apenas `titulo_original` preenchido. Essa observação levou à proposição de um tratamento de dados para padronizar essa informação (copiar `titulo_original` para `titulo_brasil` quando `pais_obra` for 'BRASIL' e `titulo_brasil` for nulo).

## 📂 Estrutura do Repositório

Seu repositório está organizado da seguinte forma:
