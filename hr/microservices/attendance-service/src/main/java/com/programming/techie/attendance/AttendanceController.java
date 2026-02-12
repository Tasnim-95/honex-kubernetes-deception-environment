
package com.programming.techie.attendance;

import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;

@RestController
@RequestMapping("/api/attendance")
@RequiredArgsConstructor
public class AttendanceController {

    private final AttendanceRepository repository;

    // 1) Add attendance record
    @PostMapping
    public Attendance save(@RequestBody AttendanceRequest request) {
        Attendance attendance = Attendance.builder()
                .employeeId(request.getEmployeeId())
                .date(LocalDate.now())
                .present(request.isPresent())
                .build();

        return repository.save(attendance);
    }

    // 2) Get all attendance records
    @GetMapping
    public List<Attendance> getAll() {
        return repository.findAll();
    }

    // 3) NEW: Get attendance by employee ID (needed for payroll)
    @GetMapping("/employee/{employeeId}")
    public List<Attendance> getByEmployee(@PathVariable Long employeeId) {
        return repository.findByEmployeeId(employeeId);
    }
}
