-- required
	repeat wait() until game.Players.LocalPlayer.Character;
	repeat wait() until game.Players.LocalPlayer:FindFirstChild("Levels");
	local skills = require(game.ReplicatedStorage.Skills);
	local player = game.Players.LocalPlayer;
	local character = player.Character;
	skills:SkillFunction("Athletics", player, character);
	skills:SkillFunction("Acrobatics", player, character);
	skills:SkillFunction("SwordFighting", player, character);