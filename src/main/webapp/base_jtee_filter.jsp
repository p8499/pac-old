<%--@formatter:off--%>
<%@ page import="java.util.Date" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="pac" uri="/WEB-INF/pac.tld" %>
<pac:java>
package ${sessionScope.json.envJtee.packageBase};

import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;

@JsonDeserialize(using = FilterDeserializer.class)
@JsonSerialize(using = FilterSerializer.class)
public interface FilterExpr {
    String toStringPostgresql();
    String toStringOracle();
}
</pac:java>