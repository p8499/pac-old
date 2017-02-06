package com.p8499.pac.pages;

import com.p8499.pac.Util;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.UnsupportedEncodingException;
import java.util.Map;

@Controller
@RequestMapping(value = "/field", produces = "application/json;charset=UTF-8")
public class Field {
    @RequestMapping(value = "", method = RequestMethod.GET)
    public String get(HttpSession session, HttpServletRequest request, HttpServletResponse response, @RequestParam(required = true) String path) {
        request.setAttribute("path", path);
        return "/field.jsp";
    }

    @ResponseBody
    @RequestMapping(value = "", method = RequestMethod.PUT)
    public String update(HttpSession session, HttpServletRequest request, HttpServletResponse response, @RequestParam(required = true) String path, @RequestBody String body) throws UnsupportedEncodingException {
        Map target = (Map) Util.read(request.getSession().getAttribute("json"), path);
        target.put("databaseColumn", Util.extract(body, "databaseColumn"));
        target.put("description", Util.extract(body, "description"));
        target.put("javaType", Util.extract(body, "javaType"));
        target.put("stringLength", Util.extract(body, "stringLength"));
        target.put("integerLength", Util.extract(body, "integerLength"));
        target.put("fractionLength", Util.extract(body, "fractionLength"));
        target.put("defaultValue", Util.extract(body, "defaultValue"));
        return "";
    }
}
