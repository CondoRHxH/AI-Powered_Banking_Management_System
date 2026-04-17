

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

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
		RequestDispatcher ds = getServletContext().getRequestDispatcher("/Register.jsp");
		ds.forward(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		
		
		String nom = request.getParameter("nom");
		String prenom = request.getParameter("prenom");
		
		String email = request.getParameter("email");
        String password = request.getParameter("password");

        

        try {
            Connection con = DBConnection.getConnection();

            String sql = "INSERT INTO users(nom, prenom, email, password) VALUES (?, ?, ?, ?)";

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, nom);
            ps.setString(2, prenom);
            ps.setString(3, email);
            ps.setString(4, password);

            int i = ps.executeUpdate();

            if(i > 0) {
                request.setAttribute("msg", "Register success 😎🔥");
                request.getRequestDispatcher("Login.jsp").forward(request, response);
            } else {
                request.setAttribute("msg", "Register failed 💀");
                request.getRequestDispatcher("Register.jsp").forward(request, response);
            }

        } catch(Exception e) {
            e.printStackTrace();
        }
	}

}
