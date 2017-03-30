<%--@formatter:off--%>
<%@ page import="java.util.Date" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="pac" uri="/WEB-INF/pac.tld" %>
<pac:java>
package ${sessionScope.json.envAndroid.packageBase};

import java.text.ParseException;
import java.text.SimpleDateFormat;

public class FilterOperandExpr implements FilterExpr {
    public static final String OP_STRING = "string";
    public static final String OP_NUMBER = "number";
    public static final String OP_DATE = "date";

    public String op = null;
    public String data = null;
    public Boolean isCol = null;

    public FilterOperandExpr() {
    }

    public FilterOperandExpr(String data, String op, Boolean isCol) {
        this.op = op;
        this.data = data;
        this.isCol = isCol;
    }
}
</pac:java>