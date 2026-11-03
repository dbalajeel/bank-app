package com.bankey.backend.security;

import io.jsonwebtoken.JwtException;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.util.List;

//it gets a ready made abilities from its parent and onceperrequestfilter is spring's ready made "guard"
public class JwtAuthFilter extends OncePerRequestFilter {

    private final JwtService jwtService;

    public JwtAuthFilter(JwtService jwtService) {
        this.jwtService = jwtService;
    }

    // Our own version of the filter method 
    @Override
    protected void doFilterInternal(HttpServletRequest request, // the incoming request
                                    HttpServletResponse response, // the reply we will send
                                    FilterChain filterChain) throws ServletException, IOException {
        String header = request.getHeader("Authorization");

         // Only continue if there is a header and it starts with "Bearer "
        if (header != null && header.startsWith("Bearer ")) {
            // Cut off "Bearer " (7 characters) to get just the token
            String token = header.substring(7);

            // Try to check the token (a fake or expired token throws an error)
            try {
                //jwtService is the only one who has the secret key 
                //readCustomerNumber is the method i did in the jwtservice
                Integer customerNumber = jwtService.readCustomerNumber(token);
                // Make a "badge" for Spring: who = customerNumber, password = null (not needed), roles = none (empty list)
                UsernamePasswordAuthenticationToken authentication =
                        new UsernamePasswordAuthenticationToken(customerNumber, null, List.of());
                       // Pin the badge on this request, so Spring knows who it is (used by @AuthenticationPrincipal)
                SecurityContextHolder.getContext().setAuthentication(authentication);
            } 
             // Fake, changed or expired token -> catch the error
            catch (JwtException | IllegalArgumentException e) {
                // Remove any badge, so the request stays anonymous 
                SecurityContextHolder.clearContext();
            }
        }
        // Always pass the request to the next checkpoint (with or without a badge)
        filterChain.doFilter(request, response);
    }
}
            
