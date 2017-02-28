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
package ${sessionScope.json.envJtee.packageControllerBase};
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URLConnection;
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
import org.springframework.util.StreamUtils;
import org.springframework.validation.beanvalidation.LocalValidatorFactoryBean;
import org.springframework.web.bind.annotation.*;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import ${sessionScope.json.envJtee.packageBase}.*;
import ${sessionScope.json.envJtee.packageBean}.${module.jteeBeanAlias};
import ${sessionScope.json.envJtee.packageMask}.${module.jteeMaskAlias};
import ${sessionScope.json.envJtee.packageMapper}.${module.datasource}.${module.jteeMapperAlias};

public abstract class ${module.jteeControllerBaseAlias} {
    protected static final String path = "${module.jteeControllerPath}";
    protected static final String attachPath = "${module.jteeAttachmentControllerPath}";
    protected static final String pathKey = "<c:forEach items="${keys}" var="keyItem" varStatus="keyStatus">{${keyItem.key}}<c:if test="${!keyStatus.last}">/</c:if></c:forEach>";

    @RequestMapping(value = path + pathKey, method = RequestMethod.GET, produces = "application/json;charset=UTF-8")
    public String get(HttpSession session,
                      HttpServletRequest request,
                      HttpServletResponse response,
                      <c:forEach items="${keys}" var="keyItem">@PathVariable ${keyItem.value.javaType} ${keyItem.value.databaseColumn},</c:forEach>
                      @RequestParam(required = false) String mask) throws Exception {
        ${module.jteeMaskAlias} maskObj = mask == null || mask.equals("") ? new ${module.jteeMaskAlias}().all(true) : jackson.readValue(mask, ${module.jteeMaskAlias}.class);
        ${module.jteeBeanAlias} bean = onGet(session, request, response, <c:forEach items="${keys}" var="keyItem">${keyItem.key},</c:forEach> maskObj);
        return jackson.writeValueAsString(bean);
    }

    protected abstract ${module.jteeBeanAlias} onGet(HttpSession session, HttpServletRequest request, HttpServletResponse response, <c:forEach items="${keys}" var="keyItem">${keyItem.value.javaType} ${keyItem.value.databaseColumn},</c:forEach> ${module.jteeMaskAlias} mask) throws Exception;

    protected ${module.jteeBeanAlias} baseGet(<c:forEach items="${keys}" var="keyItem">${keyItem.value.javaType} ${keyItem.value.databaseColumn},</c:forEach> ${module.jteeMaskAlias} mask) {
        return ${pac:lowerFirst(module.jteeMapperAlias)}.get(<c:forEach items="${keys}" var="keyItem">${keyItem.key},</c:forEach> mask);
    }

    @RequestMapping(value = path<c:if test="${!pac:read(module,\"uniques[?(@.key)]\")[0].serial}">+pathKey</c:if>, method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
    public String add(
            HttpSession session,
            HttpServletRequest request,
            HttpServletResponse response,
            <c:if test="${!pac:read(module,\"uniques[?(@.key)]\")[0].serial}"><c:forEach items="${keys}" var="keyItem">@PathVariable ${keyItem.value.javaType} ${keyItem.value.databaseColumn},</c:forEach></c:if>
            @RequestBody ${module.jteeBeanAlias} bean)
            throws Exception {
        onAdd(session, request, response, <c:if test="${!pac:read(module,\"uniques[?(@.key)]\")[0].serial}"><c:forEach items="${keys}" var="keyItem">${keyItem.key},</c:forEach></c:if> bean);
        return jackson.writeValueAsString(bean);
    }

    protected abstract ${module.jteeBeanAlias} onAdd(HttpSession session, HttpServletRequest request, HttpServletResponse response, <c:if test="${!pac:read(module,\"uniques[?(@.key)]\")[0].serial}"><c:forEach items="${keys}" var="keyItem">${keyItem.value.javaType} ${keyItem.value.databaseColumn},</c:forEach></c:if> ${module.jteeBeanAlias} bean) throws Exception;

    protected ${module.jteeBeanAlias} baseAdd(${module.jteeBeanAlias} bean) {
        if (!validatorFactory.getValidator().validate(bean, Insert.class).isEmpty()) {
            return null;
        }
        ${pac:lowerFirst(module.jteeMapperAlias)}.add(bean);
        return bean;
    }

    @RequestMapping(value = path + pathKey, method = RequestMethod.PUT, produces = "application/json;charset=UTF-8")
    public String update(
            HttpSession session,
            HttpServletRequest request,
            HttpServletResponse response,
            <c:forEach items="${keys}" var="keyItem">@PathVariable ${keyItem.value.javaType} ${keyItem.value.databaseColumn},</c:forEach>
            @RequestBody ${module.jteeBeanAlias} bean,
            @RequestParam(required = false) String mask)
            throws Exception {
        ${module.jteeMaskAlias} maskObj = mask == null || mask.equals("") ? new ${module.jteeMaskAlias}().all(true) : jackson.readValue(mask, ${module.jteeMaskAlias}.class);
        onUpdate(session, request, response, <c:forEach items="${keys}" var="keyItem">${keyItem.key},</c:forEach> bean, maskObj);
        return jackson.writeValueAsString(bean);
    }

    protected abstract ${module.jteeBeanAlias} onUpdate(HttpSession session, HttpServletRequest request, HttpServletResponse response, <c:forEach items="${keys}" var="keyItem">${keyItem.value.javaType} ${keyItem.value.databaseColumn},</c:forEach> ${module.jteeBeanAlias} bean, ${module.jteeMaskAlias} mask) throws Exception;

    protected ${module.jteeBeanAlias} baseUpdate(${module.jteeBeanAlias} bean, ${module.jteeMaskAlias} mask) {
        Set${"<"}ConstraintViolation${"<"}${module.jteeBeanAlias}${">"}${">"} violationSet = validatorFactory.getValidator().validate(bean, Update.class);
        for (ConstraintViolation${"<"}${module.jteeBeanAlias}${">"} violation : violationSet) {
            if (mask.get(violation.getPropertyPath().toString())) {
                return null;
            }
        }
        ${pac:lowerFirst(module.jteeMapperAlias)}.update(bean, mask);
        return bean;
    }

    @RequestMapping(value = path + pathKey, method = RequestMethod.DELETE, produces = "application/json;charset=UTF-8")
    public void delete(
            HttpSession session,
            HttpServletRequest request,
            HttpServletResponse response,
            <c:forEach items="${keys}" var="keyItem" varStatus="keyStatus">@PathVariable ${keyItem.value.javaType} ${keyItem.value.databaseColumn}<c:if test="${!keyStatus.last}">,</c:if></c:forEach>)
            throws Exception {
        onDelete(session, request, response, <c:forEach items="${keys}" var="keyItem" varStatus="keyStatus">${keyItem.key}<c:if test="${!keyStatus.last}">,</c:if></c:forEach>);
    }

    protected abstract void onDelete(HttpSession session, HttpServletRequest request, HttpServletResponse response, <c:forEach items="${keys}" var="keyItem" varStatus="keyStatus">${keyItem.value.javaType} ${keyItem.value.databaseColumn}<c:if test="${!keyStatus.last}">,</c:if></c:forEach>) throws Exception;

    protected boolean baseDelete(<c:forEach items="${keys}" var="keyItem" varStatus="keyStatus">${keyItem.value.javaType} ${keyItem.value.databaseColumn}<c:if test="${!keyStatus.last}">,</c:if></c:forEach>) {
        return ${pac:lowerFirst(module.jteeMapperAlias)}.delete(<c:forEach items="${keys}" var="keyItem" varStatus="keyStatus">${keyItem.key}<c:if test="${!keyStatus.last}">,</c:if></c:forEach>);
    }

    @RequestMapping(value = path, method = RequestMethod.GET, produces = "application/json;charset=UTF-8")
    public String query(
            HttpSession session,
            HttpServletRequest request,
            HttpServletResponse response,
            @RequestParam(required = false) String filter,
            @RequestParam(required = false) String orderBy,
            @RequestHeader(required = false, name = "Range", defaultValue = "items=0-9") String range,
            @RequestParam(required = false) String mask)
            throws Exception {
        FilterExpr filterObj = filter == null || filter.equals("") ? null : jackson.readValue(filter, FilterExpr.class);
        OrderByListExpr orderByListObj = mask == null || mask.equals("") ? null : OrderByListExpr.fromQuery(orderBy);
        RangeExpr rangeObj = RangeExpr.fromQuery(range);
        ${module.jteeMaskAlias} maskObj = mask == null || mask.equals("") ? new ${module.jteeMaskAlias}().all(true) : jackson.readValue(mask, ${module.jteeMaskAlias}.class);
        Long total = onCount(session, request, response, filterObj);
        if (total == null)
            return null;
        long start = rangeObj.getStart(total);
        long count = rangeObj.getCount(total);
        List${"<"}${module.jteeBeanAlias}${">"} results = onQuery(session, request, response, filterObj, orderByListObj, start, count, maskObj);
        response.setHeader("Content-Range", RangeListExpr.getContentRange(start, results.size(), total));
        return jackson.writeValueAsString(results);
    }

    protected abstract Long onCount(HttpSession session, HttpServletRequest request, HttpServletResponse response, FilterExpr filter) throws Exception;

    protected abstract List${"<"}${module.jteeBeanAlias}${">"} onQuery(HttpSession session, HttpServletRequest request, HttpServletResponse response, FilterExpr filter, OrderByListExpr orderByList, long start, long count, ${module.jteeMaskAlias} mask) throws Exception;

    protected long baseCount(FilterExpr filter) {
        return ${pac:lowerFirst(module.jteeMapperAlias)}.count(filter == null ? null : filter.toString());
    }

    protected List${"<"}${module.jteeBeanAlias}${">"} baseQuery(FilterExpr filter, OrderByListExpr orderByList, long start, long count, ${module.jteeMaskAlias} mask) {
        return ${pac:lowerFirst(module.jteeMapperAlias)}.query(filter == null ? null : filter.toString(), orderByList == null ? null : orderByList.toString(), start, count, mask);
    }

    @RequestMapping(
            value = attachPath + pathKey,
            method = RequestMethod.GET,
            produces = "application/octet-stream"
    )
    public void downloadAttach(
            HttpSession session,
            HttpServletRequest request,
            HttpServletResponse response,
            <c:forEach items="${keys}" var="keyItem">@PathVariable ${keyItem.value.javaType} ${keyItem.value.databaseColumn},</c:forEach>
            @RequestParam(required = true) String name)
            throws Exception {
        InputStream input = inputStream(session, request, response, <c:forEach items="${keys}" var="keyItem">${keyItem.key},</c:forEach> name);
        if (input == null) {
            return;
        }
        String contentType = URLConnection.guessContentTypeFromName(name);
        response.setContentType(contentType == null ? "application/octet-stream" : contentType);
        response.setHeader("Content-Disposition", "attachment;fileName=" + name);
        StreamUtils.copy(input, response.getOutputStream());
        input.close();
        response.getOutputStream().close();
    }

    protected abstract InputStream inputStream(HttpSession session, HttpServletRequest request, HttpServletResponse response, <c:forEach items="${keys}" var="keyItem">${keyItem.value.javaType} ${keyItem.value.databaseColumn},</c:forEach> String name) throws Exception;

    @RequestMapping(
            value = attachPath + pathKey,
            method = RequestMethod.PUT,
            produces = "application/json;charset=UTF-8"
    )
    public void uploadAttach(
            HttpSession session,
            HttpServletRequest request,
            HttpServletResponse response,
            <c:forEach items="${keys}" var="keyItem">@PathVariable ${keyItem.value.javaType} ${keyItem.value.databaseColumn},</c:forEach>
            @RequestParam(required = true) String name)
            throws Exception {
        OutputStream output = outputStream(session, request, response, <c:forEach items="${keys}" var="keyItem">${keyItem.key},</c:forEach> name);
        if (output == null) {
            return;
        }
        StreamUtils.copy(request.getInputStream(), output);
        request.getInputStream().close();
        output.close();
    }

    protected abstract OutputStream outputStream(HttpSession session, HttpServletRequest request, HttpServletResponse response, <c:forEach items="${keys}" var="keyItem">${keyItem.value.javaType} ${keyItem.value.databaseColumn},</c:forEach> String name) throws Exception;

    @RequestMapping(
            value = attachPath + pathKey,
            method = RequestMethod.DELETE,
            produces = "application/json;charset=UTF-8"
    )
    public void deleteAttach(
            HttpSession session,
            HttpServletRequest request,
            HttpServletResponse response,
            <c:forEach items="${keys}" var="keyItem">@PathVariable ${keyItem.value.javaType} ${keyItem.value.databaseColumn},</c:forEach>
            @RequestParam(required = true) String name)
            throws Exception {
        onDeleteAttach(session, request, response, <c:forEach items="${keys}" var="keyItem">${keyItem.key},</c:forEach> name);
    }

    protected abstract void onDeleteAttach(HttpSession session, HttpServletRequest request, HttpServletResponse response, <c:forEach items="${keys}" var="keyItem">${keyItem.value.javaType} ${keyItem.value.databaseColumn},</c:forEach> String name) throws Exception;

    public String listAttaches(
            HttpSession session,
            HttpServletRequest request,
            HttpServletResponse response,
            <c:forEach items="${keys}" var="keyItem" varStatus="keyStatus">@PathVariable ${keyItem.value.javaType} ${keyItem.value.databaseColumn}<c:if test="${!keyStatus.last}">,</c:if></c:forEach>)
            throws Exception {
        List${"<"}String${">"} result =onListAttaches(session, request, response, <c:forEach items="${keys}" var="keyItem" varStatus="keyStatus">${keyItem.key}<c:if test="${!keyStatus.last}">,</c:if></c:forEach>);
        return jackson.writeValueAsString(result);
    }

    protected abstract List${"<"}String${">"} onListAttaches(HttpSession session, HttpServletRequest request, HttpServletResponse response, <c:forEach items="${keys}" var="keyItem" varStatus="keyStatus">${keyItem.value.javaType} ${keyItem.value.databaseColumn}<c:if test="${!keyStatus.last}">,</c:if></c:forEach>) throws Exception;

    @Value(value="${"#{jackson}"}")
    protected ObjectMapper jackson;

    @Value(value="${"#{validatorFactory}"}")
    protected LocalValidatorFactoryBean validatorFactory;

    @Value(value="${String.format("#{%s}",pac:lowerFirst(module.jteeMapperAlias))}")
    protected ${module.jteeMapperAlias} ${pac:lowerFirst(module.jteeMapperAlias)};
}
</pac:java>