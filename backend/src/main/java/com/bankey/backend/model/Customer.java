package com.bankey.backend.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import org.hibernate.annotations.Check;

@Entity
@Table(name = "customers")
@Check(constraints = "customer_number BETWEEN 100000000 AND 999999999")
public class Customer {

    @Id
    @Column(name = "customer_number")
    private Integer customerNumber;

    @Column(name = "password_hash", nullable = false, length = 100)
    private String passwordHash;

    protected Customer() {
    }

    public Customer(Integer customerNumber, String passwordHash) {
        this.customerNumber = customerNumber;
        this.passwordHash = passwordHash;
    }

    public Integer getCustomerNumber() {
        return customerNumber;
    }

    public String getPasswordHash() {
        return passwordHash;
    }
}
    

