/*
NAME: Osman Osman
ID: 100962928
CRN: 46307
*/


-- Question #1 

CREATE OR REPLACE PROCEDURE insert_category
(
  category_id_param        NUMBER,   
  category_name_param   VARCHAR2
)
AS
BEGIN
  INSERT INTO mgs.categories
  VALUES (category_id_param, category_name_param);
  COMMIT;
END;
/

CALL insert_category(700, 'Internet Services');


-- Question#2

CREATE OR REPLACE FUNCTION discount_price
(
item_id_param ORDER_ITEMS.ITEM_ID%TYPE
)
RETURN ORDER_ITEMS.DISCOUNT_AMOUNT%TYPE
AS total_price ORDER_ITEMS.DISCOUNT_AMOUNT%TYPE;
BEGIN
SELECT item_price-discount_amount INTO total_price
FROM order_items WHERE item_id=item_id_param;
RETURN total_price;
END;
/
SELECT item_id, item_price, discount_amount, discount_price(item_id)
FROM order_items;

-- Question #3
SET SERVEROUTPUT ON;

CREATE OR REPLACE TRIGGER products_before_update
BEFORE UPDATE OF discount_percent
ON products
FOR EACH ROW
BEGIN
  IF (:NEW.discount_percent >= 100)THEN 
    RAISE_APPLICATION_ERROR(-2001, 'The discount percent must be less than 100.');
  END IF;
  IF (:NEW.discount_percent < 0) THEN
    RAISE_APPLICATION_ERROR(-2001, 'The discount percent must be a positive number.');
  END IF;
  IF (:NEW.discount_percent < 1) THEN
    :NEW.discount_percent := :NEW.discount_percent * 100;
  END IF;
END;
/

UPDATE products
SET discount_percent = .25
WHERE product_id = 1;

SELECT product_id, product_code, product_name, discount_percent
FROM products;

-- Question #4

CREATE OR REPLACE TRIGGER products_before_insert
BEFORE INSERT ON products
FOR EACH ROW
WHEN (NEW.date_added IS NULL)
BEGIN
  SELECT SYSDATE
  INTO :NEW.date_added
  FROM dual;
END;
/

-- Test for # 4

INSERT INTO products
  (product_id, category_id, product_code, product_name, description, list_price, discount_percent)
VALUES
  (PRODUCT_ID_SEQ.NEXTVAL, CATEGORY_ID_SEQ.NEXTVAL, 'category', 'productcode', 'description', 100.99, 50);  
  
  