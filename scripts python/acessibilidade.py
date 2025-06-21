import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

# --- Configurações do Arquivo CSV de Entrada ---

CSV_INPUT_PATH = 'acessibilidade_estado.csv' 
# --- Execução do Script ---
try:
    print(f"Lendo dados de '{CSV_INPUT_PATH}' para gerar o gráfico...")
    df_acessibilidade = pd.read_csv(CSV_INPUT_PATH)
    print("Dados lidos do CSV com sucesso!")

    # ###############################################################
    # Pré-processamento e Ordenação
    # Garante que os estados estejam ordenados pelo número total de complexos acessíveis (decrescente)
    # Isso é importante para que o gráfico mostre do maior para o menor.
    # ###############################################################
    df_acessibilidade = df_acessibilidade.sort_values(by='total_complexos_acessiveis', ascending=False)

    # --- Geração do Gráfico ---
    print("Gerando o gráfico de complexos acessíveis por estado...")

    sns.set_style("whitegrid")
    plt.figure(figsize=(14, 7)) # Define o tamanho da figura (largura, altura)

    # Cria o gráfico de barras
    sns.barplot(
        x='uf_complexo',                     # Eixo X: Os estados (UF)
        y='total_complexos_acessiveis', # Eixo Y: O total de complexos acessíveis
        data=df_acessibilidade,         # DataFrame com os dados
        palette='magma'                 # Esquema de cores (ex: 'viridis', 'plasma', 'cividis', 'magma')
    )

    # Adiciona rótulos e título ao gráfico
    plt.xlabel("Estado (UF)")
    plt.ylabel("Número de Complexos com Acessibilidade Completa")
    plt.title("Complexos com Acessibilidade Completa por Estado")
    plt.xticks(rotation=45, ha='right') # Rotaciona os rótulos do eixo X se houver muitos estados
    plt.tight_layout() # Ajusta o layout para evitar que rótulos se sobreponham

    # ###############################################################
    # Adicionar os valores numéricos em cima de cada barra para clareza
    # E escalar o eixo Y se os números forem muito grandes (igual ao gráfico anterior)
    # ###############################################################
    max_value = df_acessibilidade['total_complexos_acessiveis'].max()
    escala_label = ""
    escala_divisor = 1

    if max_value >= 1_000_000:
        escala_label = " (em milhões)"
        escala_divisor = 1_000_000
    elif max_value >= 1_000:
        escala_label = " (em milhares)"
        escala_divisor = 1_000

    # Atualiza o rótulo do eixo Y com a escala
    plt.ylabel(f"Número de Complexos com Acessibilidade Completa{escala_label}")

    # Formata os ticks do eixo Y
    if escala_divisor > 1:
        formatter = plt.FuncFormatter(lambda x, p: f'{x/escala_divisor:.1f}')
        plt.gca().yaxis.set_major_formatter(formatter)

    # Adiciona os valores nas barras (mesmo com a escala, o valor original é usado no texto)
    for index, row in df_acessibilidade.iterrows():
        plt.text(
            x=index, # Posição X da barra
            y=row['total_complexos_acessiveis'] + (max_value * 0.02), # Posição Y (valor + pequeno offset)
            s=f'{row["total_complexos_acessiveis"]:,}', # Valor formatado com vírgulas
            color='black',
            ha='center',
            va='bottom',
            fontsize=10
        )


    # Exibe o gráfico
    plt.show()

    # Opcional: Salvar o gráfico em um arquivo
    plt.savefig('complexos_acessiveis_por_estado.png', dpi=300, bbox_inches='tight')
    print("Gráfico salvo como 'complexos_acessiveis_por_estado.png'")

except FileNotFoundError:
    print(f"ERRO: O arquivo '{CSV_INPUT_PATH}' não foi encontrado.")
    print("Certifique-se de que o CSV foi exportado corretamente do DBeaver e está na mesma pasta do script Python.")
except Exception as e:
    print(f"Ocorreu um erro inesperado: {e}")

