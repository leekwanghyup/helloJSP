```sql
create user 'prospring'@'localhost' identified by 'prospring5';

create schema musicdb;

grant all privileges on musicdb . * to 'prospring'@'localhost';

flush privileges; 
```

<br><br>

```sql
drop table singer; 
create table singer(
	id int not null primary key auto_increment , 
    first_name varchar(60) not null, 
    last_name varchar(40) not null, 
    birth_date date, 
    unique uq_singer_1 (first_name, last_name)
);
```
<br><br>

```sql
create table album(
	id int not null auto_increment primary key, 
    singer_id int not null, 
    title varchar(100) not null, 
    release_date date, 
    unique uq_singer_album_1 (singer_id, title),
    constraint fk_album foreign key(singer_id) references singer(id)
);
```

<br><br>

> 테스트 데이터 
```sql
INSERT INTO singer(first_name,last_name,birth_date) VALUES('John','Mayer','1977-10-16');
INSERT INTO singer(first_name,last_name,birth_date) VALUES('Eric','Clapton','1945-03-30');
INSERT INTO singer(first_name,last_name,birth_date) VALUES('Jhon','Butler','1975-04-01');

 INSERT INTO album(id,singer_id,title,release_date) VALUES(null,1,'The Search For Everything','2017-01-20');

```
<br><br>

> Singer 
```java
public class Singer implements Serializable{
	
	private Long id; 
	private String firstName; 
	private String lastName; 
	private Date birthDate; 
	private List<Album> albums;

    // geeter setter toString


	// 추가해야할 앨범이면 true 리턴
	public boolean addAlbum(Album album) {
		if(albums == null) { // 앨범객체가 아직 없다면 새로운 리스트 객체 생성
			albums = new ArrayList<>(); 
			albums.add(album);
			return true;
		} else {
			if(albums.contains(albums)) { // 리스트에 이 객체가 포함되어있다면 false반환
				return false;
			}
		}
		albums.add(album);
		return true; 
	}

}
```

<br><br>

> Album
```java
public class Album {
	private Long id; 
	private Long singerId; 
	private String title; 
	private Date releaseDate;
    /* ... */
}
```

<br><br>

> 
```java
public interface SingerDao {
	List<Singer> findAll(); 
	List<Singer> findByFirstName(String firstName);
	String findNameById(Long id);
	String findLastNameById(Long id);
}

```

<br><br>

> 데이터베이스 설정
```java
@Configuration
public class RootConfig {
	
	@Bean
	public DataSource dataSource() {
		BasicDataSource dataSource = new BasicDataSource();
		dataSource.setDriverClassName("com.mysql.cj.jdbc.Driver");
		dataSource.setUrl("jdbc:mysql://127.0.0.1:3306/musicdb");
		dataSource.setUsername("prospring");
		dataSource.setPassword("prospring5");
		return dataSource;
	}
	
    // JdbcTemplate 스프링빈 등록
	@Bean
	public JdbcTemplate jdbcTemplate(DataSource dataSource) {
		return new JdbcTemplate(dataSource); 
	}
	
}

```

<br><br>

```java
public class PlainSingerDao implements SingerDao{

    private JdbcTemplate jdbcTemplate;
	
	public PlainSingerDao(JdbcTemplate jdbcTemplate) {
		this.jdbcTemplate = jdbcTemplate;
	}

    @Override
    public String findNameById(Long id) {
        String sql = "select concat(first_name,' ',last_name) from singer where id = ?";
        return jdbcTemplate.queryForObject(sql, new Object[] {id},String.class);
        // param1 : sql물
        // param2 : sqlq문 파라미터에 바인딩할 값을 Object 배열로 지정 
        // param3 : 쿼리의 실행결과 반환타입 지정 
    }
/* ... */
```

<br><br>


### NamedParameterJdbcTemplate 이용
> RootConfig 설정 
```java

```

<br><br>

> NamedParameterJdbcTemplate 이용
```java
private NamedParameterJdbcTemplate npjdbcJdbcTemplate; 
	
public PlainSingerDao(NamedParameterJdbcTemplate npjdbcJdbcTemplate) {
    this.npjdbcJdbcTemplate = npjdbcJdbcTemplate;
}

@Override
public String findNameById(Long id) {
    String sql = "select concat(first_name,' ',last_name) from singer where id = :singerId";
    Map<String, Object> namedParameter = new HashMap<>(); 
    namedParameter.put("singerId", id);
    return npjdbcJdbcTemplate.queryForObject(sql, namedParameter, String.class); 
}
```

<br>

### RowMapper&ltT&gt를 사용해 도메인 객체 조회 

```java
@Override
public List<Singer> findAll() {
    String sql = "select id, first_name, last_name, birth_date from singer";
    return npjdbcJdbcTemplate.query(sql, new RowMapper<Singer>() {
        @Override
        public Singer mapRow(ResultSet rs, int rowNum) throws SQLException {
            Singer singer = new Singer(); 
            singer.setId(rs.getLong("id"));
            singer.setFirstName(rs.getString("first_name"));
            singer.setLastName(rs.getString("last_name"));
            singer.setBirthDate(rs.getDate("birth_date"));
            return singer;
        }
    });  
}
```

### RowMapper 구현체 클래스를 정적 내부 클래스로 정의
```java
@Override
public List<Singer> findAll() {
    String sql = "select id, first_name, last_name, birth_date from singer";
    return npjdbcJdbcTemplate.query(sql, new SingerMapper());  
}

// 내부 클래스로 정의하면 모든 find메소드에서 이를 공유할 수있다.
public static final class SingerMapper implements RowMapper<Singer>{
    @Override
    public Singer mapRow(ResultSet rs, int rowNum) throws SQLException {
        Singer singer = new Singer(); 
        singer.setId(rs.getLong("id"));
        singer.setFirstName(rs.getString("first_name"));
        singer.setLastName(rs.getString("last_name"));
        singer.setBirthDate(rs.getDate("birth_date"));
        return singer;
    }
}
```
