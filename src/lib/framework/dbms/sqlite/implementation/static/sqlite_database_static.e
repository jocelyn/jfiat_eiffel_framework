indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SQLITE_DATABASE_STATIC

inherit
	SQLITE_DATABASE

create
	make

feature {NONE} -- Implementation

	ext_sqlite3_libversion_number: INTEGER is
			-- Encapsulation of a dll function with the `_stdcall' call mechanism.
			-- int sqlite3_libversion_number(void)
		external
			"[
				C (): EIF_INTEGER | "eif_sqlite.h"
			]"
		alias
			"sqlite3_libversion_number"
		end

	ext_sqlite3_libversion: POINTER is
			-- Encapsulation of a dll function with the `_stdcall' call mechanism.
			-- const char *sqlite3_libversion(void);
		external
			"[
				C (): EIF_POINTER | "eif_sqlite.h"
			]"
		alias
			"sqlite3_libversion"
		end

	ext_sqlite3_open (fn: POINTER; db_hdl: POINTER): INTEGER is
			-- Encapsulation of a dll function with the `_stdcall' call mechanism.
		external
			"[
				C (const char *, sqlite3 **): EIF_INTEGER | "eif_sqlite.h"
			]"
		alias
			"sqlite3_open"
		end

	ext_sqlite3_exec (db_hdl, a_sql, a_cb, a_arg, a_error_msg: POINTER): INTEGER is
		external
			"[
				C (sqlite3*, const char *, sqlite3_callback, void*, char ** ): EIF_INTEGER | "eif_sqlite.h"
			]"
		alias
			"sqlite3_exec"
		end

	ext_sqlite3_close (db_hdl: POINTER): INTEGER is
			-- Encapsulation of a dll function with the `_stdcall' call mechanism.
		external
			"[
				C (sqlite3*): EIF_INTEGER | "eif_sqlite.h"
			]"
		alias
			"sqlite3_close"
		end

end
