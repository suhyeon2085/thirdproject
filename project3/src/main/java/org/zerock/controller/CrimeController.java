package org.zerock.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class CrimeController {

    @GetMapping("/crime")
    public String showCorrelationPage() {
        return "crime";
    }
	
}
