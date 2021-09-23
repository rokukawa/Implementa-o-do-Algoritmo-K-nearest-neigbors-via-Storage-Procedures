/* GUSTAVO ROKUKAWA CAMARGO - RA 2209772*/

-- Table: public.table_iris

-- DROP TABLE public.table_iris;

/* tabela auxiliar para armazenar os dados da consulta e calculo euclidiano para cada consutla */

CREATE TABLE public.table_iris
(
    id_tb_iris integer,
    distancia_tb_iris real,
    classe_tb_iris text COLLATE pg_catalog."default"
)

TABLESPACE pg_default;

ALTER TABLE public.table_iris
    OWNER to postgres;