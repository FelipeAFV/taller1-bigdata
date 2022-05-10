create or alter procedure staging_area.dateLoad

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

                    INSERT INTO [staging_area].[date] (date, month, year, day)
                    SELECT

                        @CurrentDate AS date,
        --             DATEPART(DY, @CurrentDate) AS DayOfYear,

                        DATEPART(MM, @CurrentDate) AS month,

                        DATEPART(YEAR, @CurrentDate) AS year,
                        DATEPART(DY, @CurrentDate) AS day

                    SET @CurrentDate = DATEADD(DD, 1, @CurrentDate)
                END

        /********************************************************************************************/


