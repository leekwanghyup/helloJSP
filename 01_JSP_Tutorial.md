## JDK 설치 및 환경변수 설정

<br>

## STS 설치 

<br>

## Dynamic Web Project 애드온 설치 
- Eclipes Enterpise JAVA and Web Developer Tool

<br>

## UTF-설정

<br>

## 아파치 톰캣 9.0 설치


## 스크립틀릿
```jsp
<% 
	String str = "Hello JSP"; // 스크립틀릿 자바코드 작성
    String str2 = "한글출력!";
%>
<!-- expression 표현식 변수에 저장된 값 html로 출력 -->
<h2> message :  <%= str %> </h2>
<h2> message :  <%= str2 %> </h2>
```

## out 내장객체 
```jsp
<% 
for(int i=6; i>=1; i--){
	out.println("<h"+i+">Heading</h"+"i"+">");
}
%>
```


<br>

## 표현식 스크립틀릿 html 함께사용

```jsp
<%
	for(int i=1 ; i<=14; i++ ){
		String color = i%2 == 0 ? "red" : "blue";
%>
		<p style="color : <%= color %>;">hello</p>
<% 
	}
%>
```

## import문과 날짜객체 형식화
```jsp
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>

<%
	Date nowDate = new Date(); 
	out.println(" 형식화 전  : "+nowDate+"<br>"); 
	SimpleDateFormat dateFormat = 
			new SimpleDateFormat("yyyy년 MM월 dd일 a HH:mm:ss");
	String formatDate = dateFormat.format(nowDate);
%>

현재 날짜는 <%= formatDate %> 입니다.
```

## include 사용 
> sub.jsp 생성
```jsp
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% 
	String msg = "Hello JSP";
	String background = "yellow"; 
%>
```

> common.Constans 클래스 생성
```java
public class Constans {
	public static final int MAX = 100; 
}
```

> index.jsp
```jsp
<%@page import="common.Constans"%>
<!-- sub.jsp 파일에서 선언 및 할당한 변수를 사용할 수 있다. -->
<%@ include file="sub.jsp" %>
<style>
body { 
	background : <%= background %> 
}
</style>
<!-- ... -->
<h2>MAX : <%= Constans.MAX %></h2>
```

## 향상된 for문
```jsp
<%
String[] arr = { "Mast", "Computer", "Book", "Glove", "Cup" }; 
%> 
<ul>
<% for(String s : arr) {%>
	<li><%= s %></li>
<% } %>	
</ul>
```

## Request 객체 getParameter() 한글처리  
```jsp
<form action="proceed.jsp" method="post">
	텍스트 : <input type="text" name="input_text"><br>
    <input type="radio" name="natural" value="홀수" checked> 홀수
    <input type="radio" name="natural"  value="짝수" > 짝수
    <input type="submit" value="전송">
</form>
```
```jsp
<% 
	request.setCharacterEncoding("utf-8"); // 받는쪽에서 인코딩을 한다.
	String inputText = request.getParameter("input_text");
	String natrualNumber = request.getParameter("natural");
%>    
입력한 텍스트 : <%= inputText %><br>
홀수 또는 짝수 ? :  <%= natrualNumber  %><br>
```

<br>

## Request 객체 getParameterValues() 컨텍스트패스
> index.jsp
```jsp
<% 
	String root_path = request.getContextPath(); // 컨텍스트패스 
%>

<form action="<%= root_path %>/proceed.jsp" method="post">
	<p>선택하세요</p>
	<input type="checkbox" value="버즈" name="singer" >버즈
	<input type="checkbox" value="김종국" name="singer">김종국
	<input type="checkbox" value="KCM" name="singer">KCM
	<input type="checkbox" value="SG워너비" name="singer">SG워너비
	<input type="checkbox" value="최재훈" name="singer">최대훈
	<br>
	<button>OK</button>
</form>

```

> proceed.jsp
```jsp
<% 
	request.setCharacterEncoding("utf-8");
	String[] singers = request.getParameterValues("singer"); // 배열로 받음 
	if(singers != null){
		for(String singer : singers ){
			out.println(singer + "<br>");	
		}	
	}
	
%>
```

<br>

## 유효성 검사 후 자바스크립트로 submit, 타입 캐스팅 
> indext.jsp
```jsp
<form action="" method="" id="form">
	가격 :  <input type="text" name="price"><br>
	수량 :  <input type="text" name="amount"><br>
	<button type="button" onclick="check();">OK</button>
</form>
```
```js
function check() 
{
	let $form = document.getElementById('form');
	let $price  = document.getElementsByName('price')[0];
	let $amount  = document.getElementsByName('amount')[0];
	
	let price = $price.value.trim();
	let amount = $amount.value.trim(); 
	if(price == '' || amount == '' )
	{
		alert('값을 입력하세요');		
		$price.focus(); // 해당 input 태그에 마우스 커서 위치함
		return; 
	}
	
	if(isNaN(price)) // 숫자가 아니면 true 반환 
	{
		alert('올바른 값을 입력하세요'); 
		$price.focus();
		return; 
	}
	
	if(isNaN(amount))
	{
		alert('올바른 값을 입력하세요'); 
		$amount.focus();
		return; 
	}
	
	$form.method = "get"; // 폼태그 메서드 설정
	$form.action = "<%= root_path %>/proceed.jsp"; // 폼태그 action 설정
	$form.submit(); 	
}
```

<br>

> proceed.jsp
```jsp
<% 
	int price = Integer.valueOf(request.getParameter("price")); // 타입 캐스팅
	int amount = Integer.valueOf(request.getParameter("amount"));
	// int amount = Integer.parseInt(request.getParameter("amount"));
	int total = price * amount; 
%>
가격 : <%= price  %>원 <br>
수량 : <%= amount %>개 <br>
합계 : <%= total %>원 <br>
```

<br>

## 입력받은 값을 텍스트로 html 문서에 출력

> index.jsp
```jsp
<form action="proceed.jsp" method="post" id="form">
	<textarea rows="5" cols="30" name="subject" placeholder="여기에 입력하세요 .... "></textarea>
	<button>확인</button>
</form>
```

> HtmlSpecialChars.java
```java
package util;

public class HtmlSpecialChars {

	public static String convertToHtml(String str) {
		String result = str.replace("<", "&lt");
		result = result.replace(">", "&gt");
		result = result.replace("\n", "<br>"); // 줄바꿈처리 
		result = result.replace("  ", "&nbsp;&nbsp;"); // 공백처리 
		return result;  
	}
}
```

> proceed.jsp
```jsp
<% 
	request.setCharacterEncoding("utf-8"); 
	String subject = request.getParameter("subject");
	subject = HtmlSpecialChars.convertToHtml(subject);
%>

<p><%= subject  %></p>
```

<br>

## select 박스 데이터 받기 

> index.jsp
```jsp
<form action="proceed.jsp" method="post" id="form">
	<select name="major">
		<option value="법학" >법학</option>
		<option value="기계공학" >기계공학</option>
		<option value="경제학" >경제학</option>
		<option value="경영학" >경영학</option>
	</select>
	<button>확인</button>
</form>
```

> proceed.jsp
```jsp
<% 
	request.setCharacterEncoding("utf-8"); 
	String major = request.getParameter("major");
%>

<p><%= major  %></p>
```

## 전화번호 형식 
> index.jsp
```jsp
<form action="proceed.jsp" method="post" id="form">
	<input type="tel" name="tel" required pattern="[0-9]{2,3}-[0-9]{4}-[0-9]{4}"
	title="###-####-####" placeholder="###-####-####">
	<button>확인</button>
</form>
```

<br>


## 팝업창 
> index.jsp
```jsp
<form>
	이름을 입력하세요  <input type="text" name="str"> <br>
	<button type="button" onclick="popup();">팝업</button>
	<p><span class="popval"></span></p>
</form>
```
```js
function popup(){
	let str = document.getElementsByName("str")[0].value;
	open("pop.jsp?str="+str,"pop1","width=500,height=400, left=200, top=100");	
}
```

<br>

> pop.jsp
```jsp
<%
	request.setCharacterEncoding("utf-8");
	String str = request.getParameter("str");
	if(str == null){ str = ""; }
%>
	<h3>2022년 대선후보 선호도 조사</h3>
	<p> 이름 : <%= str  %> </p>
	<p>당신이 선호하는 대선 후보는? </p>
	<input type="radio" name="candidate" value="이재명" checked>이재명 <br> 
	<input type="radio" name="candidate" value="윤석열">윤석열 <br> 
	<input type="radio" name="candidate" value="안철수">안철수 <br>
	<input type="radio" name="candidate" value="심상정">심상정 <br>
	<button type="button" onclick="winclose()">선택 후 닫기</button>
```
```js
function winclose() {
	let checkedValue = document.querySelector("input[name='candidate']:checked").value;
	opener.document.querySelector(".popval").innerHTML = "당신의 선택 : " + checkedValue; // 부모창에 접근 	
	window.close();
}
```

<br>

## 서블릿 

> index.jsp
```jsp
<form action="/jsp01/sum.do" method="post">
	숫자 입력 : <input type=text name="number">
	<button>확인</button>
</form>
```

> SumController.java
```java
package controller;

/* ..  */

@WebServlet("/sum.do") // 맵핑 정보 : 이 URL 의 모든 요청은 이 컨트롤러가 받는다. 
public class SumController extends HttpServlet {
	
	private static final long serialVersionUID = 1L;
       
    public SumController() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		//GET 방식의 모든 요청은 여기서 처리한다.
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// POST방식의 모든 요청은 여기서 처리한다. 
		int number = Integer.parseInt(request.getParameter("number")); // 클라이언트에서 받은 파라미터 
		int sum = 0; 
		for(int i=1 ; i<= number ; i++) {
			sum+=i; 
		}
		request.setAttribute("total", sum); // 결과를 출력하는 페이지에서 total 속성을 사용하여 sum 값을 사용할 수 있다.  
		RequestDispatcher rd = request.getRequestDispatcher("/sum_result.jsp"); // 디스페처 생성(출력페이지) - 이동할 주소 설정
		rd.forward(request, response); // 설정된 주소로 이동한다. 
	}

}
```

```jsp
<% 
	int sum = (Integer)request.getAttribute("total"); // Object를 반환하므로 반드시 형변환을 해야한다. 
%>
결과 : <%= sum %>
```

<br>

## jsp:forward 

> index.jsp
```jsp
<%
	request.setAttribute("name", "곽상도");
	request.setAttribute("email", "Sangdo@naver.com");
%>
<jsp:forward page="sangdo.jsp" />
```

> sangdo.jsp
```jsp
이름 : <%= request.getAttribute("name") %> <br>
이메일 : <%= request.getAttribute("email") %> <br>
```

