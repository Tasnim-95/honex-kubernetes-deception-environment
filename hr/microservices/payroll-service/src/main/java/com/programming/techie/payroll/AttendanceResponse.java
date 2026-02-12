
package com.programming.techie.payroll;

import lombok.Data;

@Data
public class AttendanceResponse {
    private Long id;
    private Long employeeId;
    private String date;
    private boolean present;
}
