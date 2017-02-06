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
    package ${sessionScope.json.envJtee.packageControllerAttachment};
    import com.fasterxml.jackson.core.JsonProcessingException;
    import com.fasterxml.jackson.databind.ObjectMapper;
    import org.apache.commons.io.FileUtils;
    import org.springframework.beans.BeansException;
    import org.springframework.beans.factory.annotation.Value;
    import org.springframework.context.ApplicationContext;
    import org.springframework.context.ApplicationContextAware;
    import org.springframework.http.HttpStatus;
    import org.springframework.util.StreamUtils;
    import org.springframework.web.bind.annotation.*;
    import javax.servlet.http.HttpServletRequest;
    import javax.servlet.http.HttpServletResponse;
    import javax.servlet.http.HttpSession;
    import java.io.File;
    import java.io.IOException;
    import java.net.URLConnection;
    import java.util.ArrayList;
    import java.util.Arrays;
    import java.util.List;
    import ${sessionScope.json.envJtee.packageBase}.*;
    import ${sessionScope.json.envJtee.packageBean}.${module.jteeBeanAlias};
    import ${sessionScope.json.envJtee.packageMask}.${module.jteeMaskAlias};

    @RestController
    @RequestMapping(value="${module.jteeAttachmentControllerPath}")
    public class ${module.jteeAttachmentControllerAlias} implements ApplicationContextAware
    {   @RequestMapping(value="<c:forEach items="${keys}" var="keyItem" varStatus="keyStatus">{${keyItem.key}}<c:if test="${!keyStatus.last}">/</c:if></c:forEach>",method=RequestMethod.GET,produces="application/octet-stream")
        public void downloadAttach(HttpSession session,HttpServletRequest request,HttpServletResponse response,<c:forEach items="${keys}" var="keyItem">@PathVariable ${keyItem.value.javaType} ${keyItem.value.databaseColumn},</c:forEach>@RequestParam(required=true) String name) throws IOException
        {   ${module.jteeBeanAlias} keyBean=new ${module.jteeBeanAlias}()<c:forEach items="${keys}" var="keyItem">.set${pac:upperFirst(keyItem.key)}(${keyItem.key})</c:forEach>;
            if(configurator==null||!configurator.beforeDownloadAttach(session,request,response,keyBean,name))
            {   response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                return;
            }
            File file=new File(configurator.locateAttach(session,request,response,keyBean),name);
            if (file.exists())
            {   String contentType=URLConnection.guessContentTypeFromName(file.getName());
                response.setContentType(contentType==null?"application/octet-stream":contentType);
                response.setHeader("Content-Disposition","attachment;fileName="+name);
                FileUtils.copyFile(file,response.getOutputStream());
                response.getOutputStream().close();
            }
            if(configurator!=null&&!configurator.afterDownloadAttach(session,request,response,keyBean,file))
            {   response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                return;
            }
            response.setStatus(file.exists()?HttpServletResponse.SC_OK:HttpServletResponse.SC_NOT_FOUND);
        }
        @RequestMapping(value="<c:forEach items="${keys}" var="keyItem" varStatus="keyStatus">{${keyItem.key}}<c:if test="${!keyStatus.last}">/</c:if></c:forEach>",method=RequestMethod.PUT,produces="application/json;charset=UTF-8")
        public void uploadAttach(HttpSession session,HttpServletRequest request,HttpServletResponse response,<c:forEach items="${keys}" var="keyItem">@PathVariable ${keyItem.value.javaType} ${keyItem.value.databaseColumn},</c:forEach>@RequestParam(required = true) String name) throws IOException
        {   byte[] bytes=StreamUtils.copyToByteArray(request.getInputStream());
            ${module.jteeBeanAlias} keyBean=new ${module.jteeBeanAlias}()<c:forEach items="${keys}" var="keyItem">.set${pac:upperFirst(keyItem.key)}(${keyItem.key})</c:forEach>;
            if(configurator==null||!configurator.beforeUploadAttach(session,request,response,keyBean,name,bytes))
            {   response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                return;
            }
            File fileOut=new File(configurator.locateAttach(session,request,response,keyBean),name);
            FileUtils.writeByteArrayToFile(fileOut,bytes,false);
            request.getInputStream().close();
            if(configurator!=null)
            {   configurator.afterUploadAttach(session,request,response,keyBean,name,fileOut);
            }
            response.setStatus(HttpServletResponse.SC_OK);
        }
        @RequestMapping(value="<c:forEach items="${keys}" var="keyItem" varStatus="keyStatus">{${keyItem.key}}<c:if test="${!keyStatus.last}">/</c:if></c:forEach>",method=RequestMethod.DELETE,produces="application/json;charset=UTF-8")
        public String deleteAttach(HttpSession session,HttpServletRequest request,HttpServletResponse response,<c:forEach items="${keys}" var="keyItem">@PathVariable ${keyItem.value.javaType} ${keyItem.value.databaseColumn},</c:forEach>@RequestParam(required=true) String name)
        {   ${module.jteeBeanAlias} keyBean=new ${module.jteeBeanAlias}()<c:forEach items="${keys}" var="keyItem">.set${pac:upperFirst(keyItem.key)}(${keyItem.key})</c:forEach>;
            if(configurator==null||!configurator.beforeDeleteAttach(session,request,response,keyBean,name))
            {   response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                return "";
            }
            File file=new File(configurator.locateAttach(session,request,response,keyBean),name);
            boolean result=false;
            if(file.exists())
                result=file.delete();
            if(configurator!=null)
            {   configurator.afterDeleteAttach(session,request,response,keyBean,name,result);
            }
            response.setStatus(result?HttpServletResponse.SC_OK:HttpServletResponse.SC_NO_CONTENT);
            return String.valueOf(result);
        }
        @RequestMapping(value="<c:forEach items="${keys}" var="keyItem" varStatus="keyStatus">{${keyItem.key}}<c:if test="${!keyStatus.last}">/</c:if></c:forEach>",method=RequestMethod.GET,produces="application/json;charset=UTF-8")
        public String listAttaches(HttpSession session,HttpServletRequest request,HttpServletResponse response<c:forEach items="${keys}" var="keyItem">,@PathVariable ${keyItem.value.javaType} ${keyItem.value.databaseColumn}</c:forEach>) throws JsonProcessingException
        {   ${module.jteeBeanAlias} keyBean=new ${module.jteeBeanAlias}()<c:forEach items="${keys}" var="keyItem">.set${pac:upperFirst(keyItem.key)}(${keyItem.key})</c:forEach>;
            if (configurator==null||!configurator.beforeListAttaches(session,request,response,keyBean))
            {   response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                return "";
            }
            File folder=configurator.locateAttach(session,request,response,keyBean);
            List${"<"}String${">"} result=folder.exists()?Arrays.asList(folder.list((dir,file)->{return !new File(dir,file).isHidden();})):new ArrayList<>();
            if(configurator!=null&&!configurator.afterListAttaches(session,request,response,keyBean,result))
            {   response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                return "";
            }
            response.setStatus(HttpServletResponse.SC_OK);
            return jackson.writeValueAsString(result);
        }
        @ResponseStatus(HttpStatus.BAD_REQUEST)
        @ExceptionHandler({Exception.class})
        public String exception(Exception e)
        {   e.printStackTrace();
            return "";
        }
        @Value(value="${"#{jackson}"}")
        private ObjectMapper jackson;
        private Configurator${"<"}${module.jteeBeanAlias},${module.jteeMaskAlias}${">"} configurator;
        @Override
        public void setApplicationContext(ApplicationContext applicationContext) throws BeansException
        {   configurator=applicationContext.containsBean("${pac:lowerFirst(module.jteeConfiguratorAlias)}")?applicationContext.getBean("${pac:lowerFirst(module.jteeConfiguratorAlias)}",Configurator.class):null;
        }
    }
</pac:java>