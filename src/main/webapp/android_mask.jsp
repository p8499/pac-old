<%--@formatter:off--%>
<%@ page import="java.util.Calendar" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="pac" uri="/WEB-INF/pac.tld" %>
<c:set var="module" value="${pac:read(sessionScope.json,String.format(\"$.modules[%d]\",requestScope.index))}"/>
<pac:java>
    package ${sessionScope.json.envAndroid.packageMask};
    import java.io.IOException;
    import com.fasterxml.jackson.core.JsonGenerator;
    import com.fasterxml.jackson.core.JsonProcessingException;
    import com.fasterxml.jackson.databind.JsonSerializer;
    import com.fasterxml.jackson.databind.SerializerProvider;
    import com.fasterxml.jackson.databind.annotation.JsonSerialize;
    @JsonSerialize(using=${module.androidMaskAlias}.Serializer.class)
    public class ${module.androidMaskAlias}
    {   <c:forEach items="${module.fields}" var="field">
            protected boolean ${field.databaseColumn}=false;</c:forEach>
        public ${module.androidMaskAlias}
        (   <c:forEach items="${module.fields}" var="field" varStatus="fieldStatus">
                boolean ${field.databaseColumn}<c:if test="${!fieldStatus.last}">,</c:if></c:forEach>
        )
        {   <c:forEach items="${module.fields}" var="field">
                this.${field.databaseColumn}=${field.databaseColumn};</c:forEach>
        }
        public ${module.androidMaskAlias}()
        {
        }
        public ${module.androidMaskAlias} all(boolean b)
        {   <c:forEach items="${module.fields}" var="field">
                this.${field.databaseColumn}=b;</c:forEach>
            return this;
        }
        <c:forEach items="${module.fields}" var="field">
            public boolean get${pac:upperFirst(field.databaseColumn)}()
            {   return ${field.databaseColumn};
            }
            public ${module.androidMaskAlias} set${pac:upperFirst(field.databaseColumn)}(boolean ${field.databaseColumn})
            {   this.${field.databaseColumn}=${field.databaseColumn};
                return this;
            }</c:forEach>
        public boolean get(String p)
        {   <c:forEach items="${module.fields}" var="field" varStatus="fieldStatus">
                <c:if test="${!fieldStatus.first}">else </c:if>if (p.equals("${field.databaseColumn}"))
                    return ${field.databaseColumn}; </c:forEach>
            return false;
        }
        public void set(String p, boolean b)
        {   <c:forEach items="${module.fields}" var="field" varStatus="fieldStatus">
                <c:if test="${!fieldStatus.first}">else </c:if>if (p.equals("${field.databaseColumn}"))
                    this.${field.databaseColumn}=b; </c:forEach>
        }
        public static class Serializer extends JsonSerializer${"<"}${module.androidMaskAlias}${">"}
        {   @Override
            public void serialize(${module.androidMaskAlias} value,JsonGenerator gen,SerializerProvider serializers) throws IOException,JsonProcessingException
            {   gen.writeStartObject();
                <c:forEach items="${module.fields}" var="field">
                    if(value.get${pac:upperFirst(field.databaseColumn)}())
                    {   gen.writeFieldName("${field.databaseColumn}");
                        gen.writeBoolean(value.get${pac:upperFirst(field.databaseColumn)}());
                    }</c:forEach>
                gen.writeEndObject();
            }
        }
    }
</pac:java>