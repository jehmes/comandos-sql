-- Criação das tabelas do projeto (apenas entidades)
CREATE DATABASE DB_ACADEMIA

CREATE TABLE aluno(
  cd_matricula INT PRIMARY KEY IDENTITY,
  nome_aluno VARCHAR(50) NOT NULL,
  telefone_aluno CHAR(12),
  dt_nascimento DATE,
  logradouro VARCHAR(50) NOT NULL,
  numero_logradouro CHAR(5),
  bairro VARCHAR(30) NOT NULL,
  cidade VARCHAR(30) NOT NULL,
  cep  CHAR(10),
  dt_matricula DATE NOT NULL CONSTRAINT aluno_default_dt_matricula DEFAULT (GETDATE()),
  altura FLOAT(24),
  peso FLOAT(24),
  senha VARCHAR(32) NOT NULL
)

CREATE TABLE atividade(
  cd_atividade INT PRIMARY KEY IDENTITY,
  nome_atividade VARCHAR(20) NOT NULL,
  descricao_atividade VARCHAR(500),
  custo_hora SMALLMONEY NOT NULL CONSTRAINT atividade_custo_positivo CHECK (custo_hora > 0)
)

CREATE TABLE instrutor(
  cd_instrutor INT PRIMARY KEY IDENTITY,
  rg VARCHAR(10) NOT NULL UNIQUE,
  nome_instrutor VARCHAR(50) NOT NULL,
  dt_nascimento DATE NOT NULL,
  titulacao VARCHAR(20),
  salario SMALLMONEY NOT NULL CONSTRAINT instrutor_salario_positivo CHECK (salario > 0)
)

CREATE TABLE turma(
  cd_turma INT PRIMARY KEY IDENTITY,
  data_inicio DATE NOT NULL CONSTRAINT turma_default_data_inicio DEFAULT (GETDATE()),
  data_fim DATE,
  horario_aula TIME NOT NULL,
  qtd_aluno TINYINT NOT NULL CONSTRAINT turma_qtd_aluno_positivo CHECK (qtd_aluno > 0),
  cd_instrutor INT FOREIGN KEY REFERENCES instrutor(cd_instrutor),
  cd_atividade INT NOT NULL FOREIGN KEY REFERENCES atividade(cd_atividade),
  cd_matricula_monitor INT FOREIGN KEY REFERENCES aluno(cd_matricula)
)

CREATE TABLE aluno_turma(
  cd_turma_aluno INT PRIMARY KEY IDENTITY,
  cd_matricula INT NOT NULL FOREIGN KEY REFERENCES aluno(cd_matricula) ,
  cd_turma INT NOT NULL FOREIGN KEY REFERENCES turma(cd_turma)
)

CREATE TABLE telefone_instrutor(
  cd_telefone INT PRIMARY KEY IDENTITY,
  ddd CHAR(3),
  numero_telefone CHAR(9) NOT NULL UNIQUE,
  descricao_telefone VARCHAR(50),
  cd_instrutor INT NOT NULL FOREIGN KEY REFERENCES instrutor(cd_instrutor)
)

CREATE TABLE frequencia(
  cd_frequencia INT PRIMARY KEY IDENTITY,
  data_chamada DATE NOT NULL CONSTRAINT frequencia_default_data_chamada DEFAULT (GETDATE()),
  presenca BIT NOT NULL,
  feedback_aluno INT,
  cd_turma_aluno INT NOT NULL FOREIGN KEY REFERENCES aluno_turma(cd_turma_aluno)
)

CREATE TABLE plano(
  cd_plano INT PRIMARY KEY IDENTITY,
  tipo_plano VARCHAR(15) NOT NULL CONSTRAINT check_tipo_plano CHECK (tipo_plano IN ('B', 'P', 'O')),
  valor_plano SMALLMONEY NOT NULL CONSTRAINT check_valor_plano CHECK (valor_plano > 0),
  qtd_atividades_disponiveis INT NOT NULL CONSTRAINT check_qtd_atividade_disponiveis CHECK (qtd_atividades_disponiveis > 0)

)

CREATE TABLE contrato(
  cd_contrato INT PRIMARY KEY IDENTITY,
  data_inicial DATE NOT NULL CONSTRAINT contrato_default_data_inicial DEFAULT (GETDATE()),
  data_final DATE,
  scan_contrato_inicial VARBINARY(MAX),
  scan_recisao VARBINARY(MAX),
  tipo_contrato VARCHAR (10) NOT NULL CONSTRAINT contrato_check_tipo CHECK (tipo_contrato IN('M', 'T','S','A')),
  status_contrato BIT NOT NULL,
  valor_acordado SMALLMONEY NOT NULL CONSTRAINT contrato_valor_acordado_positivo CHECK (valor_acordado > 0),
  qtd_atividade_acordadas TINYINT NOT NULL constraint contrato_qtd_atividades_acordadas_positivo CHECK (qtd_atividade_acordadas > 0),
  cd_matricula INT NOT NULL FOREIGN KEY REFERENCES aluno(cd_matricula),
  cd_plano INT NOT NULL FOREIGN KEY REFERENCES plano(cd_plano)
)

CREATE TABLE pagamento (
  cd_pagamento INT PRIMARY KEY IDENTITY,
  metodo_pagamento VARCHAR(20) NOT NULL,
  confimacao_pagamento VARBINARY(MAX) NOT NULL,
  data_pagamento DATE NOT NULL CONSTRAINT pegamento_default_data_pagamento DEFAULT (GETDATE()),
  valor_pagamento SMALLMONEY NOT NULL
 )

 CREATE TABLE boleto (
  cod_barras VARCHAR (100) NOT NULL,
  cd_pagamento INT NOT NULL PRIMARY KEY FOREIGN KEY REFERENCES pagamento (cd_pagamento)
 )

 CREATE TABLE cartao (
  bandeira VARCHAR (20) NOT NULL,
  nome_pessoa VARCHAR (30) NOT NULL,
  numero_cartao VARCHAR (16) NOT NULL,
  cd_pagamento INT NOT NULL PRIMARY KEY FOREIGN KEY REFERENCES pagamento(cd_pagamento)
 )
 
 CREATE TABLE contrato_pagamento (
  cd_contrato INT NOT NULL FOREIGN KEY REFERENCES contrato(cd_contrato),
  cd_pagamento INT NOT NULL FOREIGN KEY REFERENCES pagamento(cd_pagamento)
)
--Inserir dados no banco

INSERT INTO aluno(nome_aluno, telefone_aluno, dt_nascimento, logradouro, numero_logradouro, bairro, cidade, cep, dt_matricula, altura, peso, senha)
VALUES ('Felipe Jose Arantes', '81999556333', convert(datetime, '18/04/1997',103), 'Av. João Cardoso Pinheiro', '555', 'Aparato Dois', 'Recife', '55440002', convert(datetime, '01/09/2020', 103), 1.80, 92.00, '123456'),
	('Rafael Brandao Primo', '81999556335', convert(datetime,'25/10/1985',103), 'Rua Jose Bento Rafael', '5563', 'Piedade', 'Jaboatown', '66552337', convert(datetime, '01/09/2020', 103), 1.75, 80.65, '123456'),
	('Maria Dornelas Ribeiro', '81999558333', convert(datetime,'05/06/1989',103), 'Av. Esse Projeto É Bom Demais', '622', 'Padeiro Gordo', 'Petrópolis', '665223339', convert(datetime, '01/09/2020', 103), 1.62, 66.00, '123456'),
	('Rebhecca Almeida Souza', '81989556333', convert(datetime,'12/08/1996',103), 'Rua Professor Rabino Cético', '123', 'São Jesué', 'Megalopole', '50002336', convert(datetime, '01/09/2020', 103), 1.65, 58.63, '123456')

INSERT INTO instrutor(rg, nome_instrutor, dt_nascimento, titulacao, salario)
VALUES ('10256583', 'Luiz Claudio Farelos', convert(datetime, '12/04/1993',103), 'Bacharel', 1859.50),
	('20256588', 'Jose Freitas de Brotas', convert(datetime, '05/06/1990',103), 'Certificado', 2150.85),
	('10285586', 'Maria Eduarda Finessi', convert(datetime, '17/08/1988',103), 'Bacharel', 2050.60),
	('10256542', 'Luiza Souza de Almeida', convert(datetime,'27/02/1991',103), 'Tecnólogo', 1754.30)
	
INSERT INTO atividade(nome_atividade, descricao_atividade, custo_hora)
VALUES ('Dança Jazz', 'Aula de Dança em Ritmo de Jazz', 15.80),
	('Boxe', '', 21.50),
	('Musculação', 'Treino com maquinas de hipertrofia e emagrecimento', 5.70),
	('HIIT', 'Treino focado em cardio e resistência física', 4.80)
	
INSERT INTO turma(data_inicio, data_fim, horario_aula, qtd_aluno, cd_instrutor, cd_atividade, cd_matricula_monitor)
VALUES (convert(datetime,'01/09/2020',103), NULL, '18:30:00', 30, 3, 1, 3),
	   (convert(datetime,'01/09/2020',103), NULL, '21:50:00', 20, 4, 2, 1),
	   (convert(datetime,'01/09/2020',103), NULL, '12:30:00', 150, 1, 3, 2),
	   (convert(datetime,'01/09/2020',103), NULL, '14:30:00', 20, 2, 4, 4)
	
INSERT INTO telefone_instrutor(ddd, numero_telefone, descricao_telefone, cd_instrutor)
VALUES ('81', '985663236', 'Número pessoal', 1),
	   ('81', '985666536', 'Número da esposa', 1),
	   ('81', '33669852', 'Número residencial pessoal', 2),
	   ('81', '985663268', 'Número pessoal', 2),
	   ('81', '985723236', 'Número do pai', 3),
	   ('81', '981663236', 'Número pessoal', 3),
	   ('81', '985663452', 'Número da prima', 4),
	   ('81', '33445698', 'Número residencial pessoal', 4)
	
INSERT INTO plano(tipo_plano, valor_plano, qtd_atividades_disponiveis)
VALUES ('B', 100, 2),
	   ('P', 200, 4),
	   ('O', 300, 6)

INSERT INTO contrato(data_inicial, tipo_contrato, cd_matricula, cd_plano, status_contrato, qtd_atividade_acordadas, valor_acordado)
VALUES (convert(datetime,'01/09/2020',103), 'A', 1, 1, 1, 2, 100),
	   (convert(datetime,'01/09/2020',103), 'T', 2, 2, 1, 4, 200),
	   (convert(datetime,'01/09/2020',103), 'S', 3, 3, 1, 7, 285),
	   (convert(datetime,'01/09/2020',103), 'M', 4, 2, 1, 4, 200)
	
INSERT INTO aluno_turma(cd_matricula, cd_turma)
VALUES (1, 2),
	   (1, 3),
	   (2, 2),
	   (2, 3),
	   (3, 1),
	   (3, 4),
	   (4, 4),
	   (4, 1)

INSERT INTO pagamento (metodo_pagamento, confimacao_pagamento, data_pagamento, valor_pagamento)
VALUES ('CARTAO', CAST('lorem ipsum' AS varbinary), CONVERT(DATETIME, '01/09/2020', 103), 50),
       ('BOLETO', CAST('lorem ipsum' AS varbinary), CONVERT(DATETIME, '01/09/2020', 103), 100),
       ('CARTAO', CAST('lorem ipsum' AS varbinary), CONVERT(DATETIME, '01/09/2020', 103), 285),
       ('BOLETO', CAST('lorem ipsum' AS varbinary), CONVERT(DATETIME, '01/09/2020', 103), 200)

INSERT INTO cartao (cd_pagamento, nome_pessoa, numero_cartao, bandeira)
VALUES (1, 'FELIPE J ARANTES', '1234567845615984', 'MASTER'),
       (3, 'MARIA D RIBEIRO', '1233214598542168', 'VISA')

INSERT INTO boleto (cd_pagamento, cod_barras)
VALUES (2, '03121866480054851821'),
       (4, '07897512134841582893')

INSERT INTO contrato_pagamento (cd_contrato, cd_pagamento)
VALUES (1,1),
       (2,2),
       (3,3),
       (4,4)
	   
INSERT INTO frequencia(data_chamada, presenca, feedback_aluno, cd_turma_aluno)
VALUES ('2020-09-01', 1, 4, 1),
	('2020-09-02', 0, 5, 1),
	('2020-09-03', 1, 4, 1),
	('2020-09-04', 1, 1, 1),
	('2020-09-05', 0, 1, 1),
	('2020-09-06', 1, 2, 1),
	('2020-09-07', 1, 4, 1),
	('2020-09-08', 1, 4, 1),
	('2020-09-09', 0, 4, 1),
	('2020-09-10', 1, 3, 1),
	('2020-09-11', 0, 3, 1),
	('2020-09-12', 0, 5, 1),
	('2020-09-13', 0, 5, 1),
	('2020-09-14', 1, 5, 1),
	('2020-09-15', 1, 1, 1),
	('2020-09-16', 0, 3, 1),
	('2020-09-17', 1, 3, 1),
	('2020-09-18', 1, 2, 1),
	('2020-09-19', 1, 4, 1),
	('2020-09-20', 0, 1, 1),
	('2020-09-21', 1, 4, 1),
	('2020-09-22', 0, 2, 1),
	('2020-09-23', 1, 1, 1),
	('2020-09-24', 1, 5, 1),
	('2020-09-25', 1, 5, 1),
	('2020-09-26', 1, 2, 1),
	('2020-09-27', 1, 4, 1),
	('2020-09-28', 0, 3, 1),
	('2020-09-29', 0, 4, 1),
	('2020-09-30', 0, 4, 1),
	('2020-09-01', 1, 2, 2),
	('2020-09-02', 0, 4, 2),
	('2020-09-03', 0, 4, 2),
	('2020-09-04', 0, 1, 2),
	('2020-09-05', 1, 2, 2),
	('2020-09-06', 1, 5, 2),
	('2020-09-07', 1, 4, 2),
	('2020-09-08', 0, 4, 2),
	('2020-09-09', 1, 5, 2),
	('2020-09-10', 1, 3, 2),
	('2020-09-11', 0, 5, 2),
	('2020-09-12', 1, 4, 2),
	('2020-09-13', 1, 1, 2),
	('2020-09-14', 1, 1, 2),
	('2020-09-15', 0, 1, 2),
	('2020-09-16', 1, 5, 2),
	('2020-09-17', 0, 1, 2),
	('2020-09-18', 1, 2, 2),
	('2020-09-19', 1, 4, 2),
	('2020-09-20', 0, 5, 2),
	('2020-09-21', 1, 1, 2),
	('2020-09-22', 1, 2, 2),
	('2020-09-23', 1, 4, 2),
	('2020-09-24', 0, 4, 2),
	('2020-09-25', 0, 2, 2),
	('2020-09-26', 1, 2, 2),
	('2020-09-27', 1, 1, 2),
	('2020-09-28', 0, 4, 2),
	('2020-09-29', 1, 4, 2),
	('2020-09-30', 0, 5, 2),
	('2020-09-01', 1, 1, 3),
	('2020-09-02', 0, 2, 3),
	('2020-09-03', 1, 1, 3),
	('2020-09-04', 0, 4, 3),
	('2020-09-05', 1, 3, 3),
	('2020-09-06', 1, 1, 3),
	('2020-09-07', 0, 1, 3),
	('2020-09-08', 1, 1, 3),
	('2020-09-09', 1, 4, 3),
	('2020-09-10', 1, 5, 3),
	('2020-09-11', 0, 1, 3),
	('2020-09-12', 1, 4, 3),
	('2020-09-13', 1, 3, 3),
	('2020-09-14', 1, 3, 3),
	('2020-09-15', 0, 4, 3),
	('2020-09-16', 0, 5, 3),
	('2020-09-17', 1, 2, 3),
	('2020-09-18', 1, 5, 3),
	('2020-09-19', 1, 3, 3),
	('2020-09-20', 0, 5, 3),
	('2020-09-21', 1, 5, 3),
	('2020-09-22', 0, 1, 3),
	('2020-09-23', 0, 5, 3),
	('2020-09-24', 1, 4, 3),
	('2020-09-25', 1, 5, 3),
	('2020-09-26', 1, 1, 3),
	('2020-09-27', 1, 2, 3),
	('2020-09-28', 1, 1, 3),
	('2020-09-29', 1, 3, 3),
	('2020-09-30', 1, 4, 3),
	('2020-09-01', 0, 2, 4),
	('2020-09-02', 0, 3, 4),
	('2020-09-03', 0, 1, 4),
	('2020-09-04', 1, 1, 4),
	('2020-09-05', 1, 4, 4),
	('2020-09-06', 0, 4, 4),
	('2020-09-07', 0, 3, 4),
	('2020-09-08', 1, 2, 4),
	('2020-09-09', 0, 3, 4),
	('2020-09-10', 0, 5, 4),
	('2020-09-11', 1, 3, 4),
	('2020-09-12', 0, 1, 4),
	('2020-09-13', 1, 5, 4),
	('2020-09-14', 1, 5, 4),
	('2020-09-15', 1, 5, 4),
	('2020-09-16', 1, 2, 4),
	('2020-09-17', 0, 4, 4),
	('2020-09-18', 0, 1, 4),
	('2020-09-19', 1, 5, 4),
	('2020-09-20', 0, 1, 4),
	('2020-09-21', 0, 2, 4),
	('2020-09-22', 0, 2, 4),
	('2020-09-23', 1, 3, 4),
	('2020-09-24', 1, 1, 4),
	('2020-09-25', 0, 2, 4),
	('2020-09-26', 0, 1, 4),
	('2020-09-27', 0, 4, 4),
	('2020-09-28', 0, 5, 4),
	('2020-09-29', 0, 4, 4),
	('2020-09-30', 1, 2, 4),
	('2020-09-01', 0, 1, 5),
	('2020-09-02', 1, 4, 5),
	('2020-09-03', 1, 4, 5),
	('2020-09-04', 1, 3, 5),
	('2020-09-05', 1, 5, 5),
	('2020-09-06', 1, 1, 5),
	('2020-09-07', 0, 5, 5),
	('2020-09-08', 1, 1, 5),
	('2020-09-09', 1, 3, 5),
	('2020-09-10', 1, 1, 5),
	('2020-09-11', 1, 2, 5),
	('2020-09-12', 1, 5, 5),
	('2020-09-13', 0, 4, 5),
	('2020-09-14', 1, 4, 5),
	('2020-09-15', 0, 3, 5),
	('2020-09-16', 1, 5, 5),
	('2020-09-17', 1, 2, 5),
	('2020-09-18', 1, 4, 5),
	('2020-09-19', 0, 2, 5),
	('2020-09-20', 0, 2, 5),
	('2020-09-21', 1, 2, 5),
	('2020-09-22', 1, 4, 5),
	('2020-09-23', 1, 1, 5),
	('2020-09-24', 1, 4, 5),
	('2020-09-25', 1, 2, 5),
	('2020-09-26', 0, 4, 5),
	('2020-09-27', 0, 3, 5),
	('2020-09-28', 0, 2, 5),
	('2020-09-29', 1, 5, 5),
	('2020-09-30', 1, 4, 5),
	('2020-09-01', 1, 1, 6),
	('2020-09-02', 0, 2, 6),
	('2020-09-03', 1, 3, 6),
	('2020-09-04', 0, 3, 6),
	('2020-09-05', 1, 1, 6),
	('2020-09-06', 0, 4, 6),
	('2020-09-07', 0, 2, 6),
	('2020-09-08', 0, 1, 6),
	('2020-09-09', 1, 5, 6),
	('2020-09-10', 0, 5, 6),
	('2020-09-11', 0, 1, 6),
	('2020-09-12', 0, 3, 6),
	('2020-09-13', 1, 3, 6),
	('2020-09-14', 1, 1, 6),
	('2020-09-15', 0, 5, 6),
	('2020-09-16', 1, 1, 6),
	('2020-09-17', 0, 1, 6),
	('2020-09-18', 0, 4, 6),
	('2020-09-19', 0, 4, 6),
	('2020-09-20', 0, 5, 6),
	('2020-09-21', 0, 5, 6),
	('2020-09-22', 1, 2, 6),
	('2020-09-23', 0, 3, 6),
	('2020-09-24', 0, 5, 6),
	('2020-09-25', 1, 3, 6),
	('2020-09-26', 0, 5, 6),
	('2020-09-27', 1, 4, 6),
	('2020-09-28', 1, 5, 6),
	('2020-09-29', 0, 5, 6),
	('2020-09-30', 0, 1, 6),
	('2020-09-01', 1, 2, 7),
	('2020-09-02', 0, 4, 7),
	('2020-09-03', 0, 5, 7),
	('2020-09-04', 1, 2, 7),
	('2020-09-05', 0, 4, 7),
	('2020-09-06', 1, 4, 7),
	('2020-09-07', 1, 3, 7),
	('2020-09-08', 1, 4, 7),
	('2020-09-09', 1, 4, 7),
	('2020-09-10', 0, 3, 7),
	('2020-09-11', 1, 3, 7),
	('2020-09-12', 0, 4, 7),
	('2020-09-13', 1, 5, 7),
	('2020-09-14', 0, 2, 7),
	('2020-09-15', 1, 1, 7),
	('2020-09-16', 0, 4, 7),
	('2020-09-17', 0, 2, 7),
	('2020-09-18', 0, 4, 7),
	('2020-09-19', 0, 3, 7),
	('2020-09-20', 0, 5, 7),
	('2020-09-21', 0, 1, 7),
	('2020-09-22', 1, 3, 7),
	('2020-09-23', 0, 1, 7),
	('2020-09-24', 1, 2, 7),
	('2020-09-25', 0, 5, 7),
	('2020-09-26', 0, 3, 7),
	('2020-09-27', 1, 1, 7),
	('2020-09-28', 1, 4, 7),
	('2020-09-29', 0, 2, 7),
	('2020-09-30', 1, 4, 7),
	('2020-09-01', 1, 3, 8),
	('2020-09-02', 0, 4, 8),
	('2020-09-03', 0, 4, 8),
	('2020-09-04', 1, 1, 8),
	('2020-09-05', 1, 1, 8),
	('2020-09-06', 0, 1, 8),
	('2020-09-07', 1, 2, 8),
	('2020-09-08', 0, 1, 8),
	('2020-09-09', 1, 5, 8),
	('2020-09-10', 1, 3, 8),
	('2020-09-11', 0, 1, 8),
	('2020-09-12', 1, 5, 8),
	('2020-09-13', 1, 3, 8),
	('2020-09-14', 1, 4, 8),
	('2020-09-15', 1, 5, 8),
	('2020-09-16', 1, 2, 8),
	('2020-09-17', 0, 5, 8),
	('2020-09-18', 0, 3, 8),
	('2020-09-19', 1, 2, 8),
	('2020-09-20', 1, 2, 8),
	('2020-09-21', 0, 3, 8),
	('2020-09-22', 0, 5, 8),
	('2020-09-23', 1, 4, 8),
	('2020-09-24', 0, 4, 8),
	('2020-09-25', 1, 3, 8),
	('2020-09-26', 1, 1, 8),
	('2020-09-27', 0, 1, 8),
	('2020-09-28', 0, 1, 8),
	('2020-09-29', 0, 3, 8),
	('2020-09-30', 1, 5, 8)







--PARA TESTES
INSERT INTO pagamento (metodo_pagamento, confimacao_pagamento, data_pagamento, valor_pagamento)
VALUES ('CARTAO', CAST('lorem ipsum' AS VARBINARY), CONVERT(DATETIME, '03/09/2020', 103), 100)

INSERT INTO cartao (cd_pagamento, nome_pessoa, numero_cartao, bandeira)
VALUES (5, 'RAFAEL B PRIMO', '1478123658492485', 'VISA')

INSERT INTO contrato_pagamento (cd_contrato, cd_pagamento)
VALUES (2, 5)

INSERT INTO pagamento (metodo_pagamento, confimacao_pagamento, data_pagamento, valor_pagamento)
VALUES ('BOLETO', CAST('lorem ipsum' AS VARBINARY), CONVERT(DATETIME, '08/09/2020', 103), 25)

INSERT INTO boleto (cd_pagamento, cod_barras)
VALUES (6, '15879654862300005241')

INSERT INTO contrato_pagamento (cd_contrato, cd_pagamento)
VALUES (1, 6)

UPDATE dbo.pagamento
SET dbo.pagamento.valor_pagamento = 100
WHERE dbo.pagamento.cd_pagamento = 2

UPDATE dbo.pagamento
SET dbo.pagamento.valor_pagamento = 50
WHERE dbo.pagamento.cd_pagamento = 1

INSERT INTO aluno(nome_aluno, telefone_aluno, dt_nascimento, logradouro, numero_logradouro, bairro, cidade, cep, dt_matricula, altura, peso, senha)
VALUES ('Rafael Augusto Silva', '81998856333', convert(datetime, '20/07/2000',103), 'Av. Boa Viagem', '555', 'Boa Viagem', 'Recife', '55440002', convert(datetime, '01/09/2020', 103), 1.65, 86.00, '123456')

INSERT INTO contrato(data_inicial, data_final, tipo_contrato, cd_matricula, cd_plano, status_contrato, qtd_atividade_acordadas, valor_acordado)
VALUES ((convert(datetime, '01/09/2020', 103)), (convert(datetime,'01/10/2020',103)), 'M', 5, 1, 0, 2, 100)

UPDATE contrato
SET data_inicial = CONVERT(DATETIME, '25/06/2020', 103)
WHERE cd_matricula = 5

UPDATE contrato
SET data_inicial = CONVERT(DATETIME, '18/08/2020', 103)
WHERE cd_matricula = 1 
--FIM PARA TESTES


select * from aluno

INSERT INTO aluno(nome_aluno, telefone_aluno, dt_nascimento, logradouro, numero_logradouro, bairro, cidade, cep, dt_matricula, altura, peso, senha)
VALUES ('Jehmes Thales1', '81999556333', convert(datetime, '18/04/1996',103), 'Rua Flor do Sertão', '42', 'Jordão', 'Recife', '55440002', convert(datetime, '01/09/2020', 103), 1.70, 63.00, '3342')

'Jehmes Thales', '81983541319', convert(datetime, '03/03/1996',103), 'Rua Flor do Sertão', "
					+ "'42', 'Jordão', 'Recife', '51260230',convert(datetime, '01/05/2020', 103), 1.70, 63, '3343')"