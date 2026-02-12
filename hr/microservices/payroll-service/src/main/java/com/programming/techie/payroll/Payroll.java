package com.programming.techie.payroll;

import jakarta.persistence.*;
import lombok.Data;

@Entity
@Data
public class Payroll {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private Long employeeId;
    private double baseSalary;
    private double bonus;
    private double deductions;
    private double netSalary;
}
