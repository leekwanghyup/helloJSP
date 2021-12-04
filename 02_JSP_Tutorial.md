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


## hashMap

### 객체 생성 
```java
public static void main(String[] args) {
    Map<String, Integer> map = new HashMap<>(); 
    map.put("바이에른뮌헨", 31);
    map.put("도르트문트", 30); 
    map.put("레버쿠젠", 24); 
    map.put("호펜하임", 20);
}
```

<br>

### 맵에 저장된 총 엔트리 수 
```java
System.out.println(map.size()); // 4
```

<br>

### key 이름으로 객체 찾기 
```java
System.out.println(map.get("바이에른뮌헨")); //31
```

### keySet() 맵의 key를 Set으로 반환
```java
Set<String> set =  map.keySet(); // [호펜하임, 레버쿠젠, 바이에른뮌헨, 도르트문트]
for(String v : set) {
    System.out.println(v); 
}
```

### 반복문 for문 이용
```java
for(String key : map.keySet()) {
    System.out.println("key :" + key +",  value :" + map.get(key));
}
```

### 반복문 2 : 반복자 객체 이용
```java
Iterator<String> it = map.keySet().iterator();
while (it.hasNext()) { // 반복자가 가르키는 다음 요소가 존재하면 
    String key = it.next(); // 키를 얻는다. next()반복자가 가르키는 다음요소를 의미
    Integer value = map.get(key); // get()에 키를 전달하여 value를 얻는다.
    System.out.println(key + " : " + value);
}
```

## 해쉬맵을 이용한 모델객체 

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
		request.setCharacterEncoding("utf-8"); // 한글화처리 
		
		// 리퀘스트 파라미터 정보 받음 
		String name = request.getParameter("name");
		int age = Integer.parseInt(request.getParameter("age")); 
		String gender = request.getParameter("gender");
		String major = request.getParameter("major");
		
		// 요청받은 파라미터 정보를 해쉬맵에 저장 
		Map<String, Object> map  = new HashMap<>();
		map.put("name", name); 
		map.put("age", age); 
		gender = gender.equals("m") ? "남" : "여"; 
		map.put("gender", gender); 
		map.put("major", major);
		
		request.setAttribute("map", map); // 뷰페이지에서 사용할 모델객체 
		RequestDispatcher rd = request.getRequestDispatcher("/result.jsp"); // 포워딩할 페이지 설정
		rd.forward(request, response); // 포워딩
			
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

## Request 객체 여러가지 메서드 
> index.jsp
```jsp
<h2>여러가지 Request 객체 메서드</h2>
<%
	Map<String, Object> map = new HashMap<>(); 
	map.put("portocol",request.getProtocol()); // 통신규약
	map.put("server`s name",request.getServerName()); // 서버이름
	map.put("method", request.getMethod()); // GET POST
	map.put("context",request.getContextPath()); // 컨텍스트패스
	map.put("uri",request.getRequestURI()); // 호스트 제외 
	map.put("url",request.getRequestURL()); // 호스트포함주소
	map.put("ip",request.getRemoteAddr()); // 원격주소
	
	for (String key : map.keySet()){
		out.println(key + " ===> " + map.get(key)+ "<br><br>" ); 
	}
	
	out.println("<h2>헤더정보</h2>"); 
	
	Enumeration<String> en = request.getHeaderNames();
	String key = ""; 
	String value = ""; 
	while(en.hasMoreElements()){ // 다음요소가 존재하면
		key=en.nextElement(); // 다음요소를 key변수에 저장
		value = request.getHeader(key); // 각 key에 해당하는 정보 저장 
		out.println(key + " ===> " + value + "<br>"); 
	}
%>
```

<br>


## Response 인코딩 메서드 
> index.jsp
```jsp
<%
	// String name = "임의의 문자열";
	String name = URLEncoder.encode("임의의 문자열", "utf-8");
	response.sendRedirect("result.jsp?name="+name); 
%>
```

<br>

> result.jsp
```jsp
<%
	// request.setCharacterEncoding("utf-8"); 이거 아님
	String name = request.getParameter("name");
	out.println(name);
%>
```

## 서버변수, 톰캣 정보, 배포경로

> index.jsp
```jsp
<%
	String info = application.getServerInfo();  // WAS정보 : 톰캣
	application.log("WAS : "+info); // 콘솔창에서 로그메세지 사용 
	String path = application.getRealPath("/"); // 배포디렉토리 
	application.log("서비스 경로" + path); 
	application.setAttribute("message", "Hello"); // 서버변수 : 서버가 종료될때 까지 이 변수는 유지된다.
%>
<a href="result.jsp">서버변수확인</a>
```
> result.jsp
```jsp
<%
	String message = (String )application.getAttribute("message");
	out.println(message);
%>
```

