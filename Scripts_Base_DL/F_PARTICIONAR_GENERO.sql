create or replace FUNCTION f_particionar_genero
RETURN tipo_retorno_func_genero PIPELINED
AS
    v_start    NUMBER(5);
    v_end      NUMBER(5);
    v_genero   VARCHAR2(50);
    v_id       DLK_ANIMES.ID%TYPE;
    v_genre    DLK_ANIMES.genre%TYPE;
BEGIN
    FOR registro IN (SELECT ID, genre FROM DLK_ANIMES) LOOP
        v_id := registro.ID;
        v_genre := registro.genre;
        v_start := 1;

        LOOP
            v_end := INSTR(v_genre, ',', v_start);
            IF v_end = 0 THEN
                v_genero := TRIM(SUBSTR(v_genre, v_start));
                v_genero := REPLACE(REPLACE(REPLACE(v_genero, '''', ''), '[', ''), ']', '');
                PIPE ROW (retorno_func_genero(v_id, v_genero));
                EXIT;
            ELSE
                v_genero := TRIM(SUBSTR(v_genre, v_start, v_end - v_start));
                v_genero := REPLACE(REPLACE(REPLACE(v_genero, '''', ''), '[', ''), ']', '');
                PIPE ROW (retorno_func_genero(v_id, v_genero));
                v_start := v_end + 1;
            END IF;
        END LOOP;
    END LOOP;
    RETURN;
END f_particionar_genero;
/