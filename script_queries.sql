-- QUERIES

-- 1. recuperar informações sobre os pedidos dos clientes, exibindo CPF ou CNPJ do cliente, forma de pagamento 
-- daquele pedido, caso tenha sido cartão, quais cartões foram utilizados (ultimos 4 digitos), o valor pago do frete,
-- a situação do pedido ordenado por valor total do pedido, de forma descendente.
SELECT 
CASE 
	WHEN c.tax_number is not NULL THEN c.tax_number
    ELSE "N/A"
END AS CPF, 
CASE 
	WHEN c.company_tax_number is not NULL THEN c.company_tax_number
    ELSE "N/A"
END AS CNPJ, 
o.idCorder AS NUMERO_PEDIDO,
CASE 
	WHEN o.cash is False THEN pm.payment_type
    ELSE 'Boleto'
END AS FORMA_PAGAMENTO, 
CASE 
	WHEN o.cash is False AND pm.card_number2 is not NULL THEN CONCAT(RIGHT(pm.card_number1, 4), ', ', RIGHT(pm.card_number2, 4)) 
    WHEN o.cash is False AND pm.card_number2 is NULL THEN RIGHT(pm.card_number1, 4)
    WHEN o.cash is True THEN '-'
END AS CARTAO,
CASE 
	WHEN o.shipping is not NULL THEN ROUND(o.shipping, 2)
    ELSE 0.00
END AS FRETE,
(SELECT CASE 
			WHEN o.shipping is not NULL THEN ROUND(SUM(po.amount * p.val + o.shipping), 2) 
			ELSE ROUND(SUM(po.amount * p.val), 2)
		END
FROM product AS p JOIN product_order AS po ON p.idProduct = po.product_idProduct
WHERE po.corder_idCorder = o.idCorder) AS TOTAL,
o.orderStatus AS SITUACAO
FROM corder AS o LEFT OUTER JOIN client AS c ON o.client_idClient = c.idClient
LEFT OUTER JOIN payment_method AS pm ON pm.idPayment = o.payment_method_idPayment
ORDER BY TOTAL DESC;

-- 2. total já gasto por cada cliente até o momento (excluindo frete)
SELECT CASE 
	WHEN c.tax_number is not NULL THEN c.tax_number
    ELSE "N/A"
END AS CPF, 
CASE 
	WHEN c.company_tax_number is not NULL THEN c.company_tax_number
    ELSE "N/A"
END AS CNPJ, 
CASE
	WHEN c.surname is not NULL THEN CONCAT(c.c_name, ' ', c.surname) 
    ELSE c.c_name 
END AS NOME_COMPLETO,
(SELECT ROUND(SUM(po.amount * p.val), 2) FROM product_order AS po JOIN product AS p ON p.idProduct = po.product_idProduct 
JOIN corder as co ON po.corder_idCorder = co.idCorder WHERE co.client_idClient = c.idClient) AS TOTAL_GASTO
FROM client AS c JOIN corder AS o ON o.client_idClient = c.idClient
GROUP BY c.idClient
ORDER BY TOTAL_GASTO DESC;

-- 3. promoção: clientes ganham 1 cupom de 10% de desconto a cada R$500 gastos (excluindo frete)
-- mostrar tabela com total gasto e quantos cupons o cliente recebe
-- (considerando que um cliente que gasta, por exemplo, 0.99 será arredondado para cima, ou seja, 1.)
SELECT 
CASE 
	WHEN c.tax_number is not NULL THEN c.tax_number
    ELSE "N/A"
END AS CPF, 
CASE 
	WHEN c.company_tax_number is not NULL THEN c.company_tax_number
    ELSE "N/A"
END AS CNPJ,  
CASE
	WHEN c.surname is not NULL THEN CONCAT(c.c_name, ' ', c.surname) 
    ELSE c.c_name 
END AS NOME_COMPLETO,
(SELECT ROUND(SUM(po.amount * p.val), 2) 
 FROM product_order AS po JOIN product AS p ON p.idProduct = po.product_idProduct 
 JOIN corder as co ON po.corder_idCorder = co.idCorder 
 WHERE co.client_idClient = c.idClient) AS TOTAL_GASTO,
FLOOR((SELECT ROUND(CEIL(SUM(po.amount * p.val)), 2) 
	   FROM product_order AS po JOIN product AS p ON p.idProduct = po.product_idProduct 
	   JOIN corder as co ON po.corder_idCorder = co.idCorder 
       WHERE co.client_idClient = c.idClient)/500) AS CUPONS
FROM client AS c JOIN corder AS o ON o.client_idClient = c.idClient
GROUP BY c.idClient
ORDER BY TOTAL_GASTO DESC;

-- 4. mostrar produtos, qual fornecedor fornece aquele produto e em qual a quantidade

SELECT p.pname AS PRODUTO, 
	   p.category AS CATEGORIA, 
       s.company_tax_number AS CNPJ, 
       s.razao_social AS RAZAO_SOCIAL, 
       ps.amount AS QUANTIDADE_FORNECIDA
FROM product AS p JOIN product_supplier AS ps ON ps.product_idProduct = p.idProduct
JOIN supplier AS s ON ps.supplier_idSupplier = s.idSupplier;

-- 5. relações comerciais
-- total de produtos fornecidos por fornecedor
SELECT s.company_tax_number AS CNPJ, 
       s.razao_social AS RAZAO_SOCIAL, 
       SUM(ps.amount) AS FORNECIMENTO_TOTAL
FROM supplier AS s JOIN product_supplier AS ps ON ps.supplier_idSupplier = s.idSupplier
GROUP BY s.idSupplier
ORDER BY FORNECIMENTO_TOTAL DESC;

-- 6. mostrar todos os fornecedores
SELECT company_tax_number AS CNPJ, razao_social AS Razao_social, tel AS Telefone FROM supplier;

-- 7. mostrar os fornecedores de produtos eletrônicos
SELECT company_tax_number AS CNPJ, razao_social AS Razao_social 
FROM supplier JOIN product_supplier ON idSupplier = supplier_idSupplier
			  JOIN product ON idProduct = product_idProduct
WHERE category = "Eletrônico";

-- 8. mostra em qual/quais depósitos (warehouses) tem estoque de HEADSET JBL (produto de id 1) e a quantidade em estoque
SELECT p.pname AS PRODUTO, 
	   w.location AS LOCALIZACAO, 
       pw.amount AS QUANTIDADE_EM_ESTOQUE
FROM warehouse AS w JOIN product_warehouse AS pw ON w.idWarehouse = pw.warehouse_idWarehouse
					JOIN product AS p ON p.idProduct = pw.product_idProduct
WHERE p.pname = "HEADSET JBL"
GROUP BY pw.warehouse_idWarehouse;

-- 9. mostrar os produtos que tem estoque maior ou igual a 200 unidades.
SELECT p.pname AS PRODUTO,
(SELECT SUM(amount) FROM product_warehouse WHERE product_idProduct = p.idProduct) AS QUANTIDADE_EM_ESTOQUE
FROM product AS p JOIN product_warehouse AS pw ON p.idProduct - pw.product_idProduct
GROUP BY p.idProduct
HAVING QUANTIDADE_EM_ESTOQUE >= 200
ORDER BY QUANTIDADE_EM_ESTOQUE DESC;

-- 10. quantos pedidos foram feitos por cliente
SELECT 
CASE 
	WHEN c.tax_number is not NULL THEN c.tax_number
    ELSE "N/A"
END AS CPF, 
CASE 
	WHEN c.company_tax_number is not NULL THEN c.company_tax_number
    ELSE "N/A"
END AS CNPJ,  
CASE
	WHEN c.surname is not NULL THEN CONCAT(c.c_name, ' ', c.surname) 
    ELSE c.c_name 
END AS NOME_COMPLETO,
(SELECT COUNT(*) FROM corder WHERE client_idClient = c.idClient) AS TOTAL_PEDIDOS
FROM client AS c JOIN corder AS o ON c.idClient = o.client_idClient
GROUP BY c.idClient;