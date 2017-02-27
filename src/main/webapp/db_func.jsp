<%--@formatter:off--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="pac" uri="/WEB-INF/pac.tld" %>
<c:set var="datasource" value="${pac:read(sessionScope.json.envJtee,String.format(\"$.datasources[%d]\",requestScope.dindex))}"/>
<c:if test="${datasource.databaseType==\"postgresql\"}">
set client_encoding=UTF8;
<c:forEach items="${pac:read(sessionScope.json,String.format(\"$.modules[?(@.datasource=='%s')]\",datasource.id))}" var="module"><c:forEach items="${pac:read(module,\"$.fields[?(@.source=='view')]\")}" var="field">
/*module: ${module.description}
  field: ${field.description}
 */
CREATE OR REPLACE FUNCTION ${pac:upper(module.databaseView)}_${pac:upper(field.databaseColumn)}(${pac:alias(module.databaseTable)}) RETURNS INT AS $$
DECLARE
	/*Please edit declaration*/
BEGIN
	/*Please edit function body*/
END;
$$LANGUAGE plpgsql;
</c:forEach></c:forEach>
</c:if>