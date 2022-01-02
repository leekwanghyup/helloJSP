## Enviroment 구하기 
```java
AnnotationConfigApplicationContext ctx = 
		new AnnotationConfigApplicationContext(AppConfig.class);

// getEnviroment메서드를 이용해서 Enviroment 객체를 구한다. 
// 하위 타입인 ConfigurableEnvironment 반환한다.  
ConfigurableEnvironment environment = ctx.getEnvironment();

// setActiveProfiles 메서드를 이용해서 사용할 프로필을 추가할 수 있다. 
environment.setActiveProfiles("dev","local");

String[] activeProfiles = environment.getActiveProfiles();
System.out.println(Arrays.toString(activeProfiles));
```

<br>

## Enviroment에 새로운 Porpertysource 추가 

- 클래스패스에 db.properties을 다음과 같이 작성한다.
> db.properties
```
db.driver=com.mysql.jdbc.Driver
db.jdbcUrl=jdbc:mysql://host/test
db.user=lee
db.password=1234
```

<br>


```java
public static void main(String[] args) {
    
    AnnotationConfigApplicationContext ctx = 
    new AnnotationConfigApplicationContext(AppConfig.class);
    
    ConfigurableEnvironment env = ctx.getEnvironment();
    
    // 스프링은 기본적으로 환경변수와 시스템 프로퍼티만 Enviroment의 프로퍼티로 사용한다.
    // 프로퍼티 파일을 Enviroment의 프로퍼티에 추가하려면 그에 맞는 PropertySource를 추가해야한다. 
    // MutablePropertySources 새로운 PropertySource를 추가하는 메소드를 제공한다. 
    MutablePropertySources propertySources = env.getPropertySources();
    
    ResourcePropertySource resource;
    try {
        // ResourcePropertySource 자바 프로퍼티 파일로부터 값을 읽어오는 PropertySource를 구현한 클래스다. 
        resource = new ResourcePropertySource("classpath:/db.properties");
        
        // addLast()메소드를  사용하면 파라미터로 전달한 PropertySource를 마지막에 등록한다. 
        // 탐색의 우선순위가 제일 낮다. 반대로 addFirst() 메서드를 사용하면 우선순위가 가장 높아진다. 
        propertySources.addLast(resource);
        
        String driver = env.getProperty("db.driver");
        String url = env.getProperty("db.jdbcUrl");
        String name = env.getProperty("db.user");
        String password = env.getProperty("db.password");
        String[] props = {driver, url, name, password}; 
        
        System.out.println(Arrays.toString(props));
        
    } catch (IOException e) {
        e.printStackTrace();
    }
    ctx.close();	
}

```

<br>

## 자바설정에서 Enviroment에 프로퍼티 파일 추가하기

<br>

> ConnectionPool
```java
public class ConnectionPool {
	
	private String driver; 
	private String url; 
	private String username; 
	private String password;
    // 세터 게터 투스트링 
}
```

> AppConfig
```java
// @PropertySource 어노테이션을 이용해서 프로퍼티 파일의 내용을 PropertySource에 추가할 수 있다.
@Configuration
@PropertySource(value = {"classpath:/db.properties"}) // 두 개이상 설정 할 수 있다. 
public class AppConfig {
	
	@Autowired
	private Environment env;
	
	@Bean
	public ConnectionPool pool() {
		ConnectionPool pool = new ConnectionPool();
		pool.setDriver(env.getProperty("db.driver"));
		pool.setUrl(env.getProperty("db.jdbcUrl"));
		pool.setUsername(env.getProperty("db.user"));
		pool.setPassword(env.getProperty("db.password"));
		return pool;
	}
}

```

<br>

```java
@Configuration
@PropertySource(
    value = {"classpath:/db.properties", "classpath:/app.properties"}, 
    ignoreResourceNotFound = true
)
public class AppConfig {
// ignoreResourceNotFound 속성을 true로 지정하면 
// 파일을 찾지 못하는 경우에도  익셉션이 발생하지않는다.

}
```

```java
// 여러개의 @PropertySource 애노테이션을 사용할 수 있다. 
@Configuration
@PropertySources({
	@PropertySource(value = {"classpath:/dbforOracle.properties"}), 
	@PropertySource(value = {"classpath:/app.properties"}, ignoreResourceNotFound = true),
})
public class AppConfig {
/* ... */
```

<br>

## 스프링 빈에서 Enviroment 사용 : EnvironmentAware 인터페이스 구현
> db.properties
```
db.driver=com.mysql.jdbc.Driver
db.jdbcUrl=jdbc:mysql://host/test
db.user=lee
db.password=1234
```
<br>

> ConnectionPool
```java
// EnvironmentAware 인터페이스를 구현하면 스프링컨테이너는 빈 객체를 생성 후 
// setEnviroment메서드를 호출하여 컨테이너가 사용하는 Enviroment 객체를 파라미터로 전달한다. 
public class ConnectionPool implements EnvironmentAware{
	
	private String driver; 
	private String url; 
	private String username; 
	private String password;
	// setEnvironment 메서드로부터 전달 받은 Enviroment 객체를 저장 
	private Environment env;   
	
	// 빈 객체 생성 후 스프링 컨테이너는 이 메서드를 호출한다. 
	@Override
	public void setEnvironment(Environment environment) {
		this.env = environment; 
	}
	
	// 설정정보에서 초기화 메서드로 등록한다.
	public void init() {
		this.driver = env.getProperty("db.driver");
		this.url = env.getProperty("db.jdbcUrl");
		this.username = env.getProperty("db.user");
		this.password = env.getProperty("db.password"); 
	}

	@Override
	public String toString() {
		return "ConnectionPool [driver=" + driver + ", url=" + url + ", username=" + username + ", password=" + password
				+ "]";
	}
}
```

<br>

> AppConfig
```java
@Configuration
@PropertySource(value = {"classpath:/db.properties"})
public class AppConfig {
	
	@Bean(initMethod = "init")
	public ConnectionPool pool() {
		return new ConnectionPool();
	}
}
```

<br>

## 스프링 빈에서 Enviroment 사용 : @Autowired 사용

> db.properties
```
db.driver=com.mysql.jdbc.Driver
db.jdbcUrl=jdbc:mysql://host/test
db.user=lee
db.password=1234
```
<br>

>  ConnectionPool
```java
public class ConnectionPool {
	
    // 애노테이션 기반 의존 설정이 활성화되어있다면 @Autowired로 Enviroment에 객체에 접근할 수 있다. 
	@Autowired
	private Environment env;
	
	private String driver; 
	private String url; 
	private String username; 
	private String password;
	   
	@PostConstruct
	public void init() {
		this.driver = env.getProperty("db.driver");
		this.url = env.getProperty("db.jdbcUrl");
		this.username = env.getProperty("db.user");
		this.password = env.getProperty("db.password"); 
	}

	@Override
	public String toString() {
		return "ConnectionPool [driver=" + driver + ", url=" + url + ", username=" + username + ", password=" + password
				+ "]";
	}
}

```

<br>

> 자바설정
```java
@Configuration
@PropertySource(value = {"classpath:/db.properties"})
public class AppConfig {
	
	@Bean
	public ConnectionPool pool() {
		return new ConnectionPool();
	}
}
```

- xml에서 동일한 설정을 어떻게 할까?

<br>

## XML 에서 프로퍼티 설정 

<br>

```
db.driver=com.mysql.jdbc.Driver
db.jdbcUrl=jdbc:mysql://host/test
db.user=lee
db.password=1234
```

<br>

```java
public class ConnectionPool {
	private String driver; 
	private String url; 
	private String username; 
	private String password;
    /* ... 
    게터 세터 투스트링
    */
}
```

<br>

```xml
<context:property-placeholder location="classpath:/db.properties" />
    
<bean id="pool" class="common.ConnectionPool">
    <property name="driver" value="${db.driver}"/>
    <property name="url" value="${db.jdbcUrl}"/>
    <property name="username" value="${db.user}"/>
    <property name="password" value="${db.password}"/>
</bean>
```

- 두 개이상의 프로퍼티 파일을 사용하고 싶다면 각 프로퍼티 파일을 콤마로 구분한다.
```xml
<context:property-placeholder location="classpath:/db.properties, classpath:app.properties" />
```

## Configuration 애노테이션을 이용하는 자바설정에서 프로퍼티 사용
> db.properties
```
db.driver=com.mysql.jdbc.Driver
db.jdbcUrl=jdbc:mysql://host/test
db.user=lee
db.password=1234
```
<br>

> ConnectionPool
```java
public class ConnectionPool {
	private String driver; 
	private String url; 
	private String username; 
	private String password;
    /*
        게터 세터 투스트링
    */
}
```

<br>

```java
@Configuration
public class AppConfig {
	
    // PropertySourcesPlaceholderConfigurer는 플레이스홀더의 값을 프로퍼티의 값으로 치환한다.
	@Value("${db.driver}")
	private String driver;
	
	@Value("${db.jdbcUrl}")
	private String url; 
	
	@Value("${db.user}")
	private String username; 
	
	@Value("${db.password}")
	private String password;
	
	
	// BeanFacotoryPostProcessor 인터페이스를 구현한다. 
	// 스프링은 이 인터페이스를 구현한 클래스를 빈 객체로 먼저 생성한다. 
	// 반드시 정적 메서드로 빈을 등록해야한다. 
	@Bean
	public static PropertySourcesPlaceholderConfigurer properties() {
		// xml설정에서 <context:property-placeholder> 태그는 이 객체를 빈으로 등록한다. 
		PropertySourcesPlaceholderConfigurer configurer = new PropertySourcesPlaceholderConfigurer();
		
		// 클래스패스로부터 정적 자원일 읽는다. setLocation메서드의 파라미터로 전달된다.
		ClassPathResource resource = new ClassPathResource("db.properties");
		configurer.setLocation(resource);
		return configurer;
	}
	
	@Bean
	public ConnectionPool pool() {
		ConnectionPool pool = new ConnectionPool();
		pool.setDriver(driver);
		pool.setUrl(url);
		pool.setUsername(username);
		pool.setPassword(password);
		return pool;
	}	
}
```

<br>

> 실행
```java
public static void main(String[] args) {
    AnnotationConfigApplicationContext ctx = new AnnotationConfigApplicationContext(AppConfig.class);
    ConnectionPool pool = ctx.getBean("pool",ConnectionPool.class); 		
    System.out.println(pool.toString());
    ctx.close();	
}
```

<br>

> @PropertySource 애노테이션과 함께 사용
```java
@Configuration
@PropertySource("classpath:/db.properties")
public class AppConfig {
    /* ... */

    @Bean
	public static PropertySourcesPlaceholderConfigurer properties() {
		PropertySourcesPlaceholderConfigurer configurer = new PropertySourcesPlaceholderConfigurer();
		// setLocation 메서드가 할일을 @PropertySource 애노테이션에서 한다.
		return configurer;
	}


    /* ... */
}
```

<br>

## XML 설정에서 프로필 사용하기 

<br>

> 테스트 할 스프링 빈 객체 
```java
public class Book {
	
	private String bookName;

	public Book(String bookName) {
		this.bookName = bookName;
	}

	@Override
	public String toString() {
		return "Book [bookName=" + bookName + "]";
	}
}
```

<br>

> config-dev.xml
```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans profile="dev"> <!-- 나머지 속성 생략 -->
    <!-- beans 태그의 profile 속성에 프로필 이름을 등록한다.-->

	<bean id="book" class="common.Book">
    	<constructor-arg value="최범균 스프링"/>
    </bean> 

</beans>
```

<br>

> config-prod.xml
```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans  profile="prod"> <!-- 나머지 속성 생략 -->
    
    <bean id="book" class="common.Book">
    	<constructor-arg value="토비의 스프링"/>
    </bean>

</beans>

```

<br>

> 실행
```java
public static void main(String[] args) {

    // 생성과 동시에 설정 파일을 초기화하면 안된다
    GenericXmlApplicationContext ctx = new GenericXmlApplicationContext();
    
    // Enviroment 객체를 얻어서 어떤 프로필을 사용할 것인지 지정한다. 
    // 지정한 설정파일을 바꿔 가며 실행해보자. 
    ctx.getEnvironment().setActiveProfiles("prod");

    // 설정파일 지정한다. 
    ctx.load("classpath:config-dev.xml", "classpath:config-prod.xml");
    ctx.refresh(); 
    
    Book book = ctx.getBean("book",Book.class);
    System.out.println(book);
    
    ctx.close();	
}
```

<br>

### beans 태그 중첩과 프로필 
> config.xml
```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
	xmlns:context="http://www.springframework.org/schema/context"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xsi:schemaLocation="http://www.springframework.org/schema/beans 
    https://www.springframework.org/schema/beans/spring-beans.xsd">

    <!-- beans태그를 중첩하고 profile 속성 값을 지정한다. -->    
    <beans profile="prod">
    	<bean id="book" class="common.Book">
    		<constructor-arg value="토비의 스프링"/>
    	</bean>
    </beans>
    

    <beans profile="dev">
    	<bean id="book" class="common.Book">
    		<constructor-arg value="최범균 스프링"/>
    	</bean>
    </beans>   	
</beans>
```

<br>

> 실행
```java
public static void main(String[] args) {
    GenericXmlApplicationContext ctx = new GenericXmlApplicationContext();
    ctx.getEnvironment().setActiveProfiles("dev"); 
    ctx.load("classpath:config.xml"); 
    ctx.refresh(); 
    
    Book book = ctx.getBean("book",Book.class);
    System.out.println(book);
    
    ctx.close();	
}

```

<br>

## 자바설정에서 프로필 사용하기 
> 테스트 할 스프링 빈 객체 
```java
public class Book {
	
	private String bookName;

	public Book(String bookName) {
		this.bookName = bookName;
	}

	@Override
	public String toString() {
		return "Book [bookName=" + bookName + "]";
	}
}
```

<br>

> 설정파일 
```java
@Configuration
@Profile("dev")
public class ConfigDev {
	
	@Bean
	public Book book() {
		return new Book("토비의 스프링");
	}
}
```

```java
@Configuration
@Profile("prod")
public class ConfigProd {
	
	@Bean
	public Book book() {
		return new Book("최범균 스프링 4.0");
	}
}
```

<br>

> 실행
```java
public static void main(String[] args) {
    AnnotationConfigApplicationContext ctx = new AnnotationConfigApplicationContext();
    ctx.getEnvironment().setActiveProfiles("prod");
    ctx.register(ConfigDev.class, ConfigProd.class); // xml에서는 load 자바설정에선 register
    ctx.refresh(); 
    
    Book book = ctx.getBean("book",Book.class);
    System.out.println(book);
    
    ctx.close();	
}
```

<br>

### 중첩 @Configuration을 이용한 프로필 설정

```java
@Configuration
public class AppConfig {

    // 중첩 클래스로 구성한다. 
	@Configuration
	@Profile("prod")
	public class ProdProfile{
		@Bean
		public Book book() {
			return new Book("자바 이펙티브");
		}
	}
	
	@Configuration
	@Profile("dev")
	public class DevProfile{
		@Bean
		public Book book() {
			return new Book("프로스프링5");
		}
	}
}
```

<br>

> 실행
```java
public static void main(String[] args) {
	
	AnnotationConfigApplicationContext ctx = new AnnotationConfigApplicationContext();
	ctx.getEnvironment().setActiveProfiles("prod");
	ctx.register(AppConfig.class); 
	ctx.refresh(); 
	
	Book book = ctx.getBean("book",Book.class);
	System.out.println(book);
	
	ctx.close();	
}
```

<br>

### 다수의 프로필 사용
```xml
<!--  콤마로 구분 -->
<beans profile="prod, Qa, dev">
```
```java
@Configuration
@Profile("prod, Qa, dev")
public class DevProfile{ /* ... */ }
```

<br>

## MessageSource 사용하기 

<br>

### XML 설정에서 ResourceBundleMessageSource 빈 등록
```xml
<!--
    - !!!주의 스프링 빈 이름이 반드시 messageSource 이어야한다.
    - 클래스패스기준으로 message폴더에 다음의 파일을 읽을 수 있다. 
        - greeting.properties
        - errors.properties
    - 로케일이 지정되지 않으면 위의 파일을 읽는다. 
    - 로케일 지정에 따라 다음의 파일들을 읽을 수 있다. 
        - greeting_ko.properties
        - greeting_en.properties
        - greeting_en_UK.properties
        - errors_ko.properties  
        - errors_en.properties  
        - errors_en_UK.properties  
-->
<bean id="messageSource" class="org.springframework.context.support.ResourceBundleMessageSource">
    <property name="basenames">
        <list>
            <value>message.greeting</value> <!-- 클래스패스에 위치한 message는 폴더이다-->
            <value>message.errors</value> <!-- 확장자명 properties를 적지 않는다.-->
        </list>
    </property>
<property name="defaultEncoding" value="UTF-8"/> <!-- UTF-8로 지정된 파일을 올바르게 읽어온다. -->
```

<br>

> 메세지 프로퍼티 파일 등록

- greeting.properties
```
greeting.welcome = {0} 님 반갑습니다. 여기는 {1} 입니다.
```

- greeting_en.properties
```
greeting.welcome = {0}, Welcome to the {1}!.
```

- errors.properties
```
length.usename = 이름은 {0} ~ {1} 글자어이야 합니다.
```

<br>

> 실행 
```java
public static void main(String[] args) {
    
    GenericXmlApplicationContext ctx = new GenericXmlApplicationContext("classpath:/config.xml");
//		AnnotationConfigApplicationContext ctx = new AnnotationConfigApplicationContext(AppConfig.class);
    
    String[] params = {"이재원","서울"}; // 인덱스 값 기준으로 {0} {1} .. 등의 플레이스홀더에 치환된다.  

    // 파라미터 : 프러퍼티 파일의 프러퍼티, 플레이스홀더 값, 로케일지정
    String welcome = ctx.getMessage("greeting.welcome", params, Locale.getDefault());
    
    // 파라미터 : 프러퍼티 파일의 프러퍼티, 프로퍼티가 없을 경우 기본메세지 , 로케일지정
    String message = ctx.getMessage("greeting.message", params, "이지", Locale.getDefault());
    System.out.println(welcome);
    System.out.println(message);
    
    // greeting_en.properties 파일을 읽어온다.
    String[] params_en = {"Jae Won Lee", "Seoul"}; 
    String welcom_en =ctx. getMessage("greeting.welcome", params_en, Locale.ENGLISH);
    System.out.println(welcom_en);
        
    // Locale이 null 이면 기본값을 사용한다.
    String[] sizes = {"5","16"};
    String errors = ctx.getMessage("length.usename", sizes, null);
    System.out.println(errors);
    ctx.close();	
}
```

<br>

### 자바 설정에서 ResourceBundleMessageSource 빈 등록
```java
@Configuration
public class AppConfig {
	
    // 스프링 빈 이름이 반드시 messageSource 이어야 한다.
    // 메서드명을 messageSource() 하거나 메서드명이 다를 경우 
    // @Bean(name="messageSource")로 빈 이름을 명시한다.

	@Bean
	public MessageSource messageSource() {
		ResourceBundleMessageSource messageSource= new ResourceBundleMessageSource(); 
		messageSource.setBasenames("message/greeting","message/errors");
		messageSource.setDefaultEncoding("UTF-8");
		return messageSource; 
	}
}
```

<br>

### ReloadableResourceBundleMessageSource를 이용한 설정 

- basenames를 지정할 때 스프링의 자원 경로를 지원한다. 
- 클래스패스 자원은 리로딩을 지원하지 않는다. 

<br>

> XML 설정
```xml
<bean id="messageSource" class="org.springframework.context.support.ReloadableResourceBundleMessageSource">
	<property name="basenames">
		<list>
			<value>file:src/message/greeting</value>
			<value>file:src/message/errors</value>
			<value>classpath:message/main</value>
		</list>
	</property>
	<property name="defaultEncoding" value="UTF-8"/>
	<property name="cacheSeconds" value="10" />
	<!-- 10초마다 메세지 파일의 변경 내역을 반영한다.-->
</bean>

```

<br>

> 자바 설정
```java
@Configuration
public class AppConfig {
	
	@Bean
	public MessageSource messageSource() {
		ReloadableResourceBundleMessageSource messageSource
			= new ReloadableResourceBundleMessageSource();   
		messageSource.setBasenames("file:src/message/greeting","file:src/message/errors");
		messageSource.setDefaultEncoding("UTF-8");
		messageSource.setCacheSeconds(10);
		return messageSource; 
	}
}
```

<br>

### 빈객체에 메세지 이용하기 

<br>

- ApplicationContextAware 인터페이스를 구현한다.
	- seApplicationConext() 메서드를 통해 ApplicationContext를 전달 받는다. 
	- ApplicationContext의 getMessage()메서드를 사용한다.

<br>

- MessageSourceAware 인터페이스를 구현한다. 
	- setMessageSource() 메서드를 통해 MessageSource를 전달 받는다. 
	- MessageSource의 setMessage()메서드를 사용한다.

> MessageSourceAware 인터페이스 구현
```java
public class Greeting implements MessageSourceAware{
	
	private String greeting;
	
	private MessageSource messageSource; 
	
	@Override
	public void setMessageSource(MessageSource messageSource) {
		this.messageSource = messageSource;
	}
	
	public void greet(String name, String location) {
		String[] param  = {name, location};
		String welcome = messageSource.getMessage("greeting.welcome", param, null );
		System.out.println(welcome);
	}
}
```

<br>

> 스프링 빈 등록 
```java
@Configuration
public class AppConfig {

	@Bean
	public Greeting greeting() {
		return new Greeting();
	}
	/* ... */
}
```

<br>

> 실행 
```java
public class Main {
	public static void main(String[] args) {
		AnnotationConfigApplicationContext ctx = new AnnotationConfigApplicationContext(AppConfig.class);
		
		Greeting greeting = ctx.getBean("greeting",Greeting.class);
		greeting.greet("정상수", "부산 진구");
		
		ctx.close();	
	}
}
```

<br>

