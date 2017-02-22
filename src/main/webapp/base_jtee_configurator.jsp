<%--@formatter:off--%>
<%@ page import="java.util.Date" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="pac" uri="/WEB-INF/pac.tld" %>
<pac:java>
package ${sessionScope.json.envJtee.packageBase};

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.File;
import java.util.List;

public interface Configurator${"<"}B,M${">"} {
    public boolean beforeAdd(HttpSession session,HttpServletRequest request,HttpServletResponse response,B bean) throws Exception;
    public void afterAdd(HttpSession session,HttpServletRequest request,HttpServletResponse response,B bean) throws Exception;
    public boolean beforeUpdate(HttpSession session,HttpServletRequest request,HttpServletResponse response,B newBean,M mask) throws Exception;
    public void afterUpdate(HttpSession session,HttpServletRequest request,HttpServletResponse response,B newBean,M mask) throws Exception;
    public boolean beforeDelete(HttpSession session,HttpServletRequest request,HttpServletResponse response,B keyBean) throws Exception;
    public void afterDelete(HttpSession session,HttpServletRequest request,HttpServletResponse response,B keyBean) throws Exception;
    public boolean beforeGet(HttpSession session,HttpServletRequest request,HttpServletResponse response,B keyBean,M mask) throws Exception;
    public boolean afterGet(HttpSession session,HttpServletRequest request,HttpServletResponse response,B bean) throws Exception;
    public boolean beforeQuery(HttpSession session,HttpServletRequest request,HttpServletResponse response,FilterLogicExpr filter,M mask) throws Exception;
    public boolean afterQuery(HttpSession session,HttpServletRequest request,HttpServletResponse response,List${"<"}B${">"} beanList) throws Exception;
    File locateAttach(HttpSession session, HttpServletRequest request, HttpServletResponse response, B keyBean) throws Exception;
    boolean beforeDownloadAttach(HttpSession session,HttpServletRequest request,HttpServletResponse response,B keyBean,String name) throws Exception;
    boolean afterDownloadAttach(HttpSession session,HttpServletRequest request,HttpServletResponse response,B keyBean,File file) throws Exception;
    boolean beforeUploadAttach(HttpSession session,HttpServletRequest request,HttpServletResponse response,B keyBean,String name,byte[] bytes) throws Exception;
    void afterUploadAttach(HttpSession session,HttpServletRequest request,HttpServletResponse response,B keyBean,String name,File file) throws Exception;
    boolean beforeDeleteAttach(HttpSession session,HttpServletRequest request,HttpServletResponse response,B keyBean,String name) throws Exception;
    void afterDeleteAttach(HttpSession session,HttpServletRequest request,HttpServletResponse response,B keyBean,String name,boolean result) throws Exception;
    boolean beforeListAttaches(HttpSession session,HttpServletRequest request,HttpServletResponse response,B keyBean) throws Exception;
    boolean afterListAttaches(HttpSession session,HttpServletRequest request,HttpServletResponse response,B keyBean,List${"<"}String${">"} result) throws Exception;
}
</pac:java>