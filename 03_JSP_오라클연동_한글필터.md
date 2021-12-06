## 사용자 생성 

> 사용자 생성
```SQL
CREATE USER jsp01 IDENTIFIED BY jsp01; 
```

> 권한 설정
```SQL
GRANT CONNECT, RESOURCE, DBA TO jsp01; 
```

<br>

- 전체쿼리 실행 : F9
- 현재쿼리 실행 : F5

<br>

## 포트번호 확인 및 변경 
```sql
select dbms_xdb.gethttpport() from dual;
exec dbms_xdb.sethttpport(8082); -- 변경할 포트변호 입력 

```

<br>

## 테스트 테이블 생성 및 데이터 삽입
```sql
create table member (
    username varchar(255), 
    email varchar(255)
); 

```

<br>

## 자바 Oracle 연동 

- maven 저장소에서 ojdbc6.jar 파일 다운로드 
- https://mvnrepository.com/artifact/com.oracle.database.jdbc/ojdbc6/11.2.0.4
- 다운받은 파일을 /webapp/WEB-INF/lib 폴더에 추가 
- 프로젝트 빌드 패스에 이 파일을 추가 

<br>

### 접속 테스트 
>  
```java
package jdbc;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.Statement;

public class DbConnection {
	public static void main(String[] args) {
		
		Connection conn = null;

		try {
			Class.forName("oracle.jdbc.driver.OracleDriver"); // 드라이버 로딩 

            // 접속정보 입력
			conn = DriverManager.getConnection(
					"jdbc:oracle:thin:@localhost:1521/xe",
					"jsp01",
					"jsp01"
			);
			System.out.println("접속 성공");
			
		} catch (Exception e) {
			System.out.println("접속 실패");
			System.out.println(e.getMessage());
		}    
	}
}

```

## Statement 객체를 이용한 데이터 삽입
```java
Statement stmt = null; // Statement 객체 선언 및 null 값 초기화 

/* ... try 블록 내 */
stmt = conn.createStatement(); 
stmt.executeUpdate("insert into member values ('leekwanghyup','lee@example.com')");
System.out.println("데이터 삽입 성공");

/*...*/

 finally {
    try { // Statement 객체 반납
        if(stmt!= null) stmt.close();
    } catch (SQLException e) {
        e.printStackTrace();
    }
    try { // 커넥션 반납  
        if(conn!= null) conn.close();
    } catch (SQLException e) { 
        e.printStackTrace();
    } 			
} // finally end

```

<br>

## PreparedStatement 객체를 이용한 데이터 삽입
```java
PreparedStatement pstmt = null;

/* ... try 블록 내 */
pstmt = conn.prepareStatement("insert into member values (?, ?)"); 
pstmt.setString(1, "kwanghyup"); // ?에 데이터 바인딩, 데이터 타입에 다라 메소드가 정의 되어있다.
pstmt.setString(2, "lee2@example.com");
pstmt.execute();

/* ... */
finally {
    try { // PreapredStatement 객체 반납
        if(pstmt!= null) pstmt.close();
    } catch (SQLException e) {
        e.printStackTrace();
    }
    try { // 커넥션 반납  
        if(conn!= null) conn.close();
    } catch (SQLException e) { 
        e.printStackTrace();
    } 			
} // finally end

```

## 데이터 조회 
```java


/* ... try 블록 내 */
pstmt = conn.prepareStatement("select * from member"); 
rs = pstmt.executeQuery(); // 조회한 레코드가 저장된다. 
while (rs.next()) { // 하나의 레코드를 읽음
    String username = rs.getString("username");
    String email = rs.getString("email");
    System.out.println("이름: " + username + "\t" + "이메일 : "+ email);
}

/* close 코드 작성 : rs, pstmt, conn 순서로 닫아준다. */
```

<br>

## 외부파일을 이용하여 DB 접속
> oracle.prop
``` 
driver=oracle.jdbc.driver.OracleDriver
url=jdbc:oracle:thin:@localhost:1521/xe
user=jsp01
password=jsp01
```
<br>

> DB
``` java
package jdbc;

import java.io.FileInputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Properties;

public class DB {
	
	public static Connection connetion() {
		Connection conn = null; 
		try {
			FileInputStream fis = new FileInputStream("C:/Temp/db_info/oracle.prop"); 
			Properties prop = new Properties();
			prop.load(fis); 
			String url = prop.getProperty("url");
			String user = prop.getProperty("user");
			String password = prop.getProperty("password");
			conn = DriverManager.getConnection(url,user, password); 
		} catch (Exception e) {
			System.out.println(e.getMessage());
		}	
		return conn; 
	}
	
	public static void main(String[] args) {
		Connection conn = null;
		PreparedStatement pstmt = null; 
		ResultSet rs = null; 
		
		try {
			conn = DB.connetion(); 
			pstmt = conn.prepareStatement("select * from member"); 
			rs = pstmt.executeQuery(); 
			while(rs.next()) {
				String username = rs.getString("username");
				String email = rs.getString("email"); 
				System.out.println("이름 : " + username + " " + "이메일 :" + email);
			}
		} catch (Exception e) {
			System.out.println(e.getMessage());
		} finally {
			try { if(rs != null) rs.close();} 
			catch (SQLException e) { e.printStackTrace(); }
			try { if(pstmt != null) rs.close();}	
			catch (SQLException e) { e.printStackTrace(); }
			try {if(conn != null) rs.close();}
			catch (SQLException e) { e.printStackTrace(); }
		}
	}
}

```

## 커넥션 풀 
> Server context.xml
```xml
<?xml version="1.0" encoding="UTF-8"?>
<Context>
    <WatchedResource>WEB-INF/web.xml</WatchedResource>
    <Resource
    	name = "oraDB"
    	auth = "Container"
    	driverClassName = "oracle.jdbc.driver.OracleDriver"
    	maxTotal = "50"
    	maxIdel = "10"
    	maxWaitMillis = "-1"
    	type = "javax.sql.DataSource"
    	url = "jdbc:oracle:thin:@localhost:1521/xe"
    	username = "jsp01"
    	password = "jsp01"
    />
</Context>
```

### 테스트 코드 
```java
package common; // 패키치 확인 

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.naming.Context; // 패키지 확인 
import javax.naming.InitialContext; // 패키지 확인 
import javax.sql.DataSource; // 패키지 확인 

public class DB {
	public static Connection dbConn() {
		DataSource ds = null; 
		Connection conn = null;
		
		try {
			Context ctx = new InitialContext(); // DataSource 객체를 lookup하기 위함
			ds = (DataSource) ctx.lookup("java:comp/env/oraDB"); // context.xml에 지정된 이름을 전달
			conn = ds.getConnection(); // DataSource 객체의 getConnection() 메소드로부터 Connection 객체를 받는다.
		} catch (Exception e) {
			System.out.println(e.getMessage());
		}	
		return conn; 
	}	
}

```

<br>

```jsp
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@page import="java.sql.SQLException"%>
<%@page import="common.DB"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>

<% 

Connection conn = null;
PreparedStatement pstmt = null; 
ResultSet rs = null; 

try {
	conn = DB.dbConn(); 
	pstmt = conn.prepareStatement("select * from member"); 
	rs = pstmt.executeQuery(); 
	while(rs.next()) {
		String username = rs.getString("username");
		String email = rs.getString("email"); 
		out.println("이름 : " + username + " " + "이메일 :" + email + "<br>");
	}
} catch (Exception e) {
	System.out.println(e.getMessage());
} finally {
	try { if(rs != null) rs.close();} 
	catch (SQLException e) { e.printStackTrace(); }
	try { if(pstmt != null) rs.close();}	
	catch (SQLException e) { e.printStackTrace(); }
	try {if(conn != null) rs.close();}
	catch (SQLException e) { e.printStackTrace(); }
}
%>
```

## 한글 필터 
- Filter를 이용한 한글 인코딩 
- Filter : 선처리 클래스, 요청이 들어오면 이 곳을 거친다. 
```java
package common;

import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;

@WebFilter("/*") // 모든 요청은 이곳을 거친다. 
public class EncodingFilter implements Filter {
	
	private final String CHAR_SET = "utf-8"; 
	
    public EncodingFilter() {}

	public void destroy() {}

	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) 
			throws IOException, ServletException {
		request.setCharacterEncoding(CHAR_SET); // 선처리 코드 
		chain.doFilter(request, response); // 사용자가 요청한 액션을 실행 
	}

	public void init(FilterConfig fConfig) throws ServletException {

	}
}
```





