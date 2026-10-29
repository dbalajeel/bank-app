package com.bankey.backend.dto;

import jakarta.validation.constraints.Size;

public record NicknameRequest(
        @Size(max = 255) String nickname) {
}
