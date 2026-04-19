

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.mindrot.jbcrypt.BCrypt;

/**
 * Servlet implementation class Login_Servlet
 */
@WebServlet("/Login_Servlet")
public class Login_Servlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Login_Servlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		RequestDispatcher ds = getServletContext().getRequestDispatcher("/Login.jsp");
		ds.forward(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String email = request.getParameter("email");
		String password = request.getParameter("password");

		try {

			Connection con = DBConnection.getConnection();

			String sql = "SELECT password FROM users WHERE email=?";
			PreparedStatement ps = con.prepareStatement(sql);
			ps.setString(1, email);

			ResultSet rs = ps.executeQuery();

			if (rs.next()) {

				String hashedPassword = rs.getString("password");

				if (BCrypt.checkpw(password, hashedPassword)) {

					// 🔥 kill old session (important)
					HttpSession oldSession = request.getSession(false);
					if (oldSession != null) {
						oldSession.invalidate();
					}

					// 🔥 create new session
					HttpSession session = request.getSession(true);
					session.setAttribute("user", email);

					session.setMaxInactiveInterval(30 * 60); // 30 min timeout

					// 🚀 redirect to dashboard (BEST PRACTICE)
					response.sendRedirect("Dashboard.jsp");

				} else {
					request.setAttribute("msg", "Wrong password 💀");
					request.getRequestDispatcher("Login.jsp").forward(request, response);
				}

			} else {
				request.setAttribute("msg", "User not found 😵");
				request.getRequestDispatcher("Login.jsp").forward(request, response);
			}

		} catch (Exception e) {
			e.printStackTrace();
			request.setAttribute("msg", "Server error 💥");
			request.getRequestDispatcher("Login.jsp").forward(request, response);
		}
	}
}
