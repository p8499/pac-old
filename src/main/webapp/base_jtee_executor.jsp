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

public interface Executor${"<"}B, M${">"}
{   boolean overrideGet();
    B onGet(HttpServletRequest request, HttpServletResponse response, HttpSession session, B keyBean, M mask);
    boolean overrideAdd();
    void onAdd(HttpServletRequest request, HttpServletResponse response, HttpSession session, B bean);
    boolean overrideUpdate();
    void onUpdate(HttpServletRequest request, HttpServletResponse response, HttpSession session, B bean, M mask);
    boolean overrideDelete();
    boolean onDelete(HttpServletRequest request, HttpServletResponse response, HttpSession session, B keyBean);
    boolean overrideCount();
    long onCount(HttpServletRequest request, HttpServletResponse response, HttpSession session, FilterExpr filter);
    boolean overrideQuery();
    List${"<"}B${">"} onQuery(HttpServletRequest request, HttpServletResponse response, HttpSession session, FilterExpr filter, OrderByListExpr order, long start, long count, M mask);
}
</pac:java>