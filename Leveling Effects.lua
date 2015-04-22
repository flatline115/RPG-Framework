game.Players.PlayerAdded:connect(function(player)
	repeat wait(1) until player:FindFirstChild("Levels");
	local folder = player.Levels;
	local functions = {
		Athletics = function(amount)
			player.Character.Humanoid.WalkSpeed = player.Character.Humanoid.WalkSpeed + amount;
		end;
	};
	for _, object in next, folder:GetChildren() do
		local currentVal = object.Value;
		if (object.Value > 0) then 
			functions[object.Name](object.Value * 2);
		end;	
		object.Changed:connect(function(property)
			if (property == "Value") then
				if not(object.Value == currentVal) then
					functions[object.Name](2);
				end;
			end;
		end);
	end;
end);