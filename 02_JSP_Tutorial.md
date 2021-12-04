## JSP 내장 객체 
- request : 사용자 요청 처리 
- response : 서버 응답처리 
- out : 웹브라우저 출력 
- session : 사용자 인증 정보 관리 
- application : 서버 정보 관리 
- exception : 예외처리 
- config : jsp 환경 정보 처리 
- page : 현재 페이지 정보 처리 

## 변수 사용범위 
- pageContext : 현재페이지
- reqeust : 요청,응답 페이지
- session : 각가의 사용자 마다 변수 할당 
- application : 서버 변수(애플리케이션 전체에서 사용 가능함) 


## 실습 

> index.jsp
```jsp
<% String root_path = request.getContextPath(); %>
<form action="<%=root_path%>/something">
	이름 : <input type="text" name="name"> <br>	
	나이 : <input type="text" name="age"> <br>
	성별 : 남 <input type="radio" name="gender" value="m"> 여 <input type="radio" name="gender" value="f"> <br>
	전공 : 
	<select name="major">
		<option value="법학">법학</option>
		<option value="철학">철학</option>
		<option value="물리">물리</option>
		<option value="경영">경영</option>
		<option value="건축">건축</option>
	</select> <br>
	<button>확인</button>
</form>
```

> somethingController.java
```java
package controller;

/* ... */

@WebServlet("/something")
public class SomethingController extends HttpServlet {
	
    /* ... */
    
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("utf-8");
		String name = request.getParameter("name");
		int age = Integer.parseInt(request.getParameter("age")); 
		String gender = request.getParameter("gender");
		String major = request.getParameter("major");
		
		Map<String, Object> map  = new HashMap<>();
		map.put("name", name); 
		map.put("age", age); 
		gender = gender.equals("m") ? "남" : "여"; 
		map.put("gender", gender); 
		map.put("major", major);
		
		request.setAttribute("map", map);
		RequestDispatcher rd = request.getRequestDispatcher("/result.jsp");
		rd.forward(request, response);
						
	}
    /* ...  */
}

```

> result.jsp
```jsp
<% 
	Map<String,Object> map = (Map<String,Object>) request.getAttribute("map");
%>

이름 : <%= map.get("name") %><br>
나이 : <%= map.get("age") %><br>
성별 : <%= map.get("gender") %><br>
전공 : <%= map.get("major") %><br>
```

<br>

> index.jsp
```jsp

```
> somethingController.java
```java

```
> result.jsp
```jsp

```


<br>

> index.jsp
```jsp

```
> somethingController.java
```java

```
> result.jsp
```jsp

```