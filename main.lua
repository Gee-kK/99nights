local TextChatService = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local bagable = {
	Carrot = true,
	Corn = true,
	Pumpkin = true,
	Berry = true,
	Apple = true,
	Morsel = true,
	Steak = true,
	Ribs = true,
	["Cooked Morsel"] = true,
	["Cooked Steak"] = true,
	["Cooked Ribs"] = true,
	Cake = true,
	Chili = true,
	["Meat? Sandwich"] = true,
	["Chili Seeds"] = true,
	["Flower Seeds"] = true,
	["Berry Seeds"] = true,
	["Firefly Seeds"] = true,
	Log = true,
	Chair = true,
	Biofuel = true,
	Coal = true,
	["Fuel Canister"] = true,
	["Oil Barrel"] = true,
	Bolt = true,
	["Sheet Metal"] = true,
	["UFO Junk"] = true,
	["UFO Component"] = true,
	["Broken Fan"] = true,
	["Broken Radio"] = true,
	["Broken Microwave"] = true,
	Tyre = true,
	["Metal Chair"] = true,
	["Old Car Engine"] = true,
	["Washing Machine"] = true,
	["Cultist Experiment"] = true,
	["Cultist Prototype"] = true,
	["UFO Scrap"] = true,
	["Bunny Foot"] = true,
	["Wolf Pelt"] = true,
	["Alpha Wolf Pelt"] = true,
	["Bear Pelt"] = true,
	["Arctic Fox Pelt"] = true,
	["Polar Bear Pelt"] = true,
	Feather = true,
	["Cultist Gem"] = true
}


local sack = nil
local function findSack()
	for _, item in pairs(LocalPlayer.Inventory:GetChildren()) do
		if string.find(item.Name, "Sack") then
			return item
		end
	end
	
	return nil
end

sack = findSack()

local function isSackFull()
	if not sack then return true end
	local amount = #LocalPlayer.ItemBag:GetChildren()
	local capacity = sack:GetAttribute("Capacity")
	return amount ~= nil and capacity ~= nil and amount >= capacity	
end

local function store(item)
	if not sack then return end
	local part = item:FindFirstChildWhichIsA("BasePart")
	if part then
		LocalPlayer.Character.HumanoidRootPart.CFrame = part.CFrame + Vector3.new(0, 1, 0)
		task.wait(.25)
		local res = ReplicatedStorage.RemoteEvents.RequestBagStoreItem:InvokeServer(sack, item)
		for _, d in res do
			print(d)
		end
		task.wait(.3)
		
	end
end


local function loadMap()
	local originalPos = LocalPlayer.Character.HumanoidRootPart.CFrame
	
	for _, fog in game.Workspace.Map.Boundaries:GetChildren() do
		if fog:IsA("BasePart") then
			LocalPlayer.Character.HumanoidRootPart.CFrame = fog.CFrame
		else
			continue
		end
		task.wait(.25)
	end
	
	LocalPlayer.Character.HumanoidRootPart.CFrame = originalPos
end

local function bringAll()
	local originalPos = LocalPlayer.Character.HumanoidRootPart.CFrame
	for _, item : Model in game.Workspace.Items:GetChildren() do
		if not bagable[item.Name] then continue end
		if isSackFull() then
			LocalPlayer.Character.HumanoidRootPart.CFrame = originalPos
			task.wait(.75)
			for _, c in LocalPlayer.ItemBag:GetChildren() do
				ReplicatedStorage.RemoteEvents.RequestBagDropItem:FireServer(sack, c)
				task.wait(.25)
			end
			task.wait(.75)
		end
		store(item)
		task.wait(1)
	end
end


local function bring(item: string)
	local originalPos = LocalPlayer.Character.HumanoidRootPart.CFrame
	for _, object in ipairs(game.Workspace.Items:GetChildren()) do
		if object.Name:lower() ~= item:lower() then continue end
		if isSackFull() then
			LocalPlayer.Character.HumanoidRootPart.CFrame = originalPos
			task.wait(.1)
			for _, c in LocalPlayer.ItemBag:GetChildren() do
				ReplicatedStorage.RemoteEvents.RequestBagDropItem:FireServer(sack, c)
				task.wait(.25)
			end
		end
		store(object)
		task.wait(1)
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

local SVersion = 11
game:GetService("StarterGui"):SetCore("SendNotification",{
	Title = "99 Nights Script Loaded", -- Required
	Text = "Version: ".. SVersion -- Required
})
