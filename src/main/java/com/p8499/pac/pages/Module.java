package com.p8499.pac.pages;

import com.p8499.pac.Util;
import net.minidev.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.UnsupportedEncodingException;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping(value = "/module", produces = "application/json;charset=UTF-8")
public class Module {
    @RequestMapping(value = "", method = RequestMethod.GET)
    public String get(HttpSession session, HttpServletRequest request, HttpServletResponse response, @RequestParam(required = true) String path) {
        request.setAttribute("path", path);
        return "/module.jsp";
    }

    @ResponseBody
    @RequestMapping(value = "", method = RequestMethod.PUT)
    public String update(HttpSession session, HttpServletRequest request, HttpServletResponse response, @RequestParam(required = true) String path, @RequestBody String body) throws UnsupportedEncodingException {
        Map target = (Map) Util.read(request.getSession().getAttribute("json"), path);
        target.put("id", Util.extract(body, "id"));
        target.put("description", Util.extract(body, "description"));
        target.put("comment", Util.extract(body, "comment"));
        target.put("datasource", Util.extract(body, "datasource"));
        target.put("databaseTable", Util.extract(body, "databaseTable"));
        target.put("databaseView", Util.extract(body, "databaseView"));
        target.put("jteeBeanAlias", Util.extract(body, "jteeBeanAlias"));
        target.put("jteeMaskAlias", Util.extract(body, "jteeMaskAlias"));
        target.put("jteeMapperAlias", Util.extract(body, "jteeMapperAlias"));
        target.put("jteeServiceAlias", Util.extract(body, "jteeServiceAlias"));
        target.put("jteeControllerBaseAlias", Util.extract(body, "jteeControllerBaseAlias"));
        target.put("jteeControllerPath", Util.extract(body, "jteeControllerPath"));
        target.put("jteeAttachmentControllerPath", Util.extract(body, "jteeAttachmentControllerPath"));
        target.put("androidBeanAlias", Util.extract(body, "androidBeanAlias"));
        target.put("androidMaskAlias", Util.extract(body, "androidMaskAlias"));
        target.put("androidStubAlias", Util.extract(body, "androidStubAlias"));
        return "";
    }

    @ResponseBody
    @RequestMapping(value = "/fieldIds", method = RequestMethod.GET)
    public String fieldIds(HttpSession session, HttpServletRequest request, HttpServletResponse response, @RequestParam(required = true) String path) {
        Object object = Util.read(request.getSession().getAttribute("json"), path);
        Map target = null;
        if (object instanceof Map)
            target = (Map) object;
        else if (object instanceof List)
            target = (Map) ((List) object).get(0);
        List fieldList = (List) target.get("fields");
        String[] fieldIds = new String[fieldList.size()];
        for (int i = 0; i < fieldList.size(); i++)
            fieldIds[i] = (String) ((Map) fieldList.get(i)).get("databaseColumn");
        return Util.wrap(fieldIds);
    }
}
