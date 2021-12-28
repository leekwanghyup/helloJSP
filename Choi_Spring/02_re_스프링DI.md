## DI와 스프링 

### 의존이란?

- A 객체가 B 객체의 어떤 기능을 실행하면 B 객체가 필요하다. 
- 이 때 A객체는 B객체에 의존(Dependency)한다고 말한다. 
- 타이벵 의존한 다는 것은 해당 타입의 객첼르 사용한다는 것을 뜨한다. 

<br>

```java
public interface BookRepository {
	void useRepository();	
}

```

```java
// KyoboRepository useRepository()메서드를 호출할 것이다.
public class KyoboRepository implements  BookRepository{

	@Override
	public void useRepository() {
		System.out.println("교보문고!!");
	}
}
```

<br>

```java
public class BookService {

    // KyoboRepository 사용하기 위해서 필드변수로 정의했다.
    // KyoboRepository 객체는 BookRepository의 메서드를 사용하고 있다. 
    // BookService가 KyoboRepository 의존(Dependency)한다고 말한다. 
	private BookRepository bookRepository; 
	
	public void loadBookRepository() {
        // BookRepository 생성
		bookRepository = new KyoboRepository();
		bookRepository.useRepository(); // 필요한 메서드호출
	}
}
```

<br>

> 실행
```java
public class Main {
	
	public static void main(String[] args) {
		BookService bookService = new BookService(); 
		bookService.loadBookRepository();
	}
}

```

### 의존 객체를 직접 생성하는 방식의 단점 

- 요구사항의 변화로 KyoboRepository 대신 AladdindReopository 사용한다고 가정하자.
- 이 경우 BookService의 코드를 직접 변경해주어야한다. 
- 만약 KyoboRepository 대신에 AladdindReopository를 사용하는 곳이 많다고하면 그에 비례에서 변경해주어야한다.

<br>

```java
public class AladdinRepoistory implements BookRepository{
	public void useRepository() {
		System.out.println("알라딘");
	}
}
```

<br>

> BookService에서 코드를 직접 변경해주어야한다.
```java
private BookRepository bookRepository; 
	public void loadBookRepository() { 
		bookRepository = new AladdinRepoistory(); // 직접변경 
		bookRepository.useRepository(); 
	}
}
```

<br>

- 의존객체를 직접 생성하는 방식은 개발의 효율 낮춘다. 
- 예를 들어 Yes24Repository가 아직 개발되지 않았다고 가장하자
- 이 코드에서 Yes24Repository가 완성되기 전에는 BookService 클래스를 테스트할 수 없게 된다. 
- Yes24Repository를 사용하는 곳이 많다면 이 클래스를 사용하는 곳은 코드의 완성이 늦어지게된다.
```java
public class Yes24Repository implements BookRepository{
	@Override
	public void useRepository() {
		throw new UnsupportedOperationException();
	}	
}
```

<br>

### DI를 사용하는 방식 코드 : 의존 객체를 외부에서 조립

<br>

- 의존객체를 직접생하지않고 외부에서 전달받자. 

<br>

```java
public class BookService {
	
	private BookRepository bookRepository;
	
	// 생성자를 통해서 BookRepository를 외부에서 주입받고 있다. 
	// 스스로 의존하는 객체를 생성하지 않고 누군구가 외부에서 넣어주는 이를 Dependency Injection(의존주입)이라 한다.
	// 이 경우 BookService는 BookRepository의 구체적인 구현체를 알지 못한다. 
	public BookService(BookRepository bookRepository) {
		this.bookRepository = bookRepository; 
	}
	
	public void loadBookRepository() {   
		bookRepository.useRepository(); 
	}
}
```

<br>

- 그렇다면 여기서 누가 객체를 생성하고 서로 연결할까? 그 역할을 수행하는 것이 바로 조립기다.
- KyoboRepository를 사용하는 곳이 많다고 하더라도 조립기의 코드만 바꾸면 된다.

<br>


```java
public class Assembler {
	private BookService bookService; 
	private BookRepository bookRepository; 
	
	public Assembler() {
		bookRepository = new KyoboRepository(); // 조립기에서 구현체를 선택하고 
		bookService = new BookService(bookRepository); // DI한다.
	}

    // Main메서드에서 실행을 위해 게터 생성
	public BookService getBookService() {
		return bookService;
	}
}
```

<br>

> Main
```java
public class Main {	
	public static void main(String[] args) {
		Assembler assembler = new Assembler();
		BookService bookService = assembler.getBookService(); 
		bookService.loadBookRepository();
	}
}
```

<br>

- DI의 또 다른 장점은 의존하는 클래스의 구현이 완성되어 있지 않아도 테스트 할 수있다. 
- BookRepository의 가짜 구현체를 이용해서 BookService를 테스트 할 수 있다. 
```java
public class Assembler {
	private BookService bookService; 
	private BookRepository bookRepository; 
	
	public Assembler() {
		bookRepository = new BookRepository() {
			// 가체 구현체 
			@Override
			public void useRepository() {
				System.out.println("가짜 구현체를 사용하여 BookService 테스트");
			}
		}; 
		bookService = new BookService(bookRepository); 
	}

	public BookService getBookService() {
		return bookService;
	}
}
```

## 스프링 DI 설정

### 객체생성
```java

```

