package com.p8499.pac.pages;

import com.jayway.jsonpath.Configuration;
import com.p8499.pac.Util;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.UnsupportedEncodingException;
import java.util.Map;

@Controller
@RequestMapping(value = "/special", produces = "application/json;charset=UTF-8")
public class Special {
    @RequestMapping(value = "", method = RequestMethod.GET)
    public String get(HttpSession session, HttpServletRequest request, HttpServletResponse response, @RequestParam(required = true) String path) {
        request.setAttribute("path", path);
        return "/special.jsp";
    }

    @ResponseBody
    @RequestMapping(value = "/clear", method = RequestMethod.GET)
    public String clear(HttpSession session, HttpServletRequest request, HttpServletResponse response, @RequestParam(required = true) String path) throws UnsupportedEncodingException {
        Map target = (Map) Util.read(request.getSession().getAttribute("json"), path);
        target.clear();
        return "";
    }

    @ResponseBody
    @RequestMapping(value = "", method = RequestMethod.PUT)
    public String update(HttpSession session, HttpServletRequest request, HttpServletResponse response, @RequestParam(required = true) String path, @RequestBody String body) throws UnsupportedEncodingException {
        Map target = (Map) Util.read(request.getSession().getAttribute("json"), path);
        target.clear();
        target.put("type", Util.extract(body, "type"));
        if (target.get("type").equals("next"))
            target.put("scope", Configuration.defaultConfiguration().jsonProvider().parse(Util.wrap(((String) Util.extract(body, "scope")).split(","))));
        else if (target.get("type").equals("view"))
            target.put("func", Util.extract(body, "func"));
        else if (target.get("type").equals("other")) {
            target.put("insertClass", Util.extract(body, "insertClass"));
            target.put("updateClass", Util.extract(body, "updateClass"));
        }
        return "";
    }
}
