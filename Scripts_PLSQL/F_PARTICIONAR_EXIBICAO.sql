create or replace FUNCTION f_particionar_exibicao
RETURN tipo_retorno_func_aired PIPELINED
AS
    v_start         NUMBER(5);
    v_end           NUMBER(5);
    v_aired_start   VARCHAR2(50);
    v_aired_end     VARCHAR2(50);
    v_id            DLK_ANIMES.ID%TYPE;
    v_aired         VARCHAR2(100); -- Ajuste aqui se necessário para o tamanho apropriado

BEGIN
    FOR registro IN (SELECT ID, aired FROM DLK_ANIMES) LOOP
        v_id := registro.ID;
        v_aired := registro.aired;

        v_start := 1;

        LOOP
            v_end := INSTR(v_aired, ',', v_start);

            IF v_end = 0 THEN
                v_aired_start := TRIM(
                    CASE 
                        WHEN INSTR(v_aired, 'to') > 0 THEN SUBSTR(v_aired, 1, INSTR(v_aired, 'to') - 1) 
                        ELSE v_aired 
                    END
                );

                v_aired_end := TRIM(
                    CASE 
                        WHEN INSTR(v_aired, 'to') > 0 THEN SUBSTR(v_aired, INSTR(v_aired, 'to') + 3) 
                        ELSE NULL 
                    END
                );

                PIPE ROW (retorno_func_aired(v_id, v_aired_start, v_aired_end));
                EXIT;
            ELSE
                v_aired_start := TRIM(
                    CASE 
                        WHEN INSTR(v_aired, 'to') > 0 THEN SUBSTR(v_aired, 1, INSTR(v_aired, 'to') - 1) 
                        ELSE v_aired 
                    END
                );

                v_aired_end := TRIM(
                    CASE 
                        WHEN INSTR(v_aired, 'to') > 0 THEN SUBSTR(v_aired, INSTR(v_aired, 'to') + 3) 
                        ELSE NULL 
                    END
                );

                PIPE ROW (retorno_func_aired(v_id, v_aired_start, v_aired_end));
                v_start := v_end + 1;
            END IF;
        END LOOP;
    END LOOP;
    RETURN;
END f_particionar_exibicao;