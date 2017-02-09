package com.p8499.pac;

import javax.servlet.jsp.jstl.core.LoopTagStatus;
import java.util.List;
import java.util.Map;
import java.util.StringJoiner;

/**
 * Created by Administrator on 1/9/2017.
 */
public class Check {
    public static void checkProject(Map project) {

    }

    public static void checkDatasource(Map project, Map datasource, LoopTagStatus datasourceStatus) {

    }

    public static void checkModule(Map project, Map module, LoopTagStatus moduleStatus) {
        assertTrue(((List) Util.read(project, String.format("$.modules[?(@.id=='%s')]", module.get("id")))).size() == 1, "Duplicate module found '%s'.", module.get("id"));
        assertTrue(((List) Util.read(module, "$.uniques[?(@.key==true)]")).size() > 0, "Module '%s' does not have a certain key.", module.get("id"));
        assertTrue(((List) Util.read(module, "$.uniques[?(@.key==true)]")).size() <= 1, "Module '%s' defines a compound key which PAC does not support yet.", module.get("id"));
    }

    public static void checkField(Map project, Map module, LoopTagStatus moduleStatus, Map field, LoopTagStatus fieldStatus) {

    }

    public static void checkValue(Map project, Map module, LoopTagStatus moduleStatus, Map field, LoopTagStatus fieldStatus, Map value, LoopTagStatus valueStatus) {

    }

    public static void checkScopeColumn(Map project, Map module, LoopTagStatus moduleStatus, Map field, LoopTagStatus fieldStatus, String scopeColumn, LoopTagStatus scopeColumnStatus) {

    }

    public static void checkUnique(Map project, Map module, LoopTagStatus moduleStatus, Map unique, LoopTagStatus uniqueStatus) {
        int a = 0;
        System.out.println("");

    }

    public static void checkUniqueColumn(Map project, Map module, LoopTagStatus moduleStatus, Map unique, LoopTagStatus uniqueStatus, String uniqueColumn, LoopTagStatus uniqueColumnStatus) {
        assertTrue(((List) Util.read(module, String.format("$.fields[?(@.databaseColumn=='%s')]", uniqueColumn))).size() > 0, "Unique '%s'.'%s' defines an unrecognized field '%s'", module.get("id"), Util.join(",", unique), uniqueColumn);
    }

    public static void checkReference(Map project, Map module, LoopTagStatus moduleStatus, Map reference, LoopTagStatus referenceStatus) {
        assertTrue(((List) Util.read(project, String.format("$.modules[?(@.id=='%s')]", reference.get("foreignModule")))).size() > 0, "Reference '%s'.'%s' refers '%s'.'%s' defines an unrecognized foreign module '%s'", module.get("id"), Util.join(",", (List) reference.get("domestic")), reference.get("foreignModule"), Util.join(",", (List) reference.get("foreign")), reference.get("foreignModule"));
        assertTrue(((List) reference.get("domestic")).size() == ((List) reference.get("foreign")).size(), "Reference '%s'.'%s' refers '%s'.'%s' domestic and foreign fields count mismatch.", module.get("id"), Util.join(",", (List) reference.get("domestic")), reference.get("foreignModule"), Util.join(",", (List) reference.get("foreign")));
    }

    public static void checkDomesticColumn(Map project, Map module, LoopTagStatus moduleStatus, Map reference, LoopTagStatus referenceStatus, String domesticColumn, LoopTagStatus domesticColumnStatus) {
        assertTrue(((List) Util.read(module, String.format("$.fields[?(@.databaseColumn=='%s')]", domesticColumn))).size() > 0, "Reference '%s'.'%s' refers '%s'.'%s' has an unrecognized domestic field '%s'", module.get("id"), Util.join(",", (List) reference.get("domestic")), reference.get("foreignModule"), Util.join(",", (List) reference.get("foreign")), domesticColumn);
    }

    public static void checkForeignColumn(Map project, Map module, LoopTagStatus moduleStatus, Map reference, LoopTagStatus referenceStatus, String foreignColumn, LoopTagStatus foreignColumnStatus) {
        Map foreignModule = ((List<Map>) Util.read(project, String.format("$.modules[?(@.id=='%s')]", reference.get("foreignModule")))).get(0);
        assertTrue(((List) Util.read(foreignModule, String.format("$.fields[?(@.databaseColumn=='%s')]", foreignColumn))).size() > 0, "Reference '%s'.'%s' refers '%s'.'%s' has an unrecognized foreign field '%s'", module.get("id"), Util.join(",", (List) reference.get("domestic")), reference.get("foreignModule"), Util.join(",", (List) reference.get("foreign")), foreignColumn);
        Map domesticField = ((List<Map>) Util.read(module, String.format("$.fields[?(@.databaseColumn=='%s')]", ((List) reference.get("domestic")).get(foreignColumnStatus.getIndex())))).get(0);
        Map foreignField = ((List<Map>) Util.read(foreignModule, String.format("$.fields[?(@.databaseColumn=='%s')]", foreignColumn))).get(0);
        assertTrue(domesticField.get("javaType").equals(foreignField.get("javaType")), "Java type mismatch: '%s'.'%s'.javaType=%s while '%s'.'%s'.javaType=%s in reference '%s'.'%s' refers '%s'.'%s'", module.get("id"), domesticField.get("databaseColumn"), domesticField.get("javaType"), reference.get("foreignModule"), foreignColumn, foreignField.get("javaType"), module.get("id"), Util.join(",", (List) reference.get("domestic")), reference.get("foreignModule"), Util.join(",", (List) reference.get("foreign")));
        assertTrue(domesticField.get("stringLength").equals(foreignField.get("stringLength")), "Length mismatch: '%s'.'%s'.stringLength=%s while '%s'.'%s'.stringLength=%s in reference '%s'.'%s' refers '%s'.'%s'", module.get("id"), domesticField.get("databaseColumn"), domesticField.get("stringLength"), reference.get("foreignModule"), foreignColumn, foreignField.get("stringLength"), module.get("id"), Util.join(",", (List) reference.get("domestic")), reference.get("foreignModule"), Util.join(",", (List) reference.get("foreign")));
    }

    private static void assertTrue(boolean b, String format, Object... args) {
        if (!b)
            throw new RuntimeException(String.format(format, args));
    }
}
