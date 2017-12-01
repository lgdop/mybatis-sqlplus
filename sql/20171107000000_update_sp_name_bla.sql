-- // Create Changelog

-- Default DDL for changelog table that will keep
-- a record of the migrations that have been run.

-- You can modify this to suit your database before
-- running your first migration.

-- Be sure that ID and DESCRIPTION fields exist in
-- BigInteger and String compatible fields respectively.

CREATE OR REPLACE PACKAGE PK_CS2K_MIGRATION IS

 -- Author  : Accenture
 -- Created : 9/21/2017 11:31:30
 -- Purpose : Mass migration of CS2K customer
 -- Public function and procedure declarations

    --Begin New Code - AD Team - DR34.0 NL - 27/10/2017 - MRT-4082: [BLD] : CS2K : Migration : CLY-OFF Shadow Table,Preparation scripts and Trigger (ZAN-11454 , ZAN-11563) - Part 1 / MRT-4113: [BLD] : CS2K : Migration : CLY-OFF Shadow Table,Preparation scripts and Trigger (ZAN-11454 , ZAN-11563) - Part 2
    PROCEDURE SP_Load_Mig_SDW( o_error_code   OUT  NUMBER,
                               o_errmsg       OUT  VARCHAR2);

    FUNCTION GET_CONFIG_VALUE(is_name IN TABLE_X_CONFIG_ITM.X_NAME%TYPE)
    RETURN   TABLE_X_CONFIG_ITM.X_VALUE%TYPE;

    FUNCTION AsapReplace(v_Field VARCHAR2) RETURN VARCHAR2;

    PROCEDURE P_LOG_MESSAGE( i_msg          IN VARCHAR2,
                             i_proc_id      IN VARCHAR2 := NULL,
                             i_add_info     IN VARCHAR2 := NULL);
    --End New Code - AD Team - DR34.0 NL - 27/10/2017 - MRT-4082: [BLD] : CS2K : Migration : CLY-OFF Shadow Table,Preparation scripts and Trigger (ZAN-11454 , ZAN-11563) - Part 1 / MRT-4113: [BLD] : CS2K : Migration : CLY-OFF Shadow Table,Preparation scripts and Trigger (ZAN-11454 , ZAN-11563) - Part 2

    --Begin New Code - AD Team - DR34.0 NL - 27/10/2017 - MRT-4081: [BLD] : CS2K : Migration : Migration Table and Preparation scripts (ZAN-10593 , ZAN-11025) - Part 1 / MRT-4109: [BLD] : CS2K : Migration : Migration Table and Preparation scripts (ZAN-10593 , ZAN-11025) - Part 2
    PROCEDURE CLY_LOAD_MIG_TABLE(o_error_code OUT NUMBER,
                                 o_error_msg  OUT VARCHAR2);
    --End New Code - AD Team - DR34.0 NL - 27/10/2017 - MRT-4081: [BLD] : CS2K : Migration : Migration Table and Preparation scripts (ZAN-10593 , ZAN-11025) - Part 1 / MRT-4109: [BLD] : CS2K : Migration : Migration Table and Preparation scripts (ZAN-10593 , ZAN-11025) - Part 2

END PK_CS2K_MIGRATION;

-- //@UNDO

CREATE OR REPLACE PACKAGE PK_CS2K_MIGRATION IS
 
{{ OLD CODE }}

END PK_CS2K_MIGRATION;