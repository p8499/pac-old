<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="pac" uri="/WEB-INF/pac.tld" %>
<div class="list-group list-group-root well">
    <a class="list-group-item ${requestScope.path=="$"?"active":""}" href="/project?path=$">
        <i class="glyphicon ${requestScope.path.indexOf("$")>=0?"glyphicon-chevron-down":"glyphicon-chevron-right"}"
           href="#project" data-toggle="collapse"></i>
        ${sessionScope.json.name}
    </a>
    <div class="list-group collapse ${requestScope.path.indexOf("$")>=0?"in":""}" id="project">
        <a class="list-group-item ${requestScope.path=="$.envJtee"?"active":""}"
           href="/envJtee?path=$.envJtee">
            <i class="glyphicon ${requestScope.path.indexOf("$.envJtee")>=0?"glyphicon-chevron-down":"glyphicon-chevron-right"}"
               href="#envJtee" data-toggle="collapse"></i>
            J2EE Environment
        </a>
        <div class="list-group collapse ${requestScope.path.indexOf("$.envJtee")>=0?"in":""}" id="envJtee">
            <a class="list-group-item ${requestScope.path=="$.envJtee.datasources"?"active":""}"
               href="/datasources?path=$.envJtee.datasources">
                <i class="glyphicon ${requestScope.path.indexOf("$.envJtee.datasources")>=0?"glyphicon-chevron-down":"glyphicon-chevron-right"}"
                   href="#envJtee_datasources" data-toggle="collapse"></i>
                Data Sources
            </a>
            <div class="list-group collapse ${requestScope.path.indexOf("$.envJtee.datasources")>=0?"in":""}"
                 id="envJtee_datasources">
                <c:forEach items="${sessionScope.json.envJtee.datasources}" var="datasource" varStatus="datasourceStatus">
                    <a class="list-group-item ${requestScope.path==String.format("$.envJtee.datasources[%s]",datasourceStatus.index)?"active":""}"
                       href="/datasource?path=$.envJtee.datasources[${datasourceStatus.index}]">
                        <i class="glyphicon glyphicon-minus"></i>
                        [${datasourceStatus.index}] - ${datasource.id}
                    </a>
                </c:forEach>
            </div>
        </div>
        <a class="list-group-item ${requestScope.path=="$.envAndroid"?"active":""}"
           href="/envAndroid?path=$.envAndroid">
            <i class="glyphicon glyphicon-minus"></i>
            Android Environment
        </a>
        <a class="list-group-item ${requestScope.path=="$.modules"?"active":""}"
           href="/modules?path=$.modules">
            <i class="glyphicon ${requestScope.path.indexOf("$.modules")>=0?"glyphicon-chevron-down":"glyphicon-chevron-right"}"
               href="#modules" data-toggle="collapse"></i>
            Modules
        </a>
        <div class="list-group collapse ${requestScope.path.indexOf("$.modules")>=0?"in":""}" id="modules">
            <c:forEach items="${sessionScope.json.modules}" var="module" varStatus="moduleStatus">
                <a class="list-group-item ${requestScope.path==String.format("$.modules[%d]",moduleStatus.index)?"active":""}"
                   href="/module?path=$.modules[${moduleStatus.index}]">
                    <i class="glyphicon ${requestScope.path.indexOf(String.format("$.modules[%d]",moduleStatus.index))>=0?"glyphicon-chevron-down":"glyphicon-chevron-right"}"
                       href="#modules_${moduleStatus.index}" data-toggle="collapse"></i>
                    [${moduleStatus.index}] - ${sessionScope.json.modules[moduleStatus.index].id}
                </a>
                <div class="list-group collapse ${requestScope.path.indexOf(String.format("$.modules[%d]",moduleStatus.index))>=0?"in":""}"
                     id="modules_${moduleStatus.index}">
                    <a class="list-group-item ${requestScope.path==String.format("$.modules[%d].fields",moduleStatus.index)?"active":""}"
                       href="/fields?path=$.modules[${moduleStatus.index}].fields">
                        <i class="glyphicon ${requestScope.path.indexOf(String.format("$.modules[%d].fields",moduleStatus.index))>=0?"glyphicon-chevron-down":"glyphicon-chevron-right"}"
                           href="#modules_${moduleStatus.index}_fields" data-toggle="collapse"></i>
                        Fields
                    </a>
                    <div class="list-group collapse ${requestScope.path.indexOf(String.format("$.modules[%d].fields",moduleStatus.index))>=0?"in":""}"
                         id="modules_${moduleStatus.index}_fields">
                        <c:forEach items="${module.fields}" var="field" varStatus="fieldStatus">
                            <a class="list-group-item ${requestScope.path==String.format("$.modules[%d].fields[%d]",moduleStatus.index,fieldStatus.index)?"active":""}"
                               href="/field?path=$.modules[${moduleStatus.index}].fields[${fieldStatus.index}]">
                                <i class="glyphicon ${requestScope.path.indexOf(String.format("$.modules[%d].fields[%d]",moduleStatus.index,fieldStatus.index))>=0?"glyphicon-chevron-down":"glyphicon-chevron-right"}"
                                   href="#modules_${moduleStatus.index}_fields_${fieldStatus.index}"
                                   data-toggle="collapse"></i>
                                [${fieldStatus.index}] - ${field.databaseColumn}
                            </a>
                            <div class="list-group collapse ${requestScope.path.indexOf(String.format("$.modules[%d].fields[%d]",moduleStatus.index,fieldStatus.index))>=0?"in":""}"
                                 id="modules_${moduleStatus.index}_fields_${fieldStatus.index}">
                                <a class="list-group-item ${requestScope.path==String.format("$.modules[%d].fields[%d].special",moduleStatus.index,fieldStatus.index)?"active":""}"
                                   href="/special?path=$.modules[${moduleStatus.index}].fields[${fieldStatus.index}].special">
                                    <i class="glyphicon glyphicon-minus"></i>
                                    Special
                                </a>
                                <a class="list-group-item ${requestScope.path==String.format("$.modules[%d].fields[%d].values",moduleStatus.index,fieldStatus.index)?"active":""}"
                                   href="/values?path=$.modules[${moduleStatus.index}].fields[${fieldStatus.index}].values">
                                    <i class="glyphicon ${requestScope.path.indexOf(String.format("$.modules[%d].fields[%d].values",moduleStatus.index,fieldStatus.index))>=0?"glyphicon-chevron-down":"glyphicon-chevron-right"}"
                                       href="#modules_${moduleStatus.index}_fields_${fieldStatus.index}_values"
                                       data-toggle="collapse"></i>
                                    Values
                                </a>
                                <div class="list-group collapse ${requestScope.path.indexOf(String.format("$.modules[%d].fields[%d].values",moduleStatus.index,fieldStatus.index))>=0?"in":""}"
                                     id="modules_${moduleStatus.index}_fields_${fieldStatus.index}_values">
                                    <c:forEach items="${field.values}" var="value" varStatus="valueStatus">
                                        <a class="list-group-item ${requestScope.path==String.format("$.modules[%d].fields[%d].values[%s]",moduleStatus.index,fieldStatus.index,valueStatus.index)?"active":""}"
                                           href="/value?path=$.modules[${moduleStatus.index}].fields[${fieldStatus.index}].values[${valueStatus.index}]">
                                            <i class="glyphicon glyphicon-minus"></i>
                                            [${valueStatus.index}] - ${value.code}
                                        </a>
                                    </c:forEach>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                    <a class="list-group-item ${requestScope.path==String.format("$.modules[%d].uniques",moduleStatus.index)?"active":""}"
                       href="/uniques?path=$.modules[${moduleStatus.index}].uniques">
                        <i class="glyphicon ${requestScope.path.indexOf(String.format("$.modules[%d].uniques",moduleStatus.index))>=0?"glyphicon-chevron-down":"glyphicon-chevron-right"}"
                           href="#modules_${moduleStatus.index}_uniques" data-toggle="collapse"></i>
                        Uniques
                    </a>
                    <div class="list-group collapse ${requestScope.path.indexOf(String.format("$.modules[%d].uniques",moduleStatus.index))>=0?"in":""}"
                         id="modules_${moduleStatus.index}_uniques">
                        <c:forEach items="${module.uniques}" var="unique" varStatus="uniqueStatus">
                            <a class="list-group-item ${requestScope.path==String.format("$.modules[%d].uniques[%s]",moduleStatus.index,uniqueStatus.index)?"active":""}"
                               href="/unique?path=$.modules[${moduleStatus.index}].uniques[${uniqueStatus.index}]">
                                <i class="glyphicon glyphicon-minus"></i>
                                [${uniqueStatus.index}] - ${pac:join(",",unique.items)}
                            </a>
                        </c:forEach>
                    </div>
                    <a class="list-group-item ${requestScope.path==String.format("$.modules[%d].references",moduleStatus.index)?"active":""}"
                       href="/references?path=$.modules[${moduleStatus.index}].references">
                        <i class="glyphicon ${requestScope.path.indexOf(String.format("$.modules[%d].references",moduleStatus.index))>=0?"glyphicon-chevron-down":"glyphicon-chevron-right"}"
                           href="#modules_${moduleStatus.index}_references" data-toggle="collapse"></i>
                        References
                    </a>
                    <div class="list-group collapse ${requestScope.path.indexOf(String.format("$.modules[%d].references",moduleStatus.index))>=0?"in":""}"
                         id="modules_${moduleStatus.index}_references">
                        <c:forEach items="${module.references}" var="reference" varStatus="referenceStatus">
                            <a class="list-group-item ${requestScope.path==String.format("$.modules[%d].references[%s]",moduleStatus.index,referenceStatus.index)?"active":""}"
                               href="/reference?path=$.modules[${moduleStatus.index}].references[${referenceStatus.index}]">
                                <i class="glyphicon glyphicon-minus"></i>
                                [${referenceStatus.index}] - ${pac:join(",",reference.domestic)}
                            </a>
                        </c:forEach>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
</div>
