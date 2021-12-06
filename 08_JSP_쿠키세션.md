## 쿠키 생성 

> make_cookie.jsp
```jsp
<%
// 파라미터와 다르게 쿠키는 유효시간 내에 모든 페이지에서 사용할 수 있다. 
Cookie cookie = new Cookie("id", "김철수");// key value String타입만 가능함
cookie.setMaxAge(10); // 초단위, 쿠키유효시간
response.addCookie(cookie); // 쿠키생성 

Cookie cookie2 = new Cookie("pwd", "1234");
response.addCookie(cookie2);
%>
<p>쿠키 생성!</p>
<a href="view_cookie.jsp?name=김철수">쿠키확인</a>
```

<br>

>view_cookie.jsp
```jsp
<%
	Cookie[] cookies = request.getCookies(); // 쿠키배열 조회 
	if(cookies != null){ 
		for(Cookie cookie : cookies){
			out.print("Key : "+cookie.getName() + " : "); // 쿠키 변수 
			out.print("Value" + cookie.getValue() + "<br>"); // 쿠키 값 
		}
	}
	String name = request.getParameter("name"); 
%>
<a href="delete_cookie.jsp?name=<%= name %>">쿠키삭제</a>
<a href="update_cookie.jsp">쿠키변경</a>
```

<br>

## 쿠키 삭제 
>delete_cookie.jsp
```jsp
<%
Cookie cookie = new Cookie("id",""); // 쿠키 키가 id인 값 
cookie.setMaxAge(0); // 유효시간 즉시 만료 즉 삭제 
response.addCookie(cookie); 
%>
<h2>쿠키삭제!</h2>
<a href="view_cookie.jsp">쿠키확인</a>
```

<br>

## 쿠키 수정
```jsp
<h2>쿠키 수정</h2>
<%
	response.addCookie(new Cookie("id","park")); 
	// 쿠기 변수값이 존재하지 않으면 새로운 쿠키가 생성된다. 
	// 쿠키 변수값이 존재하면 쿠키값이 수정된다. 
%>>
<a href="view_cookie.jsp">쿠키확인</a>
```

<br>

## 세션 생성
```jsp
<%
// 세션객체는 모든 자료형을 가질 수 있다.
// 서버에 저장된다.
String id = "kim@naver.com";
String password = "1234";
int age = 20;
double height = 175.5;
session.setAttribute("id", id); // 
session.setAttribute("password", password);
session.setAttribute("age", age); 
session.setAttribute("height", height);
out.print("저장되었습니다");
%>
<a href="view_session.jsp">세셴 확인</a>
```

<br>

## 세션 확인
> view_session.jsp
```jsp
<h2>모든 세션정보 확인 </h2>
<%
	// 열거객체 
	Enumeration<String> en = session.getAttributeNames();// 세션변수 이름  
	while(en.hasMoreElements()){ // 반복할 요소가 있다면 실행
		String key = en.nextElement(); // 반복대상 요소 
		Object value = session.getAttribute(key);
		out.print("key : " + key );
		out.print(" ||||  value : " + value + "<br>");
	}
%>

<br>
<%
	String id = (String) session.getAttribute("id"); // 타입 캐스팅 필수 
	String password =(String) session.getAttribute("password");
	int age = 0;
	if(session.getAttribute("age")!= null){ // 숫자타입은 null 검사 필수
		age = (int) session.getAttribute("age");
	}
	double height = 0;
	if(session.getAttribute("height")!=null){
		height = (double) session.getAttribute("height");
	}
%>
<h2>세션 확인</h2>
아이디 : <%= id %> <br> 
비밀번호 : <%= password %> <br>
나이 : <%= age %> <br>
키 : <%= height %> <br>

<h2></h2>

<a href="delete_session.jsp">세션 삭제</a>

```

<br>

## 세션 삭제
> delete_session.jsp
```jsp
<%@page import="java.util.Enumeration"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<h2>모든 세션정보 확인 </h2>
<%
	// 열거객체 
	Enumeration<String> en = session.getAttributeNames();// 세션변수 이름  
	while(en.hasMoreElements()){ // 반복할 요소가 있다면 실행
		String key = en.nextElement(); // 반복대상 요소 
		Object value = session.getAttribute(key);
		out.print("key : " + key );
		out.print(" ||||  value : " + value + "<br>");
	}
%>

<br>
<%
	String id = (String) session.getAttribute("id"); // 타입 캐스팅 필수 
	String password =(String) session.getAttribute("password");
	int age = 0;
	if(session.getAttribute("age")!= null){ // 숫자타입은 null 검사 필수
		age = (int) session.getAttribute("age");
	}
	double height = 0;
	if(session.getAttribute("height")!=null){
		height = (double) session.getAttribute("height");
	}
%>
<h2>세션 확인</h2>
아이디 : <%= id %> <br> 
비밀번호 : <%= password %> <br>
나이 : <%= age %> <br>
키 : <%= height %> <br>

<h2></h2>

<a href="delete_session.jsp">세션 삭제</a>

```

<br>

## 세션 유효시간 
```jsp
<%
session.setMaxInactiveInterval(600);
int timeout = session.getMaxInactiveInterval(); // 기본값 1800초 (30분) 
out.print("세션 유효 시간 : " + timeout);
%>
```

## 세션을 활용한 로그인 상태 유지
> login.jsp
```jsp
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% 
	String contextPath = request.getContextPath();
%>
<form action="<%= contextPath %>/login/login.do" method="post">
	아이디 : <input type="text" id="userid" name="userid"/><br>
	비밀번호 : <input type="password" id="password" name="password"/><br>
	<button>로그인</button>
</form>

<%
String message = "";
if(request.getParameter("message") != null ){
	message = request.getParameter("message");
	if(message.equals("logout")){
		out.print("<div style='color:red;'>");
		out.print("로그아웃 완료");
		out.print("</div>");
	}
}
%>

```

> MemberDTO
```java
public class MemberDTO {
	private String userid; 
	private String password; 
	private String name;

    // 생성자 및 게터세터 투스트링
}
```

> MemberDAO
```java
public class MemberDAO {
	
	public String login(MemberDTO dto) {
		String reuslt = null; 
		Connection conn = null; 
		PreparedStatement pstmt = null; 
		ResultSet rs = null;
		try {
			conn = DB.dbConn();
			pstmt = conn.prepareStatement("select * from member where userid=? and password=?");
			pstmt.setString(1, dto.getUserid());
			pstmt.setString(2, dto.getPassword());
			rs = pstmt.executeQuery(); 
			if(rs.next()) {
				reuslt = rs.getString("name");
				System.out.println(reuslt);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			try { if(rs != null) rs.close();}
			catch (SQLException e) {e.printStackTrace();}
			try { if(pstmt != null) pstmt.close();}
			catch (SQLException e) {e.printStackTrace();}
			try { if(conn != null) conn.close();}
			catch (SQLException e) {e.printStackTrace();}
		}
		return reuslt;
	}
}
```

> SessionController
```java
@WebServlet("/login/*")
public class SessionController extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public SessionController() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String url = request.getRequestURI();
		String contextPath = request.getContextPath();
        String cmdURI = url.substring(contextPath.length()+1);

		MemberDAO dao = new MemberDAO(); 
		if(cmdURI.equals("login.do")) {
			String userid = request.getParameter("userid");
			String password = request.getParameter("password");
			MemberDTO dto = new MemberDTO(); 
			dto.setUserid(userid); 
			dto.setPassword(password);
			String useranme = dao.login(dto);
			HttpSession session = request.getSession();
			String page = "/login.jsp";
			if(useranme != null) {
				session.setAttribute("userid",userid);
				session.setAttribute("password",password);
                session.setAttribute("message", useranme); // 표시할 메세지 설정
				page = "/main.jsp";
			} 
			response.sendRedirect(contextPath + page); // sendRedirect는 컨텍스트 패스를 포함해야한다.
		} else if (cmdURI.equals("loout.do")) {
			HttpSession session = request.getSession(); 
			session.invalidate(); 
			String page = contextPath + "/login.jsp?messsage=logout";
			response.sendRedirect(page);  
		}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}
}
```

<br>

> session_check.jsp
```jsp
<%
	String contextPath = request.getContextPath();
	String userid = (String) session.getAttribute("userid");
	if(userid == null){
		out.print("<script>");
		out.print("alert('로그인하세요');");
		out.print( "location.href='"+contextPath+"/login.jsp';");
		out.print("</script>");
	}
%>
```