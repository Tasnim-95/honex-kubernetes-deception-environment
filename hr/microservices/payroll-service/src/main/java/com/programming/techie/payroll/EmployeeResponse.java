
package com.programming.techie.payroll;

import lombok.Data;

@Data
public class EmployeeResponse {
    private Long id;
    private String name;
    private String email;
    private String department;
    private double baseSalary;
}

