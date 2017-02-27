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
@RequestMapping(value = "/modules", produces = "application/json;charset=UTF-8")
public class Modules {
    @RequestMapping(value = "", method = RequestMethod.GET)
    public String get(HttpSession session, HttpServletRequest request, HttpServletResponse response, @RequestParam(required = true) String path) {
        request.setAttribute("path", path);
        return "/modules.jsp";
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
        Map model = (Map) Configuration.defaultConfiguration().jsonProvider().parse("{\"fields\":[],\"uniques\":[],\"references\":[]}");
        model.put("id", Util.extract(body, "id"));
        model.put("description", Util.extract(body, "description"));
        model.put("comment", Util.extract(body, "comment"));
        model.put("datasource", Util.extract(body, "datasource"));
        model.put("databaseTable", Util.extract(body, "databaseTable"));
        model.put("databaseView", Util.extract(body, "databaseView"));
        model.put("jteeBeanAlias", Util.extract(body, "jteeBeanAlias"));
        model.put("jteeMaskAlias", Util.extract(body, "jteeMaskAlias"));
        model.put("jteeMapperAlias", Util.extract(body, "jteeMapperAlias"));
        model.put("jteeControllerBaseAlias", Util.extract(body, "jteeControllerBaseAlias"));
        model.put("jteeControllerPath", Util.extract(body, "jteeControllerPath"));
        model.put("jteeAttachmentControllerAlias", Util.extract(body, "jteeAttachmentControllerAlias"));
        model.put("jteeAttachmentControllerPath", Util.extract(body, "jteeAttachmentControllerPath"));
        model.put("androidBeanAlias", Util.extract(body, "androidBeanAlias"));
        model.put("androidMaskAlias", Util.extract(body, "androidMaskAlias"));
        model.put("androidStubAlias", Util.extract(body, "androidStubAlias"));
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
