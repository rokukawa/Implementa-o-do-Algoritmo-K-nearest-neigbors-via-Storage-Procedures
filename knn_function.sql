
-- FUNCTION: public.knn_function(real, real, real, real, integer)

-- DROP FUNCTION public.knn_function(real, real, real, real, integer);

CREATE OR REPLACE FUNCTION public.knn_function(
	real,
	real,
	real,
	real,
	integer)
    RETURNS text
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
		c_sepala ALIAS FOR $1;
		l_sepala ALIAS FOR $2;
		c_petala ALIAS FOR $3;
		l_petala ALIAS FOR $4;
		valor_k ALIAS FOR $5;
		qnt_setosa integer;
		qnt_versicolor integer;
		qnt_virginica integer;
		resposta text;
		registro RECORD; /* a variavel registro do tipo RECORD, funcionara como auxiliar das informações de cada laço do FOR */
		tupla tupla_iris; /* variavel customizada, onde terá os campo distância (euclidiana), id_iris (id da flor) e classe (nome da flor) */
	BEGIN 
		FOR registro IN SELECT id_iris FROM iris LOOP /* laço de repetição percorrendo toda a tabela iris */
			/* o select fará o retorno de todos os cálculos euclidianos das amostras e armazenará na variavel tupla do tipo tupla_iris */
			SELECT INTO tupla
				I.id_iris,
				CAST(SQRT(POWER((c_sepala - I.comprimento_sepala),2)
					+POWER((l_sepala - I.largura_sepala),2)
					+POWER((c_petala - I.comprimento_petala),2)
					+POWER((l_petala - I.largura_petala),2)) AS NUMERIC(14,4)),
				I.classe
			FROM iris I
			WHERE I.id_iris = registro.id_iris;
			INSERT INTO table_iris VALUES(tupla.id_iris, tupla.distancia, tupla.classe); /* adiciona os valores da consulta à uma tabela auxiliar table_iris */
 		END LOOP;
		
		/* cada select count, fará a contagem de cada tipo de classe na tabela dos conjunto de k vizinho mais próximos e armazenará em suas respectivas 
		variáveis, os valores retornado pelo count */
		SELECT COUNT(*) INTO qnt_setosa
		FROM 
		(SELECT * FROM table_iris ORDER BY distancia_tb_iris LIMIT valor_k) AS f
		WHERE classe_tb_iris = 'Iris-setosa';
		
		SELECT COUNT(*) INTO qnt_versicolor
		FROM 
		(SELECT * FROM table_iris ORDER BY distancia_tb_iris LIMIT valor_k) AS f
		WHERE classe_tb_iris = 'Iris-versicolor';
		
		SELECT COUNT(*) INTO qnt_virginica
		FROM 
		(SELECT * FROM table_iris ORDER BY distancia_tb_iris LIMIT valor_k) AS f
		WHERE classe_tb_iris = 'Iris-virginica';
		
		/* cada condição if, analizará qual variavel possui mais classe entre os vizinho mais próximos e assim, 
		retornará a classe que a consulta mais representar */
		IF qnt_setosa >= qnt_versicolor AND qnt_setosa >= qnt_virginica THEN
			resposta := 'SETOSA';
			RAISE NOTICE 'CLASSE %', resposta;
		ELSIF qnt_versicolor >= qnt_setosa AND qnt_versicolor >= qnt_virginica THEN
			resposta := 'VERSICOLOR';
			RAISE NOTICE 'CLASSE %', resposta;
		ELSIF qnt_virginica >= qnt_setosa AND qnt_virginica >= qnt_versicolor THEN
			resposta := 'VIRGINICA';
			RAISE NOTICE 'CLASSE %', resposta;
		END IF;
		
		TRUNCATE TABLE table_iris;
		RETURN resposta;
	END;
$BODY$;

ALTER FUNCTION public.knn_function(real, real, real, real, integer)
    OWNER TO postgres;
