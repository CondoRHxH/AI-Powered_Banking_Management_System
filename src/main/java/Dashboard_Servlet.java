

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
 * Servlet implementation class Dashboard_Servlet
 */
@WebServlet("/Dashboard_Servlet")
public class Dashboard_Servlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Dashboard_Servlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession(false);
        if(session == null || session.getAttribute("user") == null) {
            response.sendRedirect("Login_Servlet");
            return;
        }

        String userEmail = (String) session.getAttribute("user");
        double totalIncome = 0, totalExpense = 0;
        List<Map<String,String>> transactions = new ArrayList<>();
        Map<String,Double> categories = new LinkedHashMap<>();

        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps1 = con.prepareStatement(
                "SELECT COALESCE(SUM(amount),0) FROM transactions WHERE user_email=? AND type='income'");
            ps1.setString(1, userEmail);
            ResultSet rs1 = ps1.executeQuery();
            if(rs1.next()) totalIncome = rs1.getDouble(1);

            PreparedStatement ps2 = con.prepareStatement(
                "SELECT COALESCE(SUM(amount),0) FROM transactions WHERE user_email=? AND type='expense'");
            ps2.setString(1, userEmail);
            ResultSet rs2 = ps2.executeQuery();
            if(rs2.next()) totalExpense = rs2.getDouble(1);

            PreparedStatement ps3 = con.prepareStatement(
                "SELECT type, category, amount, description, transaction_date FROM transactions WHERE user_email=? ORDER BY created_at DESC LIMIT 6");
            ps3.setString(1, userEmail);
            ResultSet rs3 = ps3.executeQuery();
            while(rs3.next()) {
                Map<String,String> tx = new LinkedHashMap<>();
                tx.put("type", rs3.getString("type"));
                tx.put("category", rs3.getString("category"));
                tx.put("amount", String.valueOf(rs3.getDouble("amount")));
                tx.put("description", rs3.getString("description") != null ? rs3.getString("description") : "");
                tx.put("date", rs3.getString("transaction_date"));
                transactions.add(tx);
            }

            PreparedStatement ps4 = con.prepareStatement(
                "SELECT category, SUM(amount) as total FROM transactions WHERE user_email=? AND type='expense' GROUP BY category ORDER BY total DESC LIMIT 6");
            ps4.setString(1, userEmail);
            ResultSet rs4 = ps4.executeQuery();
            while(rs4.next()) {
                categories.put(rs4.getString("category"), rs4.getDouble("total"));
            }

        } catch(Exception e) {
            e.printStackTrace();
        }

        // pass data to JSP
        request.setAttribute("totalIncome", totalIncome);
        request.setAttribute("totalExpense", totalExpense);
        request.setAttribute("balance", totalIncome - totalExpense);
        request.setAttribute("transactions", transactions);
        request.setAttribute("categories", categories);
        request.setAttribute("userEmail", userEmail);

        request.getRequestDispatcher("Dashboard.jsp").forward(request, response); // points to JSP
    }
	

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
