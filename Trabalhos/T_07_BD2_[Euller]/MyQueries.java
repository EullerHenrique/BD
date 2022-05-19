package com.oracle.tutorial.jdbc;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.io.FileReader;
import java.io.BufferedReader;
import java.io.IOException;
import java.util.Scanner;

public class MyQueries {
  
  Connection con;
  JDBCUtilities settings;  
  
  public MyQueries(Connection connArg, JDBCUtilities settingsArg) {
    this.con = connArg;
    this.settings = settingsArg;
  }

  public static void getMyData(Connection con) throws SQLException {
    Statement stmt = null;
    String query =
      "SELECT SC.sup_name, COUNT(DISTINCT SC.cof_name) FROM (SELECT S.sup_name, C.cof_name FROM SUPPLIERS AS S, COFFEES AS C WHERE S.sup_id = C.sup_id) as SC GROUP BY SC.sup_name";

    try {
      stmt = con.createStatement();
      ResultSet rs = stmt.executeQuery(query);
      while (rs.next()) {
        String coffeeName = rs.getString(1);
        System.out.println("     " + coffeeName);
        String count = rs.getString(2);
        System.out.println("     "+count);
      }
    } catch (SQLException e) {
      JDBCUtilities.printSQLException(e);
    } finally {
      if (stmt != null) { stmt.close(); }
    }
  }
  
  
  public static void populateTable(Connection con) throws SQLException, IOException{ 
  
  	Statement stmt = null;
  	BufferedReader inputStream = null; 
	Scanner scanned_line = null; 
	String line; 
	String[] value; 
	String create;
	value = new String[7]; 
	int countv; 
  	
  	try{
  		stmt = con.createStatement();
  		inputStream = new BufferedReader(new FileReader("/home/euller/Documentos/mydir/JDBCTutorial/debito-populate-table.txt")); 
  		stmt.executeUpdate("truncate table debito");
		while ((line = inputStream.readLine()) != null) { 
		  	
		  	create = "";
			countv=0; 
			
			scanned_line = new Scanner(line); 
			scanned_line.useDelimiter("\t"); 
			while (scanned_line.hasNext()) { 
				value[countv++]=scanned_line.next();
			} //while
			
			
			if (scanned_line != null) {
				scanned_line.close(); 
			} 
				
			create = "insert into debito (numero_debito, valor_debito, motivo_debito, data_debito, numero_conta, nome_agencia, nome_cliente) " + "values (" +  value[0] +", "+ value[1] +", "+ value[2] +", '"+ value[3] +"', "+ value[4] +", '"+ value[5]  +"', '"+ value[6] + "');";
			

			System.out.println("\nExecutando DDL/DML:");
			System.out.println(create+"\n");
		  	stmt.executeUpdate(create);
		  	
		} //while
  		  	
  	}catch(SQLException e){
  		JDBCUtilities.printSQLException(e);
  	}catch(IOException e){
  		e.printStackTrace();
  	}
  	finally{
  		
  		if(stmt != null){
  			stmt.close();
  		}
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
 	MyQueries.populateTable(myConnection);

    }catch (SQLException e) {
      JDBCUtilities.printSQLException(e);
    }catch(IOException e){
  	e.printStackTrace();
    }finally {
      JDBCUtilities.closeConnection(myConnection);
    }

  }
}
