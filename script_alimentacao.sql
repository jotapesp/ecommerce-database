-- alimentando o BD com dados

-- DESC client;
INSERT INTO client (c_name, surname, street_name, street_number, neighborhood, city, state, birth, gender_id, tax_number, company_tax_number) 
VALUES ('Maria', 'Silva', 'Rua Silver de Prata', 29, 'Tijuca', 'Rio de Janeiro', 'RJ', '1984-11-02', 'F', '12345678901', null),
	   ('Matheus', 'dos Santos Pimentel', 'Rua Alameda', 289, 'Centro', 'Rio de Janeiro', 'RJ', '1987-07-14', 'M', '09876543211', null),
       ('Ricardo', 'Souza Pereira', 'Avenida das Vinhas', 1009, 'Centro', 'Curitiba', 'PR', '1984-11-02', 'M', '12312312312', null),
       ('Julia', 'França', 'Rua Laranjeiras', 861, 'Leblon', 'Rio de Janeiro', 'RJ', '1987-10-11', 'F', '12345612378', null),
       ('Roberta', 'Gouveia Assis', 'Avenida Kohler', 19, 'Centro', 'Joinville', 'SC', '1986-01-03', 'F', '45678912309', null),
       ('Isabela', 'Cruz', 'Rua Alameda das Flores', 28, 'Centro', 'Campo Grande', 'MS', '1985-03-27', 'F', '12378945698', null),
       ('Elek Sommar SA', null, 'Alameda Campinas', '777', 'Jardim Paulista', 'São Paulo', 'SP', null, 'N/A', null, 76522198777231);
-- SELECT * FROM client;

-- DESC product;
INSERT INTO product (pname, category, if_kids, val, descript) 
VALUES ('HEADSET JBL', 'Eletrônico', False, 379.99, 'Fone de ouvido com microfone'),
	   ('Barbie Elsa', 'Brinquedo', True, 199.99, 'Boneca Barbie Elsa Disney Frozen'),
	   ('Calça Jeans Hollister', 'Vestuário', False, 469.99, 'Calça Jeans Masculina Slim Tam 38'),
	   ('Sofá retrátil MEMOVEIS', 'Casa', False, 1999.99, 'Sofá retrátil MEMOVEIS 4 lugares'),
	   ('Body infatil Carters', 'Vestuário', True, 249.99, 'Body para bebê 1 ano CARTERS'),
	   ('Fire Stick Amazon', 'Eletrônico', False, 249.99, 'Fire Stick Amazon Lite');
-- SELECT * FROM product;

-- DESC payment_method;
INSERT INTO payment_method (client_idClient, payment_type, card_holder1, card_holder2, card_number1, card_number2, exp_date1, exp_date2) 
VALUES (1, 'Cartão', 'MARIA SILVA', null, '1234567890123456', null, '2030-01-01', null),
	   (2, 'Cartão', 'MATHEUS S PIMENTEL', null, '9876543210987654', null, '2027-07-01', null),
	   (3, 'Dois cartões', 'RICARDO S PEREIRA', 'RICARDO S PEREIRA', '5678904321234567', '9877896785674329', '2030-01-01', '2027-07-01'),
       (3, 'Cartão', 'RICARDO S PEREIRA', null, '9877896785674329', null, '2027-07-01', null),
	   (4, 'Cartão', 'JULIA FRANCA', null, '8769805674567876', null, '2029-10-01', null);
-- SELECT * FROM payment_method;

-- DESC corder;
INSERT INTO corder (client_idClient, payment_method_idPayment, cash, orderStatus, descript, shipping) 
VALUES (1, null, True, default, 'Compra via APP', 20.00),
	   (2, 2, False, default, 'Compra via APP', 50.00),
	   (3, null, True, 'Confirmado', 'Compra loja física', null),
	   (4, 4, False, default, 'Compra via website', 0),
       (7, null, True, 'Confirmado', 'Compra loja física', null),
       (3, 3, False, 'Confirmado', 'Compra via APP', 0);
-- SELECT * FROM corder;

-- DESC delivery;
INSERT INTO delivery (tracking_number, deliveryStatus)
VALUES (null, DEFAULT), -- order 1
	   (null, DEFAULT), -- order 2
       (null, DEFAULT), -- order 4
       ('BR96574321X', 'Em separação'), -- order 6 prod 3
       ('BR54874321T', 'Em separação'); -- order 6 prod 5
-- SELECT * FROM delivery;

-- DESC product_order;
INSERT INTO product_order (corder_idCorder, product_idProduct, amount, delivery_idDelivery, po_status)
VALUES (1, 1, 1, 1, "Disponível"),
	   (2, 3, 1, 2, "Disponível"),
       (3, 4, 1, null, "Disponível"), -- compra loja fisica, sem entrega
       (4, 6, 1, 3, "Disponível"),
       (5, 6, 1, null, "Disponível"), -- compra loja fisica, sem entrega
       (6, 3, 1, 4, "Disponível"),
       (6, 5, 1, 5, "Disponível");
-- SELECT * FROM product_order;

-- DESC warehouse;
INSERT INTO warehouse (location) VALUES ("Rio de Janeiro"),
										("São Paulo"),
										("Brasília");
-- DESC product_warehouse;
INSERT INTO product_warehouse (warehouse_idWarehouse, product_idProduct, amount)
VALUES (1, 1, 500),
	   (1, 2, 300),
       (2, 3, 400),
       (3, 4, 200),
       (1, 5, 200),
       (2, 6, 100),
       (2, 1, 500),
       (2, 5, 100);
-- SELECT * FROM product_warehouse;

-- DESC supplier;
INSERT INTO supplier (company_tax_number, razao_social, email, tel, street_name, street_number, neighborhood, city, state)
VALUES (12345678901234, "Almeida e Filhos", "supplychain@almeidafilhos.com", "21-44568799", 'Rua das Industrias', 56, 'Vila Industrial', 'Duque de Caxias', 'RJ'),
	   (98765432109876, "Eletrônicos Silva", "contato@eletronicossilva.com", "11-60017689", 'Rua Doze', 12, 'Distrito Industrial', 'Santo André', 'SP'),
       (45612378920143, "Eletrônicos Valma", "depcarga@elecvalma.com", "11-30146767", 'Rua Fernando Simas', 678, 'Vila Alameda', 'Barueri', 'SP'),
       (65478934251456, "Frederico Lar", "vendas@efredlar.com", "61-34567654", 'Rua A2', 60, 'Distrito Industrial', 'Taguatinga', 'DF'),
       (76894567213097, "Marcia Imports", "vendas@emarciasa.com", "11-40063030", 'Rua Alameda José', 1777, 'Brás', 'São Paulo', 'SP');
-- SELECT * FROM supplier;

-- DESC product_supplier;
INSERT INTO product_supplier (supplier_idSupplier, product_idProduct, amount)
VALUES (1, 1, 400),
	   (2, 1, 500),
       (1, 2, 300),
       (5, 3, 300),
       (4, 4, 200),
       (5, 5, 300),
       (5, 6, 200),
       (3, 1, 100);

-- DESC vendor;
INSERT INTO vendor (razao_social, business_name, company_tax_number, person_tax_number, street_name, street_number, neighborhood, city, state, email, tel)
VALUES ("Tech Electronic", null, "87656475632657", null, "Rua das Almas", 27, "Copacabana", "Rio de Janeiro", "RJ", "techelectronics@gmail.com", "21-63768954"),
	   ("Boutique Durgas", null, null, "35465746523", "Rua dos Vivos", 72, "Jardim Paulista", "São Paulo", "SP", "durgas_contato@gmail.com", "11-43768954"),
       ("Kids World", null, "91847275498235", null, "Rua das Almas Vivas", 927, "Morumbi", "São Paulo", "SP", "contato@kidsworld.com.br", "11-70073003");
-- SELECT * FROM vendor;

-- DESC product_vendor;
INSERT INTO product_vendor (vendor_idVendor, product_idProduct, amount)
VALUES (1, 6, 80),
	   (3, 2, 50),
       (1, 1, 100);
-- SELECT * FROM product_vendor;