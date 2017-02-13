<%--@formatter:off--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="pac" uri="/WEB-INF/pac.tld" %>
<c:set var="datasource" value="${pac:read(sessionScope.json.envJtee,String.format(\"$.datasources[%d]\",requestScope.dindex))}"/>
<c:if test="${datasource.databaseType==\"postgresql\"}">
set client_encoding=UTF8;
<c:forEach items="${pac:read(sessionScope.json,String.format(\"$.modules[?(@.datasource=='%s')]\",datasource.id))}" var="module">
<c:set var="keys" value="${pac:newMap()}"/><c:set var="nonkeys" value="${pac:newMap()}"/><c:forEach items="${module.fields}" var="field"><c:choose><c:when test="${pac:join(\",\",pac:read(module,\"$.uniques[?(@.key)]\")[0].items).indexOf(field.databaseColumn)>-1}"><c:set target="${keys}" property="${field.databaseColumn}" value="${field}"/></c:when><c:otherwise><c:set target="${nonkeys}" property="${field.databaseColumn}" value="${field}"/></c:otherwise></c:choose></c:forEach>
/*id: ${module.id}
  description: ${module.description}
  comment: ${module.comment}
 */
create table ${module.databaseTable}(<c:forEach items="${pac:read(module,\"$.fields[?(@.special.type!='view')]\")}" var="field" varStatus="fieldStatus">
    /*${field.description}*/<c:choose><c:when test="${keys.containsKey(field.databaseColumn)&&pac:read(module,\"uniques[?(@.key)]\")[0].serial}">
    ${pac:upper(pac:upper(field.databaseColumn))} SERIAL NOT NULL</c:when><c:when test="${field.javaType==\"Integer\"}">
    ${pac:upper(pac:upper(field.databaseColumn))} ${field.integerLength<5?"SMALLINT":field.integerLength<9?"INTEGER":"BIGINT"} NOT NULL</c:when><c:when test="${field.javaType==\"String\"}">
    ${pac:upper(pac:upper(field.databaseColumn))} VARCHAR(${field.stringLength}) NOT NULL</c:when><c:when test="${field.javaType==\"Double\"}">
    ${pac:upper(pac:upper(field.databaseColumn))} DECIMAL(${field.integerLength+field.fractionLength},${field.fractionLength}) NOT NULL</c:when><c:when test="${field.javaType==\"java.util.Date\"}">
    ${pac:upper(pac:upper(field.databaseColumn))} TIMESTAMP NOT NULL</c:when></c:choose><c:if test="${!fieldStatus.last}">,</c:if></c:forEach>
);
ALTER TABLE ${module.databaseTable} ADD CONSTRAINT ${pac:upper(module.id)}_PRIMARY PRIMARY KEY (<c:forEach items="${keys}" var="keyItem">${pac:upper(keyItem.key)}</c:forEach>);<c:forEach items="${module.uniques}" var="unique" varStatus="uniqueStatus">
ALTER TABLE ${module.databaseTable} ADD CONSTRAINT ${pac:upper(module.id)}_UNIQUE_${uniqueStatus.index} UNIQUE (${pac:join(",",pac:upper(unique.items))});</c:forEach><c:forEach items="${module.references}" var="reference" varStatus="referenceStatus">
ALTER TABLE ${module.databaseTable} ADD CONSTRAINT ${pac:upper(module.id)}_REFERENCE_${referenceStatus.index} FOREIGN KEY (${pac:join(",",pac:upper(reference.domestic))}) REFERENCES ${pac:read(sessionScope.json,String.format("$.modules[?(@.id=='%s')]",reference.foreignModule))[0].databaseTable} (${pac:join(",",pac:upper(reference.foreign))});</c:forEach>
</c:forEach>
</c:if>