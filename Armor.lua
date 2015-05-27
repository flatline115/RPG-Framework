local defaultWalkSpeed = 16;

game.Players.PlayerAdded:connect(function(player)
	repeat wait(1) until player.PlayerGui:FindFirstChild("skills")
	repeat wait(1) until player.PlayerGui:FindFirstChild("skills"):FindFirstChild("Armors");
	local folder = player.PlayerGui.skills.Armors;
	local db = false;
	functions = {
	findArmor = function(character)
		local light = folder["Light Armor"]:GetChildren();
		local heavy = folder["Heavy Armor"]:GetChildren();
		local armor = nil;
		local ntype = nil;
		for _, 	armor2 in next, light do
			if character:FindFirstChild(armor2.Name) then
				armor = armor2;
				ntype = "light";				
			end;
		end;
		
		for _, 	armor2 in next, heavy do
			if character:FindFirstChild(armor2.Name) then
				armor = armor2;	
				ntype = "heavy";			
			end;
		end;
		return armor, ntype;
	end;
	
	heavyArmorRating = function(rating, player)
		local rating = rating.Value;
		local formula = (rating * .1) + (player.Levels["HeavyArmor"].Value * .5);
		return formula, "HeavyArmor";
	end;
	
	lightArmorRating = function(rating, player)
		local rating2 = rating.Value;
		local formula = (rating2 * .05) + (tonumber(player.Levels["LightArmor"].Value) * .1);
		return formula, "LightArmor";
	end;
	
	calculateDamage = function(oldHealth, humanoid, player)
		local health = humanoid.Health;
		local armor, nType = functions.findArmor(humanoid.Parent);
		local modifer = 0;
		if (armor) then
			modifer, nType = functions[nType.."ArmorRating"](folder[nType:sub(1, 1):upper()..nType:sub(2).." Armor"][armor.Name].Rating, player);
		end;
		return modifer, nType;	
	end;
	
	
};

	player.CharacterAdded:connect(function(character)
		character.Humanoid.WalkSpeed = defaultWalkSpeed;
		local health = character.Humanoid.Health;
		character.Humanoid.Changed:connect(function(property)
			if (not db) then
				if (property == "Health_XML") then
					db = true;
					if (character.Humanoid.Health < health) then
					local modifer, FolderName = functions.calculateDamage(health, character.Humanoid, player);
					local plus = character.Humanoid.Health + modifer;
					character.Humanoid.Health = plus;  
					pcall(function() player.Levels[FolderName].Experience.Value = player.Levels[FolderName].Experience.Value + (health - character.Humanoid.Health) * .1 end);
					health = character.Humanoid.Health;				
					end;	
					db = false;		
				end;
			end;
		end);
	end);
end);