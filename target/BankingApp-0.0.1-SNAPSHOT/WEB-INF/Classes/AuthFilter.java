import java.io.IOException;
import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


public class AuthFilter implements Filter { // 👈 must implement Filter

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        res.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        res.setHeader("Pragma", "no-cache");
        res.setDateHeader("Expires", 0);

        String uri = req.getRequestURI();

        boolean isPublic = uri.endsWith("Login.jsp")
                        || uri.endsWith("Login_Servlet")
                        || uri.endsWith("Register.jsp")
                        || uri.endsWith("Register_Servlet");

        if (isPublic) {
            chain.doFilter(request, response);
            return;
        }

        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            chain.doFilter(request, response); // ✅ logged in
        } else {
            res.sendRedirect(req.getContextPath() + "/Login_Servlet"); // ❌ kick out
        }
    }

    @Override
    public void init(FilterConfig config) throws ServletException {} // 👈 required

    @Override
    public void destroy() {} // 👈 required
}