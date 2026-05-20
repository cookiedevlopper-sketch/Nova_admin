--- protected by MIT License. all right reserved, Each copy will be punished by law.

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer
local mouse = player:GetMouse()
local camera = workspace.CurrentCamera
local char = player.Character or player.CharacterAdded:Wait()

--- Settings do not change
local OWNER = "SuPraa006"
local PREFIX = "/"
local VERSION = "1.4"
local ADMIN_NAME = "NOVA ADMIN"

local flying = false
local noclip = false
local speedValue = 16
local jumpValue = 50
local godmode = false
local espEnabled = false
local fullbrightEnabled = false
local originalAmbient = Lighting.Ambient
local originalBrightness = Lighting.Brightness
local espHighlights = {}
local infiniteJump = false
local clickTpEnabled = false
local orbiting = false
local orbitTarget = nil
local invisEnabled = false
local savedTransparencies = {}
local rainbowEnabled = false
local rainbowConn = nil
local frozenSelf = false
local frozenCFrame = nil
local loopKillEnabled = false
local loopKillTarget = nil
local loopKillConn = nil
local spinEnabled = false
local spinConn = nil
local spinSpeed = 5
local defaultFOV = 70
local antiAfkEnabled = false
local antiAfkConn = nil
local hitboxEnabled = false
local originalHitboxSizes = {}
local savedPositions = {}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NovaAdmin"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = player.PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 500, 0, 340)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -170)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(99, 102, 241)
Stroke.Thickness = 1.5
Stroke.Transparency = 0.3
Stroke.Parent = MainFrame

local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 45)
TitleBar.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = TitleBar

local TitleFix = Instance.new("Frame")
TitleFix.Size = UDim2.new(1, 0, 0, 10)
TitleFix.Position = UDim2.new(0, 0, 1, -10)
TitleFix.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
TitleFix.BorderSizePixel = 0
TitleFix.Parent = TitleBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -50, 1, 0)
TitleLabel.Position = UDim2.new(0, 15, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = " " .. ADMIN_NAME .. " v" .. VERSION
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 15
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TitleBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -40, 0, 7)
CloseBtn.BackgroundColor3 = Color3.fromRGB(239, 68, 68)
CloseBtn.Text = ""
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 13
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.BorderSizePixel = 0
CloseBtn.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
 MainFrame.Visible = false
end)

local CmdBox = Instance.new("TextBox")
CmdBox.Size = UDim2.new(1, -20, 0, 38)
CmdBox.Position = UDim2.new(0, 10, 0, 55)
CmdBox.BackgroundColor3 = Color3.fromRGB(22, 22, 35)
CmdBox.BorderSizePixel = 0
CmdBox.Text = ""
CmdBox.PlaceholderText = " /command args... (e.g. /speed 50)"
CmdBox.TextColor3 = Color3.fromRGB(200, 200, 220)
CmdBox.PlaceholderColor3 = Color3.fromRGB(80, 80, 100)
CmdBox.TextSize = 13
CmdBox.Font = Enum.Font.Gotham
CmdBox.TextXAlignment = Enum.TextXAlignment.Left
CmdBox.ClearTextOnFocus = false
CmdBox.Parent = MainFrame

local CmdCorner = Instance.new("UICorner")
CmdCorner.CornerRadius = UDim.new(0, 8)
CmdCorner.Parent = CmdBox

local CmdStroke = Instance.new("UIStroke")
CmdStroke.Color = Color3.fromRGB(99, 102, 241)
CmdStroke.Thickness = 1
CmdStroke.Parent = CmdBox

local LogFrame = Instance.new("ScrollingFrame")
LogFrame.Size = UDim2.new(1, -20, 0, 170)
LogFrame.Position = UDim2.new(0, 10, 0, 103)
LogFrame.BackgroundColor3 = Color3.fromRGB(16, 16, 24)
LogFrame.BorderSizePixel = 0
LogFrame.ScrollBarThickness = 3
LogFrame.ScrollBarImageColor3 = Color3.fromRGB(99, 102, 241)
LogFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
LogFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
LogFrame.Parent = MainFrame

local LogCorner = Instance.new("UICorner")
LogCorner.CornerRadius = UDim.new(0, 8)
LogCorner.Parent = LogFrame

local LogLayout = Instance.new("UIListLayout")
LogLayout.SortOrder = Enum.SortOrder.LayoutOrder
LogLayout.Padding = UDim.new(0, 2)
LogLayout.Parent = LogFrame

local LogPadding = Instance.new("UIPadding")
LogPadding.PaddingLeft = UDim.new(0, 8)
LogPadding.PaddingTop = UDim.new(0, 5)
LogPadding.Parent = LogFrame

local BottomBar = Instance.new("Frame")
BottomBar.Size = UDim2.new(1, 0, 0, 30)
BottomBar.Position = UDim2.new(0, 0, 1, -30)
BottomBar.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
BottomBar.BorderSizePixel = 0
BottomBar.Parent = MainFrame

local BottomCorner = Instance.new("UICorner")
BottomCorner.CornerRadius = UDim.new(0, 10)
BottomCorner.Parent = BottomBar

local BottomFix = Instance.new("Frame")
BottomFix.Size = UDim2.new(1, 0, 0, 10)
BottomFix.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
BottomFix.BorderSizePixel = 0
BottomFix.Parent = BottomBar

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, -10, 1, 0)
StatusLabel.Position = UDim2.new(0, 10, 0, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Prefix: / | Type /help for commands"
StatusLabel.TextColor3 = Color3.fromRGB(99, 102, 241)
StatusLabel.TextSize = 11
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.Parent = BottomBar

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 100, 0, 32)
ToggleBtn.Position = UDim2.new(0, 10, 1, -50)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(99, 102, 241)
ToggleBtn.Text = " NOVA"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize = 13
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.BorderSizePixel = 0
ToggleBtn.Parent = ScreenGui

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 8)
ToggleCorner.Parent = ToggleBtn

ToggleBtn.MouseButton1Click:Connect(function()
 MainFrame.Visible = not MainFrame.Visible
end)

local logColors = {
 info = Color3.fromRGB(147, 197, 253),
 success = Color3.fromRGB(134, 239, 172),
 error = Color3.fromRGB(252, 165, 165),
 warn = Color3.fromRGB(253, 224, 71),
 system = Color3.fromRGB(192, 132, 252),
}

local function log(msg, msgType)
 msgType = msgType or "info"
 local color = logColors[msgType] or logColors.info
 local label = Instance.new("TextLabel")
 label.Size = UDim2.new(1, -5, 0, 18)
 label.BackgroundTransparency = 1
 label.Text = msg
 label.TextColor3 = color
 label.TextSize = 12
 label.Font = Enum.Font.Gotham
 label.TextXAlignment = Enum.TextXAlignment.Left
 label.TextTruncate = Enum.TextTruncate.AtEnd
 label.Parent = LogFrame
 task.wait()
 LogFrame.CanvasPosition = Vector2.new(0, LogFrame.AbsoluteCanvasSize.Y)
end

local function notify(title, msg, color)
 color = color or Color3.fromRGB(99, 102, 241)
 local notif = Instance.new("Frame")
 notif.Size = UDim2.new(0, 260, 0, 60)
 notif.Position = UDim2.new(1, -270, 1, -80)
 notif.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
 notif.BorderSizePixel = 0
 notif.Parent = ScreenGui
 local nc = Instance.new("UICorner")
 nc.CornerRadius = UDim.new(0, 8)
 nc.Parent = notif
 local ns = Instance.new("UIStroke")
 ns.Color = color
 ns.Thickness = 1.5
 ns.Parent = notif
 local accent = Instance.new("Frame")
 accent.Size = UDim2.new(0, 4, 1, 0)
 accent.BackgroundColor3 = color
 accent.BorderSizePixel = 0
 accent.Parent = notif
 local ac2 = Instance.new("UICorner")
 ac2.CornerRadius = UDim.new(0, 4)
 ac2.Parent = accent
 local titleL = Instance.new("TextLabel")
 titleL.Size = UDim2.new(1, -15, 0, 25)
 titleL.Position = UDim2.new(0, 12, 0, 5)
 titleL.BackgroundTransparency = 1
 titleL.Text = title
 titleL.TextColor3 = Color3.fromRGB(255, 255, 255)
 titleL.TextSize = 13
 titleL.Font = Enum.Font.GothamBold
 titleL.TextXAlignment = Enum.TextXAlignment.Left
 titleL.Parent = notif
 local msgL = Instance.new("TextLabel")
 msgL.Size = UDim2.new(1, -15, 0, 20)
 msgL.Position = UDim2.new(0, 12, 0, 30)
 msgL.BackgroundTransparency = 1
 msgL.Text = tostring(msg)
 msgL.TextColor3 = Color3.fromRGB(180, 180, 200)
 msgL.TextSize = 11
 msgL.Font = Enum.Font.Gotham
 msgL.TextXAlignment = Enum.TextXAlignment.Left
 msgL.Parent = notif
 task.delay(3, function()
 TweenService:Create(notif, TweenInfo.new(0.5), {Position = UDim2.new(1, 10, 1, -80)}):Play()
 task.wait(0.5)
 notif:Destroy()
 end)
end

local function getPlayer(name)
 if name == "me" then return player end
 for _, p in ipairs(Players:GetPlayers()) do
 if p.Name:lower():find(name:lower()) then return p end
 end
 return nil
end

local function getChar(p) return p and p.Character end
local function getHRP(p) local c = getChar(p) return c and c:FindFirstChild("HumanoidRootPart") end
local function getHum(p) local c = getChar(p) return c and c:FindFirstChildOfClass("Humanoid") end

local flyBodyVelocity, flyBodyGyro
local function startFly()
 flying = true
 local c = player.Character
 local hrp2 = c and c:FindFirstChild("HumanoidRootPart")
 if not hrp2 then return end
 flyBodyVelocity = Instance.new("BodyVelocity")
 flyBodyVelocity.Velocity = Vector3.zero
 flyBodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
 flyBodyVelocity.Parent = hrp2
 flyBodyGyro = Instance.new("BodyGyro")
 flyBodyGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
 flyBodyGyro.D = 100
 flyBodyGyro.Parent = hrp2
 log("Flying enabled (WASD + Space/Shift to go up/down)", "success")
 notify("Fly", "Enabled", logColors.success)
 RunService.RenderStepped:Connect(function()
 if not flying then
 if flyBodyVelocity then flyBodyVelocity:Destroy() end
 if flyBodyGyro then flyBodyGyro:Destroy() end
 return
 end
 local dir = Vector3.zero
 local cf = camera.CFrame
 if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + cf.LookVector end
 if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - cf.LookVector end
 if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - cf.RightVector end
 if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + cf.RightVector end
 if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0, 1, 0) end
 if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then dir = dir - Vector3.new(0, 1, 0) end
 if flyBodyVelocity then flyBodyVelocity.Velocity = dir * speedValue * 2 end
 if flyBodyGyro then flyBodyGyro.CFrame = cf end
 end)
end

local function stopFly()
 flying = false
end

local noclipConn
local function startNoclip()
 noclip = true
 noclipConn = RunService.Stepped:Connect(function()
 if not noclip then noclipConn:Disconnect() return end
 local c = player.Character
 if c then
 for _, part in ipairs(c:GetDescendants()) do
 if part:IsA("BasePart") then part.CanCollide = false end
 end
 end
 end)
 log("Noclip enabled", "success")
 notify("Noclip", "Enabled", logColors.success)
end

local function stopNoclip()
 noclip = false
 if noclipConn then noclipConn:Disconnect() end
end

local function updateESP()
 for _, h in pairs(espHighlights) do
 if h and h.Parent then h:Destroy() end
 end
 espHighlights = {}
 if not espEnabled then return end
 for _, p in ipairs(Players:GetPlayers()) do
 if p ~= player and p.Character then
 local hl = Instance.new("SelectionBox")
 hl.Color3 = Color3.fromRGB(99, 102, 241)
 hl.LineThickness = 0.05
 hl.SurfaceTransparency = 0.8
 hl.SurfaceColor3 = Color3.fromRGB(99, 102, 241)
 hl.Adornee = p.Character
 hl.Parent = ScreenGui
 table.insert(espHighlights, hl)
 end
 end
end

local function setFullbright(on)
 fullbrightEnabled = on
 if on then
 Lighting.Ambient = Color3.fromRGB(255, 255, 255)
 Lighting.Brightness = 10
 Lighting.ClockTime = 14
 Lighting.FogEnd = 100000
 log("Fullbright enabled", "success")
 notify("Fullbright", "Enabled", logColors.success)
 else
 Lighting.Ambient = originalAmbient
 Lighting.Brightness = originalBrightness
 end
end

UserInputService.JumpRequest:Connect(function()
 if infiniteJump then
 local h = getHum(player)
 if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
 end
end)
