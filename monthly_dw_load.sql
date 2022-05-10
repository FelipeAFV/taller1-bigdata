GO
create or alter procedure dw.dateLoad

    @StartDate date,
    @EndDate date

AS

    SET NOCOUNT ON;


    --Temporary Variables To Hold the Values During Processing of Each Date of Year
DECLARE

    @CurrentYear INT,
    @CurrentMonth INT,
    @CurrentQuarter INT


    --Extract and assign various parts of Values from Current Date to Variable

DECLARE @CurrentDate AS date = @StartDate
    SET @CurrentMonth = DATEPART(MM, @CurrentDate)
    SET @CurrentYear = DATEPART(YY, @CurrentDate)

    WHILE @CurrentDate <= @EndDate
        BEGIN
            /* Populate Your Dimension Table with values*/

            INSERT INTO [dw].[date] (date, month, year, day)
            SELECT

                @CurrentDate AS date,
                --             DATEPART(DY, @CurrentDate) AS DayOfYear,

                DATEPART(MM, @CurrentDate) AS month,

                DATEPART(YEAR, @CurrentDate) AS year,
                DATEPART(DY, @CurrentDate) AS day

            SET @CurrentDate = DATEADD(DD, 1, @CurrentDate)
        END

    /********************************************************************************************/

GO

CREATE or alter PROCEDURE dw.loadMonthlyData


    @StartDate date,
    @EndDate date
AS

    SET NOCOUNT ON;

    exec dw.dateLoad @StartDate = @StartDate, @EndDate = @EndDate

    ---Carga de dimension orders con nuevos datos
    insert into dw.orders (order_id, order_status, required_date, shipped_date)  select order_id, order_status, required_date, shipped_date from staging_area.orders sa_o where  sa_o.order_id  not in (select order_id from  dw.orders)

    
    ---select * into dw.orders_fact from staging_area.orders_fact

    insert into dw.sales_fact (order_id, store_id, date_id, product_id, units, discount, total_cost, total_discount)   select order_id, store_id, date_id, product_id, units, discount, total_cost, total_discount from staging_area.sales_fact left join staging_area.date on staging_area.sales_fact.date_id = staging_area.date.id  where  date  between @StartDate and  @EndDate
