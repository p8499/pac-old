package com.p8499.pac.pages;

import com.jayway.jsonpath.Configuration;
import com.p8499.pac.Util;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.UnsupportedEncodingException;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping(value = "/uniques", produces = "application/json;charset=UTF-8")
public class Uniques {
    @RequestMapping(value = "", method = RequestMethod.GET)
    public String get(HttpSession session, HttpServletRequest request, HttpServletResponse response, @RequestParam(required = true) String path) {
        request.setAttribute("path", path);
        return "/uniques.jsp";
    }

    @ResponseBody
    @RequestMapping(value = "/swap", method = RequestMethod.GET)
    public String swap(HttpSession session, HttpServletRequest request, HttpServletResponse response, @RequestParam(required = true) String path, @RequestParam(required = true) Integer i, @RequestParam(required = true) Integer j) {
        List target = (List) Util.read(request.getSession().getAttribute("json"), path);
        Util.swap(target, i, j);
        return "";
    }

    @ResponseBody
    @RequestMapping(value = "", method = RequestMethod.POST)
    public String add(HttpSession session, HttpServletRequest request, HttpServletResponse response, @RequestParam(required = true) String path, @RequestBody String body) throws UnsupportedEncodingException {
        List target = (List) Util.read(request.getSession().getAttribute("json"), path);
        Map model = (Map) Configuration.defaultConfiguration().jsonProvider().parse("{}");
        model.put("items", Configuration.defaultConfiguration().jsonProvider().parse(Util.wrap(((String) Util.extract(body, "item")).split(","))));
        model.put("key", new Boolean((String) Util.extract(body, "key")));
        model.put("serial", new Boolean((String) Util.extract(body, "serial")));
        target.add(model);
        return "";
    }

    @ResponseBody
    @RequestMapping(value = "/{i}", method = RequestMethod.DELETE)
    public String del(HttpSession session, HttpServletRequest request, HttpServletResponse response, @RequestParam(required = true) String path, @PathVariable Integer i) throws UnsupportedEncodingException {
        List target = (List) Util.read(request.getSession().getAttribute("json"), path);
        target.remove(i.intValue());
        return "";
    }
}
