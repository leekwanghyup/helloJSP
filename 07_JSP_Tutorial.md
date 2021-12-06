## ajax

```jsp
<%@page import="books.BookDTO"%>
<%@page import="java.util.List"%>
<%@page import="books.BookDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<h2>비동기</h2>
number : <input type="text" name="num" id="num">
<button  class="btn">확인</button>
<div class="result"></div>
```
```js
$(function(){
	$(".btn").on('click',function(){
		let num=$("#num").val(); // 태그에 입력한 값 
		// 백그라운로 호출하는 함수
		// 자바스크립트 객체 { key : value} 
		$.ajax({ 
			type : "post", 
			url: "result.jsp", 
			data : {"num" : num}, // 전달 값 
			success : function (txt){  // 콜백함수 - 백그라운드에서 실행한 결과를 받아온다.
				$(".result").html(txt); 
			}
		});
	}); 
});
```

<br>

##

> MemberDTO
```java
package member;

public class MemberDTO {
	private String userid; 
	private String password; 
	private String name;
	
    // 생성자 게터 세터 투스트링
```

MemberDAO 
```java
package member;
/* ... */
import common.DB;

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

> login.jsp
```java
	String userid = request.getParameter("userid");
	String password= request.getParameter("password");
	MemberDTO dto = new MemberDTO();
	MemberDAO dao = new MemberDAO(); 
	dto.setUserid(userid);
	dto.setPassword(password);
	String loginResult = dao.login(dto);
	if(loginResult != null){
		out.print(loginResult+"님이 로그인하였습니다."); 
	} else {
		out.print("아이디 또는 비밀번호가 일치하지 않습니다."); 
	}
```

