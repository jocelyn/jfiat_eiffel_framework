indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SQLITE_ROW

create
	make

feature -- Initialization

	make (c: INTEGER; vals, nams: POINTER) is
		local
			p: POINTER
			l_psize: INTEGER
			i: INTEGER
--			cs: C_STRING
			s: ?STRING
			vmp, nmp: MANAGED_POINTER
		do
			count := c
			l_psize := sizeof_pchar
			from
				create internal_data.make (2 * count)
				create vmp.share_from_pointer (vals, c * l_psize)
				create nmp.share_from_pointer (nams, c * l_psize)
				i := 0
			until
				i = count
			loop
				p := nmp.read_pointer (i * l_psize)
				if p /= Default_pointer then
					create s.make_from_c_pointer (p)
					internal_data [2*i] := s.twin
				end

				p := vmp.read_pointer (i * l_psize)
				if p /= Default_pointer then
					create s.make_from_c_pointer (p)
					internal_data[2*i+1] := s.twin
				end
				i := i + 1
			end
		end

feature -- Access

	count: INTEGER

	to_string: STRING is
		local
			i: INTEGER
			s: STRING
		do
			from
				Result := "[%N"
				i := 1
			until
				i > count
			loop
				s := name (i)
				Result.append_string ("  " + s + " => ")
				s := value (i)
				if s /= Void then
					Result.append_string ("%"" + value (i) + "%" %N")
				else
					Result.append_string ("Void %N")
				end
				i := i + 1
			end
			Result.append_string ("]%N")
		end

	name (i: INTEGER): STRING is
		require
			i >= 1 and i <= count
		do
			Result := internal_data [2 * (i - 1)]
		end

	value (i: INTEGER): STRING is
		require
			i >= 1 and i <= count
		do
			Result := internal_data [2 * (i - 1) + 1]
		end

feature {NONE} -- Impl

	internal_data: SPECIAL [STRING]

	sizeof_pchar: INTEGER is
		external
			"C macro use %"eif_eiffel.h%" "
		alias
			"sizeof(char*)"
		end

end
