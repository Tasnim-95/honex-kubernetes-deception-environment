
package com.programming.techie.payroll;

import lombok.Data;

@Data
public class PayrollRequest {
    private Long employeeId;
    private double bonus;
    private double deductions;
}


