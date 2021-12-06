## 02. 쿠키생성 

```jsp
<form action="proceed.jsp" method="post">
	<input type="text" name="id"><br>
	<input type="text" name="password"><br>
	<button>전송</button>
</form>
```

```jsp
<%
    String user_id = request.getParameter("id"); 
    String user_pw = request.getParameter("password");
    
    if(user_id.equals("admin") &&  user_pw.equals("1234")){
        Cookie cookie_id = new Cookie("userID", user_id); // 쿠키생성 
        Cookie cookie_pw = new Cookie("userPW", user_pw);
        response.addCookie(cookie_id); // 쿠키로 설정
        response.addCookie(cookie_pw); 
        out.print("쿠키 생성!<br>");
        out.print(user_id +" 님 환영합니다."); 
    } else {
        out.print("쿠키생성 실패");
    }
%>
```

<br>

## 04.쿠키정보
```jsp
<%
	Cookie[] cookies = request.getCookies();
	for(Cookie cookie : cookies){
		String key = cookie.getName(); // 쿠키변수
		String value = cookie.getValue(); // 쿠키변수 값
		out.print( key + " : " + value + "<br>");
	}
%>
```

## 05. 쿠키삭제
```jsp
<%
	Cookie[] cookies = request.getCookies(); // 모든 쿠키를 가져온다. 
	for(Cookie cookie : cookies){
		if(cookie.getName().equals("userID")){ // 쿠키변수가 userID인 쿠키 삭제 
			cookie.setMaxAge(0); // 유효기간을 0으로 설정하면즉시 쿠키가 삭제된다.
			response.addCookie(cookie);	
		}
	}
%>
```

## 기타 메서드 
