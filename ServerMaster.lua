local master = Instance.new("RemoteEvent", game.ReplicatedStorage);
master.Name = "Master";
master.OnServerEvent:connect(function(player, requests, data) 
	local functions = {
		change = function(data2)
			local instance = data2[1];
			local property = data2[2];
			local value = data2[3];
			instance[property] = value;
		end;
	};
	for num, item in next, requests do
		functions[item](data[num]);
	end;
end);