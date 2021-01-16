--FUNÇÃO QUE CALCULA O IMC
CREATE FUNCTION uFN_IMC 
(@ALTURA REAL, @PESO REAL)
RETURNS VARCHAR(20)
AS
BEGIN
	DECLARE @IMC REAL
	DECLARE @RESULT VARCHAR(20)
	SELECT @IMC = (@peso / (@altura*@altura))
	IF @IMC <= 18.49 
	SET @RESULT = 'Abaixo do peso'	
	ELSE IF @IMC >= 18.5 AND @IMC <= 24.9
	SET @RESULT = 'Peso normal'
	ELSE IF @IMC >= 25 AND @IMC <= 29.9
	SET @RESULT = 'Peso sobrepeso'
	ELSE IF @IMC >= 30 AND @IMC <= 34.9
	SET @RESULT = 'Obesidade grau 1'
	ELSE IF @IMC >= 35 AND @IMC <= 39.9
	SET @RESULT = 'Obesidade grau 2'
	ELSE IF @IMC >= 40
	SET @RESULT = 'Obesidade grau 3'
	RETURN @RESULT
END

--FAZ UM SELECT NA TABELA DE ALUNO MOSTRANDO ALTURA, PESO E O IMC
SELECT [nome_aluno] as Nome_do_aluno, [altura], [peso], [dbo].[uFN_IMC]([altura], [peso]) as IMC
FROM [dbo].[aluno]
--SE QUISER FILTRAR PELO RESULTADO DO IMC
WHERE [dbo].[uFN_IMC]([altura], [peso]) = 'Obesidade grau 2'
--SE QUISER FILTRAR POR NOME
WHERE [nome_aluno] = 'Isadora Ribeiro'
