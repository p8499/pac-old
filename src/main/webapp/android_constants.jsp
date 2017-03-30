<%--@formatter:off--%>
<%@ page import="java.util.Date" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="pac" uri="/WEB-INF/pac.tld" %>
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <c:forEach items="${sessionScope.json.modules}" var="module" >
        <c:forEach items="${module.fields}" var="field">
            <c:choose>
                <c:when test="${field.javaType==\"Integer\"}">
                    <integer name="${pac:upperFirst(module.id)}_${pac:upperFirst(field.databaseColumn)}_Length_Integer">${field.integerLength}</integer>
                    <integer name="${pac:upperFirst(module.id)}_${pac:upperFirst(field.databaseColumn)}_Min">${String.format("%.0f",-Math.pow(10,field.integerLength))}</integer>
                    <integer name="${pac:upperFirst(module.id)}_${pac:upperFirst(field.databaseColumn)}_Max">${String.format("%.0f",Math.pow(10,field.integerLength))}</integer></c:when>
                <c:when test="${field.javaType==\"Double\"}">
                    <integer name="${pac:upperFirst(module.id)}_${pac:upperFirst(field.databaseColumn)}_Length_Integer">${field.integerLength}</integer>
                    <integer name="${pac:upperFirst(module.id)}_${pac:upperFirst(field.databaseColumn)}_Length_Fraction">${field.fractionLength}</integer></c:when>
                <c:when test="${field.javaType==\"String\"}">
                    <integer name="${pac:upperFirst(module.id)}_${pac:upperFirst(field.databaseColumn)}_Length_String">${field.stringLength}</integer></c:when></c:choose></c:forEach></c:forEach>
</resources>