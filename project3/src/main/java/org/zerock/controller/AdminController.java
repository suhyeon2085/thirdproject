package org.zerock.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/admin/*")
public class AdminController {
	@GetMapping("/mainA")
    public String redirectAdminMainGet() {
        
        return "/admin/mainA";
    }
	
	@GetMapping("/listA")
    public String redirectAdminListGet() {
        
        return "/admin/listA";
    }
}
