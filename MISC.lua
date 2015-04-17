-- Replicated Storage
local module = {}
	function module:MatchTable(tables)
		local match = true;
		local DefaultTab = tables[1]; 
		if (type(DefaultTab) == "table") then
		for num, tab in next, tables do
			if not(num == 1) then
				for num, value in next, tab do
					for num2, value2 in next, DefaultTab do
						if (num == num2) and not(value == value2) then
							match = false;
							end;
						end;
					end;
				end;
			end;
			else match = false;	
		end;
		return match;
	end;
return module
