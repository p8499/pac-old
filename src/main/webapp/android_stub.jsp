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
package ${sessionScope.json.envAndroid.packageStub};

import android.content.Context;
import java.util.List;
import io.reactivex.Flowable;
import io.reactivex.schedulers.Schedulers;
import okhttp3.MediaType;
import okhttp3.RequestBody;
import okhttp3.ResponseBody;
import retrofit2.Response;
import retrofit2.http.Body;
import retrofit2.http.DELETE;
import retrofit2.http.GET;
import retrofit2.http.Header;
import retrofit2.http.POST;
import retrofit2.http.PUT;
import retrofit2.http.Path;
import retrofit2.http.Query;
import com.fasterxml.jackson.core.JsonProcessingException;
import ${sessionScope.json.envAndroid.packageBase}.FilterLogicExpr;
import ${sessionScope.json.envAndroid.packageBase}.OrderByListExpr;
import ${sessionScope.json.envAndroid.packageBase}.RangeExpr;
import ${sessionScope.json.envAndroid.packageBase}.RetrofitFactory;
import ${sessionScope.json.envAndroid.packageBean}.${module.androidBeanAlias};
import ${sessionScope.json.envAndroid.packageMask}.${module.androidMaskAlias};

public class ${module.androidStubAlias}
{   private static ${module.androidStubAlias} service;
    public static ${module.androidStubAlias} getInstance(Context context)
    {   if(service==null)
        {   service=new ${module.androidStubAlias}(context);
        }
        return service;
    }
    private Api api;
    public ${module.androidStubAlias}(Context context)
    {   api=RetrofitFactory.getInstance(context).create(Api.class);
    }
    public Flowable${"<"}Response${"<"}${module.androidBeanAlias}${">"}${">"} get(<c:forEach items="${keys}" var="keyItem" varStatus="keyStatus">${keyItem.value.javaType} ${keyItem.value.databaseColumn}<c:if test="${!keyStatus.last}">,</c:if></c:forEach>)
    {   return get(<c:forEach items="${keys}" var="keyItem">${keyItem.key},</c:forEach>null);
    }
    public Flowable${"<"}Response${"<"}${module.androidBeanAlias}${">"}${">"} get(<c:forEach items="${keys}" var="keyItem">${keyItem.value.javaType} ${keyItem.value.databaseColumn},</c:forEach>${module.androidMaskAlias} mask)
    {   Flowable${"<"}Response${"<"}${module.androidBeanAlias}${">"}${">"} flowable=null;
        try
        {   flowable=api.get(<c:forEach items="${keys}" var="keyItem">${keyItem.key},</c:forEach>mask==null?null:RetrofitFactory.getObjectMapper().writeValueAsString(mask)).subscribeOn(Schedulers.io());
        }
        catch(JsonProcessingException e)
        {   e.printStackTrace();
        }
        return flowable;
    }
    public Flowable${"<"}Response${"<"}${module.androidBeanAlias}${">"}${">"} add(${module.androidBeanAlias} bean)
    {   Flowable${"<"}Response${"<"}${module.androidBeanAlias}${">"}${">"} flowable=null;
        try
        {   flowable=api.add(<c:if test="${pac:read(module,\"uniques[?(@.key)]\")[0].serial}"><c:forEach items="${keys}" var="keyItem">bean.get${pac:upperFirst(keyItem.key)}(),</c:forEach></c:if>RetrofitFactory.getObjectMapper().writeValueAsString(bean)).subscribeOn(Schedulers.io());
        }
        catch(JsonProcessingException e)
        {   e.printStackTrace();
        }
        return flowable;
    }
    public Flowable${"<"}Response${"<"}${module.androidBeanAlias}${">"}${">"} update(${module.androidBeanAlias} bean)
    {   return update(bean,null);
    }
    public Flowable${"<"}Response${"<"}${module.androidBeanAlias}${">"}${">"} update(${module.androidBeanAlias} bean,${module.androidMaskAlias} mask)
    {   Flowable${"<"}Response${"<"}${module.androidBeanAlias}${">"}${">"} flowable=null;
        try
        {   flowable=api.update(<c:forEach items="${keys}" var="keyItem">bean.get${pac:upperFirst(keyItem.key)}(),</c:forEach>RetrofitFactory.getObjectMapper().writeValueAsString(bean),mask==null?null:RetrofitFactory.getObjectMapper().writeValueAsString(mask)).subscribeOn(Schedulers.io());
        }
        catch(JsonProcessingException e)
        {   e.printStackTrace();
        }
        return flowable;
    }
    public Flowable${"<"}Response${"<"}Void${">"}${">"} count(FilterLogicExpr filter)
    {   Flowable${"<"}Response${"<"}Void${">"}${">"} flowable=null;
        try
        {   flowable=api.count(filter==null?null:RetrofitFactory.getObjectMapper().writeValueAsString(filter),new RangeExpr("items",0L,-1L).toString(),RetrofitFactory.getObjectMapper().writeValueAsString(new ${module.androidMaskAlias}()<c:forEach items="${keys}" var="keyItem">.set${pac:upperFirst(keyItem.key)}(true)</c:forEach>)).subscribeOn(Schedulers.io());
        }
        catch(JsonProcessingException e)
        {   e.printStackTrace();
        }
        return flowable;
    }
    public Flowable${"<"}Response${"<"}List${"<"}${module.androidBeanAlias}${">"}${">"}${">"} query(FilterLogicExpr filter,RangeExpr range)
    {   return query(filter,null,range,null);
    }
    public Flowable${"<"}Response${"<"}List${"<"}${module.androidBeanAlias}${">"}${">"}${">"} query(FilterLogicExpr filter,OrderByListExpr orderBy,RangeExpr range)
    {   return query(filter,orderBy,range,null);
    }
    public Flowable${"<"}Response${"<"}List${"<"}${module.androidBeanAlias}${">"}${">"}${">"} query(FilterLogicExpr filter,RangeExpr range,${module.androidMaskAlias} mask)
    {   return query(filter,null,range,mask);
    }
    public Flowable${"<"}Response${"<"}List${"<"}${module.androidBeanAlias}${">"}${">"}${">"} query(FilterLogicExpr filter,OrderByListExpr orderBy,RangeExpr range,${module.androidMaskAlias} mask)
    {   Flowable${"<"}Response${"<"}List${"<"}${module.androidBeanAlias}${">"}${">"}${">"} flowable=null;
        try
        {   flowable=api.query(filter==null?null:RetrofitFactory.getObjectMapper().writeValueAsString(filter),orderBy==null?null:orderBy.toQuery(),range==null?null:range.toString(),mask==null?null:RetrofitFactory.getObjectMapper().writeValueAsString(mask)).subscribeOn(Schedulers.io());
        }
        catch(JsonProcessingException e)
        {   e.printStackTrace();
        }
        return flowable;
    }
    public Flowable${"<"}Response${"<"}Void${">"}${">"} delete(<c:forEach items="${keys}" var="keyItem" varStatus="keyStatus">${keyItem.value.javaType} ${keyItem.value.databaseColumn}<c:if test="${!keyStatus.last}">,</c:if></c:forEach>)
    {   return api.delete(<c:forEach items="${keys}" var="keyItem" varStatus="keyStatus">${keyItem.key}<c:if test="${!keyStatus.last}">,</c:if></c:forEach>).subscribeOn(Schedulers.io());
    }
    public Flowable${"<"}Response${"<"}ResponseBody${">"}${">"} downloadAttach(<c:forEach items="${keys}" var="keyItem">${keyItem.value.javaType} ${keyItem.value.databaseColumn},</c:forEach>String name)
    {   Flowable${"<"}Response${"<"}ResponseBody${">"}${">"} flowable=api.downloadAttach(<c:forEach items="${keys}" var="keyItem">${keyItem.key},</c:forEach>name,"application/octet-stream").subscribeOn(Schedulers.io());
        return flowable;
    }
    public Flowable${"<"}Response${"<"}Void${">"}${">"} uploadAttach(<c:forEach items="${keys}" var="keyItem">${keyItem.value.javaType} ${keyItem.value.databaseColumn},</c:forEach>String name,byte[] bytes)
    {   RequestBody body=RequestBody.create(MediaType.parse("multipart/form-data"),bytes);
        Flowable${"<"}Response${"<"}Void${">"}${">"} flowable=api.uploadAttach(<c:forEach items="${keys}" var="keyItem">${keyItem.key},</c:forEach>name,body).subscribeOn(Schedulers.io());
        return flowable;
    }
    public Flowable${"<"}Response${"<"}Boolean${">"}${">"} deleteAttach(<c:forEach items="${keys}" var="keyItem">${keyItem.value.javaType} ${keyItem.value.databaseColumn},</c:forEach>String name)
    {   Flowable${"<"}Response${"<"}Boolean${">"}${">"} flowable=api.deleteAttach(<c:forEach items="${keys}" var="keyItem">${keyItem.key},</c:forEach>name).subscribeOn(Schedulers.io());
        return flowable;
    }
    public Flowable${"<"}Response${"<"}List${"<"}String${">"}${">"}${">"} listAttaches(<c:forEach items="${keys}" var="keyItem" varStatus="keyStatus">${keyItem.value.javaType} ${keyItem.value.databaseColumn}<c:if test="${!keyStatus.last}">,</c:if></c:forEach>)
    {   Flowable${"<"}Response${"<"}List${"<"}String${">"}${">"}${">"} flowable=api.listAttaches(<c:forEach items="${keys}" var="keyItem" varStatus="keyStatus">${keyItem.key}<c:if test="${!keyStatus.last}">,</c:if></c:forEach>).subscribeOn(Schedulers.io());
        return flowable;
    }
    public interface Api
    {   @GET("${module.jteeControllerPath}<c:forEach items="${keys}" var="keyItem" varStatus="keyStatus">{${keyItem.key}}<c:if test="${!keyStatus.last}">/</c:if></c:forEach>")
        Flowable${"<"}Response${"<"}${module.androidBeanAlias}${">"}${">"} get(<c:forEach items="${keys}" var="keyItem">@Path("${keyItem.value.databaseColumn}") ${keyItem.value.javaType} ${keyItem.value.databaseColumn},</c:forEach>@Query("mask") String mask);
        @POST("${module.jteeControllerPath}<c:if test="${pac:read(module,\"uniques[?(@.key)]\")[0].serial}"><c:forEach items="${keys}" var="keyItem" varStatus="keyStatus">{${keyItem.key}}<c:if test="${!keyStatus.last}">/</c:if></c:forEach></c:if>")
        Flowable${"<"}Response${"<"}${module.androidBeanAlias}${">"}${">"} add(<c:if test="${pac:read(module,\"uniques[?(@.key)]\")[0].serial}"><c:forEach items="${keys}" var="keyItem">@Path("${keyItem.value.databaseColumn}") ${keyItem.value.javaType} ${keyItem.value.databaseColumn},</c:forEach></c:if>@Body String bean);
        @PUT("${module.jteeControllerPath}<c:forEach items="${keys}" var="keyItem" varStatus="keyStatus">{${keyItem.key}}<c:if test="${!keyStatus.last}">/</c:if></c:forEach>")
        Flowable${"<"}Response${"<"}${module.androidBeanAlias}${">"}${">"} update(<c:forEach items="${keys}" var="keyItem">@Path("${keyItem.value.databaseColumn}") ${keyItem.value.javaType} ${keyItem.value.databaseColumn},</c:forEach>@Body String bean,@Query("mask") String mask);
        @DELETE("${module.jteeControllerPath}<c:forEach items="${keys}" var="keyItem" varStatus="keyStatus">{${keyItem.key}}<c:if test="${!keyStatus.last}">/</c:if></c:forEach>")
        Flowable${"<"}Response${"<"}Void${">"}${">"} delete(<c:forEach items="${keys}" var="keyItem" varStatus="keyStatus">@Path("${keyItem.value.databaseColumn}") ${keyItem.value.javaType} ${keyItem.value.databaseColumn}<c:if test="${!keyStatus.last}">,</c:if></c:forEach>);
        @GET("${module.jteeControllerPath}")
        Flowable${"<"}Response${"<"}List${"<"}${module.androidBeanAlias}${">"}${">"}${">"} query(@Query("filter") String filter,@Query("orderBy") String orderBy,@Header("Range") String range,@Query("mask") String mask);
        @GET("${module.jteeControllerPath}")
        Flowable${"<"}Response${"<"}Void${">"}${">"} count(@Query("filter") String filter,@Header("Range") String range,@Query("mask") String mask);
        @GET("${module.jteeAttachmentControllerPath}<c:forEach items="${keys}" var="keyItem" varStatus="keyStatus">{${keyItem.key}}<c:if test="${!keyStatus.last}">/</c:if></c:forEach>")
        Flowable${"<"}Response${"<"}ResponseBody${">"}${">"} downloadAttach(<c:forEach items="${keys}" var="keyItem">@Path("${keyItem.value.databaseColumn}") ${keyItem.value.javaType} ${keyItem.value.databaseColumn},</c:forEach>@Query("name") String name,@Header("Accept") String accept);
        @PUT("${module.jteeAttachmentControllerPath}<c:forEach items="${keys}" var="keyItem" varStatus="keyStatus">{${keyItem.key}}<c:if test="${!keyStatus.last}">/</c:if></c:forEach>")
        Flowable${"<"}Response${"<"}Void${">"}${">"} uploadAttach(<c:forEach items="${keys}" var="keyItem">@Path("${keyItem.value.databaseColumn}") ${keyItem.value.javaType} ${keyItem.value.databaseColumn},</c:forEach>@Query("name") String name,@Body RequestBody body);
        @DELETE("${module.jteeAttachmentControllerPath}<c:forEach items="${keys}" var="keyItem" varStatus="keyStatus">{${keyItem.key}}<c:if test="${!keyStatus.last}">/</c:if></c:forEach>")
        Flowable${"<"}Response${"<"}Boolean${">"}${">"} deleteAttach(<c:forEach items="${keys}" var="keyItem">@Path("${keyItem.value.databaseColumn}") ${keyItem.value.javaType} ${keyItem.value.databaseColumn},</c:forEach>@Query("name") String name);
        @GET("${module.jteeAttachmentControllerPath}<c:forEach items="${keys}" var="keyItem" varStatus="keyStatus">{${keyItem.key}}<c:if test="${!keyStatus.last}">/</c:if></c:forEach>")
        Flowable${"<"}Response${"<"}List${"<"}String${">"}${">"}${">"} listAttaches(<c:forEach items="${keys}" var="keyItem" varStatus="keyStatus">@Path("${keyItem.value.databaseColumn}") ${keyItem.value.javaType} ${keyItem.value.databaseColumn}<c:if test="${!keyStatus.last}">,</c:if></c:forEach>);
    }
}
</pac:java>