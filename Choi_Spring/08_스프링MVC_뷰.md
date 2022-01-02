# ViewResolver 설정
```java
@Controller
public class HelloController {
	
    // 스프링 컨트롤러는 뷰에 의존적이 않으며 결과를 생성할 뷰이름을 지정할 뿐이다.
	@GetMapping("/hello")
	public String hello() {
		return "hello";
	}
}
```
- 스프링 컨트롤러는 뷰에 의존적이 않으며 결과를 생성할 뷰이름을 지정할 뿐이다.
- ViewResolser는 컨트롤러가 지정한 뷰 이름으로부터 응답결과화면을 생성하는 View객체를 구한다.


## ViewResolver 인터페이스 정의
```java
public interface ViewResolver {

	/**
	 * @param viewName 매핑값으로 사용할 뷰 이름 
	 * @param locale 지역화를 위한 로케일 정보
	 * @return 뷰 이름에 매핑되는 View 객체, 존재하지 않으면 null 리턴 
	 */
	@Nullable
	View resolveViewName(String viewName, Locale locale) throws Exception;
}

```

<br>

## Veiw 객체 
- ViewResolver는 뷰 객체를 리턴하며 뷰 객체는 응답결과를 생성한다. 
- 모든 뷰 클래스는 View 인터페이스를 구현한다.
> View 
```java
package org.springframework.web.servlet;


public interface View {

	String RESPONSE_STATUS_ATTRIBUTE = View.class.getName() + ".responseStatus";

	String PATH_VARIABLES = View.class.getName() + ".pathVariables";

	String SELECTED_CONTENT_TYPE = View.class.getName() + ".selectedContentType";


    // text/html과 같은 응답 결과의 컨텐트 타입을 리턴한다.
	@Nullable
	default String getContentType() {
		return null;
	}

    /**
     * 실제 응답 결과를 생성한다. 
	 * @param model 컨트롤러가 생성한 모델 데이터가 전달된다.
	 */
	void render(@Nullable Map<String, ?> model, HttpServletRequest request, HttpServletResponse response)
			throws Exception;
}

```

<br>

## InternalResourceViewResolver 설정

- InternalResourceView 타입의 뷰 리턴
- jsp, html 등과 같은 웹어플리케이션 내부자원을 이용해서 응답결과 생성
- JSTL이 존재할 경우 InternalResourceView의 하위타입은 JstlView 객체 리턴 

<br>

> 설정 방법
```xml
<bean id="viewResolver" class="org.springframework.web.servlet.view.InternalResourceViewResolver">
    <property name="prefix" value="/WEB-INF/views/"/>
    <property name="suffix" value=".jsp"/>
</bean>
```
- 컨트롤러가 지정한 뷰 이름으로부터 실제 사용될 뷰를 선택
- 컨트롤러가 지정한 뷰 이름 앞뒤로 prefix프로퍼티와 suffix프로퍼티를 추가한 값이 실제 사용될 자원의 경로이다.
- 컨트롤러에서 지정한 뷰 이름이 'hello'이면 실제사용할 뷰의 경로는 다음과 같다. 
    - /WEB-INF/views/hello.jsp

<br>

## BeanNameViewResolver 설정, 다수의 ViewResolver 설정하기 

### BeanNameViewResolver
- 뷰 이름과 동일한 이름을 갖는 빈을 뷰로 사용한다. 
- 주로 커스텀 View클래스를 뷰로 사용해야할 때 이용된다. 

<br>

### 다수의 ViewResolver 설정

- DispatcherServlet은 두 개 이상의 ViewResolver를 가질 수 있다. 
- 우선순위 값이 작을수록 우선순위가 높다. 
- 우선순위를 지정하지 않을 경우 가장 낮은 우선순위 값을 가진다.  
- InternalResourceViewResolver는 마지막 우선순위를 갖도록해야한다. 
    - InternalResourceViewResolver는 항상 뷰 이름에 맵핑되는 View객체를 리턴하므로 null을 리턴하지 않기 때문이다. 

<br>


### 예제 
> 커스텀 뷰 : View 인터페이스 구현
```java
public class MyCustomView implements View{

    // 응답결과의 컨텐트 타입 결정
	@Override
	public String getContentType() {
		return "text/html";
	}
	
	@Override
	public void render(Map<String, ?> model, HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		response.setContentType(getContentType());
		PrintWriter out = response.getWriter();
		out.print("This is My custom View<br>");
		 for (Map.Entry<String, ?> entry : model.entrySet()) {
	          out.printf("%s : %s<br/>", entry.getKey(), entry.getValue());
	      }
	}
}

```

> 컨트롤러
```java
@Controller
public class MyController {
	
	@RequestMapping("/beanNameViewTest")
	public String customMethod(Model model) {
		model.addAttribute("msg", "A message from the controller");
		model.addAttribute("hello", "hello");
		return "simpleView"; // View 객체중 id가 simpleView인 뷰 객체에 매핑된다.
	}
}
```

> 설정
```xml
<bean class="org.springframework.web.servlet.view.InternalResourceViewResolver">
		<property name="prefix" value="/WEB-INF/views/"/>
		<property name="suffix" value=".jsp"/>
		<property name="order" value="1"/>
</bean>
<bean class="org.springframework.web.servlet.view.BeanNameViewResolver">
    <property name="order" value="0"/>
</bean>
```

## 메세지 출력을 위한 설정, HTML 특수문자 처리 방식 걸정

### 메세지소스 설정
- 빈의 id는 반드시 messageSource로 지정
- messages.message는 classpath경로에 있는 messages 디렉토리 내에 message.properties 파일을 의미한다. 
    - 그 외에로케이일 지정에따라 message_ko.properties, message_en.properties 등을 읽을 수 있다. 
```xml
<bean id="messageSource" class="org.springframework.context.support.ResourceBundleMessageSource">
    <property name="basenames">
        <list>
            <value>messages.message</value>
        </list>
    </property>
    <property name="defaultEncoding" value="utf-8"/>
</bean>
```

### HTML 특수 문자 처리 방식 설정
- 메세지소스로 부터 문자열을 불러올때 특수 문자 처리여부를 defaultHtmlEscape를 통해서 지정할 수 있다. 
- defaultHtmlEscape 컨텍스트 파라미터 값을 true 또는 false로 지정한다. 
	- true :  html 코드를  텍트로 인식한다. 
	- false : html로 인식한다.
> web.xml
```xml
<context-param>
	<param-name>defaultHtmlEscape</param-name>
	<param-value>true</param-value>
</context-param>
```

## 메세지 출력을 위한 spring:message 커스텀 태그 

> message.properties
```
login.form.title = {0} : {1} 로그인 폼
html.escape.test = <span>태그 테스트</span>
request.save.test = 리퀘스트 객체에 저장 
```

<br>

- {숫자} 형식을 이용하여 변하는 부분을 명시할 수 있다. 
- argumetns속성을 통해 플레이스홀더에 들어갈 값을 설정할 수 있다. 
```jsp
<!-- -->
<spring:message code="login.form.title" arguments="${title}, ${register}" /><br>
```

<br>

- 주어진 코드에 해당하는 메세지가 존재하지않으면 익셉션 발생
- 익셉션을 발생시키는 대신 지정한 메세지를 출력하고 싶다면 text 속성에 기본메세지를 입력한다.
```jsp
<spring:message code="nomessage" text="지정한 메세지 없음"/><br>
```

<br>

- html 특수문자를 문자열로 인식하게 하려면 htmlEcape 속성을 true로 지정한다.
```jsp
<spring:message code="html.escape.test" htmlEscape="true" /><br>
```

<br>

- 출력하지 않고 자바스크립트 변수에 저장하고 싶다면 javaScriptEscape 속성을 true로 한다.
```jsp
<script>
	let form = '<spring:message code="login.form.title" javaScriptEscape="true" arguments="${title}, ${register}" />'
	console.log(form);
</script>
```

<br>

- page, request, session, application 과 같은 기본 객체에 메세지 값을 저장할 수 있다.
```jsp
<spring:message code="request.save.test" var="label" scope="request"/>
${label}
```

<br>

## 스프링이 제공하는 폼 관련 커스텀 태그 
> 커스텀 태그 설정
```jspp
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
```

### form 태그를 위한 커스텀 태그 form:form
> 커맨드 객체 : login.jsp
```java
public class LoginCommand {
	private String email;
	private String password;
	// 게터 세터
}
```

<br>

> 컨트롤러 
```java
@Controller
public class MemberController {
	
	@RequestMapping(value = "/auth/login", method=RequestMethod.GET)
	public String loginForm(LoginCommand loginCommand) {
		return "member/login";
	}
	
	@RequestMapping(value = "/auth/login", method=RequestMethod.POST)
	public String login(LoginCommand loginCommand) {
		System.out.println("로그인 처리 ");
		if(!loginCommand.getPassword().equals("1234")) {
			System.out.println("비밀번호 틀림");
			return "member/login";
		}
		return "redirect:/";
	}	
}
```

<br>

> 로그인 폼 
```jsp
<form:form modelAttribute="loginCommand" action="${pageContext.request.contextPath}/auth/login">
	<p>
		<label for="email">이메일</label>
		<input type="text" name="email" id="email" value="${loginCommand.email}">
		<form:errors path="email"/>
	</p>
	<p>
		<label for="password">비밀번호</label>
		<input type="password" name="password" id="password"/>
		<form:errors path="password"/>
	</p>	
	<input type="submit" value="로그인"/>
</form:form>
```
- method 속성의 기본값 : post
- action 속성의 기본값 : 현재 요청 URL 값

<br>

### input 태그를 위한 커스텀 태그 
- LoginCommand에 number 멤버변수를 추가하고 게터세트를 만든다. 
- 컨트롤러에서 number을 지정한다. 
```jsp
<form:form modelAttribute="loginCommand" action="${pageContext.request.contextPath}/auth/login">
	<form:hidden path="number"/> <!-- hidden 타입의 input 태그 -->
	<p>
		<label for="email">이메일</label>
		<form:input path="email"/> <!-- text 타입의 input 태그 -->
		<form:errors path="email"/>
	</p>
	<p>
		<label for="password">비밀번호</label>
		<form:password path="password"/> <!-- password 타입의 input 태그 -->
		<form:errors path="password"/>
	</p>	
	<input type="submit" value="로그인"/>
</form:form>
```

<br>

```jsp
<form:input path="email"/> 
<!--
	위의 커스텀태그는 다음과 같은 HTML태그를 생성성한다.
-->
<input type="text" id="email" name="email" value="">

```

<br>

### select 태그를 위한 커스텀 태그 
- LoginCommand 객체에 loginType 멤버변수로 추가 
> 컨트롤러
```java
// 컨트롤러에서 사용할 공통의 모델객체 지정 
@ModelAttribute("loginTypes")
protected List<String> referenceData() {
	List<String> loginTypes = new ArrayList<>(); 
	loginTypes.add("일반회원");
	loginTypes.add("기업회원");
	loginTypes.add("헤드헌터회원");
	return loginTypes; 
}
```

<br>

- form:options 태그 item 속성으로 사용할 콜렉션을 지정한다. 
- item 속성에 지정된 콜렉션의 각각의 값은 option태그 value속성의 값이된다.
> 뷰페이지
```jsp
<form:select path="loginType">
	<option>-------선택하세요--------</option>
	<form:options items="${loginTypes}"/>
</form:select>
```

<br>

- 다음은 콜렉션을 사용하지 않고 직접 지정하는 예이다.
```jsp
<form:select path="loginType">
	<option>-------선택하세요--------</option>
	<form:option value="일반회원">일반회원</form:option>
	<form:option value="기업회원">기업회원</form:option>
	<form:option value="헤드헌터회원">헤드헌터회원</form:option>
</form:select>	
```

- option 태그를 생성하는데 사용되는 콜렉션 객체가 String이 아닌 경우 
	- form:option 태그의 itemValue, itemLable 속성 사용
	- LoginCommand객체에 jobCode 멤버변수 추가 
	- Code 클래스 생성 
	- MemberController에서 모델객체로 사용할 jobCodes 콜렉션 생성
> Code
```java
public class Code {
	private String code; 
	private String label;
	
	public Code() {
		// TODO Auto-generated constructor stub
	}
	
	public Code(String code, String label) {
		this.code = code;
		this.label = label;
	}
	// 게터세터
}
```

<br>

> 컨트롤러 
```java
@ModelAttribute("jobCodes")
protected List<Code> codeReference() {
	Code c1 = new Code("0001","기획팀");
	Code c2 = new Code("0002","디자인팀");
	Code c3 = new Code("0003","인사팀");
	Code c4 = new Code("0004","개발팀");
	Code c5 = new Code("0005","영업팀");
	List<Code> jobCodes = Arrays.asList(c1,c2,c3,c4,c5);
	return jobCodes; 
}
```

> 뷰
```jsp
<form:select path="jobCode">
	<form:options items="${jobCodes}" itemValue="code" itemLabel="label"/>
</form:select>

```

<br>

### radio 타입 input 태그를 위한 커스텀 태그 
- LoginCommand 객체에 멤버변수 tool 추가, 게터세터 추가 
- 컨트롤러에서 toos 모델객체 추가 
```jsp
<p>
	<form:label path="tool">주로사용하는 개발 툴</form:label>
	<form:radiobuttons path="tool" items="${tools}"/>
</p>
```

> 컨트롤러 
```java
@ModelAttribute("tools")
protected List<String> tools(){
	List<String> tools = Arrays.asList("이클립스","인텔리제이","넷빈즈");
	return tools;
}
```

### textarea 태그를 위한 커스텀 태그 
- 커맨드 객체에 메버변수 etc 추가, 세터 게터 추가 
```jsp
<p>
	<form:label path="etc">하고싶은말</form:label>
	<form:textarea path="etc" rows="3" cols="20"/>
</p>
```

<br>

## 깂 포매팅 처리 
- 커맨드객체에 birthDay 멈베변수와 게터세터를 추가한다.
```jsp 
<p>
	<form:label path="birthDay">생일</form:label>
	<form:input path="birthDay"/>
</p>
```

<br>

> 컨트롤러
```java
@InitBinder
protected void initBindder(WebDataBinder binder) {
	CustomDateEditor dateEditor = new CustomDateEditor(new SimpleDateFormat("yyyyMMdd"), true); 
	binder.registerCustomEditor(Date.class, dateEditor);
}
```

> @InitBinder 대신 @DateTimeFormat 애노테이션 사용
```java

```