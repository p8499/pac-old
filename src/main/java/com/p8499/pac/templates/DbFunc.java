package com.p8499.pac.templates;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@Controller
@RequestMapping(value = "/db_func/", produces = "text/html;charset=UTF-8")
public class DbFunc {
    @RequestMapping(value = "/{d}", method = RequestMethod.GET)
    public String get(HttpSession session, HttpServletRequest request, HttpServletResponse response, @PathVariable Integer d) {
        request.setAttribute("dindex", d);
        return "/db_func.jsp";
    }
}
