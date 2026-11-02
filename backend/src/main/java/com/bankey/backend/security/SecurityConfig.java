//RULE BOOK
// each .something adds one rule
package com.bankey.backend.security;

// "Ill use these ready made tools from spring"
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpStatus;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.HttpStatusEntryPoint;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

// a setting file that is read by spring when the server starts and build whatever marked @Bean
@Configuration
public class SecurityConfig {

    // BUILD this
    @Bean
    public PasswordEncoder passwordEncoder() {
        // if i want to change the scrambler (hasher) i need to change only this line 
        // it adds rando, "salt" 2 perople with same password still get different hashes 
        return new BCryptPasswordEncoder();
    }

    @Bean
    
    public SecurityFilterChain securityFilterChain(HttpSecurity http, JwtService jwtService) throws Exception {
        http
        // CSFR is a trick where a bad website uses your browser's cookies to send requests pretending to be you.
        // it is on by default. if we kept it on it will block out post request.
                .csrf(csrf -> csrf.disable())
                // dont remember anyone check token on every request
                .sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
                //anyone can use the login page and the error page is open but the requests must be authenticated
                .authorizeHttpRequests(auth -> auth
                        .requestMatchers("/auth/**", "/error").permitAll()
                        .anyRequest().authenticated())
                        // if someone calls accounts with no tokens reply "unauthorized"
                .exceptionHandling(errors -> errors
                        .authenticationEntryPoint(new HttpStatusEntryPoint(HttpStatus.UNAUTHORIZED)))
                        // spring build the checkpoints but none will know to rad our JWT tokens so we build our own
                        // add our tickets checker before spring's user/pass checkpoint 
                .addFilterBefore(new JwtAuthFilter(jwtService), UsernamePasswordAuthenticationFilter.class);
        return http.build();
    }
}
