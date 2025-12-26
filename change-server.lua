--// SNAXX GUI - DELTA EXECUTOR
--// Autor: ChatGPT

-- Servicios
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local placeId = game.PlaceId

-- ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "SnaxxGui"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Marco principal
local main = Instance.new("Frame")
main.Parent = gui
main.Size = UDim2.new(0, 420, 0, 200)
main.Position = UDim2.new(0.5, -210, 0.5, -100)
main.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
main.BackgroundTransparency = 0.35
main.Active = true
main.Draggable = true

-- Bordes redondos
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 22)
corner.Parent = main

-- Borde gamer
local stroke = Instance.new("UIStroke")
stroke.Thickness = 3
stroke.Parent = main

-- Gradiente rojo / blanco / negro
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255,0,0)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255,255,255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(0,0,0))
}
gradient.Parent = stroke

-- Animación del borde
task.spawn(function()
	while true do
		local tween = TweenService:Create(
			gradient,
			TweenInfo.new(3, Enum.EasingStyle.Linear),
			{Rotation = gradient.Rotation + 360}
		)
		tween:Play()
		tween.Completed:Wait()
	end
end)

-- Título
local title = Instance.new("TextLabel")
title.Parent = main
title.Text = "Snaxx"
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.TextColor3 = Color3.fromRGB(255,255,255)
title.BackgroundTransparency = 1
title.Position = UDim2.new(0, 16, 0, 10)
title.Size = UDim2.new(0, 200, 0, 30)
title.TextXAlignment = Enum.TextXAlignment.Left

-- Botón X (Cerrar GUI)
local closeBtn = Instance.new("TextButton")
closeBtn.Parent = main
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -40, 0, 10)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18
closeBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
closeBtn.BackgroundTransparency = 1
closeBtn.AutoButtonColor = false

-- Botón Teleport (ÚNICO)
local bar1 = Instance.new("TextButton")
bar1.Parent = main
bar1.Size = UDim2.new(0.9, 0, 0, 38)
bar1.Position = UDim2.new(0.05, 0, 0.45, 0)
bar1.BackgroundColor3 = Color3.fromRGB(20,20,20)
bar1.BackgroundTransparency = 0.15
bar1.Text = "Cambiar de Servidor"
bar1.Font = Enum.Font.Gotham
bar1.TextSize = 15
bar1.TextColor3 = Color3.fromRGB(255,255,255)
bar1.AutoButtonColor = false

local c1 = Instance.new("UICorner")
c1.CornerRadius = UDim.new(1, 0)
c1.Parent = bar1

-- Hover effect
bar1.MouseEnter:Connect(function()
	bar1.BackgroundColor3 = Color3.fromRGB(35,35,35)
end)

bar1.MouseLeave:Connect(function()
	bar1.BackgroundColor3 = Color3.fromRGB(20,20,20)
end)

------------------------------------------------
-- FUNCIÓN TELEPORT A OTRO SERVIDOR
------------------------------------------------
local function TeleportToServer()
	local servers = {}
	local cursor = ""

	local success, result = pcall(function()
		return HttpService:JSONDecode(
			game:HttpGet(
				"https://games.roblox.com/v1/games/"
				.. placeId ..
				"/servers/Public?sortOrder=Asc&limit=100&cursor="
				.. cursor
			)
		)
	end)

	if success and result and result.data then
		for _, server in ipairs(result.data) do
			if server.playing < server.maxPlayers and server.id ~= game.JobId then
				table.insert(servers, server.id)
			end
		end
	end

	if #servers > 0 then
		TeleportService:TeleportToPlaceInstance(
			placeId,
			servers[math.random(1, #servers)],
			player
		)
	else
		warn("No hay servidores disponibles.")
	end
end

-- Conexiones
bar1.MouseButton1Click:Connect(TeleportToServer)

closeBtn.MouseButton1Click:Connect(function()
	gui:Destroy()
end)
