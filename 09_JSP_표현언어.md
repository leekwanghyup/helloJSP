
## 연산 및 오류 
```jsp
<h2>표현언어</h2>
<%-- ${주석} --%>
<%-- 
	표현식에 오류가 있으면
	 org.apache.jasper.JasperException: 
	 javax.el.ELException: 
	 Failed to parse the expression ~
--%>
덧셈 : ${10+5 } <br>
뺄셈 : ${10-5 } <br>
나머지 ${10 mod 3 } <br>
비교연산 ${2 < 4 } <br>
비교연산 ${2 > 4 } <br>
```
<br>

## request.getParameter()를 표현언어로
```jsp
<h2>표현언어</h2>
<!-- action이 생략되면 현재페이지로 제출한다. -->
<!-- ${param.name}은 request.getParameter("name")과 동일하다.-->
<!-- request.getParameter("name")와 달리 값이 null인 경우 문자열은 빈문자열로 숫자는 0으로 처리한다.  -->
<form method="result.jsp">
	이름 : <input name="name" value="${param.name}"><br>
	이메일 : <input name="email" value="${param.email}"><br>
	<button>확인</button>
</form>
이름 :  ${param.name} <br>
이메일 : ${param.email }<br>
```

## session.getAttribue()를 표현언어로
```jsp
<%
	session.setAttribute("name", "leekwnaghyup");
	session.setAttribute("email", "lee@example.com");
	out.print("세션 생성<br>");
%>
<!-- 설정된 세션을 다음과 같이 사용할 수 있다. -->
<!-- ${param.속성}과 동일한 방법으로 null을 처리한다. -->
이름 : ${sessionScope.name } <br>
이메일 : ${sessionScope.email } <br>
```

## 표현언어로 자바객체접근

### 해쉬맵
```jsp
<%
	Map<String, String> map = new HashMap<>(); 
	map.put("Ahn","안정환");
	map.put("Choi","최용수");
	map.put("Hwang","황선홍");
	request.setAttribute("map", map);
    // 여기서 설정한 속성을 다른페이지에서 사용하려면 forward로 이동해야한다.
%>
<jsp:forward page="/result.jsp"/>
```

<br>

> result.jsp
```jsp
<h2>해쉬맵</h2>
<h3>접근방법1</h3>
${map.Hwang} <br>
${map.Choi} <br>
${map.Ahn} <br>
${map.Kim} <br> <!-- null 인 경우 -->

<h3>접근방법2</h3>
${map["Hwang"]} <br>
${map["Ahn"]} <br>
${map["Choi"]} <br>
```

### DT0객체 표현언로 접근 
```jsp
<%
	MemberDTO member = new MemberDTO();
	member.setUserid("lee");
	member.setPassword("1234");
	member.setName("leekwanghyup");
	request.setAttribute("member", member);
%>
<jsp:forward page="/result.jsp"/>
```
> result.jsp
```jsp
<h2>객체접근</h2>

<!-- 객체에 접근하기 위해서 반드시 getter메서드가 있어야한다. -->
<!-- MemberDTO 객체에서 getUserid() 또는 getuserid() 메서드를 호출한다. -->
${member.userid} <br>
${member.password} <br>
${member.name } <br>

```

## JSTL
- jstl-1.2.jar파일 다운로드 후 빌드 패스추가 

```jsp
<!-- 코어태그 사용-->
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="length" value="10"/> <!-- 변수 선언 및 초기화-->
<c:forEach var="i" begin="1" end="${length}"> <!-- 인덱스 반복문 -->
	<c:set var="sum" value="${sum+i}"/> <!-- 1~10까지의 합 -->
</c:forEach>
<p>${sum}</p>
```

<br>

### 객체에 순차적으로 접근하는 반복문 
```jsp
<%
	List<String> fruits = new ArrayList<>();
	fruits.add("사과");
	fruits.add("딸기");
	fruits.add("키위");
	fruits.add("바나나");
	request.setAttribute("fruits", fruits); 
%>

<c:forEach items="${fruits}" var="f">
	${f}<br>
</c:forEach>
```
<br>

## 조건문 
```jsp
<c:set var="num" value="9"/>
<c:if test="${num >= 10}">
	<p>10보다 크거나 같음</p>
</c:if>
<c:if test="${num < 10}">
	<p>10보다 작음</p>
</c:if>
```

<br>

## 다중 조건문
- if else 문과 스위치문의 혼합형태
```jsp
<c:set var="num" value="12"/>
<c:choose>
	<c:when test="${num >= 10}">
		<p>10보다 크거나 같음</p>
	</c:when>
	<c:otherwise>
		<p>10보다 작음</p>
	</c:otherwise>
</c:choose>
```

<br>

```jsp
<c:set var="subject" value="${param.sub}"/>
<c:choose>
	<c:when test="${subject eq 'spring'}">
		<h2>스프링 프레임워크</h2>
	</c:when>
	<c:when test="${subject eq 'java'}">
		<h2>자바</h2>
	</c:when>
	<c:when test="${subject eq 'mysql'}">
		<h2>MySQL</h2>
	</c:when>
	<c:otherwise>
		<h2>해당목록 없음</h2>
	</c:otherwise>
</c:choose>
```