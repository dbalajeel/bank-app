//dto(data transfer objects) a simple box that carries data between the iphone and the server 
package com.bankey.backend.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

//record is a short way to make a class that only holds data (request)
public record LoginRequest(
        //null for anything blank for text
        @NotNull Integer customerNumber,
        @NotBlank String password) {
}
