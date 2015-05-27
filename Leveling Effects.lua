local Data = game:GetService("DataStoreService"):GetGlobalDataStore();
local validSkills = {"Athletics", "Acrobatics", "Swordfighting", "LightArmor", "HeavyArmor"};
game.Players.PlayerAdded:connect(function(player)
	local requiste = require(game.ReplicatedStorage.Skills);
	player.CharacterAdded:connect(function(character)
	-- {1, 1, 1, 1, 1}
	repeat wait() until player:FindFirstChild("Levels");
	for _, sNames in next, validSkills do
			repeat wait() until player.Levels:FindFirstChild(sNames);
			local item = player.Levels:FindFirstChild(sNames);
			repeat wait() until item:FindFirstChild("Experience")
			repeat wait() until item:FindFirstChild("ExperienceNeeded")
	end;
	local oldSkillVal = {};
		-- Acrobatics
 			local force = Instance.new("BodyVelocity", character.Torso);
			force.maxForce = Vector3.new(0, character.Torso:GetMass(), 0);
			force.velocity = Vector3.new(0, 40, 0);
		-- other
		local Effect = {
			Acrobatics = function(int)
				force.maxForce = force.maxForce + Vector3.new(0, 2 * int, 0);
			end;		
			
			Athletics = function(int)
				character.Humanoid.WalkSpeed = character.Humanoid.WalkSpeed + (int * 2)
			end;
			
			SwordFighting = function(int)
				local weapons = game.ReplicatedStorage.Skills.Weapons.SwordNames;
				for _, weapon in next, weapons:GetChildren() do
					for _, changeVal in next, weapon:GetChildren() do					
						for _, item in next, player.Backpack:GetChildren() do
							if (item.Name == weapon.Name) then
								item[changeVal.Name].Value =  (changeVal.Value) + (3 * int);
							end;
						end;
					
						for _, item in next, character:GetChildren() do
							if (item.Name == weapon.Name) then
								item[changeVal.Name].Value = (changeVal.Value) + (3 * int);
							end;
						end;
					end;
				end;
			end;
		};
		
		
		
		for _, item in next, player.Levels:GetChildren() do
			repeat wait() until item:FindFirstChild("Experience")
			repeat wait() until item:FindFirstChild("ExperienceNeeded")
			pcall(function() Effect[item.Name](item.Value) end);
			oldSkillVal[item.Name] = item.Value
			item.Changed:connect(function(property)
				if (property == "Property") then
					pcall(function() Effect[item.Name](item - oldSkillVal[item.Name]) end);
					oldSkillVal[item.Name] = item.Value
				end;
			end);		
			
			item.Experience.Changed:connect(function(property)
				print(item.Name..": "..item.Experience.Value);
				if (item.Experience.Value >= item.ExperienceNeeded.Value) then
					local upVal = 1;
					item.ExperienceNeeded.Value = item.ExperienceNeeded.Value + (item.ExperienceNeeded.Value * .2);
					repeat 
						if (item.Experience.Value - item.ExperienceNeeded.Value) >= 0 then
							item.Experience.Value = item.Experience.Value - item.ExperienceNeeded.Value
							item.ExperienceNeeded.Value = item.ExperienceNeeded.Value + (item.ExperienceNeeded.Value * .2);
							upVal = upVal + 1;
						else
							break;
						end;
						wait();
					until (item.Experience.Value - item.ExperienceNeeded.Value) < 0;
					item.Value = item.Value + upVal;
				end;
			end);	
		end;
	end);
end);

while wait(((60 + game.Players.NumPlayers) * 10)/60) do
	for _, player in next, game.Players:GetPlayers() do
			
		local syncLevels = {};
		local syncExperience = {}; 
		local syncExperienceNeeded  = {};
		for num, sNames in next, validSkills do
			repeat wait() until player:FindFirstChild("Levels")
			repeat wait() until player.Levels:FindFirstChild(sNames);
			local item = player.Levels:FindFirstChild(sNames);
			repeat wait() until item:FindFirstChild("Experience")
			repeat wait() until item:FindFirstChild("ExperienceNeeded")
			local folder = player.Levels;
			local sFolder = folder[sNames];
			local sExp = sFolder.Experience;
			local snExp = sFolder.ExperienceNeeded
			syncLevels[num] = sFolder.Value;
			syncExperience[num] = sExp.Value;
			syncExperienceNeeded[num] = snExp.Value;
			Data:SetAsync(player.Name..": SkillsLevel", syncLevels);
			Data:SetAsync(player.Name..": SkillsExp", syncExperience);
			Data:SetAsync(player.Name..": SkillsNExp", syncExperienceNeeded);
		end;
	end;
end;