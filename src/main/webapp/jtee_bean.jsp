<%--@formatter:off--%>
<%@ page import="java.util.Calendar" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="pac" uri="/WEB-INF/pac.tld" %>
<c:set var="module" value="${pac:read(sessionScope.json,String.format(\"$.modules[%d]\",requestScope.index))}"/>
<c:set var="keys" value="${pac:newMap()}"/>
<c:set var="nonkeys" value="${pac:newMap()}"/>
<c:forEach items="${module.fields}" var="field">
    <c:choose>
        <c:when test="${pac:join(\",\",pac:read(module,\"$.uniques[?(@.key)]\")[0].items).indexOf(field.databaseColumn)>-1}">
            <c:set target="${keys}" property="${field.databaseColumn}" value="${field}"/></c:when>
        <c:otherwise>
            <c:set target="${nonkeys}" property="${field.databaseColumn}" value="${field}"/></c:otherwise></c:choose></c:forEach>
<pac:java>
    package ${sessionScope.json.envJtee.packageBean};
    import com.fasterxml.jackson.annotation.JsonInclude;
    import org.apache.ibatis.annotations.Insert;
    import org.apache.ibatis.annotations.Update;
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public class ${module.jteeBeanAlias}
    {   public static final String TABLE="${module.databaseTable}";
        public static final String VIEW="${module.databaseView}";
        public static final String NAME="${pac:upper(module.id)}";
        <c:forEach items="${module.fields}" var="field">
            public static final String FIELD_${pac:upper(field.databaseColumn)}="${pac:upper(field.databaseColumn)}";</c:forEach>
        <c:forEach items="${pac:read(module,\"$.fields[?(@.values.length()>0)]\")}" var="field">
            <c:forEach items="${field.values}" var="value">
                public static final ${field.javaType} ${pac:upper(field.databaseColumn)}_${value.code}=
                <c:choose>
                    <c:when test="${field.javaType==\"Integer\"}">${value.value}</c:when>
                    <c:when test="${field.javaType==\"Double\"}">${value.value}</c:when>
                    <c:when test="${field.javaType==\"String\"}">"${value.value}"</c:when></c:choose>
                ;</c:forEach></c:forEach>
        <c:forEach items="${pac:read(module,\"$.fields[?(@.defaultValue!='')]\")}" var="field">
            public static final ${field.javaType} DEFAULT_${pac:upper(field.databaseColumn)}=
            <c:choose>
                <c:when test="${field.javaType==\"Integer\"}">${field.defaultValue}</c:when>
                <c:when test="${field.javaType==\"Double\"}">${field.defaultValue}</c:when>
                <c:when test="${field.javaType==\"String\"}">"${field.defaultValue}"</c:when></c:choose>;</c:forEach>
        <c:forEach items="${module.fields}" var="field">
            <c:if test="${field.javaType==\"java.util.Date\"}">@com.fasterxml.jackson.annotation.JsonFormat(timezone="${pac:gmt()}",pattern="yyyyMMddHHmmss")</c:if>
            protected ${field.javaType} ${field.databaseColumn}=<c:choose><c:when test="${field.defaultValue!=\"\"}">DEFAULT_${pac:upper(field.databaseColumn)}</c:when><c:otherwise>null</c:otherwise></c:choose>;</c:forEach>
        public ${module.jteeBeanAlias}
        (   <c:forEach items="${module.fields}" var="field" varStatus="fieldStatus">
                ${field.javaType} ${field.databaseColumn}<c:if test="${!fieldStatus.last}">,</c:if></c:forEach>
        )
        {   <c:forEach items="${module.fields}" var="field">
                if(${field.databaseColumn}!=null)
                    this.${field.databaseColumn}=${field.databaseColumn};</c:forEach>
        }
        public ${module.jteeBeanAlias}()
        {   this(
                <c:forEach items="${module.fields}" var="field" varStatus="fieldStatus">
                    null<c:if test="${!fieldStatus.last}">,</c:if></c:forEach>);
        }
        public ${module.jteeBeanAlias} clone()
        {	return new ${module.jteeBeanAlias}
            (   <c:forEach items="${module.fields}" var="field" varStatus="fieldStatus">
                    ${field.databaseColumn}<c:if test="${!fieldStatus.last}">,</c:if></c:forEach>
            );
        }
        <c:forEach items="${module.fields}" var="field">
            <c:choose>
                <c:when test="${keys.containsKey(field.databaseColumn)&&pac:read(module,\"uniques[?(@.key)]\")[0].serial}">
                    @javax.validation.constraints.Null(groups={Insert.class})
                    @javax.validation.constraints.NotNull(groups={Update.class})</c:when>
                <c:when test="${keys.containsKey(field.databaseColumn)}">
                    @javax.validation.constraints.NotNull(groups={Insert.class,Update.class})</c:when>
                <c:when test="${field.source==\"table\"&&field.notnull}">
                    @javax.validation.constraints.NotNull(groups={Insert.class,Update.class})</c:when>
                <c:when test="${field.source==\"table\"}">
                    </c:when>
                <c:when test="${field.source==\"view\"}">
                    @javax.validation.constraints.Null(groups={Insert.class,Update.class})</c:when>
            </c:choose>
            <c:if test="${!pac:read(module,\"uniques[?(@.key)]\")[0].serial||!keys.containsKey(field.databaseColumn)}">
                <c:choose>
                    <c:when test="${field.javaType==\"Integer\"}">
                        @javax.validation.constraints.Min(value=${String.format("%.0f",-Math.pow(10,field.integerLength))})
                        @javax.validation.constraints.Max(value=${String.format("%.0f",Math.pow(10,field.integerLength))})</c:when>
                    <c:when test="${field.javaType==\"Double\"}">
                        @javax.validation.constraints.Digits(integer=${field.integerLength},fraction={field.fractionLength})</c:when>
                    <c:when test="${field.javaType==\"String\"}">
                        @javax.validation.constraints.Size(max=${field.stringLength})</c:when>
                </c:choose>
            </c:if>
            public ${field.javaType} get${pac:upperFirst(field.databaseColumn)}()
            {   return ${field.databaseColumn};
            }
            public ${module.jteeBeanAlias} set${pac:upperFirst(field.databaseColumn)}(${field.javaType} ${field.databaseColumn})
            {   this.${field.databaseColumn}=${field.databaseColumn};
            return this;
            }
        </c:forEach>
    }
</pac:java>