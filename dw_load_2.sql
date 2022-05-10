
GO

CREATE OR alter PROCEDURE staging_area.loadInitialDwData

AS

    SET NOCOUNT ON;


------Query para cargar DW
insert into staging_area.sales_fact(date_id,order_id,product_id,store_id,discount,units, total_cost, total_discount)
select oo.odate as date_id, oo.order_id, i.product_id, oo.store_id, i.discount, i.quantity, (1-i.discount) * i.list_price * i.quantity, i.discount * i.list_price * i.quantity
from sales.order_items i left join
     (select d.id as odate, o.order_id, o.order_date, d.date, o.store_id from sales.orders o , staging_area.date  d where o.order_date = d.date) oo
     on oo.order_id = i.order_id where oo.odate is not null ;

GO


-- Procedimiento para carga mensual
CREATE PROCEDURE staging_area.loadMonthlyData


    @StartDate date,
    @EndDate date
AS

    SET NOCOUNT ON;

    ---Carga de dimension fecha
    execute staging_area.dateLoad @StartDate = @StartDate, @EndDate = @EndDate;

    ---Carga de nuevos datos dimension order

INSERT into staging_area.orders (order_id, order_status, required_date, shipped_date)
select order_id, order_status, required_date, shipped_date
from sales.orders where order_id not IN (select order_id from staging_area.orders ) and order_date between @StartDate and  @EndDate;


    ---CArga a la tabla de hechos
insert into staging_area.sales_fact(date_id,order_id,product_id,store_id,discount,units, total_cost, total_discount)
select oo.odate as date_id, oo.order_id, i.product_id, oo.store_id, i.discount, i.quantity, (1-i.discount) * i.list_price * i.quantity, i.discount * i.list_price * i.quantity
from sales.order_items i left join
     (select d.id as odate, o.order_id, o.order_date, d.date, o.store_id from sales.orders o , staging_area.date  d where o.order_date = d.date) oo
     on oo.order_id = i.order_id where DATEPART(mm, oo.date) = DATEPART(mm, @StartDate)
                                   AND DATEPART(yyyy, oo.date) = DATEPART(yyyy, @StartDate)
                                   AND oo.odate is not null ;


