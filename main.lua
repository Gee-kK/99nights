local TextChatService = game:GetService("TextChatService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function loadMap()
	for _, fog in game.Workspace.Map.Boundaries:GetChildren() do
		if fog:IsA("BasePart") then
			LocalPlayer.Character.HumanoidRootPart.CFrame = fog.CFrame
		else
			continue
		end
		task.wait(.25)
	end
end


TextChatService.SendingMessage:Connect(function(ChatMessage)
	local msg = ChatMessage.Text
	if msg == "load map" then
		loadMap()
	end
end)

local SVersion = 3
game:GetService("StarterGui"):SetCore("SendNotification",{
	Title = "99 Nights Script Loaded", -- Required
	Text = "Version: ".. SVersion -- Required
})
