<%--@formatter:off--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="pac" uri="/WEB-INF/pac.tld" %>
<c:if test="${sessionScope.json.envJtee.databaseType==\"postgresql\"}">
set client_encoding=UTF8;
<c:forEach items="${sessionScope.json.modules}" var="module">
<c:set var="key" value="${pac:read(module,\"$.fields[?(@.special.type=='key')]\")[0]}"/>
/*id: ${module.id}
  description: ${module.description}
  comment: ${module.comment}
 */
create table ${module.databaseTable}(<c:forEach items="${pac:read(module,\"$.fields[?(@.special.type!='view')]\")}" var="field" varStatus="fieldStatus">
    /*${field.description}*/<c:choose><c:when test="${field.special.type==\"key\"&&field.special.serial}">
    ${pac:upper(pac:upper(field.databaseColumn))} SERIAL NOT NULL</c:when><c:when test="${field.javaType==\"Integer\"}">
    ${pac:upper(pac:upper(field.databaseColumn))} ${field.integerLength<5?"SMALLINT":field.integerLength<9?"INTEGER":"BIGINT"} NOT NULL</c:when><c:when test="${field.javaType==\"String\"}">
    ${pac:upper(pac:upper(field.databaseColumn))} VARCHAR(${field.stringLength}) NOT NULL</c:when><c:when test="${field.javaType==\"Double\"}">
    ${pac:upper(pac:upper(field.databaseColumn))} DECIMAL(${field.integerLength+field.fractionLength},${field.fractionLength}) NOT NULL</c:when><c:when test="${field.javaType==\"java.util.Date\"}">
    ${pac:upper(pac:upper(field.databaseColumn))} TIMESTAMP NOT NULL</c:when></c:choose><c:if test="${!fieldStatus.last}">,</c:if></c:forEach>
);
ALTER TABLE ${module.databaseTable} ADD CONSTRAINT ${pac:upper(module.id)}_PRIMARY PRIMARY KEY (${pac:upper(key.databaseColumn)});<c:forEach items="${module.uniques}" var="unique" varStatus="uniqueStatus">
ALTER TABLE ${module.databaseTable} ADD CONSTRAINT ${pac:upper(module.id)}_UNIQUE_${uniqueStatus.index} UNIQUE (${pac:join(",",pac:upper(unique))});</c:forEach><c:forEach items="${module.references}" var="reference" varStatus="referenceStatus">
ALTER TABLE ${module.databaseTable} ADD CONSTRAINT ${pac:upper(module.id)}_REFERENCE_${referenceStatus.index} FOREIGN KEY (${pac:join(",",pac:upper(reference.domestic))}) REFERENCES ${pac:read(sessionScope.json,String.format("$.modules[?(@.id=='%s')]",reference.foreignModule))[0].databaseTable} (${pac:join(",",pac:upper(reference.foreign))});</c:forEach>
</c:forEach>
</c:if>