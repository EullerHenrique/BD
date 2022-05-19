-- Euller Henrique Bandeira Oliveira - 11821BSI210

-- Utilizando-se do conteúdo triggers, implemente a atualização do campo ativo_agencia,
-- da tabela agencia, para o caso de inserções, remoções ou atualizações das tabelas "deposito"
-- e/ou "emprestimo"

CREATE OR REPLACE FUNCTION Atualizar_Ativo()
	RETURNS trigger AS
$BODY$
DECLARE
	v_nome_agencia character varying;
	v_ativo_agencia float;
	cursor_conta CURSOR FOR
	
	SELECT relatorio.nome_agencia, SUM(relatorio.soma)
	FROM 
	(		
		SELECT nome_agencia, COALESCE(SUM(saldo_deposito),0) AS soma
		FROM deposito 
		GROUP BY nome_agencia
		
			UNION
		
		SELECT nome_agencia, -1 * COALESCE(SUM(valor_emprestimo),0) AS soma
		FROM emprestimo 
		GROUP BY nome_agencia
		
	) AS relatorio
	GROUP BY relatorio.nome_agencia;
	
BEGIN
	OPEN cursor_conta;
	
		LOOP
			FETCH cursor_conta INTO v_nome_agencia, v_ativo_agencia;
			
			IF FOUND THEN
			
				IF v_ativo_agencia IS NULL THEN v_ativo_agencia = 0; 
				END IF;
			
				UPDATE agencia SET ativo_agencia = v_ativo_agencia
				WHERE nome_agencia = v_nome_agencia; 
			
			END IF;
			
			IF not FOUND THEN EXIT;
			END IF;
		
		END LOOP;
   
   CLOSE cursor_conta;
   RETURN NULL;
END
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION Atualizar_Ativo()
OWNER TO aluno;

UPDATE AGENCIA SET ativo_agencia = 0;
  
CREATE TRIGGER TRIGGER_Atualizar_Ativo
AFTER INSERT OR DELETE OR UPDATE ON DEPOSITO
FOR EACH STATEMENT EXECUTE PROCEDURE Atualizar_Ativo();

CREATE TRIGGER TRIGGER_Atualizar_Ativo_After_Insert
AFTER INSERT OR DELETE OR UPDATE ON EMPRESTIMO
FOR EACH STATEMENT EXECUTE PROCEDURE Atualizar_Ativo();
  
SELECT * FROM AGENCIA;
SELECT * FROM DEPOSITO
WHERE numero_conta = 44009;

INSERT INTO DEPOSITO VALUES(187956757, 44009, 'PUC', 'Reinaldo Pereira da Silva', 10);
UPDATE DEPOSITO SET saldo_deposito = saldo_deposito + 100 WHERE numero_conta = 44009;
DELETE FROM DEPOSITO WHERE numero_conta = 44009;

SELECT * FROM AGENCIA;
SELECT * FROM EMPRESTIMO
WHERE numero_conta = 44009;

INSERT INTO EMPRESTIMO VALUES(987899, 'Reinaldo Pereira da Silva', 44009, 'PUC', 10, 0, '01/01/2021');
UPDATE EMPRESTIMO SET valor_emprestimo = valor_emprestimo + 100 WHERE numero_conta = 44009;
DELETE FROM EMPRESTIMO WHERE numero_conta = 44009;
				
							
							
							
							
							
							
							
							
							
							
							
							
							
							
							
							
							
							
							
							
							
							
							
							
							
							
							
							
							
							
							
							
							
							
SELECT nome_cliente, nome_agencia, numero_conta, SUM(D.SALDO_DEPOSITO) AS SALDO_CONTA, SUM(E.VALOR_EMPRESTIMO) AS VALOR_EMPRESTIMO
FROM CONTA AS C NATURAL FULL JOIN
(EMPRESTIMO AS E NATURAL FULL JOIN DEPOSITO AS D)
WHERE numero_conta = 44009
GROUP BY nome_cliente, nome_agencia, numero_conta;

SELECT D.numero_deposito, E.numero_emprestimo, C.NOME_CLIENTE, C.NOME_AGENCIA, C.NUMERO_CONTA,  D.SALDO_DEPOSITO, E.VALOR_EMPRESTIMO, SUM(D.SALDO_DEPOSITO) AS SALDO_CONTA, SUM(E.VALOR_EMPRESTIMO) AS VALOR_EMPRESTIMO,
COALESCE(SUM(D.SALDO_DEPOSITO),0) - COALESCE(SUM(E.VALOR_EMPRESTIMO),0) AS TOTAL
FROM CONTA AS C NATURAL FULL JOIN (EMPRESTIMO AS E NATURAL FULL JOIN DEPOSITO AS D)
WHERE numero_conta = 44009
GROUP BY  D.numero_deposito, E.numero_emprestimo, C.NOME_CLIENTE, C.NOME_AGENCIA, C.NUMERO_CONTA, D.SALDO_DEPOSITO,  E.VALOR_EMPRESTIMO;
		
SELECT SUM(saldo_deposito) FROM DEPOSITO
WHERE numero_conta = 44009;

SELECT SUM(valor_emprestimo) FROM EMPRESTIMO
WHERE numero_conta = 44009;

SELECT * FROM EMPRESTIMO
WHERE nome_cliente = 'Reinaldo Pereira da Silva';

							  
	
	
SELECT	NOME_CLIENTE, NOME_AGENCIA, NUMERO_CONTA, D.SALDO_DEPOSITO,  E.VALOR_EMPRESTIMO
FROM DEPOSITO AS D NATURAL FULL JOIN EMPRESTIMO AS E
WHERE numero_conta = 44009 	
							  
							  
							  
							  
							  
							  
							  
							  
							  
							  
							  
							  



			

