## 객체비교 equals오버라이드

```java
/*
    Object 클래스의 equals()메서는 비교연산자인 == 동일한 결과를 리턴한다. 
*/ 
public static void main(String[] args) {
    Object obj1 = new Object();
    Object obj2 = new Object(); 
    System.out.println("비교 연산자 == :"+(obj1 == obj2));
    System.out.println("Equals 메서드 : "+ obj1.equals(obj2));
}
```

```java
/*
    논리적 동등이란 객체가의 참조값에 관계 없이 
    객체가 저장하고 있는 데이터가 동일한 경우를 말한다.
    String 클래스는 equals를 재정하여 주소값 비교가 아닌 문자열을 비교한다.
*/
public static void main(String[] args) {
    String str1 = new String("Apple");
    String str2 = new String("Apple");
    System.out.println(str1==str2); // 주소값 비교 
    System.out.println(str2.equals(str2)); // 객체가 저장하고있는 데이터값 비교 
}
```

```java
public class Member {
	String username; 
	String password;

	public Member(String username, String password) {
		this.username = username;
		this.password = password;
	}
    // 게터세터

	@Override
	public boolean equals(Object obj) {
		if(!(obj instanceof Member) && obj == null) {
			return false; 
		}
		Member member = (Member) obj;
		boolean username = this.username.equals(member.getUsername());
		boolean password = this.password.equals(member.getPassword());
		return username && password ;
	}
}

```

```java
public static void main(String[] args) {
    Member member1 = new Member("lee","1234"); 
    Member member2 = new Member("lee","1234");
    System.out.println("비교 연산자 : " + (member1==member2));
    System.out.println("Equals 메소드 : " + member1.equals(member2));
}
```

## 객체 해쉬코드
- 해쉬코드는 객체를 식별하는 어떤 정수값이다. 
- Object클래스의 hasCode()는 객체의 주소값을 이용하여 해시코드를 만든다.
- 컬렉션 객체는 두 객체의 논리적 동등비교를 위해 해쉬코드를 사용한다. 
- 해쉬코드를 먼저 비교하고 같으면 Equals메소드로 데이터 값을 비교한다.

```java
public static void main(String[] args) {
    // hasCode() 메서드를 정의하지 않으면 서로 다른 해쉬코드값을 가진다.
    Member member1 = new Member("lee","1234"); 
    Member member2 = new Member("lee","1234");
    System.out.println(member1.hashCode());
    System.out.println(member2.hashCode());
}
```

```java
public static void main(String[] args) {
    Map<Member, String> map = new HashMap<Member, String>();

    // 여기서 생성된 객체의 해쉬코드와  
    map.put(new Member("lee", "1234"), "lee@naver.com");
    
    // 이곳에서 생성된 객체의 해쉬코드는 다르다. 
    String result = map.get(new Member("lee","1234"));
    System.out.println(result); // null  
	}
```

<br>

> 해쉬코드 오버라이딩
```java
package thisIsJava;

public class Member {
	
	private int id;
	private String username; 
	private String password;

	public Member(int id, String username, String password) {
		this.id = id; 
		this.username = username;
		this.password = password;
	}
	
	@Override
	public int hashCode() {
		return this.id;
	}

	@Override
	public boolean equals(Object obj) {
		if(!(obj instanceof Member) && obj == null) {
			return false; 
		}
		Member member = (Member) obj;
		boolean username = this.username.equals(member.getUsername());
		boolean password = this.password.equals(member.getPassword());
		return username && password ;
	}
    // 게터세터
}
```

```java
public static void main(String[] args) {
    Map<Member, String> map = new HashMap<Member, String>();
    map.put(new Member(1,"lee", "1234"), "lee@naver.com");
    
    // 객체를 생성하더라도 같은 해쉬코드를 린턴한다.
    String result = map.get(new Member(1,"lee","1234"));
    System.out.println(result);  
}
```

## 객체 문자정보 
- Object클래스의 toString()메소드는 "클래스명@16진수해시코드"로 구성된문자정보를 리턴한다.

```java
public static void main(String[] args) {
    Member member = new Member(13456, "lee", "1234");
    System.out.println(member.toString()); // thisIsJava.Member@3490
    System.out.println(member); 
}
```

> SmartPhone클래스에서 toString() 메소드 오버라이딩
```java
public class SmartPhone {
	private String company;
	private String os; 
	
	public SmartPhone(String company, String os) {
		this.company = company;
		this.os = os;
	}
	
	@Override
	public String toString() {
		return "[ 제작회사 : " + company + "운영체제 : " + os + " ]" ;
	}
	
	public static void main(String[] args) {
		SmartPhone sp = new SmartPhone("구글", "안드로이드");
		System.out.println(sp);
	}
}
```

## 객체 복제

## 얕은 복제
- 얕은 복제란 필드값을 복사해서 객체를 복제하는 것을 말한다. 
    - 필드가 기본값인 경우 값 복사가 일어난다.
    - 필드가 참조타입일 경우 주소값을 복사한다.

<br>

### 기본값 복사 
```java
public static void main(String[] args) {
    int value1 = 22; 
    int value2 = value1; // 기본값이므로 값이 복사된다.
    value2 = 100; // 원본값인 value1은 바뀌지 않는다.
    System.out.println(value1);
    System.out.println(value2);
}
```

<br>

### 참조 복사 
```java
public static void main(String[] args) {
    Member member = new Member(1, "lee", "1234");
    Member copied = member; // 객체의 주소값이 복사된다. 
    copied.setPassword("5678"); // 원본객체의 password값도 바뀐다.
    // 원본객체 및 사본객체 모두 비밀번호가 바뀐다.
    System.out.println(member);
    System.out.println(copied);
}
```

<br>

### Object clone()메서드
> Member
``` java
// clone()메서드로 객체를 복제하려면 반드시 Cloneable 인터페이스 구현해야한다.
// Cloneable 인터페이스에는 아무런 메서드도 선언되어있지 않다.
// 이 인터페이스를 구현하지 않고 clone()메서드를 사용하면 CloneNotSupportedException 예외가 발생한다.
public class Member implements Cloneable {
	
	private int id;
	private String username; 
	private String password;

	public Member(int id, String username, String password) {
		this.id = id; 
		this.username = username;
		this.password = password;
	}
	
	// 원복객체를 복사하여 사본객체를 리턴한다.
	public Member getMember() {
		Member cloned = null; 
		try {
			cloned = (Member) clone();
		} catch (CloneNotSupportedException e) {
			e.printStackTrace();
		}
		return cloned; 
	}
	
	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	@Override
	public String toString() {
		return "Member [id=" + id + ", username=" + username + ", password=" + password + "]";
	}
}
``` 
> 실행
```java
public static void main(String[] args) {
    Member member = new Member(13456, "lee", "1234");
    Member cloned = member.getMember(); // 복제
    
    cloned.setPassword("5678");
    System.out.println(member); // 원복객체의 비밀번호는 바뀌지 않는다.
    System.out.println(cloned); // 
}
```

<br>

### 얕은복사의 문제점
```java
public class Car {

	private String modelName;

	public String getModelName() {
		return modelName;
	}

	public void setModelName(String modelName) {
		this.modelName = modelName;
	}
	
	@Override
	public String toString() {
		return "Car [modelName=" + modelName + "]";
	} 
}
```

```java
public class CustomUser implements Cloneable {
	private int id;
	private String usernmae;
	private Car car;  // 참조값이 복사된다.
	private int[] scores; // 참조값이 복사된다.

	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getUsernmae() {
		return usernmae;
	}
	public void setUsernmae(String usernmae) {
		this.usernmae = usernmae;
	}
	public Car getCar() {
		return car;
	}
	public void setCar(Car car) {
		this.car = car;
	}
	public int[] getScores() {
		return scores;
	}
	public void setScores(int[] scores) {
		this.scores = scores;
	}
	@Override
	public String toString() {
		return "CustomUser [id=" + id + ", usernmae=" + usernmae + ", car=" + car + ", scores="
				+ Arrays.toString(scores) +"]";
	}
	
	@Override
	protected CustomUser clone() {
		CustomUser cloned= null;
		try {
			cloned = (CustomUser) super.clone();
		} catch (CloneNotSupportedException e) {
			e.printStackTrace();
		} 
		return cloned;
	}
}
```
```java
public static void main(String[] args) {
    CustomUser cu = new CustomUser();
    Car car = new Car();
    int[] scores = {10,20,30};
    car.setModelName("카니발");
    
    cu.setId(1);
    cu.setUsernmae("lee");
    cu.setCar(car);
    cu.setScores(scores);
    
    CustomUser customUser = cu.clone();
    // 복사 후 객체값을 수정해보자.
    customUser.getCar().setModelName("소나타");
    customUser.getScores()[0] = 100;
    
    // 원본객체 및 사본객체 모두 수정된다. 
    System.out.println(cu);
    System.out.println(customUser);	
}
```

<br>

## 깊은 복사

478페이지 까지 스킵

<br>

## 널 여부 조사

> Objects.isNull(T obj)
```java
// null이면 true를 리턴한다.
String obj = null;
boolean isNull = Objects.isNull(obj);
System.out.println(isNull);
```

<br>

> Objects.nonNull(T obj)
```java
String obj = null;
// null이 아니면  true를 리턴한다.
boolean isNotNull = Objects.nonNull(obj);
System.out.println(isNotNull); // null 이므로 false 리턴
```

<br>

> requireNonNull(T obj)
```java
String obj = null;
// String obj = "널아님!";

// null이면 NullPointException 예외발생  
// null이 아니면 객체 값 리턴
String result = Objects.requireNonNull(obj);
System.out.println(result);

```

> requireNonNull(T obj, String message)
```java
String obj = null;
// null이면 NullPointException 예외발생 : 예외 메세지를 추가할 수있다.  
// null이 아니면 객체 값 리턴
String result = Objects.requireNonNull(obj, "널포인트익셉션발생");
```

<br>

> requireNonNull(T obj, Supplier\<String\> messageSupplier)
```java
String obj = null;
// null이면 NullPointException 예외발생 : 예외 메세지를 추가할 수있다.  
// null이 아니면 객체 값 리턴
String result = Objects.requireNonNull(obj, ()-> "NullPointerException 발생!!");
System.out.println(result);
```

<br>

## 객체 문자 정보
```java
Member member = null;
// Null이 아니면 해당 객체의 toString()메소드를 호출한다.
// Null이면 기본값으로 지정한 문자열을 리턴한다.
String result = Objects.toString(member, "정보가없습니다.");
System.out.println(result);
```

<br><br>

# System클래스

<br>

##
- 자바프로그램은 JVM 위에서 실행되므로 운영체제의 기능에 직접 접근하기 어렵다
- System클래스로 운영체제의 일부기능을 이용할 수 있다.
- 프로그램종료, 키보드로부터 입력, 모니터로 출력, 메모리 정리 등이 있다.
- System클래스의 모든 필드 및 메소드는 정적(static)으로 구성된다.

## 시스템프로퍼티 읽기
```java
// 시스템프로퍼티에 어떤 키가 있는지 모든 키를 출력한다.
Properties props = System.getProperties(); 
for(Object objKey : props.keySet()) {
    String key = (String) objKey;
    String value = System.getProperty(key);
    System.out.println(key + " : " + value);
}
```

<br>

```java
String osName = System.getProperty("os.name"); 
String userName = System.getProperty("user.name");
String userHome = System.getProperty("user.home");

System.out.println(osName); // 운영체제 종류 반환
System.out.println(userName); // OS지정한 사용자 이름 반환
System.out.println(userHome); // 사용자 루트 디렉토리를 반환한다.
```

<br>

## 환경변수 읽기 
```java
String path = System.getenv("Path");
System.out.println(path);
```

<br>

- Class 클래스는 클래스와 인터페이스의 메타데이터를 관리하는 한다.
- 메타데이터란 클래스의 이름, 생성자 정보, 필드 정보, 메소드 정보를 의미한다.

```java
Car car = new Car();
Class clazz = car.getClass(); // getClass()는 객체를 생성한 후에 호출할 수 있다. 
String className = clazz.getName(); 
String classSimpleName = clazz.getSimpleName();
System.out.println(className);
System.out.println(classSimpleName);

```
<br>

- 객체를 생성하지않고 해당 객체의 Class 클래스를 얻을 수있다. 
- new로 객체를 생성할 수 없고 정적메서드 forName()을 이용한다.
```java
try {
    Class clazz = Class.forName("thisIsJava.Car");
    String className = clazz.getName(); // 클래스이름(패키지이름포함)
    String simpleClassName = clazz.getSimpleName(); // 패키지이름을 제외한 클래스명
    System.out.println(className);
    System.out.println(simpleClassName);
} catch (ClassNotFoundException e) {
    e.printStackTrace(); // 주어진 매개값으로 클래스를 찾지못하면 예외가 발생한다.
}
```

## 리플렉션




 

