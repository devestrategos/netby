 
CREATE PROCEDURE GetcuentasInfo
AS
BEGIN
SET NOCOUNT ON
        SELECT A.[cuenta_id]
        ,A.[cuenta_balance]
        ,A.[tipos_id]
        ,T.[icon]
        ,A.[banco_id]
        ,B.[banco_name]
        ,A.[cuenta_balance]
        ,A.[cuenta_IBAN]
        ,A.[time_stamp]
        ,A.[cuenta_holder]
    FROM [FinancialDb].[dbo].[cuenta] A,
        [FinancialDb].[dbo].[tipos] T,
        [FinancialDb].[dbo].[banco] B
    WHERE A.[tipos_id] = T.[tipos_id] AND B.[banco_id] = A.[banco_id]
END


-- Get tipos by a given table
CREATE PROCEDURE GettiposByTables
(@Table_name VARCHAR(32))
AS
BEGIN
SET NOCOUNT ON
    SELECT 
     [tipos_id]
    ,[tipos_name]
    ,[table_name]
    ,[icon]
FROM [FinancialDb].[dbo].[tipos]
WHERE @Table_name = [table_name]
END

    -- Transacción combinada con categoría de imagen 
    -- JOIN transacciones Type and categoria 
CREATE PROCEDURE GettransaccionesForAncuenta
(@cuenta_id INT)
AS
BEGIN
SET NOCOUNT ON
    SELECT T.[transacciones_id]
        ,T.[transacciones_name]
        ,Ty.[icon] TypeIcon
        ,M.[comerciante_name]
        ,C.[categoria_name]
        ,C.[icon] categoriaIcon
        ,C.[color]
        ,T.[transacciones_price]
        ,T.[transacciones_Date]
        ,T.[image]
        ,T.[transacciones_description]
        ,T.[time_stamp]
    FROM [FinancialDb].[dbo].[transacciones_Acc] T,
        [FinancialDb].[dbo].[tipos] Ty,
        [FinancialDb].[dbo].[categoria] C,
        [FinancialDb].[dbo].[comerciante] M
    WHERE T.[cuenta_id] = @cuenta_id AND 
        Ty.[tipos_id] = T.[tipos_id] AND
        C.[categoria_id] = T.[categoria_id] AND
        M.[comerciante_id] = T.[comerciante_id]
    ORDER BY T.[transacciones_Date]
END


-- Gettransaccioness GroupBy categoria By time 
CREATE PROCEDURE GroupBycategorias
(@categoria_name VARCHAR(32), @date_enrolled DATETIME, @type_groupby VARCHAR, @cuenta_id INT)
AS
BEGIN
SET NOCOUNT ON
IF ('M' = @type_groupby)
begin
    SELECT T.[transacciones_id]
        ,T.[transacciones_name]
        ,Ty.[icon] TypeIcon
        ,M.[comerciante_name]
        ,C.[categoria_name]
        ,C.[icon] categoriaIcon
        ,C.[color]
        ,T.[transacciones_price]
        ,T.[transacciones_Date]
        ,T.[image]
        ,T.[transacciones_description]
        ,T.[time_stamp]
    FROM [FinancialDb].[dbo].[transacciones_Acc] T,
        [FinancialDb].[dbo].[tipos] Ty,
        [FinancialDb].[dbo].[categoria] C,
        [FinancialDb].[dbo].[comerciante] M
    WHERE T.[cuenta_id] = @cuenta_id AND 
        Ty.[tipos_id] = T.[tipos_id] AND
        C.[categoria_id] = T.[categoria_id] AND
        M.[comerciante_id] = T.[comerciante_id] AND 
        C.[categoria_name] = @categoria_name AND
        MONTH(@date_enrolled) = MONTH(T.[transacciones_Date]) AND 
        YEAR(@date_enrolled) = YEAR(T.[transacciones_Date]) 
    ORDER BY T.[transacciones_Date]
end
ELSE 
begin
    SELECT T.[transacciones_id]
        ,T.[transacciones_name]
        ,Ty.[icon] TypeIcon
        ,M.[comerciante_name]
        ,C.[categoria_name]
        ,C.[icon] categoriaIcon
        ,C.[color]
        ,T.[transacciones_price]
        ,T.[transacciones_Date]
        ,T.[image]
        ,T.[transacciones_description]
        ,T.[time_stamp]
    FROM [FinancialDb].[dbo].[transacciones_Acc] T,
        [FinancialDb].[dbo].[tipos] Ty,
        [FinancialDb].[dbo].[categoria] C,
        [FinancialDb].[dbo].[comerciante] M
    WHERE T.[cuenta_id] = @cuenta_id AND 
        Ty.[tipos_id] = T.[tipos_id] AND
        C.[categoria_id] = T.[categoria_id] AND
        M.[comerciante_id] = T.[comerciante_id] AND 
        C.[categoria_name] = @categoria_name AND
        YEAR(@date_enrolled) = YEAR(T.[transacciones_Date]) 
    ORDER BY T.[transacciones_Date]
end
END

-- Functions 
create function TotalBalance()  
returns decimal(10,2)  
as
begin  
    return (SELECT sum([cuenta_balance]) Sum_1
            FROM [FinancialDb].[dbo].[cuenta])
end  

print dbo.TotalBalance()



create function NumberOfCards()  
returns INT  
as  
begin  
    return (SELECT count(*)
            FROM [FinancialDb].[dbo].[cuenta] 
            WHERE (SELECT [tipos_id] 
                    FROM [FinancialDb].[dbo].[tipos] 
                    WHERE [tipos_name] = 'Credit' ) = [tipos_id] OR
                  (SELECT [tipos_id] 
                    FROM [FinancialDb].[dbo].[tipos] 
                    WHERE [tipos_name] = 'Debit' ) = [tipos_id]) 
end  
print dbo.NumberOfCards()

create function NumberOfUnikbancos()  
returns INT  
as  
begin  
    return (SELECT count(F.banco_Name) nb 
            FROM (SELECT count(*) Nr_Acc,
                         B.banco_name banco_Name
                  FROM [FinancialDb].[dbo].[cuenta] A,
                       [FinancialDb].[dbo].[banco]  B
                  WHERE B.[banco_id] = A.[banco_id]
                  GROUP BY B.[banco_name]) F)
end 
print dbo.NumberOfUnikbancos()

create function GetNumberOftransaccioness(@transtaion_name VARCHAR(32))  
returns INT  
as  
begin  
    return( SELECT count(*) 
            FROM [FinancialDb].[dbo].[transacciones_Acc] T, 
                 [FinancialDb].[dbo].[tipos] Ty 
            WHERE Ty.[tipos_id] = T.[tipos_id] and 
                  @transtaion_name = Ty.[tipos_name]
            GROUP BY Ty.[tipos_name] )
end 
print dbo.GetNumberOftransaccioness('Expences')

CREATE PROCEDURE GetSmallestadistica
AS
BEGIN
SET NOCOUNT ON
SELECT dbo.TotalBalance() total_balance,   
       dbo.GetNumberOftransaccioness('Expences') number_expences,
       dbo.GetNumberOftransaccioness('Income') number_incoms,
       dbo.NumberOfCards() number_cards,
       dbo.NumberOfUnikbancos() number_bancos ;
END

CREATE PROCEDURE GetestadisticaForASepcificDate
(@type_id INT, @cuenta_id INT, @date_value DATETIME)
AS
BEGIN
SET NOCOUNT ON
    SELECT   [estadistica_id]
            ,[estadistica_date]
            ,[tipos_id]
            ,[cuenta_id]
            ,[incomes]
            ,[expences]
            ,[time_stamp]
    FROM [FinancialDb].[dbo].[estadistica]
    WHERE [tipos_id] = @type_id AND 
        [estadistica_date] = @date_value AND 
        [cuenta_id] = @cuenta_id
END