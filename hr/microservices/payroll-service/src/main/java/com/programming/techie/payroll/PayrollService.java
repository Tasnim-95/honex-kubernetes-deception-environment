package com.programming.techie.payroll;

import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

@Service
@RequiredArgsConstructor
public class PayrollService {

    private final PayrollRepository payrollRepository;
    private final RestTemplate restTemplate = new RestTemplate();

    @Value("${services.employee-url}")
    private String employeeServiceUrl;

    @Value("${services.attendance-url}")
    private String attendanceServiceUrl;

    public Payroll processPayroll(PayrollRequest request) {

        // 1️⃣ Get employee from employee-service
        EmployeeResponse employee =
                restTemplate.getForObject(employeeServiceUrl + "/" + request.getEmployeeId(),
                        EmployeeResponse.class);

        if (employee == null)
            throw new RuntimeException("Employee not found");

        // 2️⃣ Get attendance for employee
        AttendanceResponse[] attendance =
                restTemplate.getForObject(attendanceServiceUrl + "/" + request.getEmployeeId(),
                        AttendanceResponse[].class);

        long absentDays = 0;
        if (attendance != null) {
            absentDays = java.util.Arrays.stream(attendance)
                    .filter(a -> !a.isPresent())
                    .count();
        }

        // 3️⃣ salary calculation
        double deductionPerDay = 100;
        double totalDeductions = request.getDeductions() + (absentDays * deductionPerDay);

        double netSalary = employee.getBaseSalary() + request.getBonus() - totalDeductions;

        // 4️⃣ Save payroll record
        Payroll payroll = new Payroll();
        payroll.setEmployeeId(employee.getId());
        payroll.setBaseSalary(employee.getBaseSalary());
        payroll.setBonus(request.getBonus());
        payroll.setDeductions(totalDeductions);
        payroll.setNetSalary(netSalary);

        return payrollRepository.save(payroll);
    }

    // ✅ الميثود الجديدة — Get Payroll by ID
    public Payroll getPayrollById(Long id) {
        return payrollRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Payroll not found"));
    }
}
