<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="pac" uri="/WEB-INF/pac.tld" %>
<c:catch var="exception">
    ${pac:checkProject(sessionScope.json)}
    <c:forEach items="${module.envJtee.datasources}" var="datasource" varStatus="datasourceStatus">
        <%--For Each Datasource--%>
        ${pac:checkDatasource(sessionScope.json,datasource,datasourceStatus)}
    </c:forEach>
    <c:forEach items="${sessionScope.json.modules}" var="module" varStatus="moduleStatus">
        <%--For Each Module--%>
        ${pac:checkModule(sessionScope.json,module,moduleStatus)}
        <c:forEach items="${module.fields}" var="field" varStatus="fieldStatus">
            <%--For Each Field--%>
            ${pac:checkField(sessionScope.json,module,moduleStatus,field,fieldStatus)}
            <c:forEach items="${field.values}" var="value" varStatus="valueStatus">
                <%--For Each Value--%>
                ${pac:checkValue(sessionScope.json,module,moduleStatus,field,fieldStatus,value,valueStatus)}
            </c:forEach>
            <c:forEach items="${field.special.scope}" var="scopeColumn" varStatus="scopeColumnStatus">
                <%--For Each ScopeColumn--%>
                ${pac:checkScopeColumn(sessionScope.json,module,moduleStatus,field,fieldStatus,scopeColumn,scopeColumnStatus)}
            </c:forEach>
        </c:forEach>
        <c:forEach items="${module.uniques}" var="unique" varStatus="uniqueStatus">
            <%--For Each Unique--%>
            ${pac:checkUnique(sessionScope.json,module,moduleStatus,unique,uniqueStatus)}
            <c:forEach items="${unique.items}" var="uniqueColumn" varStatus="uniqueColumnStatus">
                <%--For Each UniqueColumn--%>
                ${pac:checkUniqueColumn(sessionScope.json,module,moduleStatus,unique,uniqueStatus,uniqueColumn,uniqueColumnStatus)}
            </c:forEach>
        </c:forEach>
        <c:forEach items="${module.references}" var="reference" varStatus="referenceStatus">
            <%--For Each Reference--%>
            ${pac:checkReference(sessionScope.json,module,moduleStatus,reference,referenceStatus)}
            <c:forEach items="${reference.domestic}" var="domesticColumn" varStatus="domesticColumnStatus">
                <%--For Each DomesticColumn--%>
                ${pac:checkDomesticColumn(sessionScope.json,module,moduleStatus,reference,referenceStatus,domesticColumn,domesticColumnStatus)}
            </c:forEach>
            <c:forEach items="${reference.foreign}" var="foreignColumn" varStatus="foreignColumnStatus">
                <%--For Each ForeignColumn--%>
                ${pac:checkForeignColumn(sessionScope.json,module,moduleStatus,reference,referenceStatus,foreignColumn,foreignColumnStatus)}
            </c:forEach>
        </c:forEach>
    </c:forEach>
    All validated.
</c:catch>
<c:if test="${exception!=null}">
    ${exception.cause.message}
</c:if>