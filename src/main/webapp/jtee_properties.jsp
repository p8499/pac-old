<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="pac" uri="/WEB-INF/pac.tld" %>
<c:forEach items="${sessionScope.json.envJtee.datasources}" var="datasource">
${datasource.id}.driverClassName=<c:choose><c:when test="${datasource.databaseType==\"oracle\"}">oracle.jdbc.OracleDriver</c:when><c:when test="${datasource.databaseType==\"postgresql\"}">org.postgresql.Driver</c:when><c:when test="${datasource.databaseType==\"mysql\"}">com.mysql.jdbc.Driver</c:when></c:choose>
${datasource.id}.url=${datasource.url}
${datasource.id}.username=${datasource.username}
${datasource.id}.password=${datasource.password}</c:forEach>