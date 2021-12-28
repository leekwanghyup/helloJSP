## PropertyEditor : 같은 패키지에 위치 
- 변환대상 타입과 동일한 패키지에 '타입Editor' 이름으로 PropertyEditor를 구현한다.
- 클래스 이름이 'Money'이면 'MonyEditor'

> Money
```java
public class Money {
	
	private int amount;
	private String currency;

	public Money(int amount, String currency) {
		this.amount = amount;
		this.currency = currency;
	}

	public int getAmount() {
		return amount;
	}

	public String getCurrency() {
		return currency;
	}

	@Override
	public String toString() {
		return amount + currency;
	}
}
```

<br>

> MoneyEditor
```java
// Money 클래스와 동일하 패키지에 있어야하고 클래스 이름은 반드시 MoneyEditor이어야 한다.
public class MoneyEditor extends PropertyEditorSupport{
	
	@Override
	public void setAsText(String text) throws IllegalArgumentException {
		Pattern pattern = Pattern.compile("([0-9]+)([A-Z]{3})");
		Matcher matcher = pattern.matcher(text);
		if(!matcher.matches()) throw new IllegalArgumentException("invalid format");
		
		int amount = Integer.parseInt(matcher.group(1));
		String currency = matcher.group(2);
		setValue(new Money(amount, currency));
	}
}

```

<br>

> xml 설정
```xml
<bean id="simulator" class="money.InvestmentSimulator">
    <property name="minimumAmount" value="100WON"/>
</bean>
```