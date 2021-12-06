# 회원정보 테이블 실습 모델2

``` SQL
drop table member;

create table member(
    userid varchar2(50) not null primary key, 
    password varchar2(255) not null, 
    name varchar2(255) not null,
    reg_date date default sysdate,
    address varchar2(500), 
    tel varchar2(50)
);

insert into member (userid, password, name) values ('kim', '1234','김길동'); 
insert into member (userid, password, name) values ('hong', '1234','홍길동'); 

commit; 

select * from member;


```

<br>

- index.jsp
- MemberDTO.java
- MemberDAO.java
- MemberController.java
- list.jsp
- view.jsp

> MemberDTO
```java
package member;

public class MemberDTO {
	private String userid; 
	private String password; 
	private String name; 
	private String reg_date; 
	private String address; 
	private String tel; 
	
	// 생성자 
	public MemberDTO() {}

	public MemberDTO(String userid, String password, String name, String address, String tel) {
		this.userid = userid;
		this.password = password;
		this.name = name;
		this.address = address;
		this.tel = tel;
	}

	public MemberDTO(String userid, String password, String name, String reg_date, String address, String tel) {
		this.userid = userid;
		this.password = password;
		this.name = name;
		this.reg_date = reg_date;
		this.address = address;
		this.tel = tel;
	}

	// 투스트링
	@Override
	public String toString() {
		return "MemberDTO [userid=" + userid + ", password=" + password + ", name=" + name + ", reg_date=" + reg_date
				+ ", address=" + address + ", tel=" + tel + "]";
	}	

	// 게터 
	public String getUserid() {
		return userid;
	}

	public String getPassword() {
		return password;
	}

	public String getName() {
		return name;
	}

	public String getReg_date() {
		return reg_date;
	}

	public String getAddress() {
		return address;
	}

	public String getTel() {
		return tel;
	}
}
```

<br>

### 회원목록 조회 
> MemberDAO
```java
package member;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import common.DB;

public class MemberDAO {
	public List<MemberDTO> memberList()
	{
		List<MemberDTO> list = new ArrayList<>(); 
		Connection conn = null; 
		PreparedStatement pstmt = null; 
		ResultSet rs = null; 
		
		try {
			conn = DB.dbConn(); 
			pstmt = conn.prepareStatement(
				"select userid, password, name, to_char(reg_date, 'yyyy-mm-dd') reg_date, address, tel from member order by name");
			rs = pstmt.executeQuery(); 
			while(rs.next()) {
				String userid = rs.getString("userid");
				String password = rs.getString("password");
				String name = rs.getString("name");
				String reg_date = rs.getString("reg_date");
				String address = rs.getString("address");
				String tel = rs.getString("tel");	
				MemberDTO dto = new MemberDTO(userid, password, name, reg_date, address, tel); 
				list.add(dto); 
			} 
		} catch (Exception e) {
			System.out.println("회원 정보 조회 실패...");
			System.out.println(e.getStackTrace());
		} finally {
			try { if(rs != null) rs.close();} 
			catch (SQLException e) { e.printStackTrace(); }
			try { if(pstmt != null) pstmt.close();}	
			catch (SQLException e) { e.printStackTrace(); }
			try {if(conn != null) conn.close();}
			catch (SQLException e) { e.printStackTrace(); }		
		}
		return list;
	}
}

```

> MemberController
```java
package member;
/* ... */

@WebServlet("/list.do")
public class MemberController extends HttpServlet {
/* ... */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String uri = request.getRequestURI(); // ex) /test/list.do
		String context = request.getContextPath(); // /test
		String cmdURI = uri.substring(context.length()+1); // list.do

		MemberDAO dao = new MemberDAO(); 
		if(cmdURI.equals("list.do")) {
			Map<String, Object> map = new HashMap<String, Object>(); 
			List<MemberDTO> list = dao.memberList(); 
			map.put("list", list);  // 총 레코드 
			map.put("count", list.size()); //레코드 수 
			request.setAttribute("map", map);
			
			RequestDispatcher rd = request.getRequestDispatcher("/member/list.jsp"); 
			rd.forward(request, response);
		}
	}
/* ... */
}

```

<br>

- /webapp/member/list.jsp
> list.jsp
```jsp
<%@page import="member.MemberDTO"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% 
	Map<String, Object> map = (Map<String, Object>) request.getAttribute("map"); 
	List<MemberDTO> memberList = (List) map.get("list"); 
%>

<!-- html, head, body 태그 생략 -->

<div>
<h2>회원정보</h2>
<table class="table">
	<tr>
		<th>아이디</th>
		<th>비밀번호</th>
		<th>이름</th>
		<th>연락처</th>
		<th>주소</th>
		<th>등록일</th>
	</tr>
<% for(MemberDTO dto : memberList){ %>
	<tr>
		<td><%= dto.getUserid() %></td>
		<td><%= dto.getPassword()%></td>
		<td><%= dto.getName() %></td>
		<td><%= dto.getTel()%></td>
		<td><%= dto.getAddress() %></td>
		<td><%= dto.getReg_date()%></td>
	</tr>
<% } %>
</table>
</div>

<style>
	table, td, th, tr { outline : 1px solid ; border-collapse: collapse;}
	td, th { padding : 8px 15px ;}
</style>
```

### 회원정보 등록 
> MemberDAO 
```java
// 회원정보 데이터 삽입
public void insert(MemberDTO dto) {
	Connection conn = null; 
	PreparedStatement pstmt=null; 
	try {
		conn = DB.dbConn(); 
		String sql  = " insert into member(userid, password, name, address, tel)"
				+ "values (?, ?, ?, ?, ?)"; 
		pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, dto.getUserid());
		pstmt.setString(2, dto.getPassword());
		pstmt.setString(3, dto.getName());
		pstmt.setString(4, dto.getAddress());
		pstmt.setString(5, dto.getTel());
		pstmt.executeUpdate();
	} catch (Exception e) {
		System.out.println("회원 데이터 삽입 실패");
		System.out.println(e.getStackTrace());
	} finally {
		try { if(pstmt != null) pstmt.close();}	
		catch (SQLException e) { e.printStackTrace(); }
		try {if(conn != null) conn.close();}
		catch (SQLException e) { e.printStackTrace(); }		
	}
}
```

- /webapp/member 폴더 /webapp/memberView로 변경 
- 폴더 변경으로 인한 리퀘스트디스페처 객체의 이동페이지를 모두 변경한다. 
- WeBServlet 맵핑 변경

> MemberController
```java

@WebServlet("/member/*")

/* ... */
if(cmdURI.equals("member/list.do")) {
	/* ... */
RequestDispatcher rd = request.getRequestDispatcher("/memberView/list.jsp");
	/* ... */
}
/* ... */

// 회원가입 폼으로 이동 
if(cmdURI.equals("member/joinForm.do")) {
	RequestDispatcher rd = request.getRequestDispatcher("/memberView/join.jsp"); // 아직 만들지 않았다.
	rd.forward(request, response);
}

// 회원가입 처리 
if(cmdURI.equals("member/join.do")) {
	MemberDTO dto = new MemberDTO(
			request.getParameter("userid"),
			request.getParameter("password"), 
			request.getParameter("name"), 
			request.getParameter("address"), 
			request.getParameter("tel")); 
	dao.insert(dto); 
	RequestDispatcher rd = request.getRequestDispatcher("/member/list.do");
	rd.forward(request, response);
}
```

- /webapp/memberView/join.jsp
>join.jsp
```jsp
<% String root_path = request.getContextPath();  %>
<form action="<%= root_path %>/member/join.do" method="post">
	아이디 : <input type="text" name="userid"> <br>
	이름 : <input type="text" name="name"> <br>
	비밀번호 : <input type="text" name="password"> <br>
	연락처 : <input type="text" name="tel"> <br>
	주소 : <input type="text" name="address"> <br>
	<button>가입</button>
</form>
```

## 회원정보 조회 
> MemberCotroller
```java
// 회원정보조회 
if(cmdURI.equals("member/view.do")) {
	
	RequestDispatcher rd = request.getRequestDispatcher("/memberView/view.jsp");
	rd.forward(request, response); 
}
```

<br>

> MemberDAO memberDetail()
```java
public MemberDTO memberDetail(String userid)
{
	MemberDTO member = null;  
	Connection conn = null; 
	PreparedStatement pstmt = null; 
	ResultSet rs = null; 
	
	try {
		conn = DB.dbConn(); 
		pstmt = conn.prepareStatement(
			"select * from member where userid= ?");
		pstmt.setString(1, userid);
		rs = pstmt.executeQuery(); 
		
		if(rs.next()) 
		{ 
			member = new MemberDTO(
					rs.getString("userid"),
					rs.getString("password"),
					rs.getString("name"),
					rs.getString("reg_date"),
					rs.getString("address"),
					rs.getString("tel"));
		}
		
	} catch (Exception e) {
		System.out.println("회원 정보 조회 실패...");
		System.out.println(e.getStackTrace());
	} finally {
		try { if(rs != null) rs.close();} 
		catch (SQLException e) { e.printStackTrace(); }
		try { if(pstmt != null) rs.close();}	
		catch (SQLException e) { e.printStackTrace(); }
		try {if(conn != null) rs.close();}
		catch (SQLException e) { e.printStackTrace(); }		
	}
	return member;
}
```

> MemberCotroller
```java
// 회원정보조회 
if(cmdURI.equals("member/view.do")) {
	String userid = request.getParameter("userid");
	MemberDTO dto = new MemberDTO();
	dto = dao.memberDetail(userid);
	request.setAttribute("dto", dto); 
	RequestDispatcher rd = request.getRequestDispatcher("/memberView/view.jsp");
	rd.forward(request, response); 
}
```
- memberView/list.jsp
> list.jsp
```html
<% for(MemberDTO dto : memberList){ %>
	<tr>
		<!-- 쿼리스트링 추가  -->
		<td>
			<a href="<%= root_path %>/member/view.do?userid=<%= dto.getUserid() %>"><%= dto.getUserid() %></a>
		</td>
		<!-- ...   -->
	</tr>
<% } %>
```

> view.jsp
``` jsp
<%@page import="member.MemberDTO"%>
<% 
	String root_path = request.getContextPath();
	MemberDTO dto = (MemberDTO) request.getAttribute("dto");
%>
<div>
<form id="user_form">	
	<input type="hidden" name="userid" value="<%= userid %>" id="userid">
	<ul>
		<li>아이디 : <%= dto.getUserid() %></li>
		<li>비밀번호 : <%= dto.getPassword() %> </li>
		<li>이름 : <%= dto.getName()%> </li>
		<li>등록일 : <%= dto.getReg_date() %> </li>
		<li>주소 : <%= dto.getAddress() %> </li>
		<li>연락처 : <%= dto.getTel() %> </li>
	</ul>
</form>
<a href="<%= root_path %>/member/list.do">목록으로</a>
</div>  
</body>
</html>
```



```java
public void update(MemberDTO dto) {
	
	Connection conn = null; 
	PreparedStatement pstmt = null; 
	
	try {
		conn = DB.dbConn(); 
		pstmt = conn.prepareStatement(
			"update member set password=?, name=?, address=?, tel=? "); 
		pstmt.setString(1, dto.getPassword());
		pstmt.setString(2, dto.getName());
		pstmt.setString(3, dto.getAddress());
		pstmt.setString(4, dto.getTel());
		pstmt.executeUpdate();
	} catch (Exception e) {
		System.out.println(e.getMessage());
	} finally {
		try { if(pstmt != null) pstmt.close();}	
		catch (SQLException e) { e.printStackTrace(); }
		try {if(conn != null) conn.close();}
		catch (SQLException e) { e.printStackTrace(); }
	}
}	
```

## 회원정보 수정 
> view.jsp
```jsp
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>

<%
	/*...  */
	String userid = "";
	if(dto.getUserid()!= null){
		userid = dto.getUserid(); 
	}
%>
<form id="user_form">	
	<input type="hidden" name="userid" value="<%= userid %>" id="userid"> <!-- userid를 MemberController에 전달 -->
	<!--   -->
	<!-- 수정폼으로 가는 버튼 추가 -->
	<button type="button" class="update">수정</button>
</form>
<a href="<%= root_path %>/member/list.do">목록으로</a>

<!-- ....  -->
<script type="text/javascript">
$(function(){
	let $form = $('#user_form');
	let userid = $('#userid').val();
	
	$(".update").on("click",function(){
		$form.attr("method","post");
		$form.attr("action", "<%= root_path%>/member/updateForm.do");
		$form.submit();
	}); 
	
}); 
</script>
```

> MemberController 
```java
// 회원정보 업데이트 폼
if(cmdURI.equals("member/updateForm.do")) {
	String userid = request.getParameter("userid"); // 수정할 회원의 id를 view.jsp로부터 전달받음
	MemberDTO member =  dao.memberDetail(userid); // 이 id로 수정할 회원 객체를 받음 (아직 구현하지 않음)
	request.setAttribute("member", member); // 수정할 회원객체를 수정폼에 출력하기 위함 
	RequestDispatcher rd = request.getRequestDispatcher("/memberView/update.jsp");
	rd.forward(request, response);
}
```

> MemberDao
```java
public void update(MemberDTO dto) {
	
	Connection conn = null; 
	PreparedStatement pstmt = null; 
	
	try {
		conn = DB.dbConn(); 
		pstmt = conn.prepareStatement(
			"update member set password=?, name=?, address=?, tel=? where userid=?"); 
		pstmt.setString(1, dto.getPassword());
		pstmt.setString(2, dto.getName());
		pstmt.setString(3, dto.getAddress());
		pstmt.setString(4, dto.getTel());
		pstmt.setString(5, dto.getUserid());
		pstmt.executeUpdate();
	} catch (Exception e) {
		System.out.println(e.getMessage());
	} finally {
		try { if(pstmt != null) pstmt.close();}	
		catch (SQLException e) { e.printStackTrace(); }
		try {if(conn != null) conn.close();}
		catch (SQLException e) { e.printStackTrace(); }
	}
}
```

> update.jsp
``` jsp 
<% 
	String root_path = request.getContextPath();
	MemberDTO member = (MemberDTO)request.getAttribute("member");
%>
<%= member %>

<h2>업데이트 폼</h2>
<a href="<%= root_path %>/index.jsp">home</a>
<form action="<%= root_path %>/member/update.do"  method="post">
	<!-- MemberDAO update()에 userid를 전달해야하므로 히든타입으로 이 데이터를 유지한다. -->
	<input type="hidden" value="<%= member.getUserid() %>" name="userid">
	아이디 : <%= member.getUserid() %> <br>
	이름 : <input type="text" name="name" value="<%= member.getName()  %>"> <br>
	비밀번호 : <input type="text" name="password" value="<%= member.getPassword()  %>"> <br>
	연락처 : <input type="text" name="tel" value="<%= member.getTel()  %>"> <br>
	주소 : <input type="text" name="address" value="<%= member.getAddress()  %>"> <br>
	<button>확인</button>
</form>
```

> MemberController 
```java
if(cmdURI.equals("member/update.do")) {
	System.out.println(request.getParameter("userid"));
	MemberDTO dto = new MemberDTO(
			request.getParameter("userid"),
			request.getParameter("password"), 
			request.getParameter("name"), 
			request.getParameter("address"), 
			request.getParameter("tel")); 
	dao.update(dto);
	response.sendRedirect(context + "/member/list.do");
}
```


## 회원삭제 
- 삭제 요청 추가 
- 컨트롤러 
	+ userid 받아서 회원객체 조회 
	+ 삭제 메서드 호출 
	+ list페이지  리다이렉트 

> view.jsp 
```js
$(".delete").on("click",function(){
	alert('삭제'); 
	$form.attr("method","post");
	$form.attr("action", "<%= root_path%>/member/delete.do"); 
	$form.submit();
}
```
<br>

> MemberControler
```java
if(cmdURI.equals("member/delete.do")) {
	System.out.println("삭제메서드호출");
	String userid = request.getParameter("userid")
	dao.delete(userid);
	response.sendRedirect(context + "/member/list.do");
	return; 
}
```

<br>

> MemberDao delete()
```java
public void delete(String userid) {
	Connection conn = null; 
	PreparedStatement pstmt = null; 
	
	try {
		conn = DB.dbConn(); 
		pstmt = conn.prepareStatement("delete from member where userid = ?");
		pstmt.setString(1, userid);
		pstmt.executeUpdate(); 			
	} catch (SQLException e) {
		e.printStackTrace();
	} finally {
		try { if(pstmt != null) pstmt.close();}	
		catch (SQLException e) { e.printStackTrace(); }
		try {if(conn != null) conn.close();}
		catch (SQLException e) { e.printStackTrace(); }
	}
}
```

