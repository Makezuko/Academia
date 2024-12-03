CONNECT SYSTEM/123123@localhost:1521/XEPDB1

ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD HH24:MI:SS';


CREATE TABLE alunos (
    CPF VARCHAR2(11) PRIMARY KEY,
    nome VARCHAR2(50) NOT NULL,
    email VARCHAR2(50) NOT NULL UNIQUE,
    senha VARCHAR2(100) NOT NULL,
    telefone VARCHAR2(20) NOT NULL,
    plano VARCHAR2(20) NOT NULL
);

CREATE TABLE frequencia (
    ID_frequencia NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    CPF_aluno VARCHAR2(11) NOT NULL,
    data_entrada DATE NOT NULL,
    hora_entrada TIMESTAMP NOT NULL,
    hora_saida TIMESTAMP,
    CONSTRAINT FK_Aluno_Frequencia FOREIGN KEY (CPF_aluno) 
    REFERENCES alunos(CPF) 
    ON DELETE CASCADE
);

CREATE TABLE relatorio (
    ID_relatorio NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    CPF_aluno VARCHAR2(11) NOT NULL,
    data_referencia DATE NOT NULL,
    total_horas NUMBER(5, 2) DEFAULT 0,
    classificacao VARCHAR2(50),
    CONSTRAINT FK_Aluno_Relatorio FOREIGN KEY (CPF_aluno) 
    REFERENCES alunos(CPF) 
    ON DELETE CASCADE
);

CREATE TABLE administradores (
    ID_admin NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    nome VARCHAR2(50),
    email VARCHAR2(50) UNIQUE,
    senha VARCHAR2(100)
);

INSERT INTO frequencia (CPF_aluno, data_entrada, hora_entrada, hora_saida)
VALUES (
    '23951425814',                         
    TO_DATE('20-11-2024', 'DD-MM-YYYY'),      
    TO_TIMESTAMP('20-11-2024 09:00:00', 'DD-MM-YYYY HH24:MI:SS'),  
    TO_TIMESTAMP('20-11-2024 16:30:00', 'DD-MM-YYYY HH24:MI:SS')   
);

INSERT INTO frequencia (CPF_aluno, data_entrada, hora_entrada, hora_saida)
VALUES (
    '23951425814',
    TO_DATE('19-11-2024', 'DD-MM-YYYY'),
    TO_TIMESTAMP('19-11-2024 07:45:00', 'DD-MM-YYYY HH24:MI:SS'),
    TO_TIMESTAMP('19-11-2024 18:15:00', 'DD-MM-YYYY HH24:MI:SS')
);

SELECT
            a.nome AS nome_aluno,
            COUNT(f.ID_frequencia) AS quantidade_visitas,
            SUM(
              CASE
                  WHEN f.hora_saida IS NOT NULL AND f.hora_entrada IS NOT NULL THEN
                      EXTRACT(HOUR FROM (f.hora_saida - f.hora_entrada)) 
                      + EXTRACT(MINUTE FROM (f.hora_saida - f.hora_entrada)) / 60
                  ELSE
                      0
              END
            ) AS tempo_total
        FROM
            frequencia f
        JOIN
            alunos a ON TRIM(f.CPF_aluno) = TRIM(a.cpf)
        WHERE
            TRIM(f.CPF_aluno) = :cpfAluno  
            AND f.data_entrada >= TO_TIMESTAMP(:startDate, 'YYYY-MM-DD HH24:MI:SS')
            AND f.data_entrada < TO_TIMESTAMP(:endDate, 'YYYY-MM-DD HH24:MI:SS')
        GROUP BY
            a.nome;


SELECT *
FROM alunos
WHERE TRIM(cpf) = :cpfAluno;


SELECT cpf, nome FROM alunos;


DROP TABLE alunos;
DROP TABLE frequencia;
DROP TABLE administradores;
DROP TABLE relatorio;

SELECT * 
FROM frequencia 
WHERE CPF_aluno = '23951425814' 
AND data_entrada >= TO_TIMESTAMP('2023-12-31 00:00:00', 'YYYY-MM-DD HH24:MI:SS')
AND data_entrada <= TO_TIMESTAMP('2023-12-31 23:59:59', 'YYYY-MM-DD HH24:MI:SS');

DESC frequencia;
