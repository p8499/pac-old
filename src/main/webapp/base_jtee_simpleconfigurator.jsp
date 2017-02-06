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

public class SimpleConfigurator${"<"}B, M${">"} implements Configurator${"<"}B, M${">"} {
    @Override
    public boolean beforeAdd(HttpSession session, HttpServletRequest request, HttpServletResponse response, B bean) {
        return false;
    }

    @Override
    public void afterAdd(HttpSession session, HttpServletRequest request, HttpServletResponse response, B bean) {

    }

    @Override
    public boolean beforeUpdate(HttpSession session, HttpServletRequest request, HttpServletResponse response, B newBean, M mask) {
        return false;
    }

    @Override
    public void afterUpdate(HttpSession session, HttpServletRequest request, HttpServletResponse response, B newBean, M mask) {

    }

    @Override
    public boolean beforeDelete(HttpSession session, HttpServletRequest request, HttpServletResponse response, B keyBean) {
        return false;
    }

    @Override
    public void afterDelete(HttpSession session, HttpServletRequest request, HttpServletResponse response, B keyBean) {

    }

    @Override
    public boolean beforeGet(HttpSession session, HttpServletRequest request, HttpServletResponse response, B keyBean, M mask) {
        return true;
    }

    @Override
    public boolean afterGet(HttpSession session, HttpServletRequest request, HttpServletResponse response, B bean) {
        return true;
    }

    @Override
    public boolean beforeQuery(HttpSession session, HttpServletRequest request, HttpServletResponse response, FilterLogicExpr filter, M mask) {
        return true;
    }

    @Override
    public boolean afterQuery(HttpSession session, HttpServletRequest request, HttpServletResponse response, List${"<"}B${">"} beanList) {
        return true;
    }

    @Override
    public File locateAttach(HttpSession session, HttpServletRequest request, HttpServletResponse response, B keyBean) {
        return null;
    }

    @Override
    public boolean beforeDownloadAttach(HttpSession session, HttpServletRequest request, HttpServletResponse response,  B keyBean, String name) {
        return true;
    }

    @Override
    public boolean afterDownloadAttach(HttpSession session, HttpServletRequest request, HttpServletResponse response,  B keyBean, File file) {
        return true;
    }

    @Override
    public boolean beforeUploadAttach(HttpSession session, HttpServletRequest request, HttpServletResponse response,  B keyBean, String name, byte[] bytes) {
        return false;
    }

    @Override
    public void afterUploadAttach(HttpSession session, HttpServletRequest request, HttpServletResponse response,  B keyBean, String name, File file) {

    }

    @Override
    public boolean beforeDeleteAttach(HttpSession session, HttpServletRequest request, HttpServletResponse response,  B keyBean, String name) {
        return false;
    }

    @Override
    public void afterDeleteAttach(HttpSession session, HttpServletRequest request, HttpServletResponse response,  B keyBean, String name, boolean result) {

    }

    @Override
    public boolean beforeListAttaches(HttpSession session, HttpServletRequest request, HttpServletResponse response,  B keyBean) {
        return true;
    }

    @Override
    public boolean afterListAttaches(HttpSession session, HttpServletRequest request, HttpServletResponse response,  B keyBean, List${"<"}String${">"} result) {
        return true;
    }
}
</pac:java>