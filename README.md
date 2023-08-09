# Banco de Dados de um E-commerce

(PT-BR)
Esse é o projeto de Banco de Dados de um e-commerce que vende vários tipos de produtos, como por exemplo Amazon, ou Americanas.com. O projeto foi desenvolvido como parte do desafio de projeto do Bootcamp Ciência de Dados da DIO.

### Feito com

[![MySQL](https://img.shields.io/badge/MySQL-000?style=for-the-badge&logo=mysql)](https://dev.mysql.com/doc/refman/8.0/en/)

### Como usar

(PT-BR)
* Cada um dos arquivos contidos nesse diretório são uma parte do script e estão descritos abaixo:
  - [`script_criacaoDB.sql`](https://github.com/jotapesp/ecommerce-database) - execute esse _script_ em um servidor MySQL para criar o Banco de Dados chamado `ecommerce_desafio` populado com as tabelas que serão descritas mais adiante.
  - [`script_alimentacao.sql`](https://github.com/jotapesp/ecommerce-database) - execute esse _script_ para popular o Banco de Dados com dados fictícios afim de testá-lo.
  - [`script_queries.sql`](https://github.com/jotapesp/ecommerce-database) - execute esse _script_ para extrair informações do Banco de Dados com a finalidade de testá-lo. As informações extraídas pelas queries contidas nesse _script_ são descritas mais adiante.

### Descrição do Banco de Dados

* [`modelo_eer.mwb`](https://github.com/jotapesp/ecommerce-database) - Esse arquivo contido no repositório contem o modelo lógico completo do banco de dados, a imagem abaixo é um screenshot desse modelo:
[![Modelo Lógico](https://i.imgur.com/Fz7Ed8T.png)](https://github.com/jotapesp/ecommerce-database)

  - Cliente: tabela com os dados dos clientes, que podem ser pessoas físicas ou jurídicas. No caso, uma exclui a outra, ou seja, se o cliente for registrado como pessoa física, a tabela não pode conter informação sobre seu CNPJ, por exemplo. A identidade de gênero do usuário é armazenada em um atributo do tipo ENUM e as opções são 'M', para masculino, 'F', para feminino e 'N' caso o usuário se identifique como não-binário, no caso do cliente cadastrado for uma empresa, a opção apropriada é 'N/A'. O atributo endereço é composto por alguns atributos separados no _script_, dessa forma podendo separar informações como nome da rua, nome do bairro, cidade e estado onde o usuário se localiza. O estado é dado como um atributo do tipo ENUM e as opções de escolha são todos os estados do território nacional, includindo o Distrito Federal. Esse modelo de endereço é repetido em todas as tabelas que armazenam essa informação.

  - Pedido: tabela que armazena os dados dos pedidos. Cada vez que um cliente faz uma compra na plataforma, um pedido é gerado e então a tabela Produto_Pedido também é alimentada. O método de pagamento do pedido é informado através de uma outra tabela, Método_pagamento, cuja referência pode ser encontrada na tabela Pedido através do atributo que referencia o ID do método de pagamento. Caso o pagamento seja feito em dinheiro vivo ou boleto, esse atributo é nulo e então outro atributo, do tipo booleano, recebe o valor `True` (ou `1`, no caso de `TINYINT`). Uma das duas condições deve ser verdade, ou o ID do método deve ser informado e não nulo, ou o booleano para boleto/_cash_ deve ser `1` (`True`). O _status_ do pedido é um atributo do tipo ENUM cujas opções são "Confirmado", "Processando", "Cancelado", sendo "Processando" a padrão/DEFAULT.

  - Produto: tabela contendo informação sobre todos os produtos oferecidos pelo e-commerce e que o usuário pode encontrar navegando pela plataforma. Essa tabela armazena informações como valor do produto, descrição do mesmo, nome, etc.

  - Fornecedor: a tabela Fornecedor é sobre todos os forncecedores cadastrados que estão aptos a fornecer os produtos que a plataforma oferta aos clientes. O atributo endereço é composto por alguns atributos separados no _script_, dessa forma podendo separar informações como nome da rua, nome do bairro, cidade e estado. O estado é dado como um atributo do tipo ENUM e as opções de escolha são todos os estados do território nacional, includindo o Distrito Federal. Esse modelo de endereço é repetido em todas as tabelas que armazenam essa informação.

  - Estoque: essa tabela contem informação dos armazéns da empresa e onde eles estão localizados.

  - Vendedor: a loja também oferece a opção de vender seus produtos através de terceiros, estes que podem ser vendedores autônomos (com CPF) ou lojas com CNPJ. Essa tabela contém as informações sobre os vendedores, e sempre que uma dessas entidades realiza uma venda, uma linha é adicionada à tabela Produto_vendedor. O atributo endereço é composto por alguns atributos separados no _script_, dessa forma podendo separar informações como nome da rua, nome do bairro, cidade e estado onde o vendedor terceiro se localiza. O estado é dado como um atributo do tipo ENUM e as opções de escolha são todos os estados do território nacional, includindo o Distrito Federal. Esse modelo de endereço é repetido em todas as tabelas que armazenam essa informação.

  - Produto_vendedor: tabela que faz a ligação entre os produtos e os vendedores, armazenando informação sobre as vendas realizadas por parceiros (vendedores terceiros), contendo informação sobre qual produto foi vendido e a quantidade.

  - Produto_Pedito: é uma tabela que liga as tabelas de Produto e Pedido. Cada linha nova nessa tabela é gerada cada vez que um cliente compra um produto diferente, mesmo que seja de um mesmo pedido. A tabela armazena qual produto foi vendido, a quantidade, e possui um link com a tabela Entrega. O atributo _status_ do produto é do tipo ENUM e as opções são "Disponível", "Fora de estoque", sendo "Disponível" a padrão/DEFAULT. As quantidades são definidas como FLOAT pois pode ser que o produto seja vendido por unidades de medida, como kg, ton, e não por unidades inteiras.

  - Entrega: tabela que contém informações sobre os produtos que devem ser entregues aos clientes. Ela é conectada à tabela Produto_Pedidos pois em um mesmo pedido o cliente pode comprar 2 tipos de produtos muito diferentes, que estão em armazéns (estoques) diferentes, cuja disponibilidade seja diferente, então, existe a possibilidade dos produtos serem enviados separadamente. Essa tabela contém informação sobre o _status_ da entrega e o código de rastreio junto a transportadora. O _status_ da entrega é definido como um atributo ENUM cujas escolhas são "Aguardando pagamento", "Em separação", "Enviado", "A caminho da entrega", "Entregue", sendo a padrão/DEFAULT dada por "Aguardando pagamento".

  - Produto_Estoque: essa tabela faz a ligação entre os produtos e os armazéns (estoques), indicando quais produtos e quais quantidades de produtos estão disponíveis em quais armazéns. As quantidades são definidas como FLOAT pois pode ser que o produto seja comprado/vendido por unidades de medida, como kg, ton, e não por unidades.

  - Produto_Fornecedor: essa tabela é responsável por conectar produtos a seus fornecedores, assim, é possível saber qual produto foi fornecido por qual fornecedor, e em qual quantidade. As quantidades são definidas como FLOAT pois pode ser que o produto seja fornecido por unidades de medida, como kg, ton, e não por unidades.

  - Método_pagamento: armazena as informações sobre os métodos de pagamentos de cada cliente que estão salvos no sistema. Ela também pode ser usada toda vez que um cliente faz uma compra utilizando um método de pagamento que não seja dinheiro vivo (_cash_) ou boleto, como cartões, por exemplo, assim, esses dados podem ser usados com APIs de instituições financeiras. Caso o cliente não deseje manter os dados salvos, após o uso eles podem ser apagados. Pedidos referenciam os métodos de pagamento através de um atributo que pode ser nulo na tabela Pedido. O tipo de método de pagamento é armazenado como um atributo do tipo ENUM e as opções disponívels são "Cartão" e "Dois Cartões". No caso do cliente pagar na forma de dois cartões, existem dois de cada atributo que armazena informação dos cartões, como número, nome impresso no cartão e data de validade, sendo apenas o atributo de um dos cartões obrigatório (no caso, pagamento com apenas um cartão).

### Recuperação dos dados através das _Queries_ pré-definidas em _script_

* O _script_ [`script_queries.sql`](https://github.com/jotapesp/ecommerce-database) foi criado com algumas _queries_ que retornam dados armazenados, e essas são:
  - 1. Recupera informações sobre os pedidos dos clientes, exibindo CPF ou CNPJ do cliente (dependendo se for PF ou PJ), a forma de pagamento utilizada para aquele pedido, caso tenha sido cartão, quais cartões foram utilizados (últimos 4 digitos), o valor pago pelo frete e a situação do pedido. Os dados saem ordenados por valor total do pedido, de forma decrescente.

  - 2.  O total já gasto por cada cliente até o momento (excluindo frete).

  - 3. Criado um cenário de promoção onde os clientes ganham 1 cupom de 10% de desconto a cada R$500 gastos (excluindo frete) na plataforma. Mostra tabela com total gasto e quantos cupons o cliente recebe (considerando que um cliente que gasta, por exemplo, 499.99 será arredondado para cima, ou seja, 500, desse modo, ele estará elegível a receber 1 cupom por essa quantia).

  - 4. Mostra produtos e seus respectivos fornecedores, a tabela também mostra qual a quantidade é fornecida por fornecedor.

  - 5. Em um contexto que deseja-se saber sobre as relações comerciais com os fornecedores, é exibido o total de produtos fornecidos separado por fornecedor e ordenado da maior quantidade para a menor.

  - 6. Mostra todos os fornecedores.

  - 7. Filtra os fornecedores para mostrar apenas os que fornecem produtos eletrônicos.

  - 8. Mostra qual/quais depósitos (_warehouses_) tem estoque de um produto específico e a quantidade em estoque (o exemplo no _script_ é para HEADSET JBL, produto de id 1, inserido no banco de dados através do _script_ de persistência de dados).

  - 9. Mostra todos os produtos que tem quantidade em estoque maior ou igual a 200 unidades.

  - 10. Quantos pedidos foram feitos por cliente, ordenando.
