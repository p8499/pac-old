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
import java.util.List;

public class SimpleExecutor${"<"}B,M${">"} implements Executor${"<"}B,M${">"} {
    @Override
    public boolean overrideGet() {
        return false;
    }

    @Override
    public B onGet(HttpServletRequest request, HttpServletResponse response, HttpSession session, B keyBean, M mask) {
        return null;
    }

    @Override
    public boolean overrideAdd() {
        return false;
    }

    @Override
    public void onAdd(HttpServletRequest request, HttpServletResponse response, HttpSession session, B bean) {

    }

    @Override
    public boolean overrideUpdate() {
        return false;
    }

    @Override
    public void onUpdate(HttpServletRequest request, HttpServletResponse response, HttpSession session, B bean, M mask) {

    }

    @Override
    public boolean overrideDelete() {
        return false;
    }

    @Override
    public boolean onDelete(HttpServletRequest request, HttpServletResponse response, HttpSession session, B keyBean) {
        return false;
    }

    @Override
    public boolean overrideCount() {
        return false;
    }

    @Override
    public long onCount(HttpServletRequest request, HttpServletResponse response, HttpSession session, FilterExpr filter) {
        return 0;
    }

    @Override
    public boolean overrideQuery() {
        return false;
    }

    @Override
    public List${"<"}B${">"} onQuery(HttpServletRequest request, HttpServletResponse response, HttpSession session, FilterExpr filter, OrderByListExpr order, long start, long count, M mask) {
        return null;
    }
}
</pac:java>