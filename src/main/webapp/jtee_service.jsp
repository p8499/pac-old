<%@ page import="com.p8499.pac.Util" %><%--@formatter:off--%>
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
<c:set var="datasource" value="${pac:read(sessionScope.json.envJtee,String.format(\"$.datasources[?(@.id=='%s')]\",module.datasource))[0]}"/>
<pac:java>
    package ${sessionScope.json.envJtee.packageService};
    import ${sessionScope.json.envJtee.packageBase}.FilterExpr;
    import ${sessionScope.json.envJtee.packageBase}.OrderByListExpr;
    import ${sessionScope.json.envJtee.packageMask}.${module.jteeMaskAlias};
    import ${sessionScope.json.envJtee.packageBean}.${module.jteeBeanAlias};
    import ${sessionScope.json.envJtee.packageMapper}.${module.datasource}.${module.jteeMapperAlias};
    import org.apache.ibatis.annotations.Insert;
    import org.apache.ibatis.annotations.Update;
    import org.springframework.beans.factory.annotation.Value;
    import org.springframework.stereotype.Service;
    import org.springframework.transaction.annotation.Transactional;
    import org.springframework.validation.beanvalidation.LocalValidatorFactoryBean;
    import javax.validation.ConstraintViolation;
    import java.util.List;
    import java.util.Set;
    @Service("${pac:lowerFirst(module.jteeServiceAlias)}")
    public class ${module.jteeServiceAlias}
    {   @Transactional(readOnly=true)
        public ${module.jteeBeanAlias} get(<c:forEach items="${keys}" var="keyItem">${keyItem.value.javaType} ${keyItem.value.databaseColumn},</c:forEach> ${module.jteeMaskAlias} mask)
        {   return ${pac:lowerFirst(module.jteeMapperAlias)}.get(<c:forEach items="${keys}" var="keyItem">${keyItem.key},</c:forEach> mask);
        }
        @Transactional(value="${module.datasource}_transaction")
        public ${module.jteeBeanAlias} add(${module.jteeBeanAlias} bean)
        {   if (!validatorFactory.getValidator().validate(bean,Insert.class).isEmpty())
            {   return null;
            }
            ${pac:lowerFirst(module.jteeMapperAlias)}.add(bean);
            return bean;
        }

    @Transactional(value="${module.datasource}_transaction")
    public ${module.jteeBeanAlias} update(${module.jteeBeanAlias} bean, ${module.jteeMaskAlias} mask)
    {   Set${"<"}ConstraintViolation${"<"}${module.jteeBeanAlias}${">"}${">"} violationSet= validatorFactory.getValidator().validate(bean, Update.class);
        for (ConstraintViolation${"<"}${module.jteeBeanAlias}${">"} violation : violationSet) {
            if (mask.get(violation.getPropertyPath().toString())) {
                return null;
            }
        }
        ${pac:lowerFirst(module.jteeMapperAlias)}.update(bean, mask);
        return bean;
    }

    @Transactional(value="${module.datasource}_transaction")
    public boolean delete(<c:forEach items="${keys}" var="keyItem" varStatus="keyStatus">${keyItem.value.javaType} ${keyItem.value.databaseColumn}<c:if test="${!keyStatus.last}">,</c:if></c:forEach>)
    {   return ${pac:lowerFirst(module.jteeMapperAlias)}.delete(<c:forEach items="${keys}" var="keyItem" varStatus="keyStatus">${keyItem.key}<c:if test="${!keyStatus.last}">,</c:if></c:forEach>);
    }

    @Transactional(value="${module.datasource}_transaction")
    public void delete(FilterExpr filter)
    {   ${pac:lowerFirst(module.jteeMapperAlias)}.delete(filter);
    }

    @Transactional(readOnly=true)
    public long count(FilterExpr filter)
    {   return ${pac:lowerFirst(module.jteeMapperAlias)}.count(filter);
    }

    @Transactional(readOnly=true)
    public List${"<"}${module.jteeBeanAlias}${">"} query(FilterExpr filter,OrderByListExpr orderByList,long start,long count,${module.jteeMaskAlias} mask)
    {   return ${pac:lowerFirst(module.jteeMapperAlias)}.query(filter,orderByList,start,count,mask);
    }

    @Transactional(readOnly=true)
    public boolean exists(<c:forEach items="${keys}" var="keyItem" varStatus="keyStatus">${keyItem.value.javaType} ${keyItem.value.databaseColumn}<c:if test="${!keyStatus.last}">,</c:if></c:forEach>)
    {   return ${pac:lowerFirst(module.jteeMapperAlias)}.exists(<c:forEach items="${keys}" var="keyItem" varStatus="keyStatus">${keyItem.key}<c:if test="${!keyStatus.last}">,</c:if></c:forEach>);
    }
    <c:forEach items="${pac:read(module,\"$.fields[?(@.javaType in ['Integer','Double','java.util.Date'])]\")}" var="field">
        @Transactional(readOnly=true)
        public ${field.javaType} max${pac:upperFirst(field.databaseColumn)}(FilterExpr filter,${field.javaType} defaultValue)
        {   return ${pac:lowerFirst(module.jteeMapperAlias)}.max${pac:upperFirst(field.databaseColumn)}(filter,defaultValue);
        }

        @Transactional(readOnly=true)
        public ${field.javaType} min${pac:upperFirst(field.databaseColumn)}(FilterExpr filter,${field.javaType} defaultValue)
        {   return ${pac:lowerFirst(module.jteeMapperAlias)}.max${pac:upperFirst(field.databaseColumn)}(filter,defaultValue);
        }</c:forEach>

    @Value(value="${String.format("#{%s}",pac:lowerFirst(module.jteeMapperAlias))}")
    protected ${module.jteeMapperAlias} ${pac:lowerFirst(module.jteeMapperAlias)};
    @Value(value="${"#{validatorFactory}"}")
    protected LocalValidatorFactoryBean validatorFactory;
}
</pac:java>