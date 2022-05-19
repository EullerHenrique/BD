package com.oracle.tutorial.jdbc;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class MyQueries3 {
  
  Connection con;
  JDBCUtilities settings;  
  
  public MyQueries3(Connection connArg, JDBCUtilities settingsArg) {
    this.con = connArg;
    this.settings = settingsArg;
  }

  public static void getMyData(Connection con) throws SQLException {
    Statement stmt = null;
    /* Retorne os nomes dos clientes que possuem depósitos e empréstimos (ambos) com as respectivas somas */
    String query =
      "SELECT nome_cliente, COALESCE(SUM(saldo_deposito),0) AS soma FROM deposito WHERE nome_cliente IN (SELECT nome_cliente FROM EMPRESTIMO) GROUP BY nome_cliente UNION SELECT nome_cliente, -1 * COALESCE(SUM(valor_emprestimo),0) AS soma FROM emprestimo  WHERE nome_cliente IN (SELECT nome_cliente FROM DEPOSITO) GROUP BY nome_cliente";

    try {
      stmt = con.createStatement();
      ResultSet rs = stmt.executeQuery(query);
      while (rs.next()) {
        String name = rs.getString(1);
        String saldo = rs.getString(2);
        System.out.println("     " + name + "  " + saldo);
      }
    } catch (SQLException e) {
      JDBCUtilities.printSQLException(e);
    } finally {
      if (stmt != null) { stmt.close(); }
    }
  }


  public static void main(String[] args) {
    JDBCUtilities myJDBCUtilities;
    Connection myConnection = null;
    if (args[0] == null) {
      System.err.println("Properties file not specified at command line");
      return;
    } else {
      try {
        myJDBCUtilities = new JDBCUtilities(args[0]);
      } catch (Exception e) {
        System.err.println("Problem reading properties file " + args[0]);
        e.printStackTrace();
        return;
      }
    }

    try {
      myConnection = myJDBCUtilities.getConnection();

 	MyQueries3.getMyData(myConnection);

    } catch (SQLException e) {
      JDBCUtilities.printSQLException(e);
    } finally {
      JDBCUtilities.closeConnection(myConnection);
    }

  }
}
