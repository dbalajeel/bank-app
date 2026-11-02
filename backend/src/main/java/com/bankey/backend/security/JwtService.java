// ticket machine 
//create token and read customer number (reads who owns it)
package com.bankey.backend.security;
//comes from JJWT (io)
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
//comes from spring (org)
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
//built into java 
import javax.crypto.SecretKey;
import java.nio.charset.StandardCharsets;
import java.util.Date;

//make one and hand it to whoever needs it
@Service
public class JwtService {

    private final SecretKey key;
    private final long expirationMillis;

    //@value tells spring where to get each one. "go find this setting and give me its value"
    //String ssecret -> save the value as a text 
    public JwtService(@Value("${jwt.secret}") String secret,
                      @Value("${jwt.expiration-minutes}") long expirationMinutes) {
                        //tturn text into bytes then turn bytes into real stamp (key)
        this.key = Keys.hmacShaKeyFor(secret.getBytes(StandardCharsets.UTF_8));
        this.expirationMillis = expirationMinutes * 60 * 1000;
    }

//create tokens (takes a nuber gives text)
    public String createToken(Integer customerNumber) {
        Date now = new Date();
        // start a new empty ticket
        return Jwts.builder()
        //write who the ticket is for
                .subject(String.valueOf(customerNumber))
                .issuedAt(now)
                .expiration(new Date(now.getTime() + expirationMillis))
    // stamp it with our secret key 
                .signWith(key)
                // pack everything into one long text 
                .compact();
    }

    // needs the token gives back the customer number 
    public Integer readCustomerNumber(String token) {
        //parser read and understand the token
        //claims is a type for the facts written on the token 
        Claims claims = Jwts.parser()
                //use our key to verify the signature 
                .verifyWith(key)
                // done setting up make the checker 
                .build()
                //check if the token is real and not expired 
                .parseSignedClaims(token)
                //open the token and give me whats written inside 
                .getPayload();
                // read the who part and convert it to a number
        return Integer.valueOf(claims.getSubject());
    }
}
