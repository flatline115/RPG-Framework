local module = {}
	function module:GetSkills()	
		local validSkills = {"Athletics", "Acrobatics", "Swordfighting", "LightArmor", "HeavyArmor"};
		local defaultLevel = {1, 1, 1, 1, 1};
		local defaultExp = {0, 0, 0, 0, 0};
		local defaultExpNeeded = {100, 100, 50, 100, 150};
		--[[
			Skills Description:
				Athletics is walking, running and swimming.
				Acrobatics is jumping.
		--]]		
		return validSkills, defaultLevel, defaultExp, defaultExpNeeded;
	end;
	
	function module:SkillFunction(skill, player, character)
		local functions = {
			Athletics = function(plyr, character)
				local remote = game.ReplicatedStorage.Master;
				local UserInput = game:GetService("UserInputService");				
				local shiftKey = false;
				local CurrentLevel = plyr.Levels.Athletics;
				local CurrentExp = plyr.Levels.Athletics.Experience;
				local ExpNeeded = plyr.Levels.Athletics.ExperienceNeeded;
				local SwimmingExpGain = .02; -- Given per second.
				local WalkingExpGain = .005;
				local RunningExpGain = .01;
				--------------------------------------------------------
				-- User Input.
					UserInput.InputBegan:connect(function(userinput)
						if (userinput.KeyCode == Enum.KeyCode.RightShift) then
							shiftKey = true;
						end;
					end);
					
					UserInput.InputEnded:connect(function(userinput)
						if (userinput.KeyCode == Enum.KeyCode.RightShift) then
							shiftKey = false;
						end;
					end);
				-- Swimming
					character.Humanoid.Swimming:connect(function(speed)
						-- Assumes roblox water because, yeah.
						local oldTime = tick();
						while (character.Humanoid:GetState() == Enum.HumanoidStateType.Swimming) do wait() end; 
						local currentTime = tick();
						local difference = currentTime - oldTime;
						local addExp = difference * SwimmingExpGain;
						remote:FireServer({"change"}, {{CurrentExp, "Value", tonumber(CurrentExp.Value) + addExp}});
					end);
					
				-- Walking
					character.Humanoid.Running:connect(function(speed)
						if not(shiftKey) then
							local oldTime = tick();
							while (speed > 0) do wait() end;
							local currentTime = math.floor(tick());
							local difference = currentTime - oldTime;
							local addExp = difference * WalkingExpGain;
							remote:FireServer({"change"}, {{CurrentExp, "Value", tonumber(CurrentExp.Value) + addExp}});
						else						
						end;
					end);
				-- Level up effects.
					local effects = function(walkspeed)
						character.Humanoid.WalkSpeed = character.Humanoid.WalkSpeed + walkspeed;
					end;
				
				-- Leveling up
				CurrentExp.Changed:connect(function()
					if tonumber(CurrentExp.Value) >= tonumber(ExpNeeded.Value) then
						effects(2);			
					end;
				end);
				-- Loading
				local Loaded = function(Level)
					effects(2 * Level);
				end;
				Loaded(tonumber(CurrentLevel.Value))
			end;
			
			Acrobatics = function(player, character)
				local remote = game.ReplicatedStorage.Master;				
				local folder = player.Levels;
				local skill = folder.Acrobatics;
				local CurrentExp = skill.Experience;
				local humanoid = character.Humanoid;
				
				humanoid.Changed:connect(function(property)
					print(property);
					if (property == "Jump") then
						remote:FireServer({"change"}, {{CurrentExp, "Value", tonumber(CurrentExp.Value) + 1}});
					end;
				end);
			end;
			
			SwordFighting = function(player, character)
				local remote = game.ReplicatedStorage.Master;
				local folder = script.Weapons.SwordNames;
				local folder2 = player.Levels.Swordfighting;
				local CurrentExp = folder2.Experience;
				local Debounce = false;
				local addExp = 1.5;
				-- Assumes roblox default sword; can be applied to any sword tho with minor editing to use damage values.
				local weapons = player.Backpack;
				for _, obj in next, weapons:GetChildren() do
					for _, Valid in next, folder:GetChildren() do
						if (Valid.Name == obj.Name) then
 							local mouse = player:GetMouse();
							local detect = obj.Handle;
							local debounce = false;
							mouse.Button1Down:connect(function()
 								debounce = false;
								if (obj.Parent == character) then
									detect.Touched:connect(function(part)
										if not(debounce) then
											if (part.Parent:FindFirstChild("Humanoid")) then
												debounce = true;
													print(part);												
													remote:FireServer({"change"}, {{CurrentExp, "Value", tonumber(CurrentExp.Value + addExp)}});
											end;
										end;
									end);
								end;							
							end);
						end;
					end;
				end;		
			end;
			
			LightArmor = function(player, character)
				local remote = game.ReplicatedStorage.Master;
				local Module = require(game.ReplicatedStorage.misc);
				local Armors = script.Armors;
				local LArmor = Armors["Light Armor"];
				local Humanoid = character.Humanoid;
				local folder = player.Levels;
				local Level = folder.LightArmor;
				local CurrentExp = Level.Experience;
				------------------End of System Stuff----------------------------
				local cHealth = Humanoid.Health;
				local eMod = 0.1;
			-- Changed Event; 
				Humanoid.Changed:connect(function(Property)
					if (Property == "Health_XML") then -- Roblox Why you be so Annoying?
						local bool = cHealth > Humanoid.Health;
						local bool2 = Humanoid.Health > 0;
						local bool3 = Module:FindObject(LArmor:GetChildren(), "Name", character);
						if (bool) then
							if (bool2 and bool3) then
								local addExp = (cHealth - Humanoid.Health) * eMod;
								remote:FireServer({"change"}, {{CurrentExp, "Value", tonumber(CurrentExp.Value + addExp)}});
							end;
						end;
					end;
				end);				
			end;
			HeavyArmor = function(player, character)
				local remote = game.ReplicatedStorage.Master;
				local Module = require(game.ReplicatedStorage.misc);
				local Armors = script.Armors;
				local HArmor = Armors["Heavy  Armor"];
				local Humanoid = character.Humanoid;
				local folder = player.Levels;
				local Level = folder.HeavyArmor;
				local CurrentExp = Level.Experience;
				------------------End of System Stuff----------------------------
				local cHealth = Humanoid.Health;
				local eMod = 0.1;
			-- Changed Event; 
				Humanoid.Changed:connect(function(Property)
					if (Property == "Health_XML") then -- Roblox Why you be so Annoying?
						local bool = cHealth > Humanoid.Health;
						local bool2 = Humanoid.Health > 0;
						local bool3 = Module:FindObject(HArmor:GetChildren(), "Name", character);
						if (bool) then
							if (bool2 and bool3) then
								local addExp = (cHealth - Humanoid.Health) * eMod;
								remote:FireServer({"change"}, {{CurrentExp, "Value", tonumber(CurrentExp.Value + addExp)}});
							end;
						end;
					end;
				end);				
			end;
		};
		functions[skill](player, character);
	end;
	
return module
	 