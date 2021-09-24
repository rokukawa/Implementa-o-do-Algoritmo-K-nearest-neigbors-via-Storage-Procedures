-- Table: public.iris

-- DROP TABLE public.iris;

CREATE TYPE nome AS ENUM ('Iris-setosa', 'Iris-versicolor', 'Iris-virginica');

CREATE TABLE public.iris
(
    comprimento_sepala double precision,
    largura_sepala double precision,
    comprimento_petala double precision,
    largura_petala double precision,
    classe nome,
    id_iris integer NOT NULL DEFAULT nextval('iris_id_iris_seq'::regclass)
)

/* populando a tabela iris, com a copia dos dados do arquivo csv do iris dataset*/
COPY iris
(
    comprimento_sepala,
    largura_sepala,
    comprimento_petala,
    largura_petala,
	classe
)
FROM 'D:/iris.data'
DELIMITER ','
CSV HEADER;

/* adicionando id para cada flor do iris dataset */
ALTER TABLE iris
ADD COLUMN id_iris SERIAL;

TABLESPACE pg_default;

ALTER TABLE public.iris
    OWNER to postgres;
