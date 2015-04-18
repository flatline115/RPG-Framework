local module = {}
	function module:GetSkill(player, skillName, infoType)
		local folder = player.Levels;
		if (infoType:lower() == "level") then
			return folder[skillName].Value;
		elseif (infoType:lower() == "experience") then
			return folder[skillName].Experience.Value;
		end;
	end;
return module
