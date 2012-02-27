/*
-- It seems that "Infer Generic Type" was never used so we special case it here
INSERT INTO "PUBLIC"."PER_REFACTORING_ID" 

("REFACTORING_ID", "CODINGTRACKER_PERFORMED_COUNT",
"CODINGTRACKER_UNDONE_COUNT", "CODINGTRACKER_REDONE_COUNT",
"CODINGSPECTATOR_PERFORMED_COUNT", "CODINGSPECTATOR_CANCELED_COUNT",
"CODINGSPECTATOR_UNAVAILABLE_COUNT", "INVOKED_BY_QUICKASSIST_COUNT",
"PREVIEW_COUNT",
"AVG_PERFORMED_OR_CANCELED_CONFIGURATION_DURATION_IN_MILLI_SEC")

VALUES ('org.eclipse.jdt.ui.change.type', 0, 0, 0, 0, 0, 0, 0, 0, 0);
*/

DROP TABLE "PUBLIC"."PER_REFACTORING_ID_SUMMARY" IF EXISTS;

CREATE TABLE "PUBLIC"."PER_REFACTORING_ID_SUMMARY" (

  "REFACTORING_HUMAN_READABLE_NAME" VARCHAR(100),

  "CODINGTRACKER_PERFORMED_COUNT" INT,

  "CODINGTRACKER_UNDONE_COUNT" INT,

  "CODINGTRACKER_REDONE_COUNT" INT,

  "CODINGSPECTATOR_PERFORMED_COUNT" INT,

  "CODINGSPECTATOR_CANCELED_COUNT" INT,

  "CODINGSPECTATOR_UNAVAILABLE_COUNT" INT,

  "WARNING_STATUS_COUNT" INT,

  "ERROR_STATUS_COUNT" INT,

  "FATALERROR_STATUS_COUNT" INT,

  "INVOKED_BY_QUICKASSIST_COUNT" INT,

  "PREVIEW_COUNT" INT,

  "AVG_PERFORMED_OR_CANCELED_CONFIGURATION_DURATION_IN_SEC" NUMERIC(5, 1),

  "AVG_AFFECTED_LINES" NUMERIC(5, 2),

  "AVG_AFFECTED_FILES" NUMERIC(5, 2),

  "P_UNDONE_GIVEN_PERFORMED" NUMERIC(3, 2),

--  "P_CANCELED_GIVEN_CANCELED_OR_PERFORMED_WITHOUT_QA" NUMERIC(3, 2),

  "P_PERFORMED_GIVEN_WARNING" NUMERIC(3, 2),

  "P_PERFORMED_GIVEN_ERROR" NUMERIC(3, 2),

  "P_PERFORMED_GIVEN_WARNING_OR_ERROR" NUMERIC(3, 2)

);

INSERT INTO "PUBLIC"."PER_REFACTORING_ID_SUMMARY" (

  "REFACTORING_HUMAN_READABLE_NAME",

  "CODINGTRACKER_PERFORMED_COUNT",

  "CODINGTRACKER_UNDONE_COUNT",

  "CODINGTRACKER_REDONE_COUNT",

  "CODINGSPECTATOR_PERFORMED_COUNT",

  "CODINGSPECTATOR_CANCELED_COUNT",

  "CODINGSPECTATOR_UNAVAILABLE_COUNT",

  "WARNING_STATUS_COUNT",

  "ERROR_STATUS_COUNT",

  "FATALERROR_STATUS_COUNT",

  "INVOKED_BY_QUICKASSIST_COUNT",

  "PREVIEW_COUNT",

  "AVG_PERFORMED_OR_CANCELED_CONFIGURATION_DURATION_IN_SEC",

  "AVG_AFFECTED_LINES",

  "AVG_AFFECTED_FILES",

  "P_UNDONE_GIVEN_PERFORMED",

--  "P_CANCELED_GIVEN_CANCELED_OR_PERFORMED_WITHOUT_QA",

  "P_PERFORMED_GIVEN_WARNING",

  "P_PERFORMED_GIVEN_ERROR",

  "P_PERFORMED_GIVEN_WARNING_OR_ERROR"

) SELECT

(SELECT "H"."HUMAN_READABLE_NAME"

FROM "PUBLIC"."REFACTORING_ID_TO_HUMAN_NAME" AS "H"

WHERE "H"."REFACTORING_ID" = "R"."REFACTORING_ID") AS
"REFACTORING_HUMAN_READABLE_NAME",

"R"."CODINGTRACKER_PERFORMED_COUNT" AS "CODINGTRACKER_PERFORMED_COUNT",

"R"."CODINGTRACKER_UNDONE_COUNT" AS "CODINGTRACKER_UNDONE_COUNT",

"R"."CODINGTRACKER_REDONE_COUNT" AS "CODINGTRACKER_REDONE_COUNT",

"R"."CODINGSPECTATOR_PERFORMED_COUNT" AS "CODINGSPECTATOR_PERFORMED_COUNT",

"R"."CODINGSPECTATOR_CANCELED_COUNT" AS "CODINGSPECTATOR_CANCELED_COUNT",

"R"."CODINGSPECTATOR_UNAVAILABLE_COUNT" AS "CODINGSPECTATOR_UNAVAILABLE_COUNT",

"R"."WARNING_STATUS_COUNT" AS "WARNING_STATUS_COUNT",

"R"."ERROR_STATUS_COUNT" AS "ERROR_STATUS_COUNT",

"R"."FATALERROR_STATUS_COUNT" AS "FATALERROR_STATUS_COUNT",

"R"."INVOKED_BY_QUICKASSIST_COUNT" AS "INVOKED_BY_QUICKASSIST_COUNT",

"R"."PREVIEW_COUNT" AS "PREVIEW_COUNT",

("R"."AVG_PERFORMED_OR_CANCELED_CONFIGURATION_DURATION_IN_MILLI_SEC" / 1000.0)
AS "AVG_PERFORMED_OR_CANCELED_CONFIGURATION_DURATION_IN_SEC",

"A"."AVG_AFFECTED_LINES" AS "AVG_AFFECTED_LINES",

"A"."AVG_AFFECTED_FILES" AS "AVG_AFFECTED_FILES",

"R"."P_UNDONE_GIVEN_PERFORMED" AS "P_UNDONE_GIVEN_PERFORMED",

--"R"."P_CANCELED_GIVEN_CANCELED_OR_PERFORMED_WITHOUT_QA" AS
--"P_CANCELED_GIVEN_CANCELED_OR_PERFORMED_WITHOUT_QA",

"R"."P_PERFORMED_GIVEN_WARNING" AS "P_PERFORMED_GIVEN_WARNING",

"R"."P_PERFORMED_GIVEN_ERROR" AS "P_PERFORMED_GIVEN_ERROR",

"R"."P_PERFORMED_GIVEN_WARNING_OR_ERROR" AS
"P_PERFORMED_GIVEN_WARNING_OR_ERROR"

--"R"."P_UNAVAILABLE_GIVEN_UNAVAILABLE_OR_CANCELED_OR_PERFORMED" AS
--"P_Unavailable",

--"R"."P_WARNING_GIVEN_PERFORMED_OR_CANCELED" AS "P_Warning",

--"R"."P_ERROR_GIVEN_PERFORMED_OR_CANCELED" AS "P_Error",

--"R"."P_FATAL_GIVEN_PERFORMED_OR_CANCELED" AS "P_Fatal_or_Error",

--"R"."P_UNAVAILABLE_OR_WARNING_OR_ERROR_OR_FATAL_GIVEN_CS_REFACTORINGS" AS
--"P_Unavailable_or_Warning_or_Error_or_Fatal_Error",

--"R"."P_CANCELED_GIVEN_WARNING_OR_ERROR_OR_FATAL" AS
--"P_Canceled_Given_Warning_or_Error_or_Fatal_Error",

FROM

"PUBLIC"."PER_REFACTORING_ID" "R" LEFT OUTER JOIN

(SELECT

"RCS"."REFACTORING_ID" AS "REFACTORING_ID",

COUNT("RCS"."USERNAME") AS "INVOCATION_COUNT",

CONVERT(AVG(CONVERT("RCS"."AFFECTED_FILES_COUNT", SQL_FLOAT)), NUMERIC(5, 2))
AS "AVG_AFFECTED_FILES",

CONVERT(AVG(CONVERT("RCS"."AFFECTED_LINES_COUNT", SQL_FLOAT)), NUMERIC(5, 2))
AS "AVG_AFFECTED_LINES"

--SUM("RCS"."AFFECTED_FILES_COUNT") AS "SUM_AFFECTED_FILES",

--SUM("RCS"."AFFECTED_LINES_COUNT") AS "SUM_AFFECTED_LINES"

FROM "PUBLIC"."JAVA_REFACTORING_CHANGE_SIZE" "RCS"

WHERE IS_JAVA_REFACTORING("RCS"."REFACTORING_ID")

GROUP BY "RCS"."REFACTORING_ID"

ORDER BY "RCS"."REFACTORING_ID") "A"

ON "R"."REFACTORING_ID" = "A"."REFACTORING_ID"

WHERE "R"."REFACTORING_ID" <> 'org.eclipse.jdt.ui.rename.java.project' AND
"R"."REFACTORING_ID" <> 'org.eclipse.jdt.ui.rename.source.folder';

* *DSV_COL_DELIM =,

* *DSV_ROW_DELIM =\n

* *DSV_TARGET_FILE =UsageTableFor2012ICSE.csv

\x SELECT * FROM "PUBLIC"."PER_REFACTORING_ID_SUMMARY"

