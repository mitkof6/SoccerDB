package database;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

import javax.swing.JOptionPane;

import main.Main;

/**
 * This is class is the parent of all database classes. It contains the behavior
 * of making a connection and closing it.
 *
 * @author Jim Stanev
 */
public abstract class Database {

	private static final String URL = Main.URL;
	private static final String USER = Main.USER;
	private static final String PASSWORD = Main.PASSWORD;

	protected Connection connection;
	protected boolean connectionState = false;
	protected String command;

	public Database(String command) {
		connectionState = this.makeConnection();
		this.command = command;
	}

	/**
	 * This method make a connection to the database.
	 *
	 * @return true if connection is established, else false
	 */
	private boolean makeConnection() {
		try {
			connection = DriverManager.getConnection(URL, USER, PASSWORD);
		} catch (SQLException e) {
			JOptionPane.showMessageDialog(null, "Can't make connection",
							"Error make connection", JOptionPane.ERROR_MESSAGE);
			return false;
		}
		return true;
	}

	/**
	 * DB connection accessor.
	 *
	 * @return the connection object
	 */
	public Connection getConnection() {
		return this.connection;
	}

	/**
	 * DB connection state accessor.
	 *
	 * @return the state of a connection
	 */
	public boolean getConnectionState() {
		return this.connectionState;
	}

	/**
	 * This method close the database connection.
	 *
	 */
	public void closeConnection() {
		try {
			if (connection != null) {
				connection.close();
			}
		} catch (SQLException ex) {
			JOptionPane.showMessageDialog(null, "Can't close connection",
							"Error close", JOptionPane.ERROR_MESSAGE);
		}
	}

	/**
	 * This abstract method is the action to implement on the database.
	 *
	 * @param command query to execute
	 */
	abstract public boolean execute();
}