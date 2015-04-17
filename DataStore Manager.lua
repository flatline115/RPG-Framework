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
				-- Given that we know it is in order...
					local difference = (#info[1] - #CurrentSkills);
					local start = ((#info[1] - difference) + 1);
					for i = start, #info[1] do
						CurrentSkills[i] = info[1][i];
						CurrentSLevel[i] = info[2][i];
						CurrentExp[i] = info[3][i];
						NCurrentExp[i] = info[4][i];						
					end;
				end;
				DataStore:SetAsync(player.Name..": Skills", CurrentSkills);
				DataStore:SetAsync(player.Name..": SkillsLevel", CurrentSLevel);
				DataStore:SetAsync(player.Name..": SkillsExp", CurrentExp);
				DataStore:SetAsync(player.Name..": SkillsNExp", NCurrentExp);			
		end;
		local folder = Instance.new("Folder", player);
		folder.Name = "Levels";
		for number, String in next, CurrentSkills do
				local newInstance = Instance.new("StringValue", folder);
				local subInstance = Instance.new("StringValue", newInstance);
				local subInstance2 = Instance.new("StringValue", newInstance);
				newInstance.Name = String;
				newInstance.Value = CurrentSLevel[number];
				subInstance.Name = "Experience";
				subInstance.Value = CurrentExp[number];
				subInstance2.Name = "ExperienceNeeded";
				subInstance2.Value = NCurrentExp[number];
			end;
		end);