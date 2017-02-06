<%--@formatter:off--%>
<%@ page import="java.util.Calendar" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="pac" uri="/WEB-INF/pac.tld" %>
<c:set var="module" value="${pac:read(sessionScope.json,String.format(\"$.modules[%d]\",requestScope.index))}"/>
<pac:java>
package ${sessionScope.json.envAndroid.packageBean};

import android.os.Parcel;
import android.os.Parcelable;
import com.fasterxml.jackson.annotation.JsonInclude;
import ${sessionScope.json.envAndroid.packageMask}.${module.androidMaskAlias};
@JsonInclude(JsonInclude.Include.NON_NULL)
public class ${module.androidBeanAlias} implements Parcelable
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
                <c:when test="${field.javaType==\"String\"}">"${value.value}"</c:when></c:choose>;</c:forEach></c:forEach>
    <c:forEach items="${module.fields}" var="field">
        <c:if test="${field.javaType==\"java.util.Date\"}">@com.fasterxml.jackson.annotation.JsonFormat(timezone="${pac:gmt()}",pattern="yyyyMMddHHmmss")</c:if>
        protected ${field.javaType} ${field.databaseColumn}=null;</c:forEach>
    public ${module.androidBeanAlias}
    (   <c:forEach items="${module.fields}" var="field" varStatus="fieldStatus">
            ${field.javaType} ${field.databaseColumn}<c:if test="${!fieldStatus.last}">,</c:if></c:forEach>
    )
    {   <c:forEach items="${module.fields}" var="field">
            this.${field.databaseColumn}=${field.databaseColumn};</c:forEach>
    }
    public ${module.androidBeanAlias}()
    {
    }
    public ${module.androidBeanAlias} clone()
    {	return new ${module.androidBeanAlias}
        (   <c:forEach items="${module.fields}" var="field" varStatus="fieldStatus">
                ${field.databaseColumn}<c:if test="${!fieldStatus.last}">,</c:if></c:forEach>
        );
    }
    public ${module.androidBeanAlias}(Parcel in)
    {   <c:forEach items="${module.fields}" var="field">
            <c:choose>
                <c:when test="${field.javaType==\"Integer\"}">this.${field.databaseColumn}=in.readInt();</c:when>
                <c:when test="${field.javaType==\"Double\"}">this.${field.databaseColumn}=in.Double();</c:when>
                <c:when test="${field.javaType==\"String\"}">this.${field.databaseColumn}=in.readString();</c:when>
                <c:when test="${field.javaType==\"java.util.Date\"}">try{this.${field.databaseColumn}=DefaultDateFormatter.parse(in.readString());}catch(ParseException e){e.printStackTrace();}</c:when></c:choose></c:forEach>
    }
    <c:forEach items="${module.fields}" var="field">
        public ${field.javaType} get${pac:upperFirst(field.databaseColumn)}()
        {	return ${field.databaseColumn};
        }
        public ${module.androidBeanAlias} set${pac:upperFirst(field.databaseColumn)}(${field.javaType} ${field.databaseColumn})
        {	this.${field.databaseColumn}=${field.databaseColumn};
            return this;
        }</c:forEach>
    @Override
    public int describeContents()
    {	return 0;
    }
    @Override
    public void writeToParcel(Parcel dest,int flags)
    {   <c:forEach items="${module.fields}" var="field">
            <c:choose>
                <c:when test="${field.javaType==\"Integer\"}">dest.writeInt(${field.databaseColumn});</c:when>
                <c:when test="${field.javaType==\"Double\"}">dest.writeDouble(${field.databaseColumn});</c:when>
                <c:when test="${field.javaType==\"String\"}">dest.writeString(${field.databaseColumn});</c:when>
                <c:when test="${field.javaType==\"java.util.Date\"}">dest.writeString(DefaultDateFormatter.format(${field.databaseColumn}));</c:when></c:choose></c:forEach>
    }

    @Override
    public boolean equals(Object obj)
    {	return (obj instanceof ${module.androidBeanAlias})?equals((${module.androidBeanAlias})obj,new ${module.jteeMaskAlias}().all(true)):false;
    }
    public boolean equals(${module.androidBeanAlias} bean,${module.jteeMaskAlias} mask)
    {	if(mask==null)
            mask=new ${module.jteeMaskAlias}().all(true);
        <c:forEach items="${module.fields}" var="field">
            if(mask.get${pac:upperFirst(field.databaseColumn)}()&&!(get${pac:upperFirst(field.databaseColumn)}()==null&&bean.get${pac:upperFirst(field.databaseColumn)}()==null||get${pac:upperFirst(field.databaseColumn)}()!=null&&bean.get${pac:upperFirst(field.databaseColumn)}()!=null&&get${pac:upperFirst(field.databaseColumn)}().equals(bean.get${pac:upperFirst(field.databaseColumn)}())))
                return false;</c:forEach>
        return true;
    }
    public static final ${module.androidBeanAlias}.Creator<${module.androidBeanAlias}> CREATOR=new Creator<${module.androidBeanAlias}>()
    {   @Override
        public ${module.androidBeanAlias}[] newArray(int size)
        {   return new ${module.androidBeanAlias}[size];
        }
        @Override
        public ${module.androidBeanAlias} createFromParcel(Parcel in)
        {   return new ${module.androidBeanAlias}(in);
        }
    };
}
</pac:java>