--IMPLEMENTE UM GATILHO (TRIGGER) QUE ATUALIZE A TABELA CONTA, PARA O CAMPO SALDO_CONTA, 
--SEMPRE QUE UMA NOVA LINHA FOR INSERIDA NA TABELA DE DEPÓSITO OU EMPRÉSTIMO.


CREATE OR REPLACE FUNCTION Atualizar_Conta()
	RETURNS trigger AS
$BODY$
DECLARE
	l_nome_cliente character varying;
	l_nome_agencia character varying;
	l_numero_conta integer;
	l_numero_emprestimo integer;
	l_numero_deposito integer;
	l_saldo_deposito integer;
	l_valor_emprestimo integer;
	l_saldo_conta integer;	
	l_i_deposito integer = 0;
	l_i_emprestimo integer = 0;
	l_count integer;
	
	cursor_deposito CURSOR FOR  
	
		SELECT	D.NUMERO_DEPOSITO, C.NOME_CLIENTE, C.NOME_AGENCIA, C.NUMERO_CONTA, D.SALDO_DEPOSITO
		FROM CONTA AS C NATURAL FULL JOIN (EMPRESTIMO AS E NATURAL FULL JOIN DEPOSITO AS D)
		GROUP BY D.NUMERO_DEPOSITO, C.NOME_CLIENTE, C.NOME_AGENCIA, C.NUMERO_CONTA, D.SALDO_DEPOSITO;
		
	cursor_emprestimo CURSOR FOR  
	
		SELECT	E.NUMERO_EMPRESTIMO, C.NOME_CLIENTE, C.NOME_AGENCIA, C.NUMERO_CONTA, E.VALOR_EMPRESTIMO
		FROM CONTA AS C NATURAL FULL JOIN (EMPRESTIMO AS E NATURAL FULL JOIN DEPOSITO AS D)
		GROUP BY  E.NUMERO_EMPRESTIMO, C.NOME_CLIENTE, C.NOME_AGENCIA, C.NUMERO_CONTA, E.VALOR_EMPRESTIMO;
BEGIN
	OPEN cursor_deposito;
		LOOP
			FETCH cursor_deposito INTO l_numero_deposito, l_nome_cliente, l_nome_agencia, l_numero_conta, l_saldo_deposito;
			IF FOUND THEN
			
				IF l_i_deposito = 0 THEN

					UPDATE CONTA SET saldo_conta = 0;
					
					l_i_deposito = 1;

				ELSE
				
					UPDATE CONTA SET saldo_conta = saldo_conta + l_saldo_deposito
					WHERE NOME_CLIENTE = l_nome_cliente
					AND   NOME_AGENCIA = l_nome_agencia
					AND   NUMERO_CONTA = l_numero_conta;
									
				END IF;
				
			END IF;
			
			IF not FOUND THEN EXIT;
			END IF;
		END LOOP;
   CLOSE cursor_deposito;
   
   OPEN cursor_emprestimo;
		LOOP
			FETCH cursor_emprestimo INTO l_numero_emprestimo, l_nome_cliente, l_nome_agencia, l_numero_conta, l_valor_emprestimo;
			IF FOUND THEN
			
				IF l_i_deposito = 0 THEN

					UPDATE CONTA SET saldo_conta = 0;
					
					l_i_deposito = 1;

				ELSE
				
					UPDATE CONTA SET saldo_conta = saldo_conta - l_valor_emprestimo
					WHERE NOME_CLIENTE = l_nome_cliente
					AND   NOME_AGENCIA = l_nome_agencia
					AND   NUMERO_CONTA = l_numero_conta;
									
				END IF;
				
			END IF;
			
			IF not FOUND THEN EXIT;
			END IF;
		END LOOP;
   CLOSE cursor_emprestimo;
   RETURN NULL;
END
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION Atualizar_Conta()
OWNER TO aluno;
  
CREATE TRIGGER TRIGGER_Atualizar_Conta
AFTER INSERT ON DEPOSITO
FOR EACH STATEMENT EXECUTE PROCEDURE Atualizar_Conta();

CREATE TRIGGER TRIGGER_Atualizar_Conta
AFTER INSERT ON EMPRESTIMO
FOR EACH STATEMENT EXECUTE PROCEDURE Atualizar_Conta();
  
SELECT * FROM DEPOSITO
WHERE numero_conta=44009;

INSERT INTO deposito VALUES(187956758, 44009, 'PUC', 'Reinaldo Pereira da Silva', 10);

SELECT * FROM EMPRESTIMO
WHERE numero_conta=44009;

INSERT INTO emprestimo VALUES(987899, 'Reinaldo Pereira da Silva', 44009, 'PUC', 10, 0, '01/01/2021');

SELECT * FROM CONTA
WHERE numero_conta=44009;
						
							
							
							
							
							
							
							
							
							
							
							
							
							
							
							
							
							
							
							
							
							
							
							
							
							
							
							
							
							
							
							
							
							
							
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
							  
							  
							  
							  
							  
							  
							  
							  
							  
							  
							  
							  



			

