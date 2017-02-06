<%--@formatter:off--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="pac" uri="/WEB-INF/pac.tld" %>
<c:if test="${sessionScope.json.envJtee.databaseType==\"postgresql\"}">
set client_encoding=UTF8;
<c:forEach items="${pac:read(sessionScope.json,\"$.modules[?(@.databaseTable!=@.databaseView)]\")}" var="module">
/*id: ${module.id}
  description: ${module.description}
  comment: ${module.comment}
 */
create view ${module.databaseView} as
select *,<c:forEach items="${pac:read(module,\"$.fields[?(@.special.type=='view')]\")}" var="field" varStatus="fieldStatus">
${field.special.func}(t) ${pac:upper(field.databaseColumn)}<c:if test="${!fieldStatus.last}">,</c:if></c:forEach>
from ${module.databaseTable} t;
</c:forEach>
</c:if>