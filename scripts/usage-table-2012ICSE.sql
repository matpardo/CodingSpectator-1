DROP TABLE "PUBLIC"."REFACTORING_ID_TO_HUMAN_NAME" IF EXISTS;

CREATE TABLE "PUBLIC"."REFACTORING_ID_TO_HUMAN_NAME" (
  REFACTORING_ID VARCHAR(100),
  HUMAN_READABLE_NAME VARCHAR(100)
);

* *DSV_COL_SPLITTER = ,
* *DSV_TARGET_TABLE = "PUBLIC"."REFACTORING_ID_TO_HUMAN_NAME"

\m refactoring_id_human_name_mapping.csv

* *DSV_COL_DELIM=,
* *DSV_TARGET_FILE=UsageTableFor2012ICSE.csv

-- It seems that "Infer Generic Type" was never used so we special case it here
INSERT INTO "PUBLIC"."PER_REFACTORING_ID" ("REFACTORING_ID", "CODINGTRACKER_PERFORMED_COUNT", "CODINGTRACKER_UNDONE_COUNT", "CODINGTRACKER_REDONE_COUNT", "CODINGSPECTATOR_CANCELLED_COUNT", "CODINGSPECTATOR_UNAVAILABLE_COUNT", "INVOKED_BY_QUICKASSIST_COUNT", "PREVIEW_COUNT", "AVG_PERFORMED_OR_CANCELLED_CONFIGURATION_DURATION_IN_MILLI_SEC")
VALUES ('org.eclipse.jdt.ui.change.type', 0, 0, 0, 0, 0, 0, 0, 0);

\x SELECT (SELECT "H"."HUMAN_READABLE_NAME" FROM "PUBLIC"."REFACTORING_ID_TO_HUMAN_NAME" AS "H" WHERE "H"."REFACTORING_ID" = "R"."REFACTORING_ID") AS "Refactoring Tool", "R"."CODINGTRACKER_PERFORMED_COUNT" AS "Performed", "R"."CODINGTRACKER_UNDONE_COUNT" AS "Undo", "CODINGTRACKER_REDONE_COUNT" AS "Redo", "R"."CODINGSPECTATOR_CANCELLED_COUNT" AS "Canceled", "R"."CODINGSPECTATOR_UNAVAILABLE_COUNT" AS "Unavailable", "R"."INVOKED_BY_QUICKASSIST_COUNT" AS "Quick Assist", "R"."PREVIEW_COUNT" AS "Preview", "R"."AVG_PERFORMED_OR_CANCELLED_CONFIGURATION_DURATION_IN_MILLI_SEC" AS "Average Configuration Time", "R"."P_UNDONE_GIVEN_PERFORMED" AS "P Undo Performed", "R"."P_CANCELED_GIVEN_INVOCATION" AS "P Canceled Canceled Performed" , "R"."P_PERFORMED_GIVEN_WARNING_OR_ERROR_STATUS" AS "P Performed Warning Error" , CASE ("R"."CODINGSPECTATOR_UNAVAILABLE_COUNT"+ "R"."CODINGSPECTATOR_PERFORMED_COUNT" + "R"."CODINGSPECTATOR_PERFORMED_COUNT") WHEN 0 THEN NULL ELSE (CONVERT(CONVERT("R"."CODINGSPECTATOR_UNAVAILABLE_COUNT", SQL_FLOAT) / ( "R"."CODINGSPECTATOR_UNAVAILABLE_COUNT"+ "R"."CODINGSPECTATOR_PERFORMED_COUNT" + "R"."CODINGSPECTATOR_CANCELLED_COUNT"), NUMERIC(3,2))) END AS "P Unavailable" FROM "PUBLIC"."PER_REFACTORING_ID" AS "R" WHERE "R"."REFACTORING_ID" <> 'org.eclipse.jdt.ui.rename.java.project' AND "R"."REFACTORING_ID" <> 'org.eclipse.jdt.ui.rename.source.folder';


