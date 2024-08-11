create or replace FUNCTION f_particionar_animes_fav
RETURN tipo_retorno_func_animes_fav PIPELINED
AS
    v_start                 NUMBER(5);
    v_end                   NUMBER(5);
    v_animes_favoritos      VARCHAR2(50);
    v_id                    DLK_PROFILES.ID%TYPE;
    v_favorites_animes      DLK_PROFILES.favorites_animes%TYPE;
BEGIN
    FOR registro IN (SELECT ID, favorites_animes FROM DLK_PROFILES) LOOP
        v_id := registro.ID;
        v_favorites_animes := registro.favorites_animes;
        v_start := 1;

        LOOP
            v_end := INSTR(v_favorites_animes, ',', v_start);
            IF v_end = 0 THEN
                v_animes_favoritos := TRIM(SUBSTR(v_favorites_animes, v_start));
                v_animes_favoritos := REPLACE(REPLACE(REPLACE(v_animes_favoritos, '''', ''), '[', ''), ']', '');
                PIPE ROW (retorno_func_animes_fav(v_id, v_animes_favoritos));
                EXIT;
            ELSE
                v_animes_favoritos := TRIM(SUBSTR(v_favorites_animes, v_start, v_end - v_start));
                v_animes_favoritos := REPLACE(REPLACE(REPLACE(v_animes_favoritos, '''', ''), '[', ''), ']', '');
                PIPE ROW (retorno_func_animes_fav(v_id, v_animes_favoritos));
                v_start := v_end + 1;
            END IF;
        END LOOP;
    END LOOP;
    RETURN;
END f_particionar_animes_fav;