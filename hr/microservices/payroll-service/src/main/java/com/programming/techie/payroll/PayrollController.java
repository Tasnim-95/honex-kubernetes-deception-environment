package com.programming.techie.payroll;

import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/payroll")
@RequiredArgsConstructor
public class PayrollController {

    private final PayrollService payrollService;

    @PostMapping
    public Payroll createPayroll(@RequestBody PayrollRequest request) {
        return payrollService.processPayroll(request);
    }

    @GetMapping("/{id}")
    public Payroll getPayroll(@PathVariable Long id) {
        return payrollService.getPayrollById(id);
    }
}
