# Projeto de Análise de Dados com Databricks e SQL

Este é um projeto de análise de dados realizado no ambiente Databricks com a linguagem SQL. Foi analisado um conjunto de dados disponibilizado na plataforma Kaggle.com, e pode ser encontrado através do link: https://www.kaggle.com/datasets/gyanprakashkushwaha/laptop-price-prediction-cleaned-dataset.

Os dados são sobre notebooks (laptops), com informações sobre centenas de modelos de diferentes marcas, incluindo especificações técnicas, preços, descontos, avaliações e etc.


### A análise completa juntamente com as Queries pode ser acessada via link:

https://databricks-prod-cloudfront.cloud.databricks.com/public/4027ec902e239c93eaaa8714f173bcfc/3679566292640692/4405525316613061/1968454162307818/latest.html


## Objetivo do Projeto

O objetivo deste projeto é explorar um conjunto de dados e extrair insights valiosos através da linguagem SQL. Utilizamos técnicas de análise exploratória de dados e visualização, focando em entender um pouco mais sobre as relações de marcas e preços com algumas especificações técnicas, participação em mercado e etc.


## Principais Resultados e Insights

Durante o desenvolvimento deste projeto, os seguintes resultados e insights foram obtidos:

**1. Participação das marcas no mercado:** /n
O dataset inclui uma variedade de marcas, com algumas, como Alienware e Apple, representando modelos mais premium, enquanto outras, como iball e Smartron, estão mais voltadas para produtos de entrada. A marca ASUS possui elevada versatilidade com grande número de modelos de entrada e intermediários, e algumas opções de maior valor agregado. Demais marcas concentram-se nas faixas de valores mais iniciais com poucas opções mais caras.
   
**2. Faixas de preço:** 
Observa-se que a grande maioria dos modelos (67%) custa menos que R$ 5881.00. Até R$ 10000.00, 26,7% dos modelos. Os demais se distribuiem em poucos modelos nas faixas de preço superiores.

**3. Preços médios por marca:** 
A média de preços dos notebooks da marca Alienware é a mais alta, seguida pela Apple. Isso sugere que essas marcas focam em segmentos de mercado de maior poder aquisitivo.
   
**4. Variação de preços por marca:** 
Algumas marcas, como Asus, Lenovo, MSI, e HP têm uma grande variação de preços entre seus produtos, indicando que oferecem opções em diferentes faixas de preço para atender a uma variedade de clientes. Marcas como Apple e principalmente Alienware também apresentam um range de preços elevado, porém já iniciam seu preço mínimo num valor bem alto, indicando que buscam atingir públicos mais específicos que já podem investir em um notebook de maior valor, mesmo em seus modelos de entrada.

**5. Tipo de memória RAM e preços:** 
Embora a tecnologia DDR4 seja mais atual e geralmente mais cara, a média de preços de notebooks com DDR3 é maior. Isso se deve a uma combinação de fatores, incluindo a baixa disponibilidade de modelos DDR3 no dataset e o fato de que esses modelos podem ter especificações mais robustas, elevando seus preços.

**6. Relação entre processadores e preços:** 
Há uma forte relação entre o processador do notebook e seu preço, sendo que modelos equipados com processadores mais potentes, como Core i7, Core i9 e Ryzen 9, tendendo a ter preços mais altos. É possível concluir que o modelo do processador determina o preço do notebook acima dos demais fatores como o tipo de memória RAM. 

**7. Preços e descontos:** 
Marcas como ALIENWARE, Infinix, Nokia, Avita, RedmiBook e Smartron apresentam correlações negativas fortes, sugerindo que aumentos em preço estão fortemente associados a reduções nos descontos.
Por outro lado, MICROSOFT e Mi apresentam correlações positivas, indicando que preços mais altos estão associados a maiores descontos.
Algumas marcas, como HP e realme, não apresentam uma correlação significativa entre preço e desconto.
Outras marcas, como SAMSUNG e iball, não possuem dados suficientes para calcular a correlação.















