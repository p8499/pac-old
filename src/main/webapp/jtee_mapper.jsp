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
    package ${sessionScope.json.envJtee.packageMapper}.${module.datasource};
    import java.util.List;
    import org.apache.ibatis.annotations.Select;
    import org.apache.ibatis.annotations.Insert;
    import org.apache.ibatis.annotations.Update;
    import org.apache.ibatis.annotations.Delete;
    import org.apache.ibatis.annotations.Param;
    import org.springframework.stereotype.Component;
    import ${sessionScope.json.envJtee.packageMask}.${module.jteeMaskAlias};
    import ${sessionScope.json.envJtee.packageBean}.${module.jteeBeanAlias};
    @Component("${pac:lowerFirst(module.jteeMapperAlias)}")
    public interface ${module.jteeMapperAlias}
    {   @Select("SELECT COUNT(*)>0 FROM ${module.databaseView} WHERE <c:forEach items="${keys}" var="keyItem" varStatus="keyStatus">${pac:upper(keyItem.key)}=${String.format("#{%s}",keyItem.key)}<c:if test="${!keyStatus.last}"> AND </c:if></c:forEach>")
        public boolean exists(<c:forEach items="${keys}" var="keyItem" varStatus="keyStatus">@Param("${keyItem.value.databaseColumn}")${keyItem.value.javaType} ${keyItem.value.databaseColumn}<c:if test="${!keyStatus.last}">,</c:if></c:forEach>);

        @Select("${'<script>'}"
            + "<choose>"
            + "<when test='mask!=null'>"
            + "<if test='<c:forEach items="${module.fields}" var="field" varStatus="fieldStatus">mask.${field.databaseColumn}<c:if test="${!fieldStatus.last}"> or </c:if></c:forEach>'>"
            + "<trim prefix='SELECT' suffixOverrides=','>"
            <c:forEach items="${module.fields}" var="field">
                + "<if test='mask.${field.databaseColumn}'>${pac:upper(field.databaseColumn)}, </if>"</c:forEach>
            + "</trim>"
            + "FROM ${module.databaseView} WHERE <c:forEach items="${keys}" var="keyItem" varStatus="keyStatus">${pac:upper(keyItem.key)}=${String.format("#{%s}",keyItem.key)}<c:if test="${!keyStatus.last}"> AND </c:if></c:forEach>"
            + "</if>"
            + "</when>"
            + "<otherwise>"
            + "SELECT ${pac:join(",",pac:upper(pac:read(module,"$..databaseColumn")))} FROM ${module.databaseView} WHERE <c:forEach items="${keys}" var="keyItem" varStatus="keyStatus">${pac:upper(keyItem.key)}=${String.format("#{%s}",keyItem.key)}<c:if test="${!keyStatus.last}"> AND </c:if></c:forEach>"
            + "</otherwise>"
            + "</choose>"
            + "${'</script>'}")
        public ${module.jteeBeanAlias} get(<c:forEach items="${keys}" var="keyItem">@Param("${keyItem.value.databaseColumn}")${keyItem.value.javaType} ${keyItem.value.databaseColumn},</c:forEach>@Param("mask")${module.jteeMaskAlias} mask);

        <c:choose>
            <c:when test="${pac:read(module,\"uniques[?(@.key)]\")[0].serial}">
                @Insert("INSERT INTO ${module.databaseTable} (<c:forEach items="${nonkeys}" var="fieldItem" varStatus="fieldStatus">${pac:upper(fieldItem.key)}<c:if test="${!fieldStatus.last}">,</c:if></c:forEach>) VALUES (<c:forEach items="${nonkeys}" var="fieldItem" varStatus="fieldStatus">${String.format("#{bean.%s}",fieldItem.key)}<c:if test="${!fieldStatus.last}">,</c:if></c:forEach>)")
                @org.apache.ibatis.annotations.Options(useGeneratedKeys=true,keyProperty="bean.${pac:read(module,"uniques[?(@.key)]")[0][0]}")</c:when>
            <c:otherwise>
                @Insert("INSERT INTO ${module.databaseTable} (${pac:join(",",pac:upper(pac:read(module.fields,"$..databaseColumn")))}) VALUES (<c:forEach items="${module.fields}" var="field" varStatus="fieldStatus">${String.format("#{bean.%s}",field.databaseColumn)}<c:if test="${!fieldStatus.last}">,</c:if></c:forEach>)")</c:otherwise></c:choose>
        public void add(@Param("bean")${module.jteeBeanAlias} bean);

        @Update("${'<script>'}"
            + "<choose>"
            + "<when test='mask!=null'>"
            + "<if test='<c:forEach items="${nonkeys}" var="fieldItem" varStatus="fieldStatus">mask.${fieldItem.key}<c:if test="${!fieldStatus.last}"> or </c:if></c:forEach>'>"
            + "UPDATE ${module.databaseTable} "
            + "<set>"
            <c:forEach items="${nonkeys}" var="fieldItem">
                + "<if test='mask.${fieldItem.key}'>${pac:upper(fieldItem.key)}=${String.format("#{bean.%s}",fieldItem.key)}, </if>"</c:forEach>
            + "</set>"
            + "WHERE <c:forEach items="${keys}" var="keyItem" varStatus="keyStatus">${pac:upper(keyItem.key)}=${String.format("#{bean.%s}",keyItem.key)}<c:if test="${!keyStatus.last}"> AND </c:if></c:forEach>"
            + "</if>"
            + "</when>"
            + "<otherwise>"
            + "UPDATE ${module.databaseTable} SET <c:forEach items="${nonkeys}" var="fieldItem" varStatus="fieldStatus">${String.format("%s=#{bean.%s}",pac:upper(fieldItem.key),fieldItem.key)}<c:if test="${!fieldStatus.last}">,</c:if></c:forEach> WHERE <c:forEach items="${keys}" var="keyItem" varStatus="keyStatus">${pac:upper(keyItem.key)}=${String.format("#{bean.%s}",keyItem.key)}<c:if test="${!keyStatus.last}"> AND </c:if></c:forEach>"
            + "</otherwise>"
            + "</choose>"
            + "${'</script>'}")
        public void update(@Param("bean")${module.jteeBeanAlias} bean,@Param("mask")${module.jteeMaskAlias} mask);

        @Delete("DELETE FROM ${module.databaseTable} WHERE <c:forEach items="${keys}" var="keyItem" varStatus="keyStatus">${pac:upper(keyItem.key)}=${String.format("#{%s}",keyItem.key)}<c:if test="${!keyStatus.last}"> AND </c:if></c:forEach>")
        public boolean delete(<c:forEach items="${keys}" var="keyItem" varStatus="keyStatus">@Param("${keyItem.value.databaseColumn}")${keyItem.value.javaType} ${keyItem.value.databaseColumn}<c:if test="${!keyStatus.last}">,</c:if></c:forEach>);

        <c:choose>
            <c:when test="${datasource.databaseType==\"postgresql\"}">
                @Select("${'<script>'}"
                    + "<choose>"
                    + "<when test='mask!=null'>"
                    + "<trim prefix='SELECT' suffixOverrides=','>"
                    <c:forEach items="${module.fields}" var="field">
                        + "<if test='mask.${field.databaseColumn}'>${pac:upper(field.databaseColumn)}, </if>"</c:forEach>
                    + "</trim>"
                    + "</when>"
                    + "<otherwise>"
                    + "SELECT ${pac:join(",",pac:upper(pac:read(module.fields,"$..databaseColumn")))} "
                    + "</otherwise>"
                    + "</choose>"
                    + "FROM ${module.databaseView} "
                    + "<if test='filter!=null'>WHERE ${'${filter}'} </if>"
                    + "<if test='order!=null'>ORDER BY ${'${order}'} </if>"
                    + "LIMIT ${'#{count}'} OFFSET ${'#{start}'}"
                    + "${'</script>'}")</c:when>
            <c:when test="${datasource.databaseType==\"oracle\"}">
                @Select("${'<script>'}"
                    + "SELECT A.* FROM (SELECT B.*, ROWNUM B_ROWNUM FROM ("
                    + "<choose>"
                    + "<when test='mask!=null'>"
                    + "<trim prefix='SELECT' suffixOverrides=','>"
                    <c:forEach items="${module.fields}" var="field">
                        + "<if test='mask.${field.databaseColumn}'>${pac:upper(field.databaseColumn)}, </if>"</c:forEach>
                    + "</trim>"
                    + "</when>"
                    + "<otherwise>"
                    + "SELECT ${pac:join(",",pac:upper(pac:read(module.fields,"$..databaseColumn")))} "
                    + "</otherwise>"
                    + "</choose>"
                    + "FROM ${module.databaseView} "
                    + "<if test='filter!=null'>WHERE ${'${filter}'} </if>"
                    + "<if test='order!=null'>ORDER BY ${'${order}'} </if>"
                    + ") B WHERE ROWNUM &lt;= ${'#{count}+1'}) A WHERE B_ROWNUM &gt;= ${'#{count}+#{start}'}"
                    + "${'</script>'}")</c:when></c:choose>
        public List<${module.jteeBeanAlias}> query(@Param("filter")String filter,@Param("order")String order,@Param("start")long start,@Param("count")long count,@Param("mask")${module.jteeMaskAlias} mask);

        @Select("${'<script>'}"
            + "SELECT COUNT(*) FROM ${module.databaseView} "
            + "<if test='filter!=null'>WHERE ${'${filter}'}</if> "
            + "${'</script>'}")
        public long count(@Param("filter")String filter);

        <c:forEach items="${pac:read(module,\"$.fields[?(@.special.type=='next')]\")}" var="field">
            @Select("SELECT COALESCE(MAX(${pac:upper(field.databaseColumn)}),0)+1 FROM ${module.databaseView} WHERE <c:forEach items="${field.special.scope}" var="scopeColumn" varStatus="fieldStatus">${String.format("%s=#{%s}",scopeColumn,scopeColumn)}<c:if test="${!fieldStatus.last}"> AND </c:if></c:forEach>")
            public ${field.javaType} next${pac:upperFirst(field.databaseColumn)}
            (   <c:forEach items="${field.special.scope}" var="scopeColumn" varStatus="scopeColumnStatus">
                    @Param("${scopeColumn}") ${pac:read(module,String.format("$.fields[?(@.databaseColumn=='%s')]",scopeColumn))[0].javaType} ${scopeColumn}
                    <c:if test="${!scopeColumnStatus.last}">,</c:if></c:forEach>
            );</c:forEach>
<%--
        <c:choose>
            <c:when test="${!empty module.uniques}">
                @Select("${'<script>'}"
                    + "SELECT SUM(C)=0 FROM( "
                <c:forEach items="${module.uniques}" var="unique" varStatus="uniqueStatus">
                    + "SELECT COUNT(*) C FROM ${module.databaseView} WHERE <c:forEach items="${unique}" var="uniqueColumn" varStatus="uniqueColumnStatus">${String.format("%s=#{bean.%s}",pac:upper(uniqueColumn),uniqueColumn)}<c:if test="${!uniqueColumnStatus.last}"> AND </c:if></c:forEach><if test='bean.${key.databaseColumn}!=null'> AND ${pac:upper(key.databaseColumn)}!=${String.format("#{bean.%s}",key.databaseColumn)}</if><c:if test="${!uniqueStatus.last}"> UNION ALL</c:if> "</c:forEach>
                + ") T"
                + "${'</script>'}")</c:when>
            <c:otherwise>
                @Select("SELECT 1")</c:otherwise></c:choose>
        public boolean unique(@Param("bean")${module.jteeBeanAlias} bean);
        <c:choose>
            <c:when test="${!empty module.references}">
                @Select("SELECT COUNT(C)=0 FROM( "
                <c:forEach items="${module.references}" var="reference" varStatus="referenceStatus">
                    <c:set var="foreignModule" value="${pac:read(sessionScope.json,String.format(\"$.modules[?(@.id=='%s')]\",reference.foreignModule))[0]}"/>
                    <c:set var="foreignKey" value="${pac:read(foreignModule,\"$.fields[?(@.special.type=='key')]\")[0]}"/>
                    + "SELECT COUNT(${pac:upper(foreignKey.databaseColumn)}) C FROM ${foreignModule.databaseView} WHERE <c:forEach items="${reference.domestic}" var="domesticColumn" varStatus="domesticColumnStatus">${String.format("%s=#{bean.%s}",pac:upper(reference.foreign[domesticColumnStatus.index]),domesticColumn)}<c:if test="${!domesticColumnStatus.last}"> AND </c:if></c:forEach><c:if test="${!referenceStatus.last}"> UNION ALL</c:if> "</c:forEach>
                + ") T WHERE C=0")</c:when>
            <c:otherwise>
                @Select("SELECT 1")</c:otherwise></c:choose>
        public boolean referencing(@Param("bean")${module.jteeBeanAlias} bean);

        <c:forEach items="${module.references}" var="reference">
            <c:set var="foreignModule" value="${pac:read(sessionScope.json,String.format(\"$.modules[?(@.id=='%s')]\",reference.foreignModule))[0]}"/>
            <c:set var="foreignKey" value="${pac:read(foreignModule,\"$.fields[?(@.special.type=='key')]\")[0]}"/>
            @Select("SELECT COUNT(${pac:upper(foreignKey.databaseColumn)})>0 FROM ${foreignModule.databaseView} WHERE <c:forEach items="${reference.domestic}" var="domesticColumn" varStatus="domesticColumnStatus">${String.format("%s=#{%s}",pac:upper(reference.foreign[domesticColumnStatus.index]),domesticColumn)}<c:if test="${!domesticColumnStatus.last}"> AND </c:if></c:forEach>")
            public boolean referencing${pac:join("",pac:upperFirst(reference.domestic))}
            (   <c:forEach items="${reference.domestic}" var="domesticColumn" varStatus="domesticColumnStatus">
                    @Param("${domesticColumn}")${pac:read(module,String.format("$.fields[?(@.databaseColumn=='%s')]",domesticColumn))[0].javaType} ${domesticColumn}
                    <c:if test="${!domesticColumnStatus.last}">,</c:if></c:forEach>
            );</c:forEach>

        <c:choose>
            <c:when test="${pac:read(sessionScope.json,String.format(\"$..references[?(@.foreignModule=='%s')]\",module.id)).size()>0}">
                @Select("SELECT SUM(C)>0 FROM( "
                <c:forEach items="${sessionScope.json.modules}" var="dModule">
                    <c:set var="dKey" value="${pac:read(dModule,\"$.fields[?(@.special.type=='key')]\")[0]}"/>
                    <c:forEach items="${pac:read(dModule,String.format(\"$.references[?(@.foreignModule=='%s')]\",module.id))}" var="dReference" varStatus="dReferenceStatus">
                            + "SELECT COUNT(${pac:upper(dKey.databaseColumn)}) C FROM ${dModule.databaseView} WHERE <c:forEach items="${dReference.domestic}" var="dDomesticColumn" varStatus="dDomesticColumnStatus">${String.format("%s=#{bean.%s}",pac:upper(dDomesticColumn),dReference.foreign[dDomesticColumnStatus.index])}<c:if test="${!dDomesticColumnStatus.last}"> AND </c:if></c:forEach><c:if test="${!dReferenceStatus.last}"> UNION ALL</c:if> "</c:forEach></c:forEach>
                + ") T")</c:when>
            <c:otherwise>
                @Select("SELECT 1")</c:otherwise></c:choose>
        public boolean referenced(@Param("bean")${module.jteeBeanAlias} bean);

        <c:set var="d" value="${pac:newMap()}"/>
        <c:forEach items="${sessionScope.json.modules}" var="dModule">
            <c:forEach items="${dModule.references}" var="dReference">
                <c:if test="${dReference.foreignModule==module.id}">
                    <c:if test="${empty d[pac:join(',',dReference.foreign)]}">
                        <c:set target="${d}" property="${pac:join(\",\",dReference.foreign)}" value="${pac:newList()}"/></c:if>
                    ${pac:n(d[pac:join(',',dReference.foreign)].add(dModule))}</c:if></c:forEach></c:forEach>
        <c:forEach items="${d}" var="dItem">
            @Select("SELECT SUM(C)>0 FROM( "
            <c:forEach items="${dItem.value}" var="dModule" varStatus="dModuleStatus">
                <c:set var="dModuleKey" value="${pac:read(dModule,\"$.fields[?(@.special.type=='key')]\")[0]}"/>
                + "SELECT COUNT(${pac:upper(dModuleKey.databaseColumn)}) C FROM ${dModule.databaseView} WHERE <c:forEach items="${dModule.references}" var="dReference"><c:if test="${dReference.foreignModule==module.id&&pac:join(\",\",dReference.foreign)==dItem.key}"><c:forEach items="${dReference.domestic}" var="dDomestic" varStatus="dDomesticStatus">${String.format("%s=#{%s}",pac:upper(dDomestic),dReference.foreign[dDomesticStatus.index])}<c:if test="${!dDomesticStatus.last}"> AND </c:if></c:forEach></c:if></c:forEach><c:if test="${!dModuleStatus.last}"> UNION ALL</c:if> "</c:forEach>
            + ") T")
            public boolean referenced${pac:join("",pac:upperFirst(dItem.key.split(",")))}
            (   <c:forEach items="${dItem.key.split(\",\")}" var="dKeyColumn" varStatus="dKeyColumnStatus">
                    @Param("${dKeyColumn}")${pac:read(module,String.format("$.fields[?(@.databaseColumn=='%s')]",dKeyColumn))[0].javaType} ${dKeyColumn}
                    <c:if test="${!dKeyColumnStatus.last}">,</c:if></c:forEach>
            );</c:forEach>--%>
    }
</pac:java>