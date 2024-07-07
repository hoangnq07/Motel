package controller.authentication;
import java.io.IOException;
import java.util.Arrays;
import java.util.List;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import Account.Account;

@WebFilter("/*")
public class AuthFilter implements Filter {

    private static final List<String> PUBLIC_PAGES = Arrays.asList("/home", "/login", "/register","/registration.jsp","/verify","/forgot-password","/login.jsp","/motel-rooms", "/404.jsp","/room-details","/categories","/about.jsp","reset-password.jsp","/reset-password");
    private static final List<String> ADMIN_PAGES = Arrays.asList("/admin", "/dashboard_admin");
    private static final List<String> OWNER_PAGES = Arrays.asList("/owner","/motel");
    private static final List<String> USER_PAGES = Arrays.asList("/user");
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {

    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);

        String requestURI = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        String path = requestURI.substring(contextPath.length());
        try {
            // Xử lý trường hợp root URL
            if (path.equals("/") || path.isEmpty()) {
                httpResponse.sendRedirect(contextPath + "/home");
                return;
            }

            boolean isLoggedIn = (session != null && session.getAttribute("user") != null);

            if (isPublicResource(path) || isPublicPage(path)) {
                chain.doFilter(request, response);
                return;
            }

            if (!isLoggedIn) {
                httpResponse.sendRedirect(contextPath + "/login");
                return;
            }

            Account user = (Account) session.getAttribute("user");
            String userRole = user.getRole();

            if (isAdminPage(path)) {
                if (!"admin".equals(userRole) || !isAdminSessionValid(session)) {
                    httpResponse.sendRedirect(contextPath + "/login");
                    return;
                }
                session.setAttribute("adminLastAccessTime", System.currentTimeMillis());
            } else if (isOwnerPage(path) && !"owner".equals(userRole)) {
                httpResponse.sendRedirect(contextPath + "/home");
                return;
            }
            chain.doFilter(request, response);
        }catch (Exception e){
            e.printStackTrace();
            httpRequest.getRequestDispatcher("/404.jsp").forward(request, response);
        }
    }


    private boolean isPublicResource(String uri) {
        return uri.endsWith(".css") || uri.endsWith(".js") || uri.endsWith(".json")|| uri.endsWith(".png") || uri.endsWith(".jpg") || uri.endsWith(".gif");
    }

    private boolean isPublicPage(String path) {
        for (String publicPage : PUBLIC_PAGES) {
            if (path.startsWith(publicPage)) {
                return true;
            }
        }
        return false;
    }

    private boolean isAdminPage(String path) {
        for (String adminPage : ADMIN_PAGES) {
            if (path.startsWith(adminPage)) {
                return true;
            }
        }
        return false;
    }

    private boolean isOwnerPage(String path) {
        for (String ownerPage : OWNER_PAGES) {
            if (path.startsWith(ownerPage)) {
                return true;
            }
        }
        return false;
    }

    private boolean isUserPage(String path) {
        for (String userPage : USER_PAGES) {
            if (path.startsWith(userPage)) {
                return true;
            }
        }
        return false;
    }

    private boolean isAdminSessionValid(HttpSession session) {
        Long lastAccessTime = (Long) session.getAttribute("adminLastAccessTime");
        if (lastAccessTime == null) {
            return false;
        }
        // Kiểm tra xem thời gian truy cập lần cuối có quá 30 phút không
        return (System.currentTimeMillis() - lastAccessTime) <= 30 * 60 * 1000;
    }

    @Override
    public void destroy() {
        // Cleanup code, if needed
    }
}