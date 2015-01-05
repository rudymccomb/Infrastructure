/*
 * repmgr_function.sql
 * Copyright (c) 2ndQuadrant, 2010
 *
 */

-- SET SEARCH_PATH TO 'repmgr';

CREATE FUNCTION repmgr_update_standby_location(text) RETURNS boolean
AS '$libdir/repmgr_funcs', 'repmgr_update_standby_location'
LANGUAGE C STRICT;

CREATE FUNCTION repmgr_get_last_standby_location() RETURNS text
AS '$libdir/repmgr_funcs', 'repmgr_get_last_standby_location'
LANGUAGE C STRICT;
