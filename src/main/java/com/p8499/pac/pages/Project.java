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
@RequestMapping(value = "/project", produces = "application/json;charset=UTF-8")
public class Project {
    @RequestMapping(value = "", method = RequestMethod.GET)
    public String get(HttpSession session, HttpServletRequest request, HttpServletResponse response, @RequestParam(required = false, defaultValue = "$") String path) {
        if (session.getAttribute("json") == null)
            session.setAttribute("json", Configuration.defaultConfiguration().jsonProvider().parse("{\"name\":\"MyProject\",\"envJtee\":{\"app\":\"myapp\",\"packageBean\":\"mypack.bean\",\"packageMask\":\"mypack.mask\",\"packageMapper\":\"mypack.mapper\",\"packageService\":\"mypack.service\",\"packageConfigurator\":\"mypack.configurator\",\"packageController\":\"mypack.controller\",\"packageControllerAttachment\":\"mypack.controller\",\"datasources\":[],\"baseUrl\":\"http://127.0.0.1/\",\"packageBase\":\"mypack\"},\"envAndroid\":{\"packageBean\":\"mypack.bean\",\"packageMask\":\"mypack.mask\",\"packageStub\":\"mypack.stub\",\"app\":\"myapp_gen\",\"packageBase\":\"mypack\",\"packageView\":\"mypack.view\"},\"modules\":[]}"));
        request.setAttribute("path", path);
        return "/project.jsp";
    }

    @ResponseBody
    @RequestMapping(value = "", method = RequestMethod.PUT)
    public String update(HttpSession session, HttpServletRequest request, HttpServletResponse response, @RequestParam(required = true) String path, @RequestBody String body) throws UnsupportedEncodingException {
        Map target = (Map) Util.read(request.getSession().getAttribute("json"), path);
        target.put("name", Util.extract(body, "name"));
        return "";
    }
}
