create or replace FUNCTION f_particionar_review_score
RETURN tipo_retorno_func_review_score PIPELINED
AS
    v_start                 NUMBER(5);
    v_end                   NUMBER(5);
    v_pontuacao_anime       VARCHAR2(50);
    v_id_pontuacao          INT;
    v_id                    DLK_REVIEWS.ID%TYPE; 
    v_score                 DLK_REVIEWS.SCORES%TYPE;
BEGIN
    FOR registro IN (SELECT ID, SCORES FROM DLK_REVIEWS) LOOP
        v_id := registro.ID;
        v_score := registro.SCORES;
        v_start := 1;

        LOOP
            v_end := INSTR(v_score, ',', v_start);
            IF v_end = 0 THEN
                v_pontuacao_anime := TRIM(SUBSTR(v_score, v_start));
                v_pontuacao_anime := REPLACE(REPLACE(REPLACE(v_pontuacao_anime, '''', ''), '{', ''), '}', '');
                v_id_pontuacao := case SUBSTR(v_pontuacao_anime, 1, INSTR(v_pontuacao_anime, ':') - 1) 
                                    when 'Overall'      then 1
                                    when 'Story'        then 2 
                                    when 'Animation'    then 3
                                    when 'Sound'        then 4
                                    when 'Character'    then 5
                                    when 'Enjoyment'    then 6 end;
                v_pontuacao_anime := REPLACE(SUBSTR(v_pontuacao_anime, -2, INSTR(v_pontuacao_anime, ':')  -1),' ',''); 
                
                PIPE ROW (retorno_func_review_score(v_id, v_pontuacao_anime, v_id_pontuacao));
                EXIT;
            ELSE
                v_pontuacao_anime := TRIM(SUBSTR(v_score, v_start, v_end - v_start));
                v_pontuacao_anime := REPLACE(REPLACE(REPLACE(v_pontuacao_anime, '''', ''), '{', ''), '}', '');
                v_id_pontuacao := case SUBSTR(v_pontuacao_anime, 1, INSTR(v_pontuacao_anime, ':') - 1) 
                                    when 'Overall'      then 1
                                    when 'Story'        then 2 
                                    when 'Animation'    then 3
                                    when 'Sound'        then 4
                                    when 'Character'    then 5
                                    when 'Enjoyment'    then 6 end;
                v_pontuacao_anime := REPLACE(SUBSTR(v_pontuacao_anime, -2, INSTR(v_pontuacao_anime, ':')  -1),' ',''); 
                PIPE ROW (retorno_func_review_score(v_id, v_pontuacao_anime, v_id_pontuacao));
                v_start := v_end + 1;
            END IF;
        END LOOP;
    END LOOP;
    RETURN;
END f_particionar_review_score;