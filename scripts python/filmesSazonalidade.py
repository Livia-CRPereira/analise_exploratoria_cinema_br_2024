import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

# --- Configurações do Arquivo CSV de Entrada ---
CSV_INPUT_PATH = 'filmes.csv' 

# --- Execução do Script ---
try:
    print(f"Lendo dados de '{CSV_INPUT_PATH}' para gerar o gráfico...")
    df_filmes = pd.read_csv(CSV_INPUT_PATH)
    print("Dados lidos do CSV com sucesso!")

    # --- Pré-processamento dos Dados para o Gráfico ---
    # Garante que a coluna 'mes_exibicao' seja numérica (se não for, o read_csv pode inferir como string)
    df_filmes['mes_exibicao'] = pd.to_numeric(df_filmes['mes_exibicao'], errors='coerce')

    df_filmes = df_filmes[df_filmes['mes_exibicao'].between(6, 12)]
    print("Dados filtrados para meses de Junho a Dezembro.")

    # Cria uma lista de nomes de meses para usar nos rótulos do gráfico
    nomes_dos_meses = {
        1: 'Janeiro', 2: 'Fevereiro', 3: 'Março', 4: 'Abril',
        5: 'Maio', 6: 'Junho', 7: 'Julho', 8: 'Agosto',
        9: 'Setembro', 10: 'Outubro', 11: 'Novembro', 12: 'Dezembro'
    }
    # Mapeia os números dos meses para os seus nomes correspondentes
    df_filmes['mes_nome'] = df_filmes['mes_exibicao'].map(nomes_dos_meses)

    # Garante a ordem correta dos meses no gráfico
    # As categorias devem incluir apenas os meses que serão exibidos, na ordem correta
    meses_filtrados_nomes = [nomes_dos_meses[m] for m in range(6, 13) if m in df_filmes['mes_exibicao'].unique()]
    df_filmes['mes_nome'] = pd.Categorical(df_filmes['mes_nome'], categories=meses_filtrados_nomes, ordered=True)
    
    # Ordena o DataFrame para garantir a visualização correta
    df_filmes = df_filmes.sort_values(by=['mes_exibicao', 'publico_total_no_mes'], ascending=[True, False])


    # --- Geração do Gráfico ---
    print("Gerando o gráfico de público dos filmes populares por mês...")

    sns.set_style("whitegrid")
    plt.figure(figsize=(15, 8)) # Aumenta o tamanho para acomodar mais barras e rótulos

    # Cria o gráfico de barras agrupadas
    sns.barplot(
        x='mes_nome',           # Eixo X: Nomes dos meses
        y='publico_total_no_mes', # Eixo Y: Público total no mês
        hue='titulo_original',  # Agrupa as barras por título do filme (diferenciado por cor)
        data=df_filmes,         # DataFrame com os dados
        palette='tab10'         # Esquema de cores para os filmes
    )

    # Adiciona rótulos e título ao gráfico
    plt.xlabel("Mês de Exibição")
    plt.ylabel("Público Total")
    plt.title("Público dos 5 Filmes Mais Populares por Mês (Junho a Dezembro de 2024)") # Título atualizado
    plt.xticks(rotation=45, ha='right') # Rotaciona os rótulos do eixo X para melhor visualização
    plt.legend(title='Filme', bbox_to_anchor=(1.05, 1), loc='upper left') # Move a legenda para fora do gráfico
    plt.tight_layout(rect=[0, 0, 0.88, 1]) # Ajusta o layout para dar espaço à legenda

    # Opcional: Adicionar rótulo de escala ao eixo Y (se os números forem muito grandes)
    max_publico = df_filmes['publico_total_no_mes'].max()
    if max_publico >= 1_000_000:
        escala_label = " (em milhões)"
        escala_divisor = 1_000_000
    elif max_publico >= 1_000:
        escala_label = " (em milhares)"
        escala_divisor = 1_000
    else:
        escala_label = ""
        escala_divisor = 1

    plt.ylabel(f"Público Total{escala_label}")
    if escala_divisor > 1:
        formatter = plt.FuncFormatter(lambda x, p: f'{x/escala_divisor:.1f}') # Divide e formata
        plt.gca().yaxis.set_major_formatter(formatter)

    # Exibe o gráfico
    plt.show()

    # Opcional: Salvar o gráfico em um arquivo
    plt.savefig('filmes_sazonalidade.png', dpi=300, bbox_inches='tight')
    print("Gráfico salvo como 'publico_filmes_populares_sazonalidade.png'")

except FileNotFoundError:
    print(f"ERRO: O arquivo '{CSV_INPUT_PATH}' não foi encontrado.")
    print("Certifique-se de que o CSV foi exportado corretamente e está na mesma pasta do script Python.")
except Exception as e:
    print(f"Ocorreu um erro inesperado: {e}")
