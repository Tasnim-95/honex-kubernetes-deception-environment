
package com.programming.techie.payroll;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class PayrollResponse {
    private Long id;
    private Long employeeId;
    private double baseSalary;
    private double bonus;
    private double deductions;
    private double netSalary;
}

