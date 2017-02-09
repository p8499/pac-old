package com.p8499.pac;

import com.jayway.jsonpath.Configuration;
import com.jayway.jsonpath.DocumentContext;
import com.jayway.jsonpath.JsonPath;
import com.jayway.jsonpath.ReadContext;
import com.jayway.jsonpath.internal.JsonContext;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

/**
 * Created by Administrator on 12/26/2016.
 */
@WebServlet(name = "sample", urlPatterns = "/sample")
public class Sample extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) {
        request.getSession().setAttribute("json", Configuration.defaultConfiguration().jsonProvider().parse("{\"name\":\"MyProject\",\"envJtee\":{\"databaseType\":\"postgresql\",\"app\":\"myapp\",\"packageBean\":\"mypack.bean\",\"packageMask\":\"mypack.mask\",\"packageMapper\":\"mypack.mapper\",\"packageListener\":\"mypack.listener\",\"packageController\":\"mypack.controller\",\"packageControllerAttachment\":\"mypack.controller\"},\"envAndroid\":{\"packageBean\":\"mypack.bean\",\"packageMask\":\"mypack.mask\",\"packageStub\":\"mypack.stub\"},\"modules\":[{\"id\":\"language\",\"description\":\"語言\",\"databaseTable\":\"public.F1010\",\"databaseView\":\"public.F1010\",\"jteeBeanAlias\":\"Language\",\"jteeMaskAlias\":\"LanguageMask\",\"jteeMapperAlias\":\"LanguageMapper\",\"jteeListenerAlias\":\"LanguageListener\",\"jteeControllerAlias\":\"LanguageListener\",\"jteeControllerPath\":\"/api/language\",\"jteeAttachmentControllerAlias\":\"LanguageAttachmentController\",\"jteeAttachmentControllerPath\":\"/api/language_attachment\",\"androidBeanAlias\":\"Language\",\"androidMaskAlias\":\"LanguageMask\",\"androidStubAlias\":\"LanguageStub\",\"fields\":[{\"databaseColumn\":\"LSID\",\"description\":\"語言編碼\",\"javaType\":\"String\",\"dojoType\":\"dijit/form/TextBox\",\"format\":\"\",\"length\":16,\"special\":{\"type\":\"key\",\"serial\":false}},{\"databaseColumn\":\"LSNAME\",\"description\":\"語言名稱\",\"javaType\":\"java.util.Date\",\"dojoType\":\"DateTimeTextBox\",\"format\":\"yyyy/MM/dd\",\"length\":0,\"special\":{\"type\":\"next\",\"scope\":[\"TAAA\",\"TABB\"],\"step\":1}}],\"uniques\":[[\"LSID\"],[\"LSID\",\"LSNAME\"]],\"references\":[{\"foriegnModel\":\"language\",\"domestic\":[\"LSID\",\"LSNAME\"],\"foreign\":[\"LSID\",\"LSNAME\"]}]}]}"));
    }

    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response) {
        doPost(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        doPost(request, response);
    }

    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response) {
        doPost(request, response);
    }
}
