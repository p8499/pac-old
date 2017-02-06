package com.p8499.pac.templates;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@Controller
@RequestMapping(value = "/jtee_attachmentcontroller", produces = "text/html;charset=UTF-8")
public class JteeAttachmentController {
    @RequestMapping(value = "/{i}", method = RequestMethod.GET)
    public String get(HttpSession session, HttpServletRequest request, HttpServletResponse response, @PathVariable Integer i) {
        request.setAttribute("index", i);
        return "/jtee_attachmentcontroller.jsp";
    }
}
