package com.p8499.pac;

import com.jayway.jsonpath.Configuration;
import com.jayway.jsonpath.DocumentContext;
import com.jayway.jsonpath.JsonPath;
import com.jayway.jsonpath.ReadContext;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebInitParam;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.Map;

/**
 * Created by Administrator on 12/26/2016.
 */
@WebServlet(name = "project", urlPatterns = "/project")
public class Project extends HttpServlet {
    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String path = request.getParameterMap().containsKey("path") ? request.getParameter("path") : "$";
        Object target = Util.read(request.getSession().getAttribute("json"), path);
        if (path.equals("$")) {
            ((Map) target).put("name", request.getParameter("name"));
        } else if (Util.id(path).equals("envJtee")) {
            ((Map) target).put("app", request.getParameter("app"));
            ((Map) target).put("databaseType", request.getParameter("databaseType"));
            ((Map) target).put("packageBean", request.getParameter("packageBean"));
            ((Map) target).put("packageMask", request.getParameter("packageMask"));
            ((Map) target).put("packageMapper", request.getParameter("packageMapper"));
            ((Map) target).put("packageListener", request.getParameter("packageListener"));
            ((Map) target).put("packageController", request.getParameter("packageController"));
            ((Map) target).put("packageControllerAttachment", request.getParameter("packageControllerAttachment"));
        } else if (Util.id(path).equals("envAndroid")) {
            ((Map) target).put("packageBean", request.getParameter("packageBean"));
            ((Map) target).put("packageMask", request.getParameter("packageMask"));
            ((Map) target).put("packageStub", request.getParameter("packageStub"));
        } else if (Util.id(path).equals("modules")) {
            ((List) target).add(module());
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String path = request.getParameterMap().containsKey("path") ? request.getParameter("path") : "$";
        request.setAttribute("path", path);
        if (path.equals("$"))
            request.getRequestDispatcher("/project.jsp").forward(request, response);
        else if (Util.id(path).equals("envJtee"))
            request.getRequestDispatcher("/envJtee.jsp").forward(request, response);
        else if (Util.id(path).equals("envAndroid"))
            request.getRequestDispatcher("/envAndroid.jsp").forward(request, response);
        else if (Util.id(path).equals("modules"))
            request.getRequestDispatcher("/modules.jsp").forward(request, response);
        else if (Util.id(Util.parent(path)).equals("module"))
            request.getRequestDispatcher("/module.jsp").forward(request, response);
    }

    protected Map module() {
        return (Map) Configuration.defaultConfiguration().jsonProvider().parse("{\"id\":\"\",\"description\":\"\",\"databaseTable\":\"\",\"databaseView\":\"\",\"jteeBeanAlias\":\"\",\"jteeMaskAlias\":\"\",\"jteeMapperAlias\":\"\",\"jteeListenerAlias\":\"\",\"jteeControllerAlias\":\"\",\"jteeControllerPath\":\"/\",\"jteeAttachmentControllerAlias\":\"\",\"jteeAttachmentControllerPath\":\"/\",\"androidBeanAlias\":\"\",\"androidMaskAlias\":\"\",\"androidStubAlias\":\"\",\"fields\":[],\"uniques\":[],\"references\":[]}");
    }
}
