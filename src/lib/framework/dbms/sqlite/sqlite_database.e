indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	SQLITE_DATABASE

inherit
	SQLITE_CONSTANTS
		export
			{NONE} all
		end

feature -- Make

	make is
		do
			reset
			external_handle := impl_freeze (Current)
			get_sqlite_lib_version
			is_available := sqlite_lib_version /= Void
		end

	reset is
		do
			file_name := Void
			last_returned_code := 0
			database_handle := default_pointer
		end

feature -- Change

	open (fn: STRING) is
		require
			is_available: is_available
			not_database_initialized: not database_initialized
		local
			c_fn: C_STRING
			p: POINTER
		do
			file_name := fn
			create c_fn.make (fn)
			last_returned_code := ext_sqlite3_open (c_fn.item, $p)
			database_handle := p
		end

	close is
		require
			database_initialized
		do
			last_returned_code := ext_sqlite3_close (database_handle)
			file_name := Void
			database_handle := default_pointer
		ensure
			file_name = Void
			database_handle = default_pointer
		end

feature -- lib version

	is_available: BOOLEAN

	sqlite_lib_version: ?STRING

	get_sqlite_lib_version is
		local
			rescued: BOOLEAN
			p: POINTER
		do
			if not rescued then
				p := ext_sqlite3_libversion
				if p /= default_pointer then
					create sqlite_lib_version.make_from_c_pointer (p)
				end
			else
				sqlite_lib_version := Void
			end
		rescue
			rescued := True
			retry
		end

	sqlite_lib_version_is_3_3_or_older: BOOLEAN is
		local
			sp: LIST [STRING]
			retried: BOOLEAN
			v: like sqlite_lib_version
		do
			if not retried then
				v := sqlite_lib_version
				if v /= Void then
					sp := v.split ('.')
					Result := sp[1].to_integer >= 3
						and then sp[2].to_integer >= 3
				end
			else
				Result := False
			end
		rescue
			retried := True
			retry
		end

feature -- Access

	is_open, database_initialized: BOOLEAN is
		do
			Result := file_name /= Void and then database_handle /= Default_pointer
		end

	query (sql: STRING) is
		require
			sql /= Void
			database_initialized
		local
			cs, c_sql: C_STRING
			perr: POINTER
		do
			create last_result.make (sql)

			create c_sql.make (sql)
			last_returned_code := ext_sqlite3_exec (
					database_handle,
					c_sql.item,
					$call_query_process_agent,
					$Current,
					$perr
				)
			if perr /= Default_pointer then
				create cs.make_by_pointer (perr)
				last_error_message := cs.string
			else
				last_error_message := Void
			end
		end

	create_table (tbl: STRING; p_is_temporary: BOOLEAN; p_if_not_exists: BOOLEAN;
				p_cols: ARRAY [!TUPLE [name: STRING; type: STRING; const: ?STRING]]
			) is
		local
			s: STRING
			i: INTEGER
			t: TUPLE [name: STRING; type: STRING; const: ?STRING]
		do
			if p_is_temporary then
				s := "CREATE TEMP TABLE "
			else
				s := "CREATE TABLE "
			end
			if sqlite_lib_version_is_3_3_or_older and p_if_not_exists then
				s.append ("IF NOT EXISTS ")
			end
			s.append (tbl)
			s.append_character ('(')
			from
				i := p_cols.lower
			until
				i > p_cols.upper
			loop
				t := p_cols[i]
				s.append (t.name)
				s.append_character (' ')
				s.append (t.type)
				s.append_character (' ')
				if {c: STRING} t.const then
					s.append (c)
					s.append_character (' ')
				end
				i := i + 1
				if p_cols.valid_index (i) then
					s.append_character (',')
				end
			end
			s.append (");")
			query (s)
		end

	drop_table (tbl: STRING; p_if_exists: BOOLEAN) is
		local
			s: STRING
		do
			s := "DROP TABLE "
			if sqlite_lib_version_is_3_3_or_older and p_if_exists then
				s.append ("IF EXISTS ")
			end
			s.append (tbl)
			s.append (";")
			query (s)
		end

feature -- Query

	has_table (tbl: STRING): BOOLEAN is
		require
			database_initialized: database_initialized
		do
			query ("select name from sqlite_master where name = '" + tbl + "';")
			Result := last_result.count > 0
		end

feature {NONE} -- Callback

	callbacked_query (sql: STRING; callback: like agent_callback) is
		require
			sql /= Void
			database_initialized
		local
			cs, c_sql: C_STRING
			perr: POINTER
		do
			create last_result.make (sql)
			create c_sql.make (sql)
			agent_callback := callback
			last_returned_code := ext_sqlite3_exec (
					database_handle,
					c_sql.item,
					$call_agent_callback,
					$Current,
					$perr
				)
			agent_callback := Void
			if perr /= Default_pointer then
				create cs.make_by_pointer (perr)
				last_error_message := cs.string
			else
				last_error_message := Void
			end
		end

	agent_callback: ?FUNCTION [ANY, TUPLE [INTEGER, POINTER, POINTER], INTEGER]

	call_agent_callback (a_argc: INTEGER; a_argv: POINTER; a_col_names: POINTER): INTEGER is
		do
			if {ag: like agent_callback} agent_callback then
				Result := ag.item ([a_argc, a_argv, a_col_names])
			end
		end

	call_query_process_agent (a_argc: INTEGER; a_argv: POINTER; a_col_names: POINTER): INTEGER is
		local
			srow: SQLITE_ROW
			retried: BOOLEAN
		do
			if not retried then
				create srow.make (a_argc, a_argv, a_col_names)
				last_result.add_row (srow)
				Result := 0
			else
				Result := -1
			end
		rescue
			retried := True
			retry
		end

feature -- Properties

	file_name: ?STRING

	last_result: SQLITE_RESULT

	last_returned_code: INTEGER

	last_error_message: ?STRING

	last_query_succeed: BOOLEAN is
		do
			Result := last_returned_code = 0
		end

feature {NONE} -- Impl

--	sizeof_sqlite3: INTEGER is
--		external
--			"C macro use %"eif_sqlite.h%" "
--		alias
--			"sizeof(sqlite3)"
--		end

	sizeof_pchar: INTEGER is
		external
			"C macro use %"eif_sqlite.h%" "
		alias
			"sizeof(char*)"
		end

	sizeof_char: INTEGER is
		external
			"C macro use %"eif_sqlite.h%" "
		alias
			"sizeof(char)"
		end

feature {NONE} -- Implementation
	cwd: STRING
		do
			Result := (create {EXECUTION_ENVIRONMENT}).current_working_directory
		end

	database_handle: POINTER

	ext_sqlite3_libversion_number: INTEGER is
			-- Encapsulation of a dll function with the `_stdcall' call mechanism.
			-- int sqlite3_libversion_number(void)
		deferred
		end

	ext_sqlite3_libversion: POINTER is
			-- Encapsulation of a dll function with the `_stdcall' call mechanism.
			-- const char *sqlite3_libversion(void);
		deferred
		end

	ext_sqlite3_open (fn: POINTER; db_hdl: POINTER): INTEGER is
			-- Encapsulation of a dll function with the `_stdcall' call mechanism.
		deferred
		end

	ext_sqlite3_exec (db_hdl, a_sql, a_cb, a_arg, a_error_msg: POINTER): INTEGER is
		deferred
		end

	ext_sqlite3_close (db_hdl: POINTER): INTEGER is
			-- Encapsulation of a dll function with the `_stdcall' call mechanism.
		deferred
		end

feature {NONE} -- Eiffel runtime Implementation

	external_handle: POINTER

	impl_freeze (object_: ANY): POINTER is
		external
			"C (EIF_OBJECT): EIF_POINTER | %"eif_hector.h%""
		alias
			"eif_freeze"
--		ensure
--			is_frozen: impl_is_frozen (Result) /= 0
		end

--	impl_unfreeze (reference_: POINTER) is
--		require
--			is_frozen: impl_is_frozen (reference_) /= 0
--		external "C (EIF_POINTER) | %"eif_hector.h%""
--		alias "eif_unfreeze"
--		end		

	impl_is_frozen (object_: POINTER): INTEGER is
		external
			"C [macro %"eif_hector.h%"] (EIF_POINTER): EIF_INTEGER"
		alias
			"eif_frozen"
		end

end
