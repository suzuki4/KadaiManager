package filter;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;

/**
 * Servlet Filter implementation class EncodingFilter
 */
public class ManagerLoginFilter implements Filter {

	private String encode;
    /**
     * Default constructor. 
     */
    public ManagerLoginFilter() {
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see Filter#destroy()
	 */
	public void destroy() {
		// TODO Auto-generated method stub
	}

	/**
	 * @see Filter#doFilter(ServletRequest, ServletResponse, FilterChain)
	 */
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
		// TODO Auto-generated method stub
		// place your code here
		//managerLogin�擾
		boolean managerLogin = false;
		if(request.getAttribute("managerLogin") != null ) {
			managerLogin = (boolean) request.getAttribute("managerLogin");
		//�擾�ł��Ȃ��ꍇ�A�G���[
		} else {
			RequestDispatcher dispatcher;
			dispatcher = request.getRequestDispatcher("manager.jsp");
	 	 	request.setAttribute("fail", "���O�C���G���[");
	 	 	dispatcher.forward(request, response);		
		}
		//System.out.println(encode);
		// pass the request along the filter chain
		chain.doFilter(request, response);
	}

	/**
	 * @see Filter#init(FilterConfig)
	 */
	public void init(FilterConfig fConfig) throws ServletException {
		// TODO Auto-generated method stub
		encode = fConfig.getInitParameter("encode");
	}

}
