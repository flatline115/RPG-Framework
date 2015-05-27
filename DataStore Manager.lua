-- Needed Items
	local skills = require(game.ReplicatedStorage.Skills);
	local misc = require(game.ReplicatedStorage.misc);
	local DataStore = game:GetService("DataStoreService"):GetGlobalDataStore();
	--[[
		DataStore Keys:
			Skills: All Skills known by player. 
			SkillsLevel: ...
			SkillsExp: Skills exp
			SkillsNExp: Needed exp for skill. 
	--]]
-- The Rest...
	game.Players.PlayerAdded:connect(function(player)
		local CurrentSkills = DataStore:GetAsync(player.Name..": Skills");
		local CurrentSLevel = DataStore:GetAsync(player.Name..": SkillsLevel");
		local CurrentExp = DataStore:GetAsync(player.Name..": SkillsExp");
		local NCurrentExp = DataStore:GetAsync(player.Name..": SkillsNExp");
		local info = {skills:GetSkills()};
		if (CurrentSkills == nil) or (misc:MatchTable({info[1], CurrentSkills})) then
			if (CurrentSkills == nil) then
				CurrentSkills = info[1];
				CurrentSLevel = info[2];
				CurrentExp = info[3];
				NCurrentExp = info[4];
			else
				local start = #CurrentSkills + 1;
				for i = start, #info[1] do
					CurrentSkills[i] = info[1][i];
					CurrentSLevel[i] = info[2][i];
					CurrentExp[i] = info[3][i];
					NCurrentExp[i] = info[4][i];
				end;
			end;
		end;
		local folder = Instance.new("Folder", player);
		folder.Name = "Levels";
		for num, String in next, CurrentSkills do
			local instance = Instance.new("StringValue", folder);
			local subinstance = Instance.new("StringValue", instance);
			local subinstance2 = Instance.new("StringValue", instance);
			instance.Name = String;
			subinstance.Name = "Experience";
			subinstance2.Name = "ExperienceNeeded"	
			
			instance.Value = tostring(CurrentSLevel[num]);
			subinstance.Value =  tostring(CurrentExp[num]);	
			subinstance2.Value =  tostring(NCurrentExp[num]);
		end;
	end);