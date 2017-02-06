<%--@formatter:off--%>
<%@ page import="java.util.Date" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
    package ${sessionScope.json.envJtee.packageController};
    import java.io.IOException;
    import java.util.List;
    import java.util.Set;
    import javax.servlet.http.HttpServletRequest;
    import javax.servlet.http.HttpServletResponse;
    import javax.servlet.http.HttpSession;
    import javax.validation.ConstraintViolation;
    import org.apache.ibatis.annotations.Insert;
    import org.apache.ibatis.annotations.Update;
    import org.springframework.beans.BeansException;
    import org.springframework.beans.factory.annotation.Value;
    import org.springframework.context.ApplicationContext;
    import org.springframework.context.ApplicationContextAware;
    import org.springframework.http.HttpStatus;
    import org.springframework.validation.beanvalidation.LocalValidatorFactoryBean;
    import org.springframework.web.bind.annotation.*;
    import com.fasterxml.jackson.core.JsonProcessingException;
    import com.fasterxml.jackson.databind.ObjectMapper;
    import ${sessionScope.json.envJtee.packageBase}.*;
    import ${sessionScope.json.envJtee.packageBean}.${module.jteeBeanAlias};
    import ${sessionScope.json.envJtee.packageMask}.${module.jteeMaskAlias};
    import ${sessionScope.json.envJtee.packageMapper}.${module.datasource}.${module.jteeMapperAlias};
    @RestController
    @RequestMapping(value="${module.jteeControllerPath}",produces="application/json;charset=UTF-8")
    public class ${module.jteeControllerAlias} implements ApplicationContextAware
    {   /* Web Browser
         *  Path:
         *   ${sessionScope.json.envJtee.baseUrl}${module.jteeControllerPath}<c:forEach items="${keys}" var="keyItem" varStatus="keyStatus">{${keyItem.key}}<c:if test="${!keyStatus.last}">/</c:if></c:forEach>?mask={<c:forEach items="${module.fields}" var="field" varStatus="fieldStatus">"${field.databaseColumn}":true<c:if test="${!fieldStatus.last}">,</c:if></c:forEach>}
         */
        @RequestMapping(value="<c:forEach items="${keys}" var="keyItem" varStatus="keyStatus">{${keyItem.key}}<c:if test="${!keyStatus.last}">/</c:if></c:forEach>",method=RequestMethod.GET)
        public String get(HttpSession session,HttpServletRequest request,HttpServletResponse response,<c:forEach items="${keys}" var="keyItem">@PathVariable ${keyItem.value.javaType} ${keyItem.value.databaseColumn},</c:forEach>@RequestParam(required=false) String mask) throws IOException
        {   ${module.jteeMaskAlias} maskObj=mask==null?new ${module.jteeMaskAlias}().all(true):jackson.readValue(mask,${module.jteeMaskAlias}.class);
            if(configurator!=null&&!configurator.beforeGet(session,request,response,new ${module.jteeBeanAlias}()<c:forEach items="${keys}" var="keyItem">.set${pac:upperFirst(keyItem.key)}(${keyItem.key})</c:forEach>,maskObj))
            {   response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                return "";
            }
            ${module.jteeBeanAlias} result=executor!=null&&executor.overrideGet()?executor.onGet(request,response,session,new ${module.jteeBeanAlias}()<c:forEach items="${keys}" var="keyItem">.set${pac:upperFirst(keyItem.key)}(${keyItem.key})</c:forEach>,maskObj):${pac:lowerFirst(module.jteeMapperAlias)}.get(<c:forEach items="${keys}" var="keyItem">${keyItem.key},</c:forEach>maskObj);
            if(configurator!=null&&!configurator.afterGet(session,request,response,result))
            {   response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                return "";
            }
            response.setStatus(result==null?HttpServletResponse.SC_NOT_FOUND:HttpServletResponse.SC_OK);
            return jackson.writeValueAsString(result);
        }
        /* REST Client:
         *  HTTP Method:
         *   POST
         *  Path:
         *   ${sessionScope.json.envJtee.baseUrl}${module.jteeControllerPath}<c:if test="${!pac:read(module,\"uniques[?(@.key)]\")[0].serial}"><c:forEach items="${keys}" var="keyItem" varStatus="keyStatus">{${keyItem.key}}<c:if test="${!keyStatus.last}">/</c:if></c:forEach></c:if>
         *  Headers:
         *   Accept:application/json;charset=UTF-8
         *   Content-Type:application/json;charset=UTF-8
         *   Cache-Control:no-cache
         *  Request Body:
         *   {<c:if test="${!pac:read(module,\"uniques[?(@.key)]\")[0].serial}"><c:forEach items="${keys}" var="keyItem" varStatus="keyStatus">"${keyItem.key}":{${keyItem.key}}<c:if test="${!keyStatus.last}">,</c:if></c:forEach>,</c:if><c:forEach items="${nonkeys}" var="fieldItem" varStatus="fieldStatus">"${fieldItem.key}":{${fieldItem.key}}<c:if test="${!fieldStatus.last}">,</c:if></c:forEach>}
         */
        @RequestMapping(method=RequestMethod.POST)
        public String add(HttpSession session,HttpServletRequest request,HttpServletResponse response,<c:if test="${!pac:read(module,\"uniques[?(@.key)]\")[0].serial}"><c:forEach items="${keys}" var="keyItem">@PathVariable ${keyItem.value.javaType} ${keyItem.value.databaseColumn},</c:forEach></c:if>@RequestBody ${module.jteeBeanAlias} bean) throws JsonProcessingException
        {   <c:forEach items="${module.fields}" var="field">
                <c:choose><c:when test="${field.special.type==\"password\"}">
                    bean.set${pac:upperFirst(field.databaseColumn)}(org.apache.commons.codec.digest.DigestUtils.md5Hex(bean.get${pac:upperFirst(field.databaseColumn)}()));</c:when><c:when test="${field.special.type==\"next\"}">if(bean.get${pac:upperFirst(field.databaseColumn)}()==null)bean.set${pac:upperFirst(field.databaseColumn)}(${pac:lowerFirst(module.jteeMapperAlias)}.next${pac:upperFirst(field.databaseColumn)}(<c:forEach items="${field.special.scope}" var="scopeColumn" varStatus="scopeColumnStatus">
                    bean.get${pac:upperFirst(scopeColumn)}()<c:if test="${!scopeColumnStatus.last}">,</c:if></c:forEach>));</c:when><c:when test="${field.special.type==\"created\"}">
                    bean.set${pac:upperFirst(field.databaseColumn)}(new java.util.Date());</c:when><c:when test="${field.special.type==\"updated\"}">
                    bean.set${pac:upperFirst(field.databaseColumn)}(new java.util.Date());</c:when></c:choose></c:forEach>
            if(!validatorFactory.getValidator().validate(bean, Insert.class).isEmpty())
            {   response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                return "";
            }
            if(configurator==null||!configurator.beforeAdd(session,request,response,bean))
            {   response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                return "";
            }
            if(executor!=null&&executor.overrideAdd())
                executor.onAdd(request,response,session,bean);
            else
                ${pac:lowerFirst(module.jteeMapperAlias)}.add(bean);
            if(configurator!=null)
                configurator.afterAdd(session,request,response,bean);
            response.setStatus(HttpServletResponse.SC_OK);
            return jackson.writeValueAsString(bean);
        }
        /* REST Client:
         *  HTTP Method:
         *   PUT
         *  Path:
         *   ${sessionScope.json.envJtee.baseUrl}${module.jteeControllerPath}<c:forEach items="${keys}" var="keyItem" varStatus="keyStatus">{${keyItem.key}}<c:if test="${!keyStatus.last}">/</c:if></c:forEach>
         *  Headers:
         *   Accept:application/json;charset=UTF-8
         *   Content-Type:application/json;charset=UTF-8
         *   Cache-Control:no-cache
         *  Request Parameters:
         *   mask={<c:forEach items="${nonkeys}" var="field" varStatus="fieldStatus">"${field.key}":true<c:if test="${!fieldStatus.last}">,</c:if></c:forEach>}
         *  Request Body:
         *   {<c:forEach items="${module.fields}" var="field" varStatus="fieldStatus">"${field.databaseColumn}":true<c:if test="${!fieldStatus.last}">,</c:if></c:forEach>}
         */
        @RequestMapping(value="<c:forEach items="${keys}" var="keyItem" varStatus="keyStatus">{${keyItem.key}}<c:if test="${!keyStatus.last}">/</c:if></c:forEach>",method=RequestMethod.PUT)
        public String update(HttpSession session,HttpServletRequest request,HttpServletResponse response,<c:forEach items="${keys}" var="keyItem">@PathVariable ${keyItem.value.javaType} ${keyItem.value.databaseColumn},</c:forEach>@RequestBody ${module.jteeBeanAlias} bean,@RequestParam(required=false) String mask) throws IOException
        {   ${module.jteeMaskAlias} maskObj=mask==null?new ${module.jteeMaskAlias}().all(true):jackson.readValue(mask,${module.jteeMaskAlias}.class);
            <c:forEach items="${module.fields}" var="field">
                <c:choose><c:when test="${field.special.type==\"password\"}">
                    if(maskObj.get${pac:upperFirst(field.databaseColumn)}()) bean.set${pac:upperFirst(field.databaseColumn)}(org.apache.commons.codec.digest.DigestUtils.md5Hex(bean.get${pac:upperFirst(field.databaseColumn)}()));</c:when><c:when test="${field.special.type==\"created\"}">
                    if(maskObj.get${pac:upperFirst(field.databaseColumn)}()) bean.set${pac:upperFirst(field.databaseColumn)}(new java.util.Date());</c:when><c:when test="${field.special.type==\"updated\"}">
                    if(maskObj.get${pac:upperFirst(field.databaseColumn)}()) bean.set${pac:upperFirst(field.databaseColumn)}(new java.util.Date());</c:when></c:choose></c:forEach>
            Set${"<"}ConstraintViolation${"<"}${module.jteeBeanAlias}${">"}${">"} violationSet=validatorFactory.getValidator().validate(bean,Update.class);
            for(ConstraintViolation${"<"}${module.jteeBeanAlias}${">"} violation:violationSet)
            {   if(maskObj.get(violation.getPropertyPath().toString()))
                {   response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    return "";
                }
            }
            if(configurator==null||!configurator.beforeUpdate(session,request,response,bean,maskObj))
            {   response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                return "";
            }
            if(executor!=null&&executor.overrideUpdate())
                executor.onUpdate(request,response,session,bean,maskObj<c:forEach items="${pac:read(module,\"$.fields[?(@.special.type in ['created','updated'])]\")}" var="field" varStatus="fieldStatus">.set${pac:upperFirst(field.databaseColumn)}(true)</c:forEach>);
            else
                ${pac:lowerFirst(module.jteeMapperAlias)}.update(bean,maskObj<c:forEach items="${pac:read(module,\"$.fields[?(@.special.type in ['created','updated'])]\")}" var="field" varStatus="fieldStatus">.set${pac:upperFirst(field.databaseColumn)}(true)</c:forEach>);
            if(configurator!=null)
                configurator.afterUpdate(session,request,response,bean,maskObj);
            response.setStatus(HttpServletResponse.SC_OK);
            return jackson.writeValueAsString(bean);
        }
        /* REST Client:
         *  HTTP Method:
         *   DELETE
         *  Path:
         *   ${sessionScope.json.envJtee.baseUrl}${module.jteeControllerPath}<c:forEach items="${keys}" var="keyItem" varStatus="keyStatus">{${keyItem.key}}<c:if test="${!keyStatus.last}">/</c:if></c:forEach>
         *  Headers:
         *   Accept:application/json;charset=UTF-8
         *   Cache-Control:no-cache
         */
        @RequestMapping(value="<c:forEach items="${keys}" var="keyItem" varStatus="keyStatus">{${keyItem.key}}<c:if test="${!keyStatus.last}">/</c:if></c:forEach>",method=RequestMethod.DELETE)
        public String delete(HttpSession session,HttpServletRequest request,HttpServletResponse response<c:forEach items="${keys}" var="keyItem">,@PathVariable ${keyItem.value.javaType} ${keyItem.value.databaseColumn}</c:forEach>) throws JsonProcessingException
        {   if(configurator==null||!configurator.beforeDelete(session,request,response,new ${module.jteeBeanAlias}()<c:forEach items="${keys}" var="keyItem">.set${pac:upperFirst(keyItem.key)}(${keyItem.key})</c:forEach>))
            {   response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                return "";
            }
            boolean success=executor!=null&&executor.overrideDelete()?executor.onDelete(request,response,session,new ${module.jteeBeanAlias}()<c:forEach items="${keys}" var="keyItem">.set${pac:upperFirst(keyItem.key)}(${keyItem.key})</c:forEach>):${pac:lowerFirst(module.jteeMapperAlias)}.delete(<c:forEach items="${keys}" var="keyItem" varStatus="keyStatus">${keyItem.key}<c:if test="${!keyStatus.last}">,</c:if></c:forEach>);
            if(configurator!=null)
                configurator.afterDelete(session,request,response,new ${module.jteeBeanAlias}()<c:forEach items="${keys}" var="keyItem">.set${pac:upperFirst(keyItem.key)}(${keyItem.key})</c:forEach>);
            response.setStatus(success?HttpServletResponse.SC_OK:HttpServletResponse.SC_NO_CONTENT);
            return "";
        }
        /* REST Client:
         *  HTTP Method:
         *   GET
         *  Path:
         *   ${sessionScope.json.envJtee.baseUrl}${module.jteeControllerPath}
         *  Headers:
         *   Accept:application/json;charset=UTF-8
         *   Cache-Control:no-cache
         *   Range:items=0-9
         *  Request Parameters:
         *   filter=
         *   orderBy=<c:forEach items="${module.fields}" var="field" varStatus="fieldStatus">+${field.databaseColumn}<c:if test="${!fieldStatus.last}">,</c:if></c:forEach>
         *   mask={<c:forEach items="${module.fields}" var="field" varStatus="fieldStatus">"${field.databaseColumn}":true<c:if test="${!fieldStatus.last}">,</c:if></c:forEach>}
         */
        @RequestMapping(method=RequestMethod.GET)
        public String query(HttpSession session,HttpServletRequest request,HttpServletResponse response,@RequestParam(required=false) String filter,@RequestParam(required=false) String orderBy,@RequestHeader(required=false,name="Range",defaultValue="items=0-9") String range,@RequestParam(required=false) String mask) throws IOException
        {   ${module.jteeMaskAlias} maskObj=mask==null||mask.equals("")?new ${module.jteeMaskAlias}().all(true):jackson.readValue(mask,${module.jteeMaskAlias}.class);
            FilterExpr filterObj=filter==null||filter.equals("")?null:jackson.readValue(filter,FilterExpr.class);
            OrderByListExpr orderByListObj=mask==null||mask.equals("")?null:OrderByListExpr.fromQuery(orderBy);
            RangeExpr rangeObj=RangeExpr.fromQuery(range);
            if(configurator!= null&&!configurator.beforeQuery(session,request,response,(FilterLogicExpr)filterObj,maskObj))
            {   response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                return "";
            }
            long total=executor!=null&&executor.overrideCount()?executor.onCount(request,response,session,filterObj):${pac:lowerFirst(module.jteeMapperAlias)}.count(filterObj==null?null:filterObj.toString());
            long start=rangeObj.getStart(total);
            long count=rangeObj.getCount(total);
            List<${module.jteeBeanAlias}> results=executor!=null&&executor.overrideQuery()?executor.onQuery(request,response,session,filterObj,orderByListObj,start,count,maskObj):${pac:lowerFirst(module.jteeMapperAlias)}.query(filterObj==null?null:filterObj.toString(),orderByListObj==null?null:orderByListObj.toString(),start,count,maskObj);
            if(configurator!=null&&configurator.afterQuery(session,request,response,results))
            {   response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                return "";
            }
            response.setHeader("Content-Range",RangeListExpr.getContentRange(start,results.size(),total));
            response.setStatus(HttpServletResponse.SC_OK);
            return jackson.writeValueAsString(results);
        }
        @ResponseStatus(HttpStatus.BAD_REQUEST)
        @ExceptionHandler({Exception.class})
        public String exception(Exception e)
        {   e.printStackTrace();
            return "";
        }
        @Value(value="${"#{jackson}"}")
        private ObjectMapper jackson;
        @Value(value="${"#{validatorFactory}"}")
        private LocalValidatorFactoryBean validatorFactory;
        @Value(value="${String.format("#{%s}",pac:lowerFirst(module.jteeMapperAlias))}")
        private ${module.jteeMapperAlias} ${pac:lowerFirst(module.jteeMapperAlias)};
        private Configurator${"<"}${module.jteeBeanAlias},${module.jteeMaskAlias}${">"} configurator;
        private Executor${"<"}${module.jteeBeanAlias},${module.jteeMaskAlias}${">"} executor;
        @Override
        public void setApplicationContext(ApplicationContext applicationContext) throws BeansException
        {   configurator=applicationContext.containsBean("${pac:lowerFirst(module.jteeConfiguratorAlias)}")?applicationContext.getBean("${pac:lowerFirst(module.jteeConfiguratorAlias)}",Configurator.class):null;
            executor=applicationContext.containsBean("${pac:lowerFirst(module.jteeExecutorAlias)}")?applicationContext.getBean("${pac:lowerFirst(module.jteeExecutorAlias)}",Executor.class):null;
        }
    }
</pac:java>