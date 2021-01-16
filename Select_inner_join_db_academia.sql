--QUANTOS MESES ESTÁ MATRICULADO NA ATIVIDADE
SELECT 
A.nome_aluno,
ATV.nome_atividade,
T.data_inicio,
DATEDIFF(MONTH, T.data_inicio , GETDATE()) AS 'MÊS(ES) MATRICULADO NESSA ATIVIDADE'
FROM aluno AS A
INNER JOIN aluno_turma AT
ON A.cd_matricula = AT.cd_matricula
INNER JOIN turma AS T
ON T.cd_turma = AT.cd_turma
INNER JOIN atividade AS ATV
ON ATV.cd_atividade = T.cd_atividade



--SABER A IDADE MEDIA DOS ALUNOS NAS ATIVIDADES MATRICULADAS. 
SELECT 
A.nome_aluno,
ATV.nome_atividade,
DATEDIFF(YEAR, A.dt_nascimento , GETDATE()) AS 'IDADE DO ALUNO'
FROM aluno AS A
INNER JOIN aluno_turma AT
ON A.cd_matricula = AT.cd_matricula
INNER JOIN turma AS T
ON T.cd_turma = AT.cd_turma
INNER JOIN atividade AS ATV
ON ATV.cd_atividade = T.cd_atividade


--SABER QUAIS DIAS O ALUNO FREQUENTOU A ATIVIDADE
SELECT
A.nome_aluno,
F.data_chamada,
DATENAME (WEEKDAY, F.data_chamada) DIA_DA_SEMANA,
ATV.nome_atividade
FROM ALUNO AS A
INNER JOIN aluno_turma AS AT
ON A.cd_matricula = AT.cd_matricula
INNER JOIN frequencia AS F
ON AT.cd_matricula = F.cd_turma_aluno
INNER JOIN atividade AS ATV
ON ATV.cd_atividade = AT.cd_turma
WHERE presenca = 1