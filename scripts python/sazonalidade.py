import pandas as pd 
import matplotlib.pyplot as plt 
import seaborn as sns 

# --- Configurações do Arquivo CSV de Entrada ---
CSV_INPUT_PATH = 'sazonalidade.csv'

try:
    print(f"Lendo dados de '{CSV_INPUT_PATH}' para gerar o gráfico...")
    df_para_grafico = pd.read_csv(CSV_INPUT_PATH)
    print("Dados lidos do CSV para gráfico com sucesso!")

    # --- Pré-processamento dos Dados para o Gráfico ---
    # Cria uma lista de nomes de meses para usar nos rótulos do gráfico
    nomes_dos_meses = {
        1: 'Janeiro', 2: 'Fevereiro', 3: 'Março', 4: 'Abril',
        5: 'Maio', 6: 'Junho', 7: 'Julho', 8: 'Agosto',
        9: 'Setembro', 10: 'Outubro', 11: 'Novembro', 12: 'Dezembro'
    }
    # Mapeia os números dos meses para os seus nomes correspondentes
    df_para_grafico['mes_nome'] = df_para_grafico['mes_exibicao'].map(nomes_dos_meses)

    # Garante a ordem correta dos meses no gráfico
    df_para_grafico['mes_nome'] = pd.Categorical(df_para_grafico['mes_nome'], categories=nomes_dos_meses.values(), ordered=True)
    df_para_grafico = df_para_grafico.sort_values('mes_exibicao')


    # --- Geração do Gráfico ---
    print("Gerando o gráfico de sazonalidade...")

    # Define o estilo do gráfico (opcional, deixa mais bonito)
    sns.set_style("whitegrid")
    plt.figure(figsize=(10, 5)) # Define o tamanho da figura (largura, altura)

    # Cria o gráfico de barras
    sns.barplot(
        x='mes_nome',           # Eixo X: Nomes dos meses
        y='publico_total_mensal', # Eixo Y: Público total mensal
        data=df_para_grafico,   # DataFrame com os dados (agora lidos do CSV)
        palette='viridis'       # Esquema de cores
    )

    # Adiciona rótulos e título ao gráfico
    plt.xlabel("Mês")
    plt.title("Sazonalidade do Público em Cinemas (2024)")
    plt.xticks(rotation=45, ha='right') # Rotaciona os rótulos do eixo X para melhor visualização
    plt.tight_layout() # Ajusta o layout para evitar que rótulos se sobreponham

    
    # Determina a escala com base no valor máximo do público
    max_publico = df_para_grafico['publico_total_mensal'].max()
    if max_publico >= 1_000_000:
        escala_label = " (em milhões)"
        escala_divisor = 1_000_000
    elif max_publico >= 1_000:
        escala_label = " (em milhares)"
        escala_divisor = 1_000
    else:
        escala_label = ""
        escala_divisor = 1

    # Atualiza os rótulos do eixo Y para refletir a escala
    # Para que a escala no eixo Y apareça corretamente, é preciso ajustar os "tick labels"
    # Matplotlib pode fazer isso automaticamente com FuncFormatter ou ScalarFormatter
    # Mas para uma legenda simples, podemos adicionar ao ylabel.
    plt.ylabel(f"Público Total{escala_label}")
    # Para forçar a notação de escala no eixo Y (como "x 1e7"), o matplotlib faz isso automaticamente
    # se o ScalarFormatter for usado, mas o Seaborn pode sobreescrever algumas dessas configurações.
    # Uma forma manual é manipular o formato dos ticks:
    if escala_divisor > 1:
        formatter = plt.FuncFormatter(lambda x, p: f'{x/escala_divisor:.1f}') # Divide e formata
        plt.gca().yaxis.set_major_formatter(formatter)
        
    # ###############################################################


    # Exibe o gráfico
    plt.show()

    # Opcional: Salvar o gráfico em um arquivo
    plt.savefig('sazonalidade_publico_2024.png', dpi=300, bbox_inches='tight')
    print("Gráfico salvo como 'sazonalidade_publico_2024.png'")

except FileNotFoundError:
    print(f"ERRO: O arquivo '{CSV_INPUT_PATH}' não foi encontrado.")
    print("Certifique-se de que o CSV foi exportado corretamente do DBeaver e está na mesma pasta do script Python.")
except Exception as e:
    print(f"Ocorreu um erro inesperado: {e}")

