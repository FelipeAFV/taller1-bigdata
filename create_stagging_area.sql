CREATE SCHEMA staging_area;

GO
CREATE SCHEMA dw;

CREATE TABLE staging_area.[stores] (
  [id] int PRIMARY KEY IDENTITY(1, 1),
  [store_id] int UNIQUE,
  [store_name] nvarchar(255),
  [phone] nvarchar(255),
  [email] nvarchar(255),
  [street] nvarchar(255),
  [city] nvarchar(255),
  [state] nvarchar(255),
  [zip_code] nvarchar(255)
)
GO

CREATE TABLE staging_area.[date] (
  [id] int PRIMARY KEY IDENTITY(1, 1),
  [date] date,
  [year] int,
  [month] int,
  [day] int
)
GO

CREATE TABLE staging_area.[products] (
  [id] int PRIMARY KEY IDENTITY(1, 1),
  [product_id] int UNIQUE,
  [product_name] nvarchar(255),
  [brand] nvarchar(255),
  [category] nvarchar(255),
  [model_year] int,
  [list_price] float
)
GO

CREATE TABLE staging_area.[orders] (
  [id] int PRIMARY KEY IDENTITY(1, 1),
  [order_id] int UNIQUE,
  [order_status] nvarchar(255),
  [required_date] date,
  [shipped_date] date
)
GO

CREATE TABLE staging_area.[sales_fact] (
  [order_id] int,
  [store_id] int,
  [date_id] int,
  [product_id] int,
  [units] int,
  [discount] float,
  [total_cost] float,
  [total_discount] float,
  PRIMARY KEY ([order_id], [store_id], [date_id], [product_id])
)
GO

ALTER TABLE staging_area.[sales_fact] ADD FOREIGN KEY ([order_id]) REFERENCES staging_area.[orders] ([id])
GO

ALTER TABLE staging_area.[sales_fact] ADD FOREIGN KEY ([store_id]) REFERENCES staging_area.[stores] ([id])
GO

ALTER TABLE staging_area.[sales_fact] ADD FOREIGN KEY ([date_id]) REFERENCES staging_area.[date] ([id])
GO

ALTER TABLE staging_area.[sales_fact] ADD FOREIGN KEY ([product_id]) REFERENCES staging_area.[products] ([id])
GO
