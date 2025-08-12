local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function loadMap()
	for _, fog in game.Workspace.Map.Boundaries:GetChildren() do
		if not fog:IsA("BasePart") then continue end
		LocalPlayer.Character.HumanoidRootPart.CFrame = fog.CFrame + Vector3(0, 10, 0)
	end
end

