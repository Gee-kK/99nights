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

local function bringAll()
	for _, item : Model in game.Workspace.Items:GetChildren() do
		item:MoveTo(LocalPlayer.Character.HumanoidRootPart.Position + Vector3(0, 0, 5))
	end
end


TextChatService.SendingMessage:Connect(function(ChatMessage)
	local msg = ChatMessage.Text
	if msg == "load map" then
		loadMap()
	elseif msg == "bring all" then
		bringAll()
	end
end)

local SVersion = 4
game:GetService("StarterGui"):SetCore("SendNotification",{
	Title = "99 Nights Script Loaded", -- Required
	Text = "Version: ".. SVersion -- Required
})
