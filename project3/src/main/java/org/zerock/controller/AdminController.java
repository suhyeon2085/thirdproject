package org.zerock.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.zerock.service.ReportService;

@Controller
@RequestMapping("/admin/*")
public class AdminController {
	@Autowired
    private ReportService reportService;
	
	@GetMapping("/mainA")
    public String redirectAdminMainGet() {
        
        return "/admin/mainA";
    }
	
	@GetMapping("/listA")
    public String redirectAdminListGet() {
        
        return "/admin/listA";
    }
	
	@GetMapping("/viewA")
    public String redirectAdminViewGet() {
        
        return "/admin/viewA";
    }
	
	/*@PostMapping("/updateState")
	@ResponseBody
	public String updateState(@RequestParam String id, @RequestParam String state) {
		reportService.updateState(id, state);
	    return "success";
	}*/
}
