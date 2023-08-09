-- DROP DATABASE ecommerce_desafio;

CREATE DATABASE ecommerce_desafio;
USE ecommerce_desafio;

-- criar tabelas:
	-- 1. cliente
CREATE TABLE client(
	idClient INT PRIMARY KEY AUTO_INCREMENT,
    c_name VARCHAR(15) NOT NULL,
    surname VARCHAR(45),
    street_name VARCHAR(30),
    street_number INT,
    neighborhood VARCHAR(50),
    city VARCHAR(50),
    state ENUM("AC", "AL", "AP", "AM", "BA", "CE", "DF", "ES", "GO", "MA", "MT", "MS", "MG", "PA", "PB", "PR", "PE", "PI", "RJ", "RN", "RS", "RO", "RR", "SC", "SP", "SE", "TO"),
    birth DATE,
    gender_id ENUM("M", "F", "N", "N/A"),
    tax_number CHAR(11) UNIQUE,
    company_tax_number CHAR(14) UNIQUE,
    CONSTRAINT check_tax_number_type CHECK ((tax_number is not NULL AND company_tax_number is NULL) OR  
											(tax_number is NULL AND company_tax_number is not NULL))
);
ALTER TABLE client AUTO_INCREMENT = 1;

	-- 2. produto
CREATE TABLE product(
	idProduct INT PRIMARY KEY AUTO_INCREMENT,
    pname VARCHAR(45) NOT NULL,
    category ENUM("Eletrônico", "Vestuário", "Brinquedo", "Alimento", "Casa") NOT NULL,
    if_kids BOOL DEFAULT False,
    val FLOAT NOT NULL, -- product price
    descript VARCHAR(45),
    rating FLOAT DEFAULT 0,
    CONSTRAINT product_name_unique UNIQUE (pname)
);
ALTER TABLE product AUTO_INCREMENT = 1;

	-- 3. método de pagamento associado aos clientes e utilizado nos pedidos
CREATE TABLE payment_method(
	idPayment INT AUTO_INCREMENT,
    client_idClient INT,
    payment_type ENUM("Cartão", "Dois cartões") DEFAULT "Cartão",
    card_holder1 VARCHAR(100) NOT NULL,
    card_holder2 VARCHAR(100),
    card_number1 VARCHAR(16) NOT NULL,
    card_number2 VARCHAR(16),
    exp_date1 DATE NOT NULL,
    exp_date2 DATE,
    PRIMARY KEY (idPayment, client_idClient)
);
ALTER TABLE payment_method AUTO_INCREMENT = 1;

	-- 4. pedido (corder = customer/client orders)
CREATE TABLE corder(
	idCorder INT AUTO_INCREMENT PRIMARY KEY ,
    client_idClient INT,
    payment_method_idPayment INT,
    cash BOOL DEFAULT False,
    orderStatus ENUM("Confirmado", "Processando", "Cancelado") DEFAULT 'Processando',
    descript VARCHAR(45) NOT NULL,
    shipping FLOAT DEFAULT 0,
    CONSTRAINT fk_order_client FOREIGN KEY (client_idClient) REFERENCES client(idClient) ON UPDATE CASCADE,
    CONSTRAINT fk_order_payment FOREIGN KEY (payment_method_idPayment) REFERENCES payment_method(idPayment),
    CONSTRAINT check_if_payment_method CHECK (payment_method_idPayment is not null OR cash is True)
);
ALTER TABLE corder AUTO_INCREMENT = 1;

    -- 5. informação sobre a entrega
CREATE TABLE delivery(
	idDelivery INT PRIMARY KEY AUTO_INCREMENT,
    deliveryStatus ENUM("Aguardando pagamento", "Em separação", "Enviado", "A caminho da entrega", "Entregue") DEFAULT "Aguardando pagamento",
    tracking_number VARCHAR(20)
);
ALTER TABLE delivery AUTO_INCREMENT = 1;
-- ALTER TABLE delivery DROP COLUMN deliveryStatus;
-- ALTER TABLE delivery ADD COLUMN deliveryStatus ENUM("Aguardando pagamento", "Em separação", "Enviado", "A caminho da entrega", "Entregue") DEFAULT "Aguardando pagamento";
-- DESC delivery;

	-- 6. estoque
CREATE TABLE warehouse(
	idWarehouse INT AUTO_INCREMENT PRIMARY KEY,
    location VARCHAR(100) NOT NULL
);
ALTER TABLE warehouse AUTO_INCREMENT = 1;

    -- 7. fornecedor
CREATE TABLE supplier(
	idSupplier INT AUTO_INCREMENT PRIMARY KEY,
    company_tax_number CHAR(14) NOT NULL UNIQUE,
    razao_social VARCHAR(45) NOT NULL,
    email VARCHAR(50),
    tel VARCHAR(11) NOT NULL,
	street_name VARCHAR(30),
    street_number INT,
    neighborhood VARCHAR(50),
    city VARCHAR(50),
    state ENUM("AC", "AL", "AP", "AM", "BA", "CE", "DF", "ES", "GO", "MA", "MT", "MS", "MG", "PA", "PB", "PR", "PE", "PI", "RJ", "RN", "RS", "RO", "RR", "SC", "SP", "SE", "TO")
);
ALTER TABLE supplier AUTO_INCREMENT = 1;

    -- 8. vendedor
CREATE TABLE vendor(
	idVendor INT AUTO_INCREMENT PRIMARY KEY,
    razao_social VARCHAR(45) NOT NULL,
	business_name VARCHAR(45),
    company_tax_number CHAR(14),
    person_tax_number CHAR(11),
    street_name VARCHAR(30),
    street_number INT,
    neighborhood VARCHAR(50),
    city VARCHAR(50),
    state ENUM("AC", "AL", "AP", "AM", "BA", "CE", "DF", "ES", "GO", "MA", "MT", "MS", "MG", "PA", "PB", "PR", "PE", "PI", "RJ", "RN", "RS", "RO", "RR", "SC", "SP", "SE", "TO"),
    email VARCHAR(45),
    tel VARCHAR(11) NOT NULL,
    CONSTRAINT c_tax_number_unique UNIQUE (company_tax_number),
    CONSTRAINT tax_number_unique UNIQUE (tax_number),
    CONSTRAINT check_tax_number CHECK (company_tax_number is not NULL OR person_tax_number is not NULL)
);
ALTER TABLE vendor AUTO_INCREMENT = 1;

	-- 9. produto/pedido
CREATE TABLE product_order(
	corder_idCorder INT,
    product_idProduct INT,
    amount FLOAT NOT NULL, -- float pois pode ser unidade de medida (kg, ton, etc)
    delivery_idDelivery INT, -- entrega separadas por produto do pedido, pois pode ser que sejam enviados separados (por ex, um móvel e um alimento)
    po_status ENUM("Disponível","Fora de estoque") DEFAULT "Disponível",
	PRIMARY KEY(corder_idCorder, product_idProduct),
	CONSTRAINT fk_corder_po FOREIGN KEY (corder_idCorder) REFERENCES corder (idCorder),
	CONSTRAINT fk_product_po FOREIGN KEY (product_idProduct) REFERENCES product (idProduct)
);

    -- 10. produto/estoque
CREATE TABLE product_warehouse(
	warehouse_idWarehouse INT,
    product_idProduct INT,
    amount FLOAT NOT NULL, -- qtd de produto em estoque na warehouse, float pois pode ser unidade de medida (kg, ton, etc)
    PRIMARY KEY(warehouse_idWarehouse, product_idProduct),
    CONSTRAINT fk_warehouse_pw FOREIGN KEY (warehouse_idWarehouse) REFERENCES warehouse (idWarehouse),
    CONSTRAINT fk_product_pw FOREIGN KEY (product_idProduct) REFERENCES product (idProduct)
);

	-- 11. produto/vendedor
CREATE TABLE product_vendor(
	vendor_idVendor INT,
    product_idProduct INT,
    amount FLOAT NOT NULL, -- float pois pode ser unidade de medida (kg, ton, etc)
    PRIMARY KEY (vendor_idVendor, product_idProduct),
    CONSTRAINT fk_vendor_pv FOREIGN KEY (vendor_idVendor) REFERENCES vendor (idVendor),
    CONSTRAINT fk_product_pv FOREIGN KEY (product_idProduct) REFERENCES product (idProduct)
);

	-- 12. produto/fornecedor
CREATE TABLE product_supplier(
	supplier_idSupplier INT,
    product_idProduct INT,
    amount FLOAT NOT NULL, -- float pois pode ser unidade de medida (kg, ton, etc)
    PRIMARY KEY(supplier_idSupplier, product_idProduct),
    CONSTRAINT fk_supplier_ps FOREIGN KEY (supplier_idSupplier) REFERENCES supplier(idSupplier),
    CONSTRAINT fk_product_ps FOREIGN KEY (product_idProduct) REFERENCES product(idProduct)
);

-- show databases;
-- USE information_schema;
-- SHOW TABLES;
-- DESC TABLES;
-- SELECT count(TABLE_NAME) FROM TABLES WHERE TABLE_SCHEMA = 'ecommerce'; -- 11 tables
-- SELECT TABLE_NAME FROM TABLES WHERE TABLE_SCHEMA = 'ecommerce';
-- DESC TABLE_CONSTRAINTS;
-- DESC REFERENTIAL_CONSTRAINTS;
-- SELECT * FROM REFERENTIAL_CONSTRAINTS WHERE CONSTRAINT_SCHEMA = 'ecommerce';

use ecommerce_desafio;
-- show tables;
-- DESC client;