-- ReplicatedStorage
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
					character.Humanoid.Swimming:connect(function()
						-- Assumes roblox water because, yeah.
						local oldTime = math.floor(tick());
						while character.Humanoid.Swimming.connected do wait() end;
						local currentTime = math.floor(tick());
						local difference = currentTime - oldTime;
						local addExp = difference * SwimmingExpGain;
						remote:FireServer({"change"}, {{CurrentExp, "Value", tonumber(CurrentExp.Value) + addExp}});
					end);
					
				-- Walking
					character.Humanoid.Running:connect(function(speed)
						if not(shiftKey) then
							local oldTime = math.floor(tick());
							while speed > 0 do print(speed) wait() end;
							local currentTime = math.floor(tick());
							local difference = currentTime - oldTime;
							local addExp = difference * WalkingExpGain;
							remote:FireServer({"change"}, {{CurrentExp, "Value", tonumber(CurrentExp.Value) + addExp}});
						else						
						end;
					end);
				
			end;
		};
		functions[skill](player, character);
	end;
	
return module