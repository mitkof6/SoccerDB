package gui;

import java.awt.BorderLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.sql.SQLException;

import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JOptionPane;
import javax.swing.JScrollPane;
import javax.swing.JTable;
import javax.swing.JToolBar;

import com.mysql.jdbc.PreparedStatement;

import database.Database;

import main.Main;

/**
 * The team insert window
 * 
 * @author Jim Stanev
 *
 */
public class InsertTeamWindow extends JFrame{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private Object[][] data;
	private JTable table;
	
	private static final int COLUMN_WIDTH = 100, COLUMN_HEIGHT = 40;
	
	public InsertTeamWindow(){
		super("Insert Team");
		this.setDefaultCloseOperation(DISPOSE_ON_CLOSE);
		this.setLayout(new BorderLayout());
		this.setSize(Main.WIDTH, Main.HEIGHT);
		//Table
		String[] columnNames = {
						"Team",
						"League"};
		
		final String games = JOptionPane.showInputDialog("How many teams?");
		
		data = new Object[Integer.parseInt(games)][12];
		table = new JTable(data, columnNames);
		table.setSize(COLUMN_WIDTH, COLUMN_HEIGHT);
		JScrollPane scrollPane = new JScrollPane(table);
		this.add(scrollPane, BorderLayout.CENTER);
		
		JToolBar toolBar = new JToolBar();
		
		JButton insert = new JButton("Insert");
		insert.addActionListener(new ActionListener() {
			
			@Override
			public void actionPerformed(ActionEvent arg0) {
				Database db = new Database("") {
					
					@Override
					public boolean execute() {
						for(int i = 0;i<Integer.parseInt(games);i++){
							try {
								this.command = 
									"INSERT INTO Team(name, league) " +
									"VALUES('"+
									get(i,0)+"', '"+
									get(i,1)+"')";
								PreparedStatement ps = 
									(PreparedStatement) connection.prepareStatement(command);
								ps.executeUpdate();
							} catch (SQLException e) {
								e.printStackTrace();
								return false;
							}
						}
						return true;
					}
					
				};
				System.out.println("Insert: "+db.execute());
				db.closeConnection();
			}
		});
		toolBar.add(insert);
		
		this.add(toolBar, BorderLayout.SOUTH);
		
	}
	
	private String get(int i, int j){
		return (String) table.getModel().getValueAt(i, j);
	}
}

