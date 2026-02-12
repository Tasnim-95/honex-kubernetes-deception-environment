
package com.programming.techie.employee;

import lombok.Data;

@Data
public class EmployeeRequest {
    private String name;
    private String email;
    private String department;
    private double baseSalary;
}
