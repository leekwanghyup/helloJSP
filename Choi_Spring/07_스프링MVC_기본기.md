
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
	
	<!-- 몇 가지 설정을 한번에 해주는 코드이다. 뒤에서 알아본다.  -->
	<mvc:annotation-driven/>
	
	<!-- 
        어떤 뷰로 연결할지 결정한다. 
        컨트롤러가 리턴한 문자열 값이 hello이면
        /WEB-INF/views/hello.jsp 뷰를 사용한다. 
    -->
	<bean id="viewResolver" class="org.springframework.web.servlet.view.InternalResourceViewResolver">
		<property name="prefix" value="/WEB-INF/views/"/>
		<property name="suffix" value=".jsp"/>
	</bean>	
	
	<!-- HomeController를 스프링 빈으로 등록  -->
    <bean class="xml.spring.HomeController"/>
</beans>
```