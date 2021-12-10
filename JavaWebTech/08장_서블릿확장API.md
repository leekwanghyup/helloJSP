## redirect를 이용한 포워딩
> FirstServlet
```java
@WebServlet("/first")
public class FirstServlet extends HttpServlet {
    /* ... */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=utf-8"); 
        response.sendRedirect("second?name=lee"); // sendRedirect 컨텍스트 경로를 기준으로 한다.
        // 쿼리스트링으로 데이터 전달
        // 절대경로로 요청할 경우 '/second' 컨텍스트 경로를 반드시 붙여한다.   
    }
    /* ... */
}
```

<br>

> SecondServlet
```java
@WebServlet("/second")
public class SecondServlet extends HttpServlet {

    /* ... */   
    
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setContentType("text/html;charset=utf-8");
        String name = request.getParameter("name"); // 전달된 데이터를 받는다.
		PrintWriter out = response.getWriter(); 
		out.print("<html><body>");
		out.print("sendRedirect를 이용한 redirect 실습<br>");
        out.print("이름 : " + name);
		out.print("</body></html>");
    }
    /* ... */
}
```

<br>

## refresh를 이용한 포워딩
- 웹브라우저에서 첫 번째 서블릿에 요청
- 첫 번째 서블릿은 addHeader() 메서드를 이용해 이 요청을 웹브라우저에게 전달 
- 웹브라우저는 addHeader() 메서드가 지정한 두 번째 서블릿을 다시 요청

<br>

> FirstServlet
``` java
package servlet;
/* ... */


@WebServlet("/first")
public class FirstServlet extends HttpServlet {
/* ... */
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setContentType("text/html;charset=utf-8"); 
		response.addHeader("Refresh", "1;url=second"); 
		// 웹브라우저를 통해 요청한다. 1초후 second로 재요청   
	}
/* ... */
}
```

```java
@WebServlet("/second")
public class SecondServlet extends HttpServlet {
/* ... */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter(); 
		out.print("<html><body>");
		out.print("sendRedirect를 이용한 redirect 실습");
		out.print("</body></html>");
	}
/* ... */
	
}

```
<br>

## Dispatch를 이용한 포워딩 

<br>

- 웹브라우저를 거치지 않고 서버에서 바로 포워딩 된다. 
- 주소창의 URL 변화가 없다.

<br>

> FirstServlet
```java
@Override
protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    RequestDispatcher rd = request.getRequestDispatcher("/second?name=홍길동&email=hong@example");
    rd.forward(request, response);
}
```

> SecondServlet
```java
protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    request.setCharacterEncoding("utf-8");
    response.setContentType("text/html;charset=utf-8");
    
    String name = request.getParameter("name"); 
    String email = request.getParameter("email"); 
    
    PrintWriter out = response.getWriter();
    out.print("<html><body>");
    out.print("Dispatch를 이용한 forwad<br>");
    out.print("이름 : " + name + "<br>");
    out.print("이메일 : " + email + "<br>");
    out.print("</body></html>");	
}
```

<br>

## 객체 바인딩

> FirstServlet
```java
@Override
protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    request.setAttribute("address", "대구광역시 구암서로");
    response.sendRedirect("second");
}
```

<br>

>SecondServlet
```java
protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    request.setCharacterEncoding("utf-8");
    response.setContentType("text/html;charset=utf-8");
    
    // address에 바인딩된 객체를 가져온다.
    String address = (String) request.getAttribute("address");
    
    PrintWriter out = response.getWriter();
    out.print("<html><body>");
    out.print("Redirect를 이용한 forwad 객체 바인딩<br>"); // null 값이 출력된다 ??
    out.print("주소 : " + address + "<br>");
    out.print("</body></html>");
}
```

<br>

- 리다이렉트 방식의 포워드는 브라우저를 통해 이루어지기 때문에
- 첫 번째 서블릿에 전달되는 Request 객체와 두 번째 서블릿에 전달되는 Request객체는 다르다.
- 그러므로 첫 번째 서블릿의 Request 객체만 속성값이 바인딩 되었을 뿐이다.

<br>

> FirstServlet
```java
@Override
protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {	
    request.setAttribute("address", "대구광역시 구암서로"); 
    // request 객체 속성 바인딩 
    // param1 : 변수명 
    // param2 : 변수에 바인딩된 값
    RequestDispatcher rd = request.getRequestDispatcher("/second?name=홍길동&email=hong@example");
    rd.forward(request, response);
}
```

<br>

> SecondServlet
```java
protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    request.setCharacterEncoding("utf-8");
    response.setContentType("text/html;charset=utf-8");
    
    // address에 바인딩된 객체를 가져온다.
    String address = (String) request.getAttribute("address");
    
    PrintWriter out = response.getWriter();
    out.print("<html><body>");
    out.print("Dispatch를 이용한 forwad 객체 바인딩<br>"); 
    out.print("주소 : " + address + "<br>");
    out.print("</body></html>");
}
```
<br>


## ServletContext 클래스 
- javax.servelt.ServletContext
- 컨텍스트마다 하나의 ServletContext 객체가 생성된다. 
- 톰캣 컨테이너 실행 시 생성되고 톰캣 컨테이너 종료시 소멸된다.
- 서블리 끼리 자원을 공유하는데 사용한다. 

<br>


## ServletContext 바인딩 
- ServletContext에 바인딩 된 데이터는 모든 서블릿에서 접근할 수 있다. 
- 모든 사용자가 사용하는 데이터는 ServletContext에 바인딩하고 사용하면 편리하다

<br>

> FirstServlet
```java
@Override
protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {	
    response.setContentType("text/html;charset=utf-8");
    PrintWriter out = response.getWriter();
    
    ServletContext context = getServletContext(); // ServletContext객체를 가져온다.
    List<String> member = new ArrayList<>();  
    member.add("홍길동"); 
    context.setAttribute("member", member);
    out.print("<html><body>");
    out.print("서블릿 컨텍스트 객체 바인딩<br>"); 
    out.print("</body></html>");
}
```

<br>

> SecondServlet
```java
protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    request.setCharacterEncoding("utf-8");
    response.setContentType("text/html;charset=utf-8");
    
    ServletContext context = getServletContext(); 
    List<String> member = (List<String>) context.getAttribute("member");
    
    PrintWriter out = response.getWriter();
    out.print("<html><body>");
    out.print("ServletContext 바인딩<br>"); 
    out.print("이름 : " + member.get(0));
    out.print("</body></html>");
}

```
- 먼저 FirstServlet을 요청하여 ServletContext 객체에 데이터 바인딩을 하고
- SecondServlet을 요청한다.

<br>

## ServeltContext의 매개변수 설정
> web.xml
```xml
  <context-param>
  	<param-name>member_list</param-name> <!-- getInitParameter메서드의 파라미터값-->
  	<param-value>홍길동 박길동 김길동 이길동</param-value> <!-- getInitParameter메서드의 리턴값 -->
  </context-param>
```

> FirstServlet
```java
@Override
protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {	
    response.setContentType("text/html;charset=utf-8");
    PrintWriter out = response.getWriter();
    
    ServletContext context = getServletContext(); 
    String memberList = context.getInitParameter("memberList");
    // getInitParameter의 파라미터는 web.xml에 지정한 param-name 값이다. 
    // 이 메서드는 web.xml에서 지정한 param-value 값을 리턴한다.
    
    out.print("<html><body>");
    out.print("서블릿 컨텍스트 getInitParameter 메서드<br>");
    out.print("회원 목록 : " + memberList);
    out.print("</body></html>");
}
```

<br>

## 서블릿 컨텍스트의 파일 입출력 기능 

- /WEB-INF/bin/init.txt
> init.txt
```
회원등록 회원조회 회원수정, 주문조회 주문수정 주문취소, 상품조회 상품등록 상품수정 상품삭제
```

<br>

> FirstServlet
```java
@Override
protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {	
    response.setContentType("text/html;charset=utf-8");
    PrintWriter out = response.getWriter();
    
    ServletContext context = getServletContext(); 
    InputStream is =  context.getResourceAsStream("/WEB-INF/bin/init.txt");
    // param1 : 현재 컨텍스트 경로를 기준으로한다. 
    // 프로젝트 폴더 기준으로 webapp 폴더이다.

    BufferedReader buffer = new BufferedReader(new InputStreamReader(is));
    
    String menu = null; 
    String menu_member = null; 
    String menu_order = null; 
    String menu_goods = null; 
    
    while((menu=buffer.readLine()) != null) {
        StringTokenizer tokens = new StringTokenizer(menu, ","); 
        menu_member = tokens.nextToken();
        menu_order = tokens.nextToken();
        menu_goods = tokens.nextToken();
    }
    
    out.print("<html><body>");
    out.print("서블릿 컨텍스트의 파일 입출력 기능 <br>");
    out.print(menu_member + "<br>");
    out.print(menu_order + "<br>");
    out.print(menu_goods + "<br>");
    out.print("</body></html>");
}
```

<br>

## ServletConfig 
- javax.servlet
- 각 Servlet 객체에 대하여 생성된다.
- 각 서블릿에서만 접근할 수 있으며 공유할 수 없다.
- ServletConfig 인터페이스를 GenericServlet 클래스가 구현한다.

<br>

## 서블릿 초기화 :  @WebServlet 애노테이션 설정
> FristServlet
```java
@WebServlet(
	urlPatterns = {"/fisrt", "/firstServlet"}, // 여러개의 url 매핑 설정 
	initParams = {
			@WebInitParam(name="username", value="홍길동" ),
			@WebInitParam(name="email", value="hong@example.com" )
	}
)
public class FirstServlet extends HttpServlet {
/* ... */
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	    response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		
		String username = getInitParameter("username"); // @WebInitParam에 설정된 값 가져옴 
		String email = getInitParameter("email");
		
		out.print("<html><body>");
	    out.print("ServletConfig 객체 <br>");
	    out.print("이름 : " +  username +"<br>");
	    out.print("이메일 : " + email + "<br>");
	    out.print("</body></html>");
	}
/* ... */
}
```

<br>

## 서블릿 초기화 :  web.xml설정
- 앞에서 지정한 @WebServlet 어노테이션을 삭제한다.
> web.xml
```xml
  <servlet>
  	<servlet-name>firstServelt</servlet-name>
  	<servlet-class>servlet.FirstServlet</servlet-class>
  	<init-param>
  		<param-name>username</param-name>
  		<param-value>홍길동</param-value>
  	</init-param>
  	<init-param>
  		<param-name>email</param-name>
  		<param-value>hong@example</param-value>
  	</init-param>
  </servlet>
  <!-- 두 개이상의 매핑 -->
  <servlet-mapping>
  	<servlet-name>firstServelt</servlet-name>
  	<url-pattern>/first</url-pattern>
  </servlet-mapping>
  <servlet-mapping>
  	<servlet-name>firstServelt</servlet-name>
  	<url-pattern>/firstServlet</url-pattern>
  </servlet-mapping>
```

<br>

## load-on-startup 

- 톰캣 컨테이너가 실행되면서 미리 서블릿을 실행한다.
- 지정한 숫자가 0보다 크면 톰캣 컨테이너가 실행되면서 서블릿이 초기화된다.
- 지정한 숫자는 우선순위를 의미하며 작은 숫자부터 먼저 초기화된다.

<br>

> LoadAppConfig
```java
@WebServlet(urlPatterns = {"/loadConfig"}, loadOnStartup = 1)
public class LoadAppConfig extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
	private ServletContext context; 
	
    public LoadAppConfig() {
        super();
    }
    
    @Override
    public void init() throws ServletException {
    	System.out.println("LoadAppConfig init메서드 호출");
    	context = getServletContext();
    	context.setAttribute("contextPath", context.getContextPath());
        // contextPath 변수를 전체 애플리케이션에서 사용할 수 있다.
    }
/* ... */
}
```

<br>

## web.xml 설정
> 
```java
@WebServlet( name="loadAppConfig", urlPatterns = "/loadConfig")
public class LoadAppConfig extends HttpServlet { 
    /* ... */
```

<br>

> web.xml
```xml
  <servlet>
  	<servlet-name>loadAppConfig</servlet-name>
  	<servlet-class>servlet.LoadAppConfig</servlet-class>
  	<load-on-startup>1</load-on-startup>
  </servlet>
```