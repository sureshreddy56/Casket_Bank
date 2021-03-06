USE [master]
GO
/****** Object:  Database [bankdomain]    Script Date: 28-12-2020 11:59:21 ******/
CREATE DATABASE [bankdomain]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'bankdomain', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\bankdomain.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'bankdomain_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\bankdomain_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [bankdomain] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [bankdomain].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [bankdomain] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [bankdomain] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [bankdomain] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [bankdomain] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [bankdomain] SET ARITHABORT OFF 
GO
ALTER DATABASE [bankdomain] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [bankdomain] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [bankdomain] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [bankdomain] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [bankdomain] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [bankdomain] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [bankdomain] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [bankdomain] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [bankdomain] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [bankdomain] SET  ENABLE_BROKER 
GO
ALTER DATABASE [bankdomain] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [bankdomain] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [bankdomain] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [bankdomain] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [bankdomain] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [bankdomain] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [bankdomain] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [bankdomain] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [bankdomain] SET  MULTI_USER 
GO
ALTER DATABASE [bankdomain] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [bankdomain] SET DB_CHAINING OFF 
GO
ALTER DATABASE [bankdomain] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [bankdomain] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [bankdomain] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [bankdomain] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [bankdomain] SET QUERY_STORE = OFF
GO
USE [bankdomain]
GO
/****** Object:  Table [dbo].[Account]    Script Date: 28-12-2020 11:59:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Account](
	[aid] [int] IDENTITY(1,1) NOT NULL,
	[Account_id] [bigint] NOT NULL,
	[Balance] [int] NULL,
	[Acc_type] [varchar](50) NULL,
	[Branch_id] [varchar](50) NULL,
	[IFSC_code] [varchar](50) NULL,
 CONSTRAINT [PK_Account] PRIMARY KEY CLUSTERED 
(
	[Account_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Branch]    Script Date: 28-12-2020 11:59:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Branch](
	[bid] [int] IDENTITY(1,1) NOT NULL,
	[Branch_id] [varchar](50) NOT NULL,
	[Branch_name] [varchar](50) NULL,
	[Branch_address] [varchar](150) NULL,
 CONSTRAINT [PK_Branch] PRIMARY KEY CLUSTERED 
(
	[Branch_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[Branch_Account]    Script Date: 28-12-2020 11:59:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[Branch_Account] as 
 (SELECT 
        B.Branch_name,
	     A.Acc_type,
	     COUNT(A.Account_ID) AS Number_of_accounts
FROM Branch B
INNER JOIN Account A ON B.Branch_id = A.Branch_id
GROUP BY B.Branch_name,A.Acc_type)
GO
/****** Object:  View [dbo].[Ac_Branch]    Script Date: 28-12-2020 11:59:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Ac_Branch] AS 
SELECT  
       A.Branch_id,
      (SELECT Branch_name FROM Branch B 
       where A.Branch_id=B.Branch_id) AS Branch_name,
	   COUNT(Account_id) Account_total
FROM Account A
group by Branch_id
GO
/****** Object:  Table [dbo].[Payment]    Script Date: 28-12-2020 11:59:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Payment](
	[Payment_number] [int] IDENTITY(3020,1) NOT NULL,
	[Loan_number] [int] NOT NULL,
	[Payment_date] [date] NOT NULL,
	[Payment_amount] [decimal](10, 2) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Payment_number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Loan]    Script Date: 28-12-2020 11:59:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Loan](
	[lid] [int] IDENTITY(1,1) NOT NULL,
	[Loan_number] [int] NOT NULL,
	[Cust_id] [int] NULL,
	[Loan_amount] [int] NULL,
	[Loan_type] [varchar](50) NULL,
	[Loan_period] [int] NULL,
	[Loan_bal] [int] NULL,
	[Loan_status] [varchar](50) NULL,
 CONSTRAINT [PK_Loan] PRIMARY KEY CLUSTERED 
(
	[Loan_number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Loan_type]    Script Date: 28-12-2020 11:59:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Loan_type](
	[Ltype_ID] [int] IDENTITY(1,1) NOT NULL,
	[Ltype_Name] [varchar](20) NOT NULL,
 CONSTRAINT [PK_LT_ID] PRIMARY KEY CLUSTERED 
(
	[Ltype_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[Ltype_Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[Loan_status]    Script Date: 28-12-2020 11:59:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Loan_status] AS SELECT	P.Loan_number,
		L.Cust_ID,
count(L.Cust_ID) as count,
		(Select Ltype_Name FROM Loan_type lt where lt.Ltype_ID=L.Loan_type)as Loan_type,
		L.Loan_amount,
		sum(P.Payment_amount) as Payment_total,
		(L.Loan_amount-sum(P.Payment_amount)) as Balance,
		Case when (L.Loan_amount-sum(P.Payment_amount)) = 0 then 'Completed'
		     else 'On Progress'
			 End as Status
FROM Payment P
JOIN Loan L ON P.Loan_number=L.Loan_number
Group by P.Loan_number,L.Cust_ID,L.Loan_amount,L.Loan_type
GO
/****** Object:  Table [dbo].[Customer]    Script Date: 28-12-2020 11:59:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Customer](
	[Cust_ID] [int] NOT NULL,
	[Account_ID] [bigint] NOT NULL,
	[Cust_name] [varchar](20) NOT NULL,
	[Cust_address] [varchar](70) NULL,
	[Phone_number] [bigint] NOT NULL,
	[Email_ID] [varchar](30) NULL,
	[Yearly_income] [int] NULL,
	[cid] [int] IDENTITY(1,1) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Cust_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[Phone_number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[Email_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[Loan_type_distribution]    Script Date: 28-12-2020 11:59:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[Loan_type_distribution] AS (
SELECT  B.Branch_name, Lt.Ltype_Name, count(Lt.Ltype_Name) as count     FROM Branch B JOIN Account A ON A.Branch_id=B.Branch_id JOIN Customer C ON C.Account_ID=A.Account_ID JOIN Loan L ON L.Cust_ID=C.Cust_ID JOIN Loan_type Lt ON Lt.Ltype_ID= L.Loan_type GROUP BY B.Branch_name,Lt.Ltype_Name)

GO
/****** Object:  Table [dbo].[admin]    Script Date: 28-12-2020 11:59:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[admin](
	[userId] [int] NOT NULL,
	[userName] [varchar](50) NULL,
	[password] [varchar](50) NULL,
 CONSTRAINT [PK_admin] PRIMARY KEY CLUSTERED 
(
	[userId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Employee]    Script Date: 28-12-2020 11:59:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Employee](
	[eid] [int] IDENTITY(1,1) NOT NULL,
	[Emp_id] [varchar](50) NOT NULL,
	[Emp_name] [varchar](50) NULL,
	[Phone_no] [bigint] NULL,
	[Emp_exp] [int] NULL,
	[Salary] [int] NULL,
	[Designation] [varchar](50) NULL,
	[Branch_id] [varchar](50) NULL,
 CONSTRAINT [PK_Employee] PRIMARY KEY CLUSTERED 
(
	[Emp_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Payment]  WITH CHECK ADD FOREIGN KEY([Loan_number])
REFERENCES [dbo].[Loan] ([Loan_number])
GO
USE [master]
GO
ALTER DATABASE [bankdomain] SET  READ_WRITE 
GO
