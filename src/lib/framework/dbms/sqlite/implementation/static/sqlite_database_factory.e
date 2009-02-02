indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SQLITE_DATABASE_FACTORY

feature {ANY} -- Access

	new_database: SQLITE_DATABASE
			-- New database
		do
			create {SQLITE_DATABASE_STATIC} Result.make
		end


end
