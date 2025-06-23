DO $$

-- Carrega todos os arquivos de meses
DECLARE
    base_csv_path TEXT := 'C:/data_cinema/'; -- Caminho da pasta. Use barras normais no PostgreSQL.
    table_name TEXT := 'bilheteriafilmes2024';
    current_mes TEXT;
    csv_file_name TEXT;
    full_csv_path TEXT;
    sql_command TEXT;
    meses_array TEXT[] := ARRAY['janeiro', 'fevereiro', 'marco', 'abril', 'maio', 'junho',
                                'julho', 'agosto', 'setembro', 'outubro', 'novembro', 'dezembro'];
BEGIN
    RAISE NOTICE 'Iniciando COPY para cada mês...';

    FOREACH current_mes IN ARRAY meses_array
    LOOP
        csv_file_name := current_mes || '.csv';
        full_csv_path := base_csv_path || csv_file_name;

        sql_command := FORMAT('COPY %I.%I FROM %L WITH (FORMAT CSV, DELIMITER '';'', HEADER TRUE, ENCODING ''UTF8'')',
                              'public', table_name, full_csv_path);

        RAISE NOTICE 'Executando para %: %', csv_file_name, sql_command;

        -- Bloco EXCEPTION para lidar com erros em cada COPY individualmente
        BEGIN
            EXECUTE sql_command;
            RAISE NOTICE 'COPY para % concluído com sucesso!', csv_file_name;
        EXCEPTION
            WHEN OTHERS THEN
                RAISE WARNING 'ERRO ao executar COPY para %. Mensagem: %', csv_file_name, SQLERRM;
                -- Você pode optar por parar aqui ou continuar
        END;
    END LOOP;

    RAISE NOTICE 'Processo de COPY concluído para todos os meses na Bilheteria.';

    -- Carrega o arquivo SalasComplexos.csv
    full_csv_path := base_csv_path || 'SalasComplexos.csv';
    sql_command := FORMAT('COPY %I.%I FROM %L WITH (FORMAT CSV, DELIMITER '';'', HEADER TRUE, ENCODING ''UTF8'')',
                          'public', 'salascomplexos', full_csv_path);

    RAISE NOTICE 'Executando para SalasComplexos.csv: %', sql_command;

    BEGIN
        EXECUTE sql_command;
        RAISE NOTICE 'COPY para SalasComplexos.csv concluído com sucesso!';
    EXCEPTION
        WHEN OTHERS THEN
            RAISE WARNING 'ERRO ao executar COPY para SalasComplexos.csv. Mensagem: %', SQLERRM;
    END;

    RAISE NOTICE 'Processo de COPY concluído para Salas e Complexos.';

END $$;
