package com.p8499.pac.templates;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@Controller
@RequestMapping(value = "/jtee_bean", produces = "text/html;charset=UTF-8")
public class JteeBean {
    @RequestMapping(value = "/{i}", method = RequestMethod.GET)
    public String get(HttpSession session, HttpServletRequest request, HttpServletResponse response, @PathVariable Integer i) {
        request.setAttribute("index", i);
        return "/jtee_bean.jsp";
    }
}
