

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet implementation class Transaction_Servlet
 */
@WebServlet("/Transaction_Servlet")
public class Transaction_Servlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Transaction_Servlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// get logged in user email from session
        HttpSession session = request.getSession(false);
        String userEmail = (String) session.getAttribute("user");

        // get form data
        String type = request.getParameter("type");
        String category = request.getParameter("category");
        String amount = request.getParameter("amount");
        String description = request.getParameter("description");
        String transaction_date = request.getParameter("transaction_date");

        try {
            Connection con = DBConnection.getConnection();
            String sql = "INSERT INTO transactions(user_email, type, category, amount, description, transaction_date) VALUES (?, ?, ?, ?, ?, ?)";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, userEmail);
            ps.setString(2, type);
            ps.setString(3, category);
            ps.setDouble(4, Double.parseDouble(amount));
            ps.setString(5, description);
            ps.setString(6, transaction_date);

            int i = ps.executeUpdate();
            if(i > 0) {
                request.setAttribute("msg", "Transaction saved 🔥✅");
            } else {
                request.setAttribute("msg", "Something went wrong 💀");
            }
        } catch(Exception e) {
            e.printStackTrace();
            request.setAttribute("msg", "Server error 💥");
        }

        // go back to dashboard
        request.getRequestDispatcher("Dashboard_Servlet").forward(request, response);
    }
	}

