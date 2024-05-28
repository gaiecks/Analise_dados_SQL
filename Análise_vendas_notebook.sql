-- Databricks notebook source
-- MAGIC %md
-- MAGIC Vamos realizar uma análise exploratória de um dataset sobre notebooks e suas especificações. O objetivo é explorar o conteúdo no tocante a participação das marcas no mercado, preços por marca e por especificações relevantes como processador e tipo de memória utilizada e etc. 
-- MAGIC Deseja-se demonstrar algumas Queries em SQL para gerar insights sobre o conjuto de dados, mas não é o objetivo do projeto se aprofundar nas análises. 

-- COMMAND ----------

/*Verificando os dados contidos na tabela*/

select * from tb_notebook limit 10

-- COMMAND ----------

/* Criando uma View com colunas convertendo o preço dos notebooks de Rupias Indianas para Real
e ajustando o campo de desconto*/

create view vw_tb_notebook as
select *, 
round((latest_price*0.063),2) as preco_atual_real, 
round((old_price*0.063),2) as preco_antigo_real,
discount / 100 as discount2
from tb_notebook

-- COMMAND ----------

select * from vw_tb_notebook

-- COMMAND ----------

/*Calculando a média de preços. 
OBS: verificou-se que a marca "Lenovo" aparece também como "lenovo" e foi feita uma tratativa para corrigir os dados.*/

select
case when brand = "lenovo" then "Lenovo"
     else brand
end as brand_new,
round(avg(preco_atual_real),2) as media_preco_atual
from vw_tb_notebook
group by brand_new
order by media_preco_atual desc

-- COMMAND ----------

-- MAGIC %md
-- MAGIC Podemos observar que a média de preços dos notebooks da marca "Alienware" é bem superior as demais. A marca "Apple" também se destaca por preços elevados.

-- COMMAND ----------

-- MAGIC %md
-- MAGIC Vamos analisar um pouco os preços considerando o tipo de memória RAM presente nos notebooks:

-- COMMAND ----------

/* Analisando a média de preços por tipo de memória RAM*/

select 
case when ram_type = "LPDDR3" then "DDR3"
     when ram_type in ('LPDDR4','LPDDR4X') then "DDR4"
     else ram_type
end as ram_type_new,
round(avg(preco_atual_real),2) as media_preco_atual
from vw_tb_notebook
group by ram_type_new

-- COMMAND ----------

-- MAGIC %md
-- MAGIC Aqui encontramos um fato curioso, pois a tecnologia DDR4 é mais atual e mais cara. Entretanto, a média de preços de notebooks com DDR3 é maior. Vamos trazer algumas informações a mais sobre os notebooks com DDR3 e DDR4 para identificar qual pode ser a justificativa:

-- COMMAND ----------

SELECT 
    CASE 
        WHEN brand = "lenovo" THEN "Lenovo"
        ELSE brand
    END AS brand_new,
    model,
    processor_brand,
    preco_atual_real,
    processor_name,
    processor_gnrtn,
    ram_gb,
    CASE 
        WHEN ram_type IN ('DDR3', 'LPDDR3') THEN 'DDR3'
        ELSE ram_type
    END AS ram_type_new,
    ssd,
    hdd,
    os,
    os_bit,
    graphic_card_gb,
    weight,
    display_size
    
FROM 
    vw_tb_notebook
WHERE 
    ram_type IN ('DDR3', 'LPDDR3')
ORDER BY 
    preco_atual_real DESC;


-- COMMAND ----------

SELECT 
    CASE 
        WHEN brand = "lenovo" THEN "Lenovo"
        ELSE brand
    END AS brand_new,
    model,
    processor_brand,
    preco_atual_real,
    processor_name,
    processor_gnrtn,
    ram_gb,
    CASE 
        WHEN ram_type IN ('DDR4', 'LPDDR4', 'LPDDR4X') THEN 'DDR4'
        ELSE ram_type
    END AS ram_type_new,
    ssd,
    hdd,
    os,
    os_bit,
    graphic_card_gb,
    weight,
    display_size
FROM 
    vw_tb_notebook
WHERE 
    ram_type IN ('DDR4', 'LPDDR4', 'LPDDR4X')
ORDER BY 
    preco_atual_real DESC;


-- COMMAND ----------

-- MAGIC %md
-- MAGIC Observamos que nas listas acima criadas, temos muito mais notebooks com tecnologia DDR4 e consequentemente muito mais valores que puxam a média para baixo. Com a tecnologia DDR3 há poucos modelos, sendo que esses poussuem especificações consideravelmente boas e que elevam a média de preços desses produtos. 
-- MAGIC Vamos conferir a quantidade de modelos por marca para cada tipo de memória:

-- COMMAND ----------

SELECT 
    CASE 
        WHEN brand = "lenovo" THEN "Lenovo"
        ELSE brand
    END AS brand_new,
    SUM(CASE WHEN ram_type IN ('DDR3', 'LPDDR3') THEN 1 ELSE 0 END) AS qtd_models_ddr3,
    SUM(CASE WHEN ram_type IN ('DDR4', 'LPDDR4', 'LPDDR4X') THEN 1 ELSE 0 END) AS qtd_models_ddr4,
    SUM(CASE WHEN ram_type = "DDR5" THEN 1 ELSE 0 END) AS qtd_models_ddr5
FROM 
    vw_tb_notebook
GROUP BY 
    brand_new
ORDER BY 
    brand_new;




-- COMMAND ----------

-- MAGIC %md
-- MAGIC Evidenciamos que de fato as quantidades de notebooks com memória DDR4 é muito maior.
-- MAGIC Vamos observar as médias de preço por tipo de memória por marca:
-- MAGIC

-- COMMAND ----------

SELECT 
    CASE 
        WHEN brand = "lenovo" THEN "Lenovo"
        ELSE brand
    END AS brand_new,
    ROUND(AVG(CASE 
                WHEN ram_type = "LPDDR3" THEN preco_atual_real
                WHEN ram_type = "DDR3" THEN preco_atual_real
                ELSE NULL
              END), 2) AS media_preco_ddr3,
    ROUND(AVG(CASE 
                WHEN ram_type IN ('LPDDR4', 'LPDDR4X') THEN preco_atual_real
                WHEN ram_type = "DDR4" THEN preco_atual_real
                ELSE NULL
              END), 2) AS media_preco_ddr4,
    ROUND(AVG(CASE 
                WHEN ram_type = "DDR5" THEN preco_atual_real
                ELSE NULL
              END), 2) AS media_preco_ddr5
FROM 
    vw_tb_notebook
GROUP BY 
    brand_new
ORDER BY 
    media_preco_ddr3 DESC, media_preco_ddr4 DESC, media_preco_ddr5 DESC;



-- COMMAND ----------

-- MAGIC %md
-- MAGIC Vemos que a média de preços de notebooks por marca é quase sempre maior em notebooks com memória DDR3. O fato deve ser explicado pela baixa quantidade de produtos nessa amostra somado a serem modelos mais caros que o convencional. 
-- MAGIC
-- MAGIC Agora vamos analisar o intervalo de preços dos notebooks por marca:

-- COMMAND ----------

SELECT 
    CASE 
        WHEN brand = "lenovo" THEN "Lenovo"
        ELSE brand
    END AS brand_new,
    MAX(preco_atual_real) AS maior_valor,
    MIN(preco_atual_real) AS menor_valor,
    round((maior_valor - menor_valor),2) as delta_preco
FROM 
    vw_tb_notebook
GROUP BY 
    brand_new
ORDER BY 
    delta_preco desc



-- COMMAND ----------

-- MAGIC %md
-- MAGIC Vemos que algumas marcas possuem um delta no preço muito grande, evidenciando a participação da marca em vários nichos de mercado, com produtos de entrada e produtos de elite. 
-- MAGIC Abaixo vamos categorizar os preços em intervalos apenas para fins de constatação da participação da marca em determinados intervalos de preço de mercado:

-- COMMAND ----------

SELECT 
    CASE 
        WHEN brand = "lenovo" THEN "Lenovo"
        ELSE brand
    END AS brand_new,
    SUM(CASE WHEN preco_atual_real <= 5000 THEN 1 ELSE 0 END) AS ate_5000,
    SUM(CASE WHEN preco_atual_real > 5000 AND preco_atual_real <= 8000 THEN 1 ELSE 0 END) AS faixa_5001_8000,
    SUM(CASE WHEN preco_atual_real > 8000 AND preco_atual_real <= 11000 THEN 1 ELSE 0 END) AS faixa_8001_11000,
    SUM(CASE WHEN preco_atual_real > 11000 AND preco_atual_real <= 14000 THEN 1 ELSE 0 END) AS faixa_11001_14000,
    SUM(CASE WHEN preco_atual_real > 14000 AND preco_atual_real <= 17000 THEN 1 ELSE 0 END) AS faixa_14001_17000,
    SUM(CASE WHEN preco_atual_real > 17000 AND preco_atual_real <= 20000 THEN 1 ELSE 0 END) AS faixa_17001_20000,
    SUM(CASE WHEN preco_atual_real > 20000 AND preco_atual_real <= 23000 THEN 1 ELSE 0 END) AS faixa_20001_23000,
    SUM(CASE WHEN preco_atual_real > 23000 AND preco_atual_real <= 26000 THEN 1 ELSE 0 END) AS faixa_23001_26000,
    SUM(CASE WHEN preco_atual_real > 26000 AND preco_atual_real <= 27845.37 THEN 1 ELSE 0 END) AS faixa_26001_29000
FROM 
    vw_tb_notebook
GROUP BY 
    brand_new
ORDER BY 
    brand_new


-- COMMAND ----------

-- MAGIC %md
-- MAGIC Podemos observar que a marca Alienware inicia seus modelos já com preço relativamente elevado, e a marca Apple não possui nenhum notebook com valor mais baixo que R$ 5000,00.
-- MAGIC A marca ASUS possui elevada versatilidade com grande número de modelos de entrada e intermediários, e algumas opções de maior valor agregado.
-- MAGIC Demais marcas concentram-se nas faixas de valores mais iniciais com poucas opções mais caras. 
-- MAGIC

-- COMMAND ----------

-- MAGIC %md
-- MAGIC Apenas para fins de apreciação, vamos ver de forma geral a distribuição de modelos do dataset por faixa de preço a cada R$ 5000,00:

-- COMMAND ----------

SELECT 
    CONCAT('[', FLOOR(min(preco_atual_real)), ' - ', FLOOR(min(preco_atual_real)) + 5000, ']') AS faixa_preco,
    COUNT(*) AS qtd_modelos
FROM 
    vw_tb_notebook
GROUP BY 
    FLOOR(preco_atual_real / 5000)
ORDER BY 
    FLOOR(preco_atual_real / 5000);


-- COMMAND ----------

#histograma de preços para facilitar a visualização dos dados
select preco_atual_real 
from vw_tb_notebook

-- COMMAND ----------

-- MAGIC %md
-- MAGIC Vamos fazer uma análise sobre os processadores, seus preços e relação com tipo de memória RAM utilizada:

-- COMMAND ----------

SELECT
    processor_name,
    COUNT(*) AS contagem,
    ROUND(AVG(preco_antigo_real), 2) AS media,
    SUM(CASE WHEN ram_type IN ('DDR3', 'LPDDR3') THEN 1 ELSE 0 END) AS contagem_ddr3,
    SUM(CASE WHEN ram_type IN ('DDR4', 'LPDDR4', 'LPDDR4X') THEN 1 ELSE 0 END) AS contagem_ddr4,
    SUM(CASE WHEN ram_type = 'DDR5' THEN 1 ELSE 0 END) AS contagem_ddr5
FROM
    vw_tb_notebook
GROUP BY
    processor_name
ORDER BY
    contagem DESC;



-- COMMAND ----------

-- MAGIC %md
-- MAGIC Observamos que o processador Core i5 é o mais numeroso, acompanhado majoritariamente por memória DDR4 (assim como demais modelos também usam majoritariamente memória DDR4). sua média de preço é intermediária dentro de sua marca (INTEL) e reflete a realidade, ficando acima Core i3 e abaixo do Core i7 e Core i9.
-- MAGIC
-- MAGIC O mesmo vale para os processadores Ryzen, da AMD. 
-- MAGIC
-- MAGIC Verifica-se através da tabela acima que o processador do notebook tem forte relação com seu preço, mais ainda do que o tipo de memória RAM utilizada.

-- COMMAND ----------

-- MAGIC %md
-- MAGIC Podemos também fazer uma análise de correlação entre os preços dos notebooks por marca e os descontos dados. 

-- COMMAND ----------

SELECT 
    case when brand = "lenovo" then "Lenovo"
    else brand
end as brand_new,
    AVG(preco_atual_real) AS media_preco,
    AVG(discount2) AS media_desconto,
    CORR(preco_atual_real, discount2) AS correlacao_preco_desconto
FROM vw_tb_notebook
GROUP BY brand_new;


-- COMMAND ----------

Marcas como ALIENWARE, Infinix, Nokia, Avita, RedmiBook e Smartron apresentam correlações negativas fortes, sugerindo que aumentos em preço estão fortemente associados a reduções nos descontos (quando um aumenta, o outro diminui).
Por outro lado, MICROSOFT e Mi apresentam correlações positivas, indicando que preços mais altos estão associados a maiores descontos (quanto mais próximo de 1, maior é a proporcionalidade entre as variáveis - quando um aumenta, o outro também aumenta).
Algumas marcas, como HP e realme, não apresentam uma correlação significativa entre preço e desconto.
Outras marcas, como SAMSUNG e iball, não possuem dados suficientes para calcular a correlação.

-- COMMAND ----------

-- MAGIC %md
-- MAGIC
