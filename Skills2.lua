local module = {}
	function module:GetSkills()	
		local validSkills = {"Athletics", "Acrobatics"};
		local defaultLevel = {1, 1,};
		local defaultExp = {0, 0};
		local defaultExpNeeded = {100, 100};
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
							local currentTime = tick();
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
		};
		functions[skill](player, character);
	end;
	
return module
	 