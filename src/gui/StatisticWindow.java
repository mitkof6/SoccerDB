package gui;


import java.awt.BorderLayout;

import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Locale;

import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JScrollPane;
import javax.swing.JTable;
import javax.swing.JToolBar;

import com.mysql.jdbc.PreparedStatement;

import database.Database;

import main.StatisticsCalculator;

/**
 * Statistics window
 * 
 * @author Jim Stanev
 */
public class StatisticWindow extends JFrame{
	
	//Variables
	private static final long serialVersionUID = 1L;
	private JButton news, load, calculate, save, clear;
	private JScrollPane scrollPane, resultScrollPane;
	private JTable table, resultTable;
	private Object[][] data, resultData;
	private int games;
	private ButtonHandler handler;
	private JLabel status;
	private boolean flagNew = false;
	private String round, league, result;
	
	/**
	 * Constructor
	 */
	public StatisticWindow(){
		super("Statistics");
		this.setDefaultCloseOperation(DISPOSE_ON_CLOSE);
		this.setLayout(new BorderLayout());
		
		//button
		JToolBar menuBar = new JToolBar();
		
		news = new JButton("New");
		menuBar.add(news);
		
		load = new JButton("Load");
		load.setEnabled(false);
		menuBar.add(load);
		
		calculate = new JButton("Calculate");
		calculate.setEnabled(false);
		menuBar.add(calculate);
		
		save = new JButton("Save");
		save.setEnabled(false);
		menuBar.add(save);
		
		clear = new JButton("Clear");
		clear.setEnabled(false);
		menuBar.add(clear);
		
		add(menuBar, BorderLayout.NORTH);
			
		//Handlers
		handler = new ButtonHandler();
		news.addActionListener(handler);
		load.addActionListener(handler);
		calculate.addActionListener(handler);
		save.addActionListener(handler);
		clear.addActionListener(handler);
		
		this.pack();
	}
	
	/**
	 * Handlers of the buttons.
	 */
	private class ButtonHandler implements ActionListener{
		public void actionPerformed(ActionEvent event){
			if(event.getSource()==news){
				
				//Reusable
				if(flagNew==true){
					StatisticWindow application = new StatisticWindow();
					application.pack();
					application.setVisible(true);
					setVisible(false);
					return;
				}
				flagNew = true;
				
				//Table
				String[] columnNames = {"MATCH",
		                "REAL",
		                "1",
		                "X",
		                "2",
		                "LOGIC"};
				
				String lines = JOptionPane.showInputDialog("How many games?");
				games = Integer.parseInt(lines);
				data = new Object[games][6];
				for(int i = 0;i<games;i++){
					data[i][0] = (i+1);
					data[i][1] = new String("");
					data[i][2] = new String("");
					data[i][3] = new String("");
					data[i][4] = new String("");
					data[i][5] = new String("");
					
				}
				table = new JTable(data, columnNames);
				scrollPane = new JScrollPane(table);
				add(scrollPane, BorderLayout.WEST);
				
				//Status Label
				status = new JLabel("Status: New");
				add(status, BorderLayout.AFTER_LAST_LINE);
				
				//Result
				String[] resaultColumnNames = {"FUNC",
		                "REAL",
		                "LOGIC"};
				resultData = new Object[12][3];
				resultData[0][0] = "MIN: ";
				resultData[1][0] = "MAX: ";
				resultData[2][0] = "COEFF: ";
				resultData[3][0] = "PERCENTAGE  %: ";
				resultData[4][0] = "SYMMETRY 1: ";
				resultData[5][0] = "SYMMETRY X: ";
				resultData[6][0] = "SYMMETRY 2: ";
				resultData[7][0] = "SYMMETRY TOTAL: ";
				resultData[8][0] = "PERMUTATION: ";
				resultData[9][0] = "NON NEXT: ";
				resultData[10][0] = "SURPRISE 1: ";
				resultData[11][0] = "SURPRISE 2: ";
				
				for(int i = 0;i<12;i++){
					resultData[i][1] = new String("");
					resultData[i][2] = new String("");
				}
				resultTable = new JTable(resultData, resaultColumnNames);
				resultScrollPane =  new JScrollPane(resultTable);
				add(resultScrollPane, BorderLayout.CENTER);

				setSize(830, 297);
				
				status.setText("Status: New");
				
				clear.setEnabled(true);
				load.setEnabled(true);
				calculate.setEnabled(false);

			}else if(event.getSource()==load){
				Database db = new Database(""){

					@Override
					public boolean execute() {
						round = JOptionPane.showInputDialog("Round?");
						league = JOptionPane.showInputDialog("League?");
						result = JOptionPane.showInputDialog("resultFH/resultSH?");
						this.command = 
							"SELECT * "+
							"FROM Game JOIN Team ON name = inTeam "+
							"WHERE round = '"+round+"' AND league = '"+league+"'";
						try {
							PreparedStatement ps = 
											(PreparedStatement) this.connection.prepareStatement(command);
							ResultSet rs = ps.executeQuery();
							int i = 0;
							while(rs.next()){
								table.getModel().setValueAt(rs.getObject(result),i,1);
								table.getModel().setValueAt(
									String.format(Locale.US, "%.2f", rs.getObject(
													result.equalsIgnoreCase("resultSH") ? "oneCoeff":"oneCoeffFH")),i,2);
								table.getModel().setValueAt(
									String.format(Locale.US, "%.2f", rs.getObject(
													result.equalsIgnoreCase("resultSH") ? "xCoeff":"xCoeffFH")),i,3);
								table.getModel().setValueAt(
									String.format(Locale.US, "%.2f", rs.getObject(
													result.equalsIgnoreCase("resultSH") ? "twoCoeff":"twoCoeffFH")),i,4);
								i++;
							}
						} catch (SQLException e) {
							e.printStackTrace();
							return false;
						}
										
						return true;
					}
					
				};
				if(db.execute()){
					calculate.setEnabled(true);
					load.setEnabled(false);
					
					status.setText("Status: Loaded");
					
					System.out.println("Load: true");
				}
				db.closeConnection();
				
			}else if(event.getSource()==calculate){
				StatisticsCalculator calc = new StatisticsCalculator(table, games);
				for(int i = 0;i<games;i++){
					String[] logic = calc.getLogic();
					table.getModel().setValueAt(logic[i], i, 5);
				}
				resultTable.getModel().setValueAt(calc.getMin(), 0, 1);
				resultTable.getModel().setValueAt(calc.getMin(), 0, 2);
				resultTable.getModel().setValueAt(calc.getMax(), 1, 1);
				resultTable.getModel().setValueAt(calc.getMax(), 1, 2);
				resultTable.getModel().setValueAt(calc.getRealCoeff(), 2, 1);
				resultTable.getModel().setValueAt(calc.getRealCoeff(), 2, 2);
				resultTable.getModel().setValueAt(calc.getPercentage(), 3, 1);
				resultTable.getModel().setValueAt(calc.getPercentage(), 3, 2);
				resultTable.getModel().setValueAt(calc.getSymmetry1R(), 4, 1);
				resultTable.getModel().setValueAt(calc.getSymmetry1L(), 4, 2);
				resultTable.getModel().setValueAt(calc.getSymmetryXR(), 5, 1);
				resultTable.getModel().setValueAt(calc.getSymmetryXL(), 5, 2);
				resultTable.getModel().setValueAt(calc.getSymmetry2R(), 6, 1);
				resultTable.getModel().setValueAt(calc.getSymmetry2L(), 6, 2);
				resultTable.getModel().setValueAt(calc.getSymmetryTotalR(), 7, 1);
				resultTable.getModel().setValueAt(calc.getSymmetryTotalL(), 7, 2);
				resultTable.getModel().setValueAt(calc.getPerReal(), 8, 1);
				resultTable.getModel().setValueAt(calc.getPerLogic(), 8, 2);
				resultTable.getModel().setValueAt(calc.getNonReal(), 9, 1);
				resultTable.getModel().setValueAt(calc.getNonLogic(), 9, 2);
				resultTable.getModel().setValueAt(calc.getSurprise1(), 10, 1);
				resultTable.getModel().setValueAt(calc.getSurprise1(), 10, 2);
				resultTable.getModel().setValueAt(calc.getSurprise2(), 11, 1);
				resultTable.getModel().setValueAt(calc.getSurprise2(), 11, 2);
				
				status.setText("Status: Calculated");
				
				save.setEnabled(true);
			
			}else if(event.getSource()==save){
				
				Database db = new Database("") {
					
					@Override
					public boolean execute() {
						String logic = "", real = "";
						
						for(int i = 0;i<data.length;i++){
							real += table.getModel().getValueAt(i, 1)+" ";
							logic += table.getModel().getValueAt(i, 5)+" ";
						}
						String res = result.equalsIgnoreCase("resultSH") ? "0" : "1";
						
						command = 
							"INSERT INTO Statistics VALUES('"+
							round+"', '"+
							league+"', '"+
							res+"', '"+
							real+"', '"+
							logic+"', '"+
							resultTable.getModel().getValueAt(0, 1)+"', '"+
							resultTable.getModel().getValueAt(1, 1)+"', '"+
							resultTable.getModel().getValueAt(2, 1)+"', '"+
							resultTable.getModel().getValueAt(3, 1)+"', '"+
							resultTable.getModel().getValueAt(4, 1)+"', '"+
							resultTable.getModel().getValueAt(5, 1)+"', '"+
							resultTable.getModel().getValueAt(6, 1)+"', '"+
							resultTable.getModel().getValueAt(7, 1)+"', '"+
							resultTable.getModel().getValueAt(4, 2)+"', '"+
							resultTable.getModel().getValueAt(5, 2)+"', '"+
							resultTable.getModel().getValueAt(6, 2)+"', '"+
							resultTable.getModel().getValueAt(7, 2)+"', '"+
							resultTable.getModel().getValueAt(8, 1)+"', '"+
							resultTable.getModel().getValueAt(8, 2)+"', '"+
							resultTable.getModel().getValueAt(9, 1)+"', '"+
							resultTable.getModel().getValueAt(9, 2)+"', '"+
							resultTable.getModel().getValueAt(10, 1)+"', '"+
							resultTable.getModel().getValueAt(11, 1)+"')";
							
						try {
							PreparedStatement ps =
											(PreparedStatement) connection.prepareStatement(command);
							ps.executeUpdate();
						} catch (SQLException e) {
							e.printStackTrace();
							return false;
						}
						return true;
					}
				};
				System.out.println("Insert: "+db.execute());
				db.closeConnection();
				
				status.setText("Status: Saved");
				
				save.setEnabled(false);
			}else if(event.getSource()==clear){
				for(int i = 0;i<games;i++){
					for(int j = 1;j<6;j++){
						table.getModel().setValueAt("", i, j);
					}
				}
				
				for(int i = 0;i<12;i++){
					for(int j = 1;j<3;j++){
						resultTable.getModel().setValueAt("", i, j);
					}
				}
				
				status.setText("Status: Clear");
				
				calculate.setEnabled(false);
				load.setEnabled(true);
			}
		}
	}
}
