


GO
CREATE OR alter PROCEDURE staging_area.loadStoresData

AS

    SET NOCOUNT ON;
    INSERT into staging_area.stores (store_id, store_name, phone, email, street, city, state, zip_code)
SELECT store_id, store_name, phone, email, street, city, state, zip_code
FROM sales.stores;
GO

CREATE OR ALTER PROCEDURE staging_area.loadProductsData

AS

    SET NOCOUNT ON;
INSERT into staging_area.products (product_id, product_name, brand, category, model_year, list_price)
select p.product_id, p.product_name, b.brand_name, c.category_name, p.model_year, p.list_price
    from production.products p
        left join production.brands b on p.brand_id = b.brand_id
        left join production.categories c on c.category_id = p.category_id;
GO
CREATE OR ALTER PROCEDURE staging_area.loadOrdersData

AS

    SET NOCOUNT ON;

INSERT into staging_area.orders (order_id, order_status, required_date, shipped_date)
select order_id, order_status, required_date, shipped_date
from sales.orders where order_date between '2016-01-01' and  '2016-12-31';




