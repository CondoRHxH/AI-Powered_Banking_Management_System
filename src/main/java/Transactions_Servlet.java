

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet implementation class Transactions_Servlet
 */
@WebServlet("/Transactions_Servlet")
public class Transactions_Servlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Transactions_Servlet() {
        super();
        
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("Login_Servlet");
            return;
        }
 
        String userEmail = (String) session.getAttribute("user");
        double totalIncome = 0, totalExpense = 0;
        List<Map<String, String>> transactions = new ArrayList<>();
 
        try (Connection con = DBConnection.getConnection()) {
 
            // Total income
            try (PreparedStatement ps1 = con.prepareStatement(
                    "SELECT COALESCE(SUM(amount),0) FROM transactions WHERE user_email=? AND type='income'")) {
                ps1.setString(1, userEmail);
                try (ResultSet rs1 = ps1.executeQuery()) {
                    if (rs1.next()) totalIncome = ((Number) rs1.getObject(1)).doubleValue();
                }
            }
 
            // Total expense
            try (PreparedStatement ps2 = con.prepareStatement(
                    "SELECT COALESCE(SUM(amount),0) FROM transactions WHERE user_email=? AND type='expense'")) {
                ps2.setString(1, userEmail);
                try (ResultSet rs2 = ps2.executeQuery()) {
                    if (rs2.next()) totalExpense = ((Number) rs2.getObject(1)).doubleValue();
                }
            }
 
            // ALL transactions — no LIMIT
            try (PreparedStatement ps3 = con.prepareStatement(
                    "SELECT type, category, amount, description, transaction_date " +
                    "FROM transactions WHERE user_email=? ORDER BY transaction_date DESC, created_at DESC")) {
                ps3.setString(1, userEmail);
                try (ResultSet rs3 = ps3.executeQuery()) {
                    while (rs3.next()) {
                        Map<String, String> tx = new LinkedHashMap<>();
                        tx.put("type",        rs3.getString("type"));
                        tx.put("category",    rs3.getString("category"));
                        tx.put("amount",      String.valueOf(rs3.getDouble("amount")));
                        tx.put("description", rs3.getString("description") != null ? rs3.getString("description") : "");
                        tx.put("date",        rs3.getString("transaction_date"));
                        transactions.add(tx);
                    }
                }
            }
 
        } catch (Exception e) {
            e.printStackTrace();
        }
 
        // Pass data to JSP
        request.setAttribute("userEmail",     userEmail);
        request.setAttribute("totalIncome",   totalIncome);
        request.setAttribute("totalExpense",  totalExpense);
        request.setAttribute("transactions",  transactions);
 
        // Read + clear flash message from session
        String msg = (String) session.getAttribute("msg");
        if (msg != null) {
            request.setAttribute("msg", msg);
            session.removeAttribute("msg");
        }
 
        request.getRequestDispatcher("Transactions.jsp").forward(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
