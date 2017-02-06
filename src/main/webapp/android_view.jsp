<%--@formatter:off--%>
<%@ page import="java.util.Calendar" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="pac" uri="/WEB-INF/pac.tld" %>
<c:set var="module" value="${pac:read(sessionScope.json,String.format(\"$.modules[%d]\",requestScope.index))}"/>
<pac:java>
package ${sessionScope.json.envAndroid.packageView};
import ${sessionScope.json.envAndroid.packageBean}.${module.androidBeanAlias};
public interface ${module.androidBeanAlias}View
{	void on${module.androidBeanAlias}(${module.androidBeanAlias} ${pac:lower(module.androidBeanAlias)});
}
</pac:java>