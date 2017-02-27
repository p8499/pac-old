<%--@formatter:off--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="pac" uri="/WEB-INF/pac.tld" %>
<c:set var="datasource" value="${pac:read(sessionScope.json.envJtee,String.format(\"$.datasources[%d]\",requestScope.dindex))}"/>
<c:if test="${datasource.databaseType==\"postgresql\"}">
set client_encoding=UTF8;
<c:forEach items="${pac:read(sessionScope.json,String.format(\"$.modules[?(@.datasource=='%s'&&@.databaseTable!=@.databaseView)]\",datasource.id))}" var="module">
/*id: ${module.id}
  description: ${module.description}
  comment: ${module.comment}
 */
create view ${module.databaseView} as
select *,<c:forEach items="${pac:read(module,\"$.fields[?(@.source=='view')]\")}" var="field" varStatus="fieldStatus">
${module.databaseView}_${pac:upper(field.databaseColumn)}(t) ${pac:upper(field.databaseColumn)}<c:if test="${!fieldStatus.last}">,</c:if></c:forEach>
from ${module.databaseTable} t;
</c:forEach>
</c:if>