package com.bankey.backend.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

public record LoginRequest(
        @NotNull Integer customerNumber,
        @NotBlank String password) {
}
