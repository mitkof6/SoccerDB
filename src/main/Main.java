package main;

import gui.MainWindow;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.Properties;
import java.util.Vector;

import javax.swing.JFrame;
import javax.swing.JOptionPane;
import javax.swing.JScrollPane;
import javax.swing.JTable;
import javax.swing.table.DefaultTableModel;

import database.TableColumnAdjuster;

/**
 * The main class. Contains the settings of the database connection
 * and starts the main window.
 * 
 * @author Jim Stanev
 */
public class Main {

	/**
	 * database URL
	 */
	public static String URL;
	/**
	 * database user
	 */
	public static String USER;
	/**
	 * database password
	 */
	public static String PASSWORD;
	
	public static final int WIDTH = 800;
	public static final int HEIGHT = 300;
	/**
	 * @param args
	 */
	public static void main(String[] args) {
		
		//#############properties#############
		Properties properties = new Properties();

		//load properties file
		FileInputStream in = null;

		try{
			in = new FileInputStream("database.properties");
			properties.load(in);
		}catch (FileNotFoundException ex) {
			JOptionPane.showMessageDialog(null, "Property file not found",
							"Property File Error", JOptionPane.ERROR_MESSAGE);
		}catch (IOException ex) {
			JOptionPane.showMessageDialog(null, "Property reading problem",
							"Property Read Error", JOptionPane.ERROR_MESSAGE);
		}finally{
			try {
				if (in != null) {
					in.close();
				}
			} catch (IOException ex) {}
		}

		//set database properties
		URL = properties.getProperty("db.url");
		USER = properties.getProperty("db.user");
		PASSWORD = properties.getProperty("db.passwd");
		
		//#############window#############
		MainWindow application = new MainWindow();
		application.setVisible(true);
	}
	
	private static DefaultTableModel buildTableModel(ResultSet rs) throws SQLException {

		ResultSetMetaData metaData = rs.getMetaData();

		// names of columns
		Vector<String> columnNames = new Vector<String>();
		int columnCount = metaData.getColumnCount();
		for (int column = 1; column <= columnCount; column++) {
			columnNames.add(metaData.getColumnName(column));
		}

		// data of the table
		Vector<Vector<Object>> data = new Vector<Vector<Object>>();
		while (rs.next()) {
			Vector<Object> vector = new Vector<Object>();
			for (int columnIndex = 1; columnIndex <= columnCount; columnIndex++) {
				vector.add(rs.getObject(columnIndex));
			}
			data.add(vector);
		}

		return new DefaultTableModel(data, columnNames);

	}
	
	public static void showResult(ResultSet rs) throws SQLException{
		//creates the table
		JTable table = new JTable(buildTableModel(rs));
		table.setEnabled(false);
					
		//abjust table size
		table.setAutoResizeMode(JTable.AUTO_RESIZE_OFF);
		TableColumnAdjuster tca = new TableColumnAdjuster(table);
		tca.adjustColumns();	
			
		//JFrame
		JFrame view = new JFrame("View");
		view.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
		
		//add to frame
		JScrollPane pane = new JScrollPane(table);
		view.add(pane);
		
		//settings
		view.setVisible(true);
		view.setSize(table.getWidth(), 400);
	}

}
