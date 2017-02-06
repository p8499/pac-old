<%--@formatter:off--%>
<%@ page import="java.util.Date" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="pac" uri="/WEB-INF/pac.tld" %>
<pac:java>
package ${sessionScope.json.envJtee.packageBase};

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

public class DefaultDateFormatter {
    private static SimpleDateFormat formatter;

    public static SimpleDateFormat getFormatter() {
        if (formatter == null)
            formatter = new SimpleDateFormat("yyyyMMddHHmmss");
        return formatter;
    }

    public static String format(Date date) {
        return getFormatter().format(date);
    }

    public static Date parse(String str) {
        Date date = null;
        try {
            date = getFormatter().parse(str);
        } catch (ParseException e) {
            e.printStackTrace();
        }
        return date;
    }
}
</pac:java>