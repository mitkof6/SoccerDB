package gui;

import java.awt.BorderLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;
import java.io.PrintStream;
import java.sql.SQLException;

import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTextArea;
import javax.swing.JTextField;
import javax.swing.JToolBar;

import com.mysql.jdbc.CallableStatement;
import com.mysql.jdbc.PreparedStatement;

import database.Database;

import main.Main;

/**
 * This is the main window
 * 
 * @author Jim Stanev
 *
 */
public class MainWindow extends JFrame {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private JTextArea textArea;
	private JTextField commandTextField;

	public MainWindow() {
		super("SoccerDB");
		this.setDefaultCloseOperation(EXIT_ON_CLOSE);
		this.setSize(Main.WIDTH, Main.HEIGHT);
		this.setLayout(new BorderLayout());
		this.setResizable(false);

		// key handler
		KeyHandler keyHandler = new KeyHandler();

		// buttons
		JToolBar toolBar = new JToolBar();
		
		JButton insertTeam = new JButton("Insert Team");
		insertTeam.addActionListener(new ActionListener() {

			@Override
			public void actionPerformed(ActionEvent arg0) {
				InsertTeamWindow insertTeamWindow = new InsertTeamWindow();
				insertTeamWindow.setVisible(true);
			}
		});
		toolBar.add(insertTeam);
		
		JButton insertGame = new JButton("Insert Game");
		insertGame.addActionListener(new ActionListener() {

			@Override
			public void actionPerformed(ActionEvent arg0) {
				InsertGameWindow insertGameWindow = new InsertGameWindow();
				insertGameWindow.setVisible(true);
			}
		});
		toolBar.add(insertGame);

		JButton statistics = new JButton("Statistics");
		statistics.addActionListener(new ActionListener() {

			@Override
			public void actionPerformed(ActionEvent arg0) {
				StatisticWindow statisticWindow = new StatisticWindow();
				statisticWindow.setVisible(true);
			}
		});
		toolBar.add(statistics);
		
		JButton exitButton = new JButton("Exit");
		exitButton.addActionListener(new ActionListener() {

			@Override
			public void actionPerformed(ActionEvent arg0) {
				System.exit(0);

			}
		});
		toolBar.add(exitButton);

		// text area
		textArea = new JTextArea(20, 70);
		textArea.setEditable(false);
		textArea.setLineWrap(true);
		textArea.setWrapStyleWord(true);
		JScrollPane scrollPane = new JScrollPane(textArea);
		scrollPane.setAutoscrolls(true);
		JTextAreaRedirecction infoScrean = new JTextAreaRedirecction(textArea);
		System.setOut(new PrintStream(infoScrean));
		System.setErr(new PrintStream(infoScrean));

		//command text field
		JPanel commandPanel = new JPanel();
		commandTextField = new JTextField("", 70);
		commandTextField.addKeyListener(keyHandler);
		commandPanel.add(commandTextField);
		

		// add
		this.add(toolBar, BorderLayout.NORTH);
		this.add(scrollPane, BorderLayout.CENTER);
		this.add(commandPanel, BorderLayout.SOUTH);

	}


	/**
	 * Key handler class
	 * 
	 * @author 
	 */
	private class KeyHandler implements KeyListener {

		@Override
		public void keyPressed(KeyEvent e) {
			if (e.getKeyCode() == KeyEvent.VK_ENTER) {
				
				if(commandTextField.getText().length()<6){
					return;
				}
				
				if (commandTextField.getText().substring(0, 6)
						.equalsIgnoreCase("insert")||
						commandTextField.getText().substring(0, 6)
						.equalsIgnoreCase("update")||
						commandTextField.getText().substring(0, 6)
						.equalsIgnoreCase("delete")) {
					Database db = new Database(commandTextField.getText()) {
						
						@Override
						public boolean execute() {
							try {
								PreparedStatement ps = (PreparedStatement) connection.prepareStatement(command);
								ps.executeUpdate();
							} catch (SQLException e) {
								e.printStackTrace();
								return false;
							}
							return true;
						}
					};
					System.out.println("Query: "+db.execute());
					db.closeConnection();
					
				} else if (commandTextField.getText().substring(0, 6)
						.equalsIgnoreCase("select")) {
					Database db = new Database(commandTextField.getText()) {
						@Override
						public boolean execute() {
							try {
								PreparedStatement ps = 
									 (PreparedStatement) this.connection.prepareStatement(this.command);
								Main.showResult(ps.executeQuery());
								return true;
							} catch (SQLException e) {
								e.printStackTrace();
								return false;
							}	
						}
					};
					System.out.println("Select: "+db.execute());
					db.closeConnection();
					
				} else if (commandTextField.getText().substring(0, 4)
								.equalsIgnoreCase("call")){
					Database db = new Database(commandTextField.getText()) {
						@Override
						public boolean execute() {
							try {
								CallableStatement cs = 
									(CallableStatement) this.connection.prepareCall(this.command);
								Main.showResult(cs.executeQuery());
								return true;
							} catch (SQLException e) {
								e.printStackTrace();
								return false;
							}	
						}
					};
					System.out.println("Call: "+db.execute());
					db.closeConnection();
				}
			}
		}

		@Override
		public void keyReleased(KeyEvent e) {}

		@Override
		public void keyTyped(KeyEvent e) {}
	}
}
