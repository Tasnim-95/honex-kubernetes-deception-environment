
package com.programming.techie.attendance;

import lombok.Data;

@Data
public class AttendanceRequest {
    private Long employeeId;
    private boolean present;
}
