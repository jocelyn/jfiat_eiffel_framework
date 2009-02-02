indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SQLITE_RESULT

create
	make

feature

	make (sql: STRING) is
		do
			query := sql
			count := 0
			create rows.make (10)
		end

	add_row (row: SQLITE_ROW) is
		do
			rows.force (row)
			count := count + 1
		end

feature -- Access

	count: INTEGER

	query: STRING

	rows: ARRAYED_LIST [SQLITE_ROW]

invariant
	rows /= Void

end
