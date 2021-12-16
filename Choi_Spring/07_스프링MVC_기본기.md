
## 스프링 MVC  기본 

>pom.xml
```xml
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">
  <modelVersion>4.0.0</modelVersion>
  <groupId>xml.spring</groupId>
  <artifactId>spring_xml</artifactId>
  <version>0.0.1-SNAPSHOT</version>
  <packaging>war</packaging>
  
  <properties>
		<org.springframework-version>5.2.2.RELEASE</org.springframework-version>
  </properties>
  <dependencies>
    <!-- 스프링 MVC 의존설정-->
  	<dependency>
        <groupId>org.springframework</groupId>
        <artifactId>spring-webmvc</artifactId>
        <version>${org.springframework-version}</version>
    </dependency>
    <dependency>
        <groupId>org.springframework</groupId>
        <artifactId>spring-test</artifactId>
        <version>${org.springframework-version}</version>
    </dependency>		

    <!-- Servlet, JSP JSTL 의존설정-->
    <dependency>
        <groupId>javax.servlet</groupId>
        <artifactId>javax.servlet-api</artifactId>
        <version>3.1.0</version>
        <scope>provided</scope>
    </dependency>
    <dependency>
        <groupId>javax.servlet.jsp</groupId>
        <artifactId>jsp-api</artifactId>
        <version>2.1</version>
        <scope>provided</scope>
    </dependency>
    <dependency>
        <groupId>javax.servlet</groupId>
        <artifactId>jstl</artifactId>
        <version>1.2</version>
    </dependency>

    <!-- Test -->
    <dependency>
        <groupId>junit</groupId>
        <artifactId>junit</artifactId>
        <version>4.12</version>
        <scope>test</scope>
    </dependency>
</dependencies>
  
<build>
    <plugins>
        <plugin>
        <artifactId>maven-compiler-plugin</artifactId>
        <version>3.8.1</version>
        <configuration>
            <release>11</release>
        </configuration>
        </plugin>
        <plugin>
        <artifactId>maven-war-plugin</artifactId>
        <version>3.2.3</version>
        </plugin>
    </plugins>
</build>
</project>
```

<br><br>

> web.xml
```xml
<?xml version="1.0" encoding="UTF-8"?>
<web-app xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://xmlns.jcp.org/xml/ns/javaee" xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/javaee http://xmlns.jcp.org/xml/ns/javaee/web-app_4_0.xsd" id="WebApp_ID" version="4.0">
  <display-name>spring_xml</display-name>

  <servlet>
  	<servlet-name>dispatcher</servlet-name>
  	<servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
  	<init-param>
  		<param-name>contextConfigLocation</param-name>
  		<param-value>/WEB-INF/appServlet/servlet-context.xml</param-value>
  	</init-param>
  	<load-on-startup>1</load-on-startup>
  </servlet>
  <!-- 
  	DispatcherServlet 
  	- 내부적으로 스프링 컨테이너 생성 
  	- contextConfigLocation 초기화 파라미터를 이용해서 컨테이너 생성시 사용할 설정파일 지정 
    - 초기화 파라미터의 경로 : /WEB-INF/appServlet/servlet-context.xml
   -->
  
  <servlet-mapping>
  	<servlet-name>dispatcher</servlet-name>
  	<url-pattern>/</url-pattern>
  </servlet-mapping>
  <!-- '/'이하 모든 요청을 dispatcher 서블릿이 처리한다. -->
  
  <!-- 요청 파라미터를 UTF-8로 처리 -->
  <filter>
  	<filter-name>encodingFitler</filter-name>
  	<filter-class>org.springframework.web.filter.CharacterEncodingFilter</filter-class>
  	<init-param>
  		<param-name>encoding</param-name>
  		<param-value>UTF-8</param-value>
  	</init-param>
  </filter>
  <filter-mapping>
  	<filter-name>encodingFitler</filter-name>
  	<url-pattern>/*</url-pattern>
  </filter-mapping>
  
</web-app>
```

<br><br>

> 설정파일 작성 
- /WEB-INF/appServlet/servlet-context.xml 파일 생성
```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:mvc="http://www.springframework.org/schema/mvc"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
        http://www.springframework.org/schema/beans/spring-beans.xsd 
       http://www.springframework.org/schema/mvc
       http://www.springframework.org/schema/mvc/spring-mvc.xsd">
	
	<!-- 몇 가지 설정을 한번에 해주는 코드이다. 다음의 인터페이스를 객체를 구현한다. 
        HandlerAdapter 구현 객체 : RequestMappingHandlerAdapter
        HandlerMapping 구현 객체 : RequestMappingHanlderMapping
        이 두 객체는 @Controller 애노테이션이 적용된 클래스를 컨트롤러로 사용할 수 있게 한다.
    
    -->
	<mvc:annotation-driven/>
	
	<!-- 
        어떤 뷰로 연결할지 결정한다. 
        컨트롤러가 리턴한 문자열 값이 hello이면
        /WEB-INF/views/hello.jsp 뷰를 사용한다. 
        id 는 반드시 viewResolver로 지정해야한다.
    -->
	<bean id="viewResolver" class="org.springframework.web.servlet.view.InternalResourceViewResolver">
		<property name="prefix" value="/WEB-INF/views/"/>
		<property name="suffix" value=".jsp"/>
	</bean>	
	
	<!-- HomeController를 스프링 빈으로 등록  -->
    <bean class="xml.spring.HomeController"/>
</beans>
```

<br><br>

> 컨트롤러 
```java
@Controller // MVC 컨트롤러 클래스임을 선언
public class HomeController {
	
    // '/'으로 들어오는 요청을을 home()메서드가 처리한다. 
	@RequestMapping(value = "/", method=RequestMethod.GET)
	public String home(Model model) {
        // 뷰에서 greeting이라는 변수명으로 "Hello 스프링" 문자열 데이터를 사용할 수 있다.
		model.addAttribute("greeting", "Hello 스프링");
		return "index";
	}
}
```

<br><br>

- /WEB-INF/vies/index.jsp
> 뷰
```jsp
<body>
<!-- 컨트롤러에서 지정한 변수명으로 모델객체를 사용할 수 있다.  -->
${greeting}
</body>

```

## DispatcherServlet 설정

<br><br>

### 초기화 파라미터를 설정하지 않은 경우 
>web.xml
```xml
<servlet>
<servlet-name>dispatcher</servlet-name>
<servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
<!-- 
    별도로 초기화 파라미터를 설정하지 않았다면 [서블릿이름]-servlet.xml 파일을 스프링 설정파일로 사용한다. 
    현재 서블릿 이름이 dispatcher이므로 dispatcher-servlet.xml이 스프링 설정파일이 된다.
-->
<load-on-startup>1</load-on-startup>
</servlet>
``` 

<br><br>

### 여러개의 설정파일 사용하기 

<br>

- 초기화파라미터(스프링 설정파일)은 줄바꿈, 콤마, 공백, 세미콜론을 이용하여 구분할 수 있다. 
- 아래 예시는 줄바꿈으로 구분했다.

<br>

> web.xml
```xml
<servlet>
 	<servlet-name>dispatcher</servlet-name>
 	<servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
 	<init-param>
 		<param-name>contextConfigLocation</param-name>
 		<param-value>
 			/WEB-INF/spring/appServlet/servlet-context.xml
 			/WEB-INF/spring/root-context.xml
 		</param-value>
 	</init-param>
 	<load-on-startup>1</load-on-startup>
</servlet>
```

<br><br>

- 테스트를 위해 TestController를 만들고 root-context.xml에 스프링빈으로 등록한다.
```java
@Controller
public class TestController {
	
	@GetMapping("/test")
	public String test() {
		return "test"; // 이에 상응하는 veiw를 만든다. 이 예제에선 생략하겠다.
	}
}
```

<br><br>

- /WEB-INF/spring/root-context.xml 파일생성
> root-context.xml
```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:mvc="http://www.springframework.org/schema/mvc"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
        http://www.springframework.org/schema/beans/spring-beans.xsd 
       http://www.springframework.org/schema/mvc
       http://www.springframework.org/schema/mvc/spring-mvc.xsd">

<mvc:annotation-driven/>

<!-- TestController를 스프링 빈으로 등록-->
<bean class="com.spring.TestController"/>
	
</beans>
```

<br>

### web.xml에 자바설정 등록 

> 자바기반 설정
```java
package com.spring;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.servlet.view.InternalResourceViewResolver;

@Configuration
@EnableWebMvc
public class MvcConfig {
	
	@Bean
	public InternalResourceViewResolver viewResolver() {
		InternalResourceViewResolver viewResolver =
				new InternalResourceViewResolver();
		viewResolver.setPrefix("/WEB-INF/views/");
		viewResolver.setSuffix(".jsp");
		return viewResolver;
	}
	
	@Bean
	public HomeController homeController() {
		return new HomeController();
	}
}
```

<br><br>

> web.xml
```xml
<servlet>
 	<servlet-name>dispatcher</servlet-name>
 	<servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
 	<init-param>
        <!-- @Configuration 기반의 자바설정을 사용할 수 있게 해준다.-->
 		<param-name>contextClass</param-name>
        <param-value>
             org.springframework.web.context.support.AnnotationConfigWebApplicationContext
        </param-value>
 	    </init-param>
        <!-- 
            자바기반 설정파일을 지정한다. 
            다수의 설정정보는 콤마,세미콜론,공백,탭 줄바꿈으로 구분한다.        
        -->
        <init-param>
            <param-name>contextConfigLocation</param-name>
            <param-value>
                com.spring.MvcConfig 
            </param-value>
        </init-param>
 	<load-on-startup>1</load-on-startup>
</servlet> 
```

