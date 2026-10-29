package com.bankey.backend.dto;

import com.bankey.backend.model.Account;

public record AccountResponse(String accountNumber, Float balance, String nickname) {

    public static AccountResponse from(Account account) {
        return new AccountResponse(
                account.getAccountNumber(),
                account.getBalance(),
                account.getNickname());
    }
}