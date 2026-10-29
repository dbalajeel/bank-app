package com.bankey.backend.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import org.hibernate.annotations.Check;

@Entity
@Table(name = "accounts")
@Check(constraints = "length(account_number) = 9")
public class Account {

    @Id
    @Column(name = "account_number", length = 9)
    private String accountNumber;

    @Column(name = "customer_number", nullable = false)
    private Integer customerNumber;

    @Column(nullable = false)
    private Float balance;

    @Column(length = 255)
    private String nickname;

    protected Account() {
    }

    public Account(String accountNumber, Integer customerNumber, Float balance, String nickname) {
        this.accountNumber = accountNumber;
        this.customerNumber = customerNumber;
        this.balance = balance;
        this.nickname = nickname;
    }

    public String getAccountNumber() {
        return accountNumber;
    }

    public Integer getCustomerNumber() {
        return customerNumber;
    }

    public Float getBalance() {
        return balance;
    }

    public String getNickname() {
        return nickname;
    }

    public void setNickname(String nickname) {
        this.nickname = nickname;
    }
}
