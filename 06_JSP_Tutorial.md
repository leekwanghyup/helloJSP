# 오라클 DB 암호화

## 패키지 생성
```sql
CREATE OR REPLACE PACKAGE CryptIT AS 
         FUNCTION encrypt( Str VARCHAR2,  
                     hash VARCHAR2 ) RETURN VARCHAR2;

         FUNCTION decrypt( xCrypt VARCHAR2,
                     hash VARCHAR2 ) RETURN VARCHAR2;
     END CryptIT;
```