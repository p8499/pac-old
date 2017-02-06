package com.p8499.pac.templates;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@Controller
@RequestMapping(value = "/base_android_defaultdateformatter", produces = "text/html;charset=UTF-8")
public class BaseAndroidDefaultDateFormatter {
    @RequestMapping(value = "", method = RequestMethod.GET)
    public String get(HttpSession session, HttpServletRequest request, HttpServletResponse response) {
        return "/base_android_defaultdateformatter.jsp";
    }
}
