/* Euller Henrique Bandeira Oliveira - 11821BSI210 */

/* 

Construam uma função para retornar o balanço financeiro de um cliente. 
A função deve se chamar saldo_cliente. Para uma determinada conta bancária, 
a função saldo_cliente deve somar todos o saldo de depósito, somar todo o saldo de empréstimos e,por fim,
retornar a diferença entre o saldo de depósito subtraido do saldo de empréstimo de um cliente específico. 
Assim sendo, saldo_cliente recebe os dados de apenas uma conta e retorna o balanço financeiro apenas desta conta. 
O código fonte em PL/SQL deve ser entregue em formato texto (não entregue PDF ou WORD) porque preciso carregar
a função para testar o código.

*/


CREATE OR REPLACE FUNCTION saldo_cliente(p_numero_conta integer, p_nome_agencia character varying, p_nome_cliente character varying)
	RETURNS float AS
$BODY$
DECLARE
	saldo_total float;
	soma_deposito float;
	soma_emprestimo float;
	cursor_saldo_cliente CURSOR FOR 
	
		SELECT SUM(D.SALDO_DEPOSITO) AS TOTAL_DEP, SUM (E.VALOR_EMPRESTIMO) AS TOTAL_EMP
		FROM CONTA AS C NATURAL LEFT OUTER JOIN
		(EMPRESTIMO AS E NATURAL FULL JOIN DEPOSITO AS D)
		WHERE 
		C.NOME_CLIENTE=p_nome_cliente 
		AND 
		C.NOME_AGENCIA = p_nome_agencia 
		AND
		C.NUMERO_CONTA = p_numero_conta
		GROUP BY C.NOME_CLIENTE, C.NOME_AGENCIA, C.NUMERO_CONTA;
		
BEGIN
	OPEN cursor_saldo_cliente;
		saldo_total = 0;
		FETCH cursor_saldo_cliente INTO soma_deposito, soma_emprestimo;
			IF FOUND THEN
			
				IF soma_deposito IS NULL then soma_deposito = 0; END IF;
				IF soma_emprestimo IS NULL then soma_emprestimo = 0; END IF;
				saldo_total = soma_deposito - soma_emprestimo;
		END IF;
   CLOSE cursor_saldo_cliente;
   RETURN saldo_total;
END
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION saldo_cliente(integer, character varying, character varying)
OWNER TO aluno;

select numero_conta, nome_agencia, nome_cliente, saldo_cliente(numero_conta, nome_agencia, nome_cliente) from conta;
















  

						
							
						