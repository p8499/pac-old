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
@RequestMapping(value = "/envJtee", produces = "application/json;charset=UTF-8")
public class EnvJtee {
    @RequestMapping(value = "", method = RequestMethod.GET)
    public String get(HttpSession session, HttpServletRequest request, HttpServletResponse response, @RequestParam(required = true) String path) {
        request.setAttribute("path", path);
        return "/envJtee.jsp";
    }

    @ResponseBody
    @RequestMapping(value = "", method = RequestMethod.PUT)
    public String update(HttpSession session, HttpServletRequest request, HttpServletResponse response, @RequestParam(required = true) String path, @RequestBody String body) throws UnsupportedEncodingException {
        Map target = (Map) Util.read(request.getSession().getAttribute("json"), path);
        target.put("app", Util.extract(body, "app"));
        target.put("baseUrl", Util.extract(body, "baseUrl"));
        target.put("packageBase", Util.extract(body, "packageBase"));
        target.put("packageBean", Util.extract(body, "packageBean"));
        target.put("packageMask", Util.extract(body, "packageMask"));
        target.put("packageMapper", Util.extract(body, "packageMapper"));
        target.put("packageControllerBase", Util.extract(body, "packageControllerBase"));
        return "";
    }
}
