indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SQLITE_CONSTANTS

feature -- SQLITE Constants

--	c_SQLITE_OK: INTEGER is
--		external
--			"C [macro %"eif_sqlite.h%"] : EIF_INTEGER"
--		alias
--			"SQLITE_OK"
--		end
--
--	c_SQLITE_BUSY: INTEGER is
--		external
--			"C [macro %"eif_sqlite.h%"] : EIF_INTEGER"
--		alias
--			"SQLITE_BUSY"
--		end
--
--	c_SQLITE_ERROR: INTEGER is
--		external
--			"C [macro %"eif_sqlite.h%"] : EIF_INTEGER"
--		alias
--			"SQLITE_ERROR"
--		end
--
--
--	c_SQLITE_ABORT: INTEGER is
--		external
--			"C [macro %"eif_sqlite.h%"] : EIF_INTEGER"
--		alias
--			"SQLITE_ABORT"
--		end

	c_SQLITE_OK: INTEGER         is 0   --|  Successful result |--
	c_SQLITE_ERROR: INTEGER      is 1   --|  SQL error or missing database |--
	c_SQLITE_INTERNAL: INTEGER   is 2   --|  An internal logic error in SQLite |--
	c_SQLITE_PERM: INTEGER       is 3   --|  Access permission denied |--
	c_SQLITE_ABORT: INTEGER      is 4   --|  Callback routine requested an abort |--
	c_SQLITE_BUSY: INTEGER       is 5   --|  The database file is locked |--
	c_SQLITE_LOCKED: INTEGER     is 6   --|  A table in the database is locked |--
	c_SQLITE_NOMEM: INTEGER      is 7   --|  A malloc() failed |--
	c_SQLITE_READONLY: INTEGER   is 8   --|  Attempt to write a readonly database |--
	c_SQLITE_INTERRUPT: INTEGER  is 9   --|  Operation terminated by sqlite_interrupt() |--
	c_SQLITE_IOERR: INTEGER      is 10   --|  Some kind of disk I/O error occurred |--
	c_SQLITE_CORRUPT: INTEGER    is 11   --|  The database disk image is malformed |--
	c_SQLITE_NOTFOUND: INTEGER   is 12   --|  (Internal Only) Table or record not found |--
	c_SQLITE_FULL: INTEGER       is 13   --|  Insertion failed because database is full |--
	c_SQLITE_CANTOPEN: INTEGER   is 14   --|  Unable to open the database file |--
	c_SQLITE_PROTOCOL: INTEGER   is 15   --|  Database lock protocol error |--
	c_SQLITE_EMPTY: INTEGER      is 16   --|  (Internal Only) Database table is empty |--
	c_SQLITE_SCHEMA: INTEGER     is 17   --|  The database schema changed |--
	c_SQLITE_TOOBIG: INTEGER     is 18   --|  Too much data for one row of a table |--
	c_SQLITE_CONSTRAINT: INTEGER is 19   --|  Abort due to constraint violation |--
	c_SQLITE_MISMATCH: INTEGER   is 20   --|  Data type mismatch |--
	c_SQLITE_MISUSE: INTEGER     is 21   --|  Library used incorrectly |--
	c_SQLITE_NOLFS: INTEGER      is 22   --|  Uses OS features not supported on host |--
	c_SQLITE_AUTH: INTEGER       is 23   --|  Authorization denied |--
	c_SQLITE_ROW: INTEGER        is 100  --|  sqlite_step() has another row ready |--
	c_SQLITE_DONE: INTEGER       is 101  --|  sqlite_step() has finished executing |--

end
