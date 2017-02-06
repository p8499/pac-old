<%--@formatter:off--%>
<%@ page import="java.util.Calendar" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="pac" uri="/WEB-INF/pac.tld" %>
<c:set var="module" value="${pac:read(sessionScope.json,String.format(\"$.modules[%d]\",requestScope.index))}"/>
<pac:java>
package ${sessionScope.json.envAndroid.packageView};
import java.util.List;
import ${sessionScope.json.envAndroid.packageBean}.${module.androidBeanAlias};
public interface ${module.androidBeanAlias}ListView
{	void on${module.androidBeanAlias}ListReloaded(List${"<"}${module.androidBeanAlias}${">"} ${pac:lower(module.androidBeanAlias)}List);
    void on${module.androidBeanAlias}ListAppended(List${"<"}${module.androidBeanAlias}${">"} ${pac:lower(module.androidBeanAlias)}List);
}
</pac:java>