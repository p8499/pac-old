package com.p8499.pac;

import com.google.googlejavaformat.java.Formatter;
import com.google.googlejavaformat.java.FormatterException;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.tagext.SimpleTagSupport;
import java.io.IOException;
import java.io.StringWriter;

/**
 * Created by Administrator on 1/10/2017.
 */
public class JavaTag extends SimpleTagSupport {
    @Override
    public void doTag() throws IOException, JspException {
        StringWriter writer = new StringWriter();
        getJspBody().invoke(writer);
        try {
            getJspContext().getOut().write(new Formatter().formatSource(writer.toString()));
        } catch (FormatterException e) {
            throw new JspException(e);
        }
    }
}
