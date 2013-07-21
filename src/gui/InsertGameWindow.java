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
 * The game insert window
 * 
 * @author Jim Stanev
 *
 */
public class InsertGameWindow extends JFrame{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private Object[][] data;
	private JTable table;
	
	private static final int COLUMN_WIDTH = 100, COLUMN_HEIGHT = 40;
	
	public InsertGameWindow(){
		super("Insert Game");
		this.setDefaultCloseOperation(DISPOSE_ON_CLOSE);
		this.setLayout(new BorderLayout());
		this.setSize(Main.WIDTH+200, Main.HEIGHT);
		//Table
		String[] columnNames = {
						"round",
						"inTeam",
						"outTeam",
						"resultFH",
						"resultSH",
						"inGoalFH",
						"outGoalFH",
						"inGoalSH",
						"outGoalSH",
						"oneCoeff",
						"xCoeff",
						"twoCoeff",
						"oneCoeffFX",
						"xCoeffFX",
						"twoCoeffFX"};
		
		final String games = JOptionPane.showInputDialog("How many games?");
		
		data = new Object[Integer.parseInt(games)][columnNames.length];
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
								command = 
									"INSERT INTO Game(round, inTeam, outTeam, resultFH, resultSH, " +
									"inGoalFH, outGoalFH, inGoalSH, outGoalSH, oneCoeff, xCoeff, " +
									"twoCoeff, oneCoeffFH, xCoeffFH, twoCoeffFH) " +
									"VALUES('"+
									get(i,0)+"', '"+
									get(i,1)+"', '"+
									get(i,2)+"', '"+
									get(i,3)+"', '"+
									get(i,4)+"', '"+
									get(i,5)+"', '"+
									get(i,6)+"', '"+
									get(i,7)+"', '"+
									get(i,8)+"', '"+
									get(i,9)+"', '"+
									get(i,10)+"', '"+
									get(i,11)+"', '"+
									get(i,12)+"', '"+
									get(i,13)+"', '"+
									get(i,14)+"')";
								System.out.println(command);
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
