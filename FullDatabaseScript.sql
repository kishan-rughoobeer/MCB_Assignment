USE [master]
GO
/****** Object:  Database [MCB_Assignment]    Script Date: 25/03/2025 07:26:23 ******/
CREATE DATABASE [MCB_Assignment]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'MCB_Assignment', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQL2019FULL\MSSQL\DATA\MCB_Assignment.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'MCB_Assignment_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQL2019FULL\MSSQL\DATA\MCB_Assignment_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [MCB_Assignment] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [MCB_Assignment].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [MCB_Assignment] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [MCB_Assignment] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [MCB_Assignment] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [MCB_Assignment] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [MCB_Assignment] SET ARITHABORT OFF 
GO
ALTER DATABASE [MCB_Assignment] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [MCB_Assignment] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [MCB_Assignment] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [MCB_Assignment] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [MCB_Assignment] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [MCB_Assignment] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [MCB_Assignment] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [MCB_Assignment] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [MCB_Assignment] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [MCB_Assignment] SET  DISABLE_BROKER 
GO
ALTER DATABASE [MCB_Assignment] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [MCB_Assignment] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [MCB_Assignment] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [MCB_Assignment] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [MCB_Assignment] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [MCB_Assignment] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [MCB_Assignment] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [MCB_Assignment] SET RECOVERY FULL 
GO
ALTER DATABASE [MCB_Assignment] SET  MULTI_USER 
GO
ALTER DATABASE [MCB_Assignment] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [MCB_Assignment] SET DB_CHAINING OFF 
GO
ALTER DATABASE [MCB_Assignment] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [MCB_Assignment] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [MCB_Assignment] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [MCB_Assignment] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [MCB_Assignment] SET QUERY_STORE = OFF
GO
USE [MCB_Assignment]
GO
/****** Object:  Table [dbo].[XXBCM_PURCHASE_ORDER]    Script Date: 25/03/2025 07:26:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[XXBCM_PURCHASE_ORDER](
	[ORDER_ID] [int] IDENTITY(1,1) NOT NULL,
	[SUPPLIER_NAME] [varchar](2000) NULL,
	[ORDER_REF] [varchar](2000) NULL,
	[ORDER_DATE] [smalldatetime] NULL,
	[ORDER_TOTAL_AMOUNT] [float] NULL,
	[ORDER_DESCRIPTION] [varchar](2000) NULL,
	[ORDER_STATUS] [varchar](2000) NULL,
 CONSTRAINT [PK_XXBCM_PURCHASE_ORDER] PRIMARY KEY CLUSTERED 
(
	[ORDER_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[Second Highest Order Total Amount]    Script Date: 25/03/2025 07:26:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Second Highest Order Total Amount]
AS
SELECT ORDER_TOTAL_AMOUNT 
FROM (
    SELECT ORDER_TOTAL_AMOUNT, DENSE_RANK() OVER (ORDER BY ORDER_TOTAL_AMOUNT DESC) AS rank 
    FROM XXBCM_PURCHASE_ORDER
) ranked
WHERE rank = 2 
GO
/****** Object:  Table [dbo].[XXBCM_SUPPLIER]    Script Date: 25/03/2025 07:26:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[XXBCM_SUPPLIER](
	[SUPPIER_ID] [int] IDENTITY(1,1) NOT NULL,
	[SUPPLIER_NAME] [varchar](2000) NULL,
	[SUPPLIER_CONTACT_NAME] [varchar](2000) NULL,
	[SUPPLIER_ADDRESS] [varchar](2000) NULL,
	[SUPPLIER_CONTACT_NUMBER] [varchar](2000) NULL,
	[SUPPLIER_EMAIL] [varchar](2000) NULL,
 CONSTRAINT [PK_XXBCM_SUPPLIER] PRIMARY KEY CLUSTERED 
(
	[SUPPIER_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[All_Orders_01012022To31082022]    Script Date: 25/03/2025 07:26:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[All_Orders_01012022To31082022]
AS
SELECT        t1.SUPPLIER_NAME, dbo.XXBCM_SUPPLIER.SUPPLIER_CONTACT_NAME, dbo.XXBCM_SUPPLIER.SUPPLIER_CONTACT_NUMBER, COUNT(*) AS [Total Orders], t1.ORDER_TOTAL_AMOUNT
FROM            dbo.XXBCM_PURCHASE_ORDER AS t1 INNER JOIN
                         dbo.XXBCM_SUPPLIER ON t1.SUPPLIER_NAME = dbo.XXBCM_SUPPLIER.SUPPLIER_NAME
WHERE        (t1.ORDER_DATE <= CONVERT(DATETIME, '2022-08-31 00:00:00', 102))
GROUP BY t1.SUPPLIER_NAME, dbo.XXBCM_SUPPLIER.SUPPLIER_CONTACT_NAME, dbo.XXBCM_SUPPLIER.SUPPLIER_CONTACT_NUMBER, t1.ORDER_DATE, t1.ORDER_TOTAL_AMOUNT
HAVING        (t1.ORDER_DATE >= CONVERT(DATETIME, '2022-01-01 00:00:00', 102))
GO
/****** Object:  View [dbo].[SplittedContact]    Script Date: 25/03/2025 07:26:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[SplittedContact]
AS
WITH Splitted AS (
    SELECT SUPPLIER_CONTACT_NUMBER, value, ROW_NUMBER() OVER (PARTITION BY SUPPLIER_CONTACT_NUMBER ORDER BY (SELECT NULL)) AS rn
    FROM XXBCM_SUPPLIER
    CROSS APPLY STRING_SPLIT(SUPPLIER_CONTACT_NUMBER, ',')
)
SELECT * 
FROM Splitted
PIVOT (
    MAX(value) FOR rn IN ([1], [2]) -- Adjust based on max expected columns
) AS PivotTable;

GO
/****** Object:  Table [dbo].[XXBCM_INVOICE_PAYMENT]    Script Date: 25/03/2025 07:26:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[XXBCM_INVOICE_PAYMENT](
	[INVOICE_ID] [int] IDENTITY(1,1) NOT NULL,
	[INVOICE_DATE] [varchar](2000) NULL,
	[INVOICE_REFERENCE] [varchar](2000) NULL,
	[INVOICE_STATUS] [varchar](2000) NULL,
	[INVOICE_HOLD_REASON] [varchar](2000) NULL,
	[INVOICE_AMOUNT] [float] NULL,
	[INVOICE_DESCRIPTION] [varchar](2000) NULL,
 CONSTRAINT [PK_XXBCM_INVOICE_PAYMENT] PRIMARY KEY CLUSTERED 
(
	[INVOICE_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[XXBCM_ORDER_MGT]    Script Date: 25/03/2025 07:26:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[XXBCM_ORDER_MGT](
	[ORDER_REF] [varchar](2000) NULL,
	[ORDER_DATE] [varchar](2000) NULL,
	[SUPPLIER_NAME] [varchar](2000) NULL,
	[SUPP_CONTACT_NAME] [varchar](2000) NULL,
	[SUPP_ADDRESS] [varchar](2000) NULL,
	[SUPP_CONTACT_NUMBER] [varchar](2000) NULL,
	[SUPP_EMAIL] [varchar](2000) NULL,
	[ORDER_TOTAL_AMOUNT] [varchar](2000) NULL,
	[ORDER_DESCRIPTION] [varchar](2000) NULL,
	[ORDER_STATUS] [varchar](2000) NULL,
	[ORDER_LINE_AMOUNT] [varchar](2000) NULL,
	[INVOICE_REFERENCE] [varchar](2000) NULL,
	[INVOICE_DATE] [varchar](2000) NULL,
	[INVOICE_STATUS] [varchar](2000) NULL,
	[INVOICE_HOLD_REASON] [varchar](2000) NULL,
	[INVOICE_AMOUNT] [varchar](2000) NULL,
	[INVOICE_DESCRIPTION] [varchar](2000) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[XXBCM_PURCHASE_ORDER_LINES]    Script Date: 25/03/2025 07:26:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[XXBCM_PURCHASE_ORDER_LINES](
	[POL_ID] [int] IDENTITY(1,1) NOT NULL,
	[PO_ID] [int] NULL,
	[ORDER_REF] [varchar](2000) NULL,
	[ORDER_DESCRIPTION] [varchar](2000) NULL,
	[ORDER_LINE_AMOUNT] [float] NULL,
 CONSTRAINT [PK_XXBCM_PURCHASE_ORDER_LINES] PRIMARY KEY CLUSTERED 
(
	[POL_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[XXBCM_STOCK]    Script Date: 25/03/2025 07:26:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[XXBCM_STOCK](
	[STOCK_ID] [int] IDENTITY(1,1) NOT NULL,
	[STOCK_DESCRIPTION] [varchar](2000) NULL,
	[STOCK_PRICE] [float] NULL,
 CONSTRAINT [PK_XXBCM_STOCK] PRIMARY KEY CLUSTERED 
(
	[STOCK_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [idx_ORDER_ID]    Script Date: 25/03/2025 07:26:23 ******/
CREATE NONCLUSTERED INDEX [idx_ORDER_ID] ON [dbo].[XXBCM_PURCHASE_ORDER]
(
	[ORDER_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  StoredProcedure [dbo].[CleanData]    Script Date: 25/03/2025 07:26:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CleanData]
AS
BEGIN
    -- Update ORDER_LINE_AMOUNT: Trim spaces, remove unwanted characters
    UPDATE XXBCM_ORDER_MGT
    SET ORDER_LINE_AMOUNT = TRIM(REPLACE(REPLACE(REPLACE(REPLACE(ORDER_LINE_AMOUNT, ',',''),'o','0'),'I','1'),'S','5'))
    WHERE ORDER_LINE_AMOUNT IS NOT NULL;

    -- Update ORDER_LINE_AMOUNT: Convert empty strings to NULL
    UPDATE XXBCM_ORDER_MGT
    SET ORDER_LINE_AMOUNT = NULL
    WHERE ORDER_LINE_AMOUNT = '';

    -- Update ORDER_LINE_AMOUNT: Convert VARCHAR to FLOAT, handle non-numeric data
    UPDATE XXBCM_ORDER_MGT
    SET ORDER_LINE_AMOUNT = TRY_CAST(ORDER_LINE_AMOUNT AS FLOAT)
    WHERE ISNUMERIC(ORDER_LINE_AMOUNT) = 1;

    -- Update SUPP_CONTACT_NUMBER: Trim spaces, remove unwanted characters
    UPDATE XXBCM_ORDER_MGT
    SET SUPP_CONTACT_NUMBER = TRIM(REPLACE(REPLACE(REPLACE(REPLACE(SUPP_CONTACT_NUMBER, 'o','0'),'I','1'),'S','5'),'.',''))
    WHERE SUPP_CONTACT_NUMBER IS NOT NULL;

    -- Update SUPP_CONTACT_NUMBER: Convert empty strings to NULL
    UPDATE XXBCM_ORDER_MGT
    SET SUPP_CONTACT_NUMBER = NULL
    WHERE SUPP_CONTACT_NUMBER = '';

	 -- Update ORDER_TOTAL_AMOUNT: Trim spaces, remove unwanted characters
    UPDATE XXBCM_ORDER_MGT
    SET ORDER_TOTAL_AMOUNT = TRIM(REPLACE(REPLACE(REPLACE(REPLACE(ORDER_TOTAL_AMOUNT, ',',''),'o','0'),'I','1'),'S','5'))
    WHERE ORDER_TOTAL_AMOUNT IS NOT NULL;

    -- Update ORDER_TOTAL_AMOUNT: Convert empty strings to NULL
    UPDATE XXBCM_ORDER_MGT
    SET ORDER_TOTAL_AMOUNT = NULL
    WHERE ORDER_TOTAL_AMOUNT = '';

	 -- Update ORDER_TOTAL_AMOUNT: Convert VARCHAR to FLOAT, handle non-numeric data
    UPDATE XXBCM_ORDER_MGT
    SET ORDER_TOTAL_AMOUNT = TRY_CAST(ORDER_TOTAL_AMOUNT AS FLOAT)
    WHERE ISNUMERIC(ORDER_TOTAL_AMOUNT) = 1;

	-- Update INVOICE_AMOUNT: Trim spaces, remove unwanted characters
    UPDATE XXBCM_ORDER_MGT
    SET INVOICE_AMOUNT = TRIM(REPLACE(REPLACE(REPLACE(REPLACE(INVOICE_AMOUNT, ',',''),'o','0'),'I','1'),'S','5'))
    WHERE INVOICE_AMOUNT IS NOT NULL;

    -- Update INVOICE_AMOUNT: Convert empty strings to NULL
    UPDATE XXBCM_ORDER_MGT
    SET INVOICE_AMOUNT = NULL
    WHERE INVOICE_AMOUNT = '';

	 -- Update INVOICE_AMOUNT: Convert VARCHAR to FLOAT, handle non-numeric data
    UPDATE XXBCM_ORDER_MGT
    SET INVOICE_AMOUNT = TRY_CAST(INVOICE_AMOUNT AS FLOAT)
    WHERE ISNUMERIC(INVOICE_AMOUNT) = 1;

    PRINT 'Data cleaning completed successfully!';
END
GO
/****** Object:  StoredProcedure [dbo].[MIGRATION]    Script Date: 25/03/2025 07:26:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[MIGRATION]

AS

BEGIN

EXEC CleanData

--Stock
INSERT INTO
dbo.XXBCM_STOCK(STOCK_DESCRIPTION, STOCK_PRICE)
SELECT
ORDER_DESCRIPTION, TRY_CAST(ORDER_LINE_AMOUNT AS FLOAT)
FROM
dbo.XXBCM_ORDER_MGT
WHERE ORDER_LINE_AMOUNT IS NOT NULL


--Supplier
INSERT INTO
dbo.XXBCM_SUPPLIER(SUPPLIER_NAME,SUPPLIER_CONTACT_NAME,SUPPLIER_ADDRESS,SUPPLIER_CONTACT_NUMBER,SUPPLIER_EMAIL)
SELECT
SUPPLIER_NAME,SUPP_CONTACT_NAME,SUPP_ADDRESS,SUPP_CONTACT_NUMBER,SUPP_EMAIL
FROM
dbo.XXBCM_ORDER_MGT

-- Purchase Order
INSERT INTO
dbo.XXBCM_PURCHASE_ORDER(ORDER_REF,ORDER_DATE,ORDER_TOTAL_AMOUNT,ORDER_DESCRIPTION,ORDER_STATUS,SUPPLIER_NAME)
SELECT
ORDER_REF,ORDER_DATE,ORDER_TOTAL_AMOUNT,ORDER_DESCRIPTION,ORDER_STATUS,SUPPLIER_NAME
FROM
dbo.XXBCM_ORDER_MGT
where ORDER_REF  NOT LIKE '%-%'

-- PO LINES
INSERT INTO
dbo.XXBCM_PURCHASE_ORDER_LINES(ORDER_REF,ORDER_DESCRIPTION,ORDER_LINE_AMOUNT)
SELECT
ORDER_REF,ORDER_DESCRIPTION, TRY_CAST(ORDER_LINE_AMOUNT AS FLOAT)
FROM
dbo.XXBCM_ORDER_MGT
WHERE ORDER_LINE_AMOUNT IS NOT NULL

--Update ORDER ID from PO HEADER
UPDATE l
SET l.PO_ID = p.ORDER_ID
FROM XXBCM_PURCHASE_ORDER_LINES l
JOIN XXBCM_PURCHASE_ORDER p ON left(l.ORDER_REF,5) = p.ORDER_REF

-- INVOICE PAYMENT
INSERT INTO
dbo.XXBCM_INVOICE_PAYMENT(INVOICE_DATE,INVOICE_REFERENCE,INVOICE_STATUS,INVOICE_HOLD_REASON,INVOICE_AMOUNT,INVOICE_DESCRIPTION)
SELECT
INVOICE_DATE,INVOICE_REFERENCE,INVOICE_STATUS,INVOICE_HOLD_REASON,TRY_CAST(INVOICE_AMOUNT AS FLOAT),INVOICE_DESCRIPTION
FROM
dbo.XXBCM_ORDER_MGT
WHERE INVOICE_REFERENCE IS NOT NULL


END
GO
/****** Object:  StoredProcedure [dbo].[Task No.4 - InvoicesAndTotals]    Script Date: 25/03/2025 07:26:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Task No.4 - InvoicesAndTotals]

AS
BEGIN
SELECT DISTINCT 
	CAST(SUBSTRING(t1.ORDER_REF, PATINDEX('%[0-9]%', t1.ORDER_REF), 
	LEN(t1.ORDER_REF)) AS INT) AS [Order Reference], 
	{fn CONCAT(UPPER(LEFT(t1.SUPPLIER_NAME, 1)), LOWER(SUBSTRING(t1.SUPPLIER_NAME, 2, LEN(t1.SUPPLIER_NAME)))) } AS [Supplier Name], 
	FORMAT(t1.ORDER_TOTAL_AMOUNT, 'N2') AS [Order Total Amount], 
	t1.ORDER_STATUS AS [Order Status], 
	CAST(SUBSTRING(t2.INVOICE_REFERENCE, PATINDEX('%[0-9]%', 
	t2.INVOICE_REFERENCE), LEN(t2.INVOICE_REFERENCE)) AS DECIMAL) AS [Invoice Reference], 
	FORMAT(SUM(t2.INVOICE_AMOUNT), 'N2') AS [Invoice Total Amount], 
	CASE WHEN t2.INVOICE_STATUS = 'Paid' THEN 'OK' WHEN t2.INVOICE_STATUS = 'Pending' THEN 'To follow up' ELSE 'To Verify' END AS Action
FROM dbo.XXBCM_PURCHASE_ORDER AS t1 INNER JOIN
	dbo.XXBCM_INVOICE_PAYMENT AS t2 ON CAST(SUBSTRING(t1.ORDER_REF, PATINDEX('%[0-9]%', t1.ORDER_REF), LEN(t1.ORDER_REF)) AS INT) = CAST(SUBSTRING(t2.INVOICE_REFERENCE, PATINDEX('%[0-9]%', 
	t2.INVOICE_REFERENCE), LEN(t2.INVOICE_REFERENCE)) AS DECIMAL)
	GROUP BY CAST(SUBSTRING(t1.ORDER_REF, PATINDEX('%[0-9]%', t1.ORDER_REF), LEN(t1.ORDER_REF)) AS INT), t1.SUPPLIER_NAME, t1.ORDER_DATE, t1.ORDER_TOTAL_AMOUNT, t1.ORDER_STATUS, t2.INVOICE_STATUS, 
	CAST(SUBSTRING(t2.INVOICE_REFERENCE, PATINDEX('%[0-9]%', t2.INVOICE_REFERENCE), LEN(t2.INVOICE_REFERENCE)) AS DECIMAL)
END
GO
/****** Object:  StoredProcedure [dbo].[Task No.5 - Second Highest Order]    Script Date: 25/03/2025 07:26:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Task No.5 - Second Highest Order]

AS
BEGIN
SELECT DISTINCT 
	CAST(SUBSTRING(t1.ORDER_REF, PATINDEX('%[0-9]%', t1.ORDER_REF), LEN(t1.ORDER_REF)) AS INT) AS [Order Reference], 
	FORMAT(t1.ORDER_DATE, 'dd MMMM, yyyy') AS [Order Date], 
	UPPER(t1.SUPPLIER_NAME) AS [Supplier Name], 
	format(t1.ORDER_TOTAL_AMOUNT, 'N2') AS [Order Total Amount], 
	t1.ORDER_STATUS AS [Order Status], 
	STRING_AGG(t2.INVOICE_REFERENCE, ' | ') AS [Invoice References]
FROM dbo.XXBCM_PURCHASE_ORDER AS t1 
	INNER JOIN
		dbo.XXBCM_INVOICE_PAYMENT AS t2 ON CAST(SUBSTRING(t1.ORDER_REF, PATINDEX('%[0-9]%', t1.ORDER_REF), LEN(t1.ORDER_REF)) AS INT) = CAST(SUBSTRING(t2.INVOICE_REFERENCE, PATINDEX('%[0-9]%', 
		t2.INVOICE_REFERENCE), LEN(t2.INVOICE_REFERENCE)) AS DECIMAL) 
	INNER JOIN 
        dbo.[Second Highest Order Total Amount] ON t1.ORDER_TOTAL_AMOUNT = dbo.[Second Highest Order Total Amount].ORDER_TOTAL_AMOUNT --a view created [Second Highest Order Total Amount] to split and modularise the process
GROUP BY CAST(SUBSTRING(t1.ORDER_REF, PATINDEX('%[0-9]%', t1.ORDER_REF), 
	LEN(t1.ORDER_REF)) AS INT), 
	t1.SUPPLIER_NAME, 
	t1.ORDER_DATE, 
	t1.ORDER_TOTAL_AMOUNT, 
	t1.ORDER_STATUS
END
GO
/****** Object:  StoredProcedure [dbo].[Task No.6 - Number of orders and total amount ordered]    Script Date: 25/03/2025 07:26:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Task No.6 - Number of orders and total amount ordered]
	
AS
BEGIN
SELECT 
	dbo.All_Orders_01012022To31082022.SUPPLIER_NAME AS [Supplier Name], 
	dbo.All_Orders_01012022To31082022.SUPPLIER_CONTACT_NAME AS [Supplier Contact Name], 
	dbo.SplittedContact.[1] AS [Supplier Contact No.1], --Pivot [SplittedContact] created in a view
    dbo.SplittedContact.[2] AS [Supplier Contact No.2], 
	dbo.All_Orders_01012022To31082022.[Total Orders], -- a view created [All_Orders_01012022To31082022] to split and modularise the process
	FORMAT(SUM(dbo.All_Orders_01012022To31082022.ORDER_TOTAL_AMOUNT), 'N2') AS [Order Total Amount]
FROM dbo.All_Orders_01012022To31082022 
	INNER JOIN
    dbo.SplittedContact ON dbo.All_Orders_01012022To31082022.SUPPLIER_CONTACT_NUMBER = dbo.SplittedContact.SUPPLIER_CONTACT_NUMBER
GROUP BY 
	dbo.All_Orders_01012022To31082022.SUPPLIER_NAME, 
	dbo.All_Orders_01012022To31082022.SUPPLIER_CONTACT_NAME, 
	dbo.All_Orders_01012022To31082022.SUPPLIER_CONTACT_NUMBER, 
    dbo.All_Orders_01012022To31082022.[Total Orders], 
	dbo.SplittedContact.[1], dbo.SplittedContact.[2]
END
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "t1"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 246
               Right = 279
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "XXBCM_SUPPLIER"
            Begin Extent = 
               Top = 6
               Left = 317
               Bottom = 245
               Right = 586
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 2640
         Width = 2190
         Width = 1785
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 2445
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1560
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'All_Orders_01012022To31082022'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'All_Orders_01012022To31082022'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Second Highest Order Total Amount'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Second Highest Order Total Amount'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'SplittedContact'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'SplittedContact'
GO
USE [master]
GO
ALTER DATABASE [MCB_Assignment] SET  READ_WRITE 
GO
