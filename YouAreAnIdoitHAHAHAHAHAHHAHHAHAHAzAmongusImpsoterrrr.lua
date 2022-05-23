function MainScript()
	local mt = getrawmetatable(game)
	local old = mt.__namecall
	local protect = newcclosure or protect_function

	if not protect then
		protect = function(f) return f end
	end

	setreadonly(mt, false)
	mt.__namecall = protect(function(self, ...)
		local method = getnamecallmethod()
		if method == "Kick" then
			wait(9e9)
			return
		end
		return old(self, ...)
	end)
	hookfunction(game:GetService("Players").LocalPlayer.Kick,protect(function() wait(9e9) end))

	shared.VapeIndependent = true
	shared.CustomSaveVape = "name of file to save"
	local uilib = loadstring(game:HttpGet("https://raw.githubusercontent.com/ZoDuxDev/BoogaVapeV4/main/NewMainScript.lua", true))()
	local GuiLibrary = shared.GuiLibrary

	require(game.ReplicatedStorage.Modules.Client_Function_Bank).CreateNotification("V1.01", Color3.fromRGB(255, 255, 255), 10)
	require(game.ReplicatedStorage.Modules.Client_Function_Bank).CreateNotification("released on github", Color3.fromRGB(255, 255, 255), 8)

	local Combat = uilib["ObjectsThatCanBeSaved"]["CombatWindow"]["Api"]
	local Blatant = uilib["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"]
	local Render = uilib["ObjectsThatCanBeSaved"]["RenderWindow"]["Api"]
	local Utility = uilib["ObjectsThatCanBeSaved"]["UtilityWindow"]["Api"]
	local World = uilib["ObjectsThatCanBeSaved"]["WorldWindow"]["Api"]

	local players = game:GetService("Players")
	local textservice = game:GetService("TextService")
	local lplr = players.LocalPlayer
	local workspace = game:GetService("Workspace")
	local lighting = game:GetService("Lighting")
	local cam = workspace.CurrentCamera

	shared.vapeteamcheck = function(plr)
		return (GuiLibrary["ObjectsThatCanBeSaved"]["Teams by colorToggle"]["Api"]["Enabled"] and (plr.Team ~= lplr.Team or (lplr.Team == nil or #lplr.Team:GetPlayers() == #game:GetService("Players"):GetChildren())) or GuiLibrary["ObjectsThatCanBeSaved"]["Teams by colorToggle"]["Api"]["Enabled"] == false)
	end

	local healthColorToPosition = {
		[Vector3.new(Color3.fromRGB(255, 28, 0).r,
			Color3.fromRGB(255, 28, 0).g,
			Color3.fromRGB(255, 28, 0).b)] = 0.1;
		[Vector3.new(Color3.fromRGB(250, 235, 0).r,
			Color3.fromRGB(250, 235, 0).g,
			Color3.fromRGB(250, 235, 0).b)] = 0.5;
		[Vector3.new(Color3.fromRGB(27, 252, 107).r,
			Color3.fromRGB(27, 252, 107).g,
			Color3.fromRGB(27, 252, 107).b)] = 0.8;
	}
	local min = 0.1
	local minColor = Color3.fromRGB(255, 28, 0)
	local max = 0.8
	local maxColor = Color3.fromRGB(27, 252, 107)

	local TribeColors = {}
	TribeColors.Red = Color3.fromRGB(230, 25, 75)
	TribeColors.Green = Color3.fromRGB(60, 180, 75)
	TribeColors.Yellow = Color3.fromRGB(255, 225, 25)
	TribeColors.Blue = Color3.fromRGB(0, 130, 200)
	TribeColors.Orange = Color3.fromRGB(245, 130, 48)
	TribeColors.Purple = Color3.fromRGB(146, 30, 180)
	TribeColors.Cyan = Color3.fromRGB(70, 240, 240)
	TribeColors.Magenta = Color3.fromRGB(240, 50, 230)
	TribeColors.Pink = Color3.fromRGB(250, 190, 190)
	TribeColors.Teal = Color3.fromRGB(0, 128, 128)
	TribeColors.Lavender = Color3.fromRGB(230, 190, 255)
	TribeColors.Beige = Color3.fromRGB(255, 250, 200)
	TribeColors.Maroon = Color3.fromRGB(128, 0, 0)
	TribeColors.Mint = Color3.fromRGB(170, 255, 195)
	TribeColors.Olive = Color3.fromRGB(130, 130, 0)
	TribeColors.Apricot = Color3.fromRGB(255, 215, 180)
	TribeColors.Navy = Color3.fromRGB(0, 0, 128)
	TribeColors.Grey = Color3.fromRGB(128, 128, 128)
	TribeColors.White = Color3.fromRGB(255, 255, 255)
	TribeColors.Black = Color3.fromRGB(0, 0, 0)

	local PlayerTribe

	for i,v in pairs(TribeColors) do
		if game.Players.LocalPlayer.Character.NameGui.TextLabel.TextColor3 == v then
			print("Player is in "..i.." tribe")
			PlayerTribe = v
		end
	end

	function UpdateTribe()
		for i,v in pairs(TribeColors) do
			if game.Players.LocalPlayer.Character.NameGui.TextLabel.TextColor3 == v then
				print("Player is in "..i.." tribe")
				PlayerTribe = v
			end
		end
	end

	local RenderStepTable = {}
	local StepTable = {}

	local function BindToRenderStep(name, num, func)
		if RenderStepTable[name] == nil then
			RenderStepTable[name] = game:GetService("RunService").RenderStepped:connect(func)
		end
	end
	local function UnbindFromRenderStep(name)
		if RenderStepTable[name] then
			RenderStepTable[name]:Disconnect()
			RenderStepTable[name] = nil
		end
	end

	local function BindToStepped(name, num, func)
		if StepTable[name] == nil then
			StepTable[name] = game:GetService("RunService").Stepped:connect(func)
		end
	end
	local function UnbindFromStepped(name)
		if StepTable[name] then
			StepTable[name]:Disconnect()
			StepTable[name] = nil
		end
	end
	local function runcode(func)
		func()
	end


	local function isAlive(plr)
		if plr then
			return plr and plr.Character and plr.Character.Parent ~= nil and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Head") and plr.Character:FindFirstChild("Humanoid")
		end
		return lplr and lplr.Character and lplr.Character.Parent ~= nil and lplr.Character:FindFirstChild("HumanoidRootPart") and lplr.Character:FindFirstChild("Head") and lplr.Character:FindFirstChild("Humanoid")
	end

	local function CalculateObjectPosition(pos)
		local newpos = cam:WorldToViewportPoint(cam.CFrame:pointToWorldSpace(cam.CFrame:pointToObjectSpace(pos)))
		return Vector2.new(newpos.X, newpos.Y)
	end

	local function CalculateLine(startVector, endVector, obj)
		local Distance = (startVector - endVector).Magnitude
		obj.Size = UDim2.new(0, Distance, 0, 2)
		obj.Position = UDim2.new(0, (startVector.X + endVector.X) / 2, 0, ((startVector.Y + endVector.Y) / 2) - 36)
		obj.Rotation = math.atan2(endVector.Y - startVector.Y, endVector.X - startVector.X) * (180 / math.pi)
	end

	local function HealthbarColorTransferFunction(healthPercent)
		if healthPercent < min then
			return minColor
		elseif healthPercent > max then
			return maxColor
		end


		local numeratorSum = Vector3.new(0,0,0)
		local denominatorSum = 0
		for colorSampleValue, samplePoint in pairs(healthColorToPosition) do
			local distance = healthPercent - samplePoint
			if distance == 0 then

				return Color3.new(colorSampleValue.x, colorSampleValue.y, colorSampleValue.z)
			else
				local wi = 1 / (distance*distance)
				numeratorSum = numeratorSum + wi * colorSampleValue
				denominatorSum = denominatorSum + wi
			end
		end
		local result = numeratorSum / denominatorSum
		return Color3.new(result.x, result.y, result.z)
	end

	local function createwarning(title, text, delay)
		pcall(function()
			local frame = GuiLibrary["CreateNotification"](title, text, delay, "assets/WarningNotification.png")
			frame.Frame.BackgroundColor3 = Color3.fromRGB(236, 129, 44)
			frame.Frame.Frame.BackgroundColor3 = Color3.fromRGB(236, 129, 44)
		end)
	end

	local function runcode(func)
		func()
	end


	local function friendCheck(plr, recolor)
		if GuiLibrary["ObjectsThatCanBeSaved"]["Use FriendsToggle"]["Api"]["Enabled"] then
			local friend = (table.find(GuiLibrary["ObjectsThatCanBeSaved"]["FriendsListTextCircleList"]["Api"]["ObjectList"], plr.Name) and GuiLibrary["ObjectsThatCanBeSaved"]["FriendsListTextCircleList"]["Api"]["ObjectListEnabled"][table.find(GuiLibrary["ObjectsThatCanBeSaved"]["FriendsListTextCircleList"]["Api"]["ObjectList"], plr.Name)] and true or nil)
			if recolor then
				return (friend and GuiLibrary["ObjectsThatCanBeSaved"]["Recolor visualsToggle"]["Api"]["Enabled"] and true or nil)
			else
				return friend
			end
		end
		return nil
	end


	local function getPlayerColor(plr)
		return (friendCheck(plr, true) and Color3.fromHSV(GuiLibrary["ObjectsThatCanBeSaved"]["Friends ColorSliderColor"]["Api"]["Hue"], GuiLibrary["ObjectsThatCanBeSaved"]["Friends ColorSliderColor"]["Api"]["Sat"], GuiLibrary["ObjectsThatCanBeSaved"]["Friends ColorSliderColor"]["Api"]["Value"]) or tostring(plr.TeamColor) ~= "White" and plr.TeamColor.Color)
	end

	runcode(function()
		local KillAura = {["Enabled"] = false}
		local TeamCheck = {["Value"] = false}
		local KillAuraRange = {["Value"] = 5}
		KillAura = GuiLibrary["ObjectsThatCanBeSaved"]["CombatWindow"]["Api"].CreateOptionsButton({
			["Name"] = "KillAura",
			["Function"] = function(callback)
				if callback then
					while wait(0.5) and KillAura.Enabled == true do
						for i,v in pairs(game.Players:GetChildren()) do
							local char = game.Workspace.Characters:FindFirstChild(game.Players.LocalPlayer.Name)
							if TeamCheck.Enabled then
								if char.HumanoidRootPart and v.Name ~= game.Players.LocalPlayer.Name then
									for i,v in pairs(TribeColors) do
										if char.NameGui.TextLabel.TextColor3 ~= game.Players.LocalPlayer.Character.NameGui.TextLabel.TextColor3 then
											if (char.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).magnitude < KillAuraRange.Value then
												if GuiLibrary["MainGui"].ScaledGui.ClickGui.Visible == false then
													mouse1click() 
												end
											end
										end
									end
								end
							else
								if char.HumanoidRootPart and v.Name ~= game.Players.LocalPlayer.Name then
									if (char.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).magnitude < KillAuraRange.Value then
										if GuiLibrary["MainGui"].ScaledGui.ClickGui.Visible == false then
											mouse1click() 
										end
									end
								end
							end
						end
					end
				else
				end
			end,
			["HoverText"] = "Kills people in your radius",
			["Default"] = false,
			["ExtraText"] = function() return " " end
		})

		KillAuraRange = KillAura.CreateSlider({
			["Name"] = "Distance",
			["Min"] = 1,
			["Max"] = 10,
			["Function"] = function(val)
			end,
			["HoverText"] = "changes the range of the kill aura",
			["Default"] = 5
		})
		TeamCheck = KillAura.CreateToggle({
			["Name"] = "Teamcheck", 
			["Function"] = function() end,
			["Default"] = false
		})
		 
	end)
	runcode(function()
		local AutoHeal = {["Enabled"] = false}
		local HealthMustBe = {["Value"] = 70}
		local AutoHealItem = {["Value"] = ""}
		AutoHeal = GuiLibrary["ObjectsThatCanBeSaved"]["CombatWindow"]["Api"].CreateOptionsButton({
			["Name"] = "AutoHeal",
			["Function"] = function(callback)
				if callback then
					local char = game.Workspace.Characters:FindFirstChild(game.Players.LocalPlayer.Name)
					while game:GetService("RunService").Heartbeat:Wait()and AutoHeal.Enabled == true do
						if char.Humanoid.Health <= HealthMustBe.Value then
							game:GetService("ReplicatedStorage").Events.UseBagItem:FireServer(AutoHealItem.Value)
						end
					end
				else
				end
			end,
			["HoverText"] = "Heals yourself and you need to choose the item you want to eat",
			["Default"] = false,
			["ExtraText"] = function() return " " end
		})

		HealthMustBe = AutoHeal.CreateSlider({
			["Name"] = "Health Check",
			["Min"] = 1,
			["Max"] = 99,
			["Function"] = function(val)
			end,
			["HoverText"] = "Checks your health",
			["Default"] = 70
		})
		AutoHealItem = AutoHeal.CreateTextBox({
			["Name"] = "Item",
			["TempText"] = "Item Name",
			["HoverText"] = "the item you want to heal"
		})
		 
	end)

	runcode(function()
		local TeleportKill = {["Enabled"] = false}
		local KillName = {["Value"] = ""}
		TeleportKill = GuiLibrary["ObjectsThatCanBeSaved"]["CombatWindow"]["Api"].CreateOptionsButton({
			["Name"] = "Teleport Kill",
			["Function"] = function(callback)
				if callback then
					local char = game.Workspace.Characters:FindFirstChild(game.Players.LocalPlayer.Name)
					local hum = char:FindFirstChild("HumanoidRootPart")
					while game:GetService("RunService").Heartbeat:Wait() and TeleportKill.Enabled == true do
						local enemyHum = game.Players:FindFirstChild(KillName.Value).Character.HumanoidRootPart
						hum.CFrame = CFrame.new(enemyHum.Position - enemyHum.CFrame.lookVector * 3.2)
					end
				else
				end
			end,
			["HoverText"] = "Teleport to your enemy you want to kill",
			["Default"] = false,
			["ExtraText"] = function() return " " end
		})
		KillName = TeleportKill.CreateTextBox({
			["Name"] = "Player Name",
			["TempText"] = "Player Name",
			["HoverText"] = "player name"
		})
		 
	end)

	runcode(function()
		local phase = {["Enabled"] = false}
		local spidergoinup = false
		local holdingshift = false
		local phasemode = {["Value"] = "Normal"}
		local phaselimit = {["Value"] = 1}
		local phaseparts = {}

		phase = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
			["Name"] = "Phase", 
			["Function"] = function(callback)
				if callback then
					BindToStepped("Phase", 1, function()
						if isAlive(game.Players.LocalPlayer) then
							if phasemode["Value"] == "Normal" then
								for i, part in pairs(lplr.Character:GetDescendants()) do
									if part:IsA("BasePart") and part.CanCollide == true then
										phaseparts[part] = true
										part.CanCollide = (false and (not holdingshift))
									end
								end
							else
								local chars = {}
								for i,v in pairs(players:GetChildren()) do
									table.insert(chars, v.Character)
								end
								local pos = game.Players.LocalPlayer.character.HumanoidRootPart.CFrame.p - Vector3.new(0, 1, 0)
								local pos2 = game.Players.LocalPlayer.character.HumanoidRootPart.CFrame.p + Vector3.new(0, 1, 0)
								local pos3 = game.Players.LocalPlayer.character.Head.CFrame.p
								local raycastparameters = RaycastParams.new()
								raycastparameters.FilterDescendantsInstances = chars
								raycastparameters.FilterType = Enum.RaycastFilterType.Blacklist
								local newray = workspace:Raycast(pos3, game.Players.LocalPlayer.character.Humanoid.MoveDirection, raycastparameters)
								if newray and not holdingshift then
									local dir = newray.Normal.Z ~= 0 and "Z" or "X"
									if newray.Instance.Size[dir] <= phaselimit["Value"] and newray.Instance.CanCollide then
										game.Players.LocalPlayer.character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.character.HumanoidRootPart.CFrame + (newray.Normal * (-(newray.Instance.Size[dir]) - 2))
									end
							--[[if isPointInMapOccupied(getScaffold(pos, false) + (newray.Normal * -6)) and isPointInMapOccupied(getScaffold(pos2, false) + (newray.Normal * -6)) then
								phasedelay = tick() + 0.075
								phasedelay2 = tick() + 0.1
								slowdownspeed = true
								nocheck = true
								game.Players.LocalPlayer.character.HumanoidRootPart.CFrame = addvectortocframe(game.Players.LocalPlayer.character.HumanoidRootPart.CFrame, (newray.Normal * -2.5))
							end]]
								end
							end
						end
					end)
				else
					UnbindFromStepped("Phase")
					for i,v in pairs(phaseparts) do
						if i then
							i.CanCollide = true
						end
					end
					table.clear(phaseparts)
				end
			end,
			["HoverText"] = "Lets you Phase/Clip through walls. (Hold shift to use phase over spider)"
		})
		phasemode = phase.CreateDropdown({
			["Name"] = "Mode",
			["List"] = {"Normal", "AntiCheat"},
			["Function"] = function(val) 
				if phaselimit["Object"] then
					phaselimit["Object"].Visible = val == "AntiCheat"
				end
			end
		})
		phaselimit = phase.CreateSlider({
			["Name"] = "Studs",
			["Function"] = function() end,
			["Min"] = 1,
			["Max"] = 20,
			["Default"] = 5,
		})
		phaselimit["Object"].Visible = phasemode["Value"] == "AntiCheat"
		 
	end)

	runcode(function()
		local HighJumpMethod = {["Value"] = "Toggle"}
		local HighJumpBoost = {["Value"] = 1}
		local HighJumpDelay = {["Value"] = 20}
		local HighJumpTick = tick()
		local highjumpbound = true
		local HighJump = {["Enabled"] = false}
		local uis = game:GetService("UserInputService")
		HighJump = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
			["Name"] = "HighJump", 
			["Function"] = function(callback)
				if callback then
					highjumpbound = false
					if HighJumpMethod["Value"] == "Toggle" then
						if HighJumpTick > tick()  then
							createwarning("LongJump", "Wait "..math.round(HighJumpTick - tick()).." before retoggling.", 1)
						end
						if HighJumpTick <= tick() and isAlive(game.Players.LocalPlayer) and (game.Players.LocalPlayer.character.Humanoid:GetState() == Enum.HumanoidStateType.Running or game.Players.LocalPlayer.character.Humanoid:GetState() == Enum.HumanoidStateType.RunningNoPhysics) then
							HighJumpTick = tick() + (HighJumpDelay["Value"] / 10)
							game.Players.LocalPlayer.character.HumanoidRootPart.Velocity = Vector3.new(0, HighJumpBoost["Value"], 0)
						end
						HighJump["ToggleButton"](false)
					else
						highjumpbound = true
						BindToRenderStep("HighJump", 1, function()
							if HighJumpTick <= tick() and isAlive(game.Players.LocalPlayer) and (game.Players.LocalPlayer.character.Humanoid:GetState() == Enum.HumanoidStateType.Running or game.Players.LocalPlayer.character.Humanoid:GetState() == Enum.HumanoidStateType.RunningNoPhysics) and uis:IsKeyDown(Enum.KeyCode.Space) then
								HighJumpTick = tick() + (HighJumpDelay["Value"] / 10)
								game.Players.LocalPlayer.character.HumanoidRootPart.Velocity = Vector3.new(0, HighJumpBoost["Value"], 0)
							end
						end)
					end
				else
					if highjumpbound then
						UnbindFromRenderStep("HighJump")
					end
				end
			end,
			["HoverText"] = "Lets you jump higher"
		})
		HighJumpMethod = HighJump.CreateDropdown({
			["Name"] = "Mode", 
			["List"] = {"Toggle", "Normal"},
			["Function"] = function(val) end
		})
		HighJumpBoost = HighJump.CreateSlider({
			["Name"] = "Boost",
			["Min"] = 1,
			["Max"] = 150, 
			["Function"] = function(val) end,
			["Default"] = 100
		})
		HighJumpDelay = HighJump.CreateSlider({
			["Name"] = "Delay",
			["Min"] = 0,
			["Max"] = 50, 
			["Function"] = function(val) end,
		})
		 
	end)

	runcode(function()
		 
		local ESPFolder = Instance.new("Folder")
		ESPFolder.Name = "ESPFolder"
		ESPFolder.Parent = GuiLibrary["MainGui"]
		local espfolderdrawing = {}
		players.PlayerRemoving:connect(function(plr)
			if ESPFolder:FindFirstChild(plr.Name) then
				ESPFolder[plr.Name]:Remove()
			end
			if espfolderdrawing[plr.Name] then
				pcall(function()
					pcall(function()
						espfolderdrawing[plr.Name].Quad1:Remove()
						espfolderdrawing[plr.Name].Quad2:Remove()
						espfolderdrawing[plr.Name].Quad3:Remove()
						espfolderdrawing[plr.Name].Quad4:Remove()
					end)
					pcall(function()
						espfolderdrawing[plr.Name].Head:Remove()
						espfolderdrawing[plr.Name].Head2:Remove()
						espfolderdrawing[plr.Name].Torso:Remove()
						espfolderdrawing[plr.Name].Torso2:Remove()
						espfolderdrawing[plr.Name].Torso3:Remove()
						espfolderdrawing[plr.Name].LeftArm:Remove()
						espfolderdrawing[plr.Name].RightArm:Remove()
						espfolderdrawing[plr.Name].LeftLeg:Remove()
						espfolderdrawing[plr.Name].RightLeg:Remove()
					end)
					espfolderdrawing[plr.Name] = nil
				end)
			end
		end)

		local function floorpos(pos)
			return Vector2.new(math.floor(pos.X), math.floor(pos.Y))
		end

		local ESPColor = {["Value"] = 0.44}
		local ESPHealthBar = {["Enabled"] = false}
		local ESPMethod = {["Value"] = "2D"}
		local ESPDrawing = {["Enabled"] = false}
		local ESPTeammates = {["Enabled"] = true}
		local ESP = GuiLibrary["ObjectsThatCanBeSaved"]["RenderWindow"]["Api"].CreateOptionsButton({
			["Name"] = "ESP", 
			["Function"] = function(callback) 
				if callback then
					BindToRenderStep("ESP", 500, function()
						for i,plr in pairs(players:GetChildren()) do
							local thing
							if ESPDrawing["Enabled"] then 
								if ESPMethod["Value"] == "2D" then
									if espfolderdrawing[plr.Name] then
										thing = espfolderdrawing[plr.Name]
										thing.Quad1.Visible = false
										thing.Quad1.Color = getPlayerColor(plr) or Color3.fromHSV(ESPColor["Hue"], ESPColor["Sat"], ESPColor["Value"])
										thing.Quad2.Visible = false
										thing.Quad3.Visible = false
										thing.Quad4.Visible = false
									else
										espfolderdrawing[plr.Name] = {}
										espfolderdrawing[plr.Name].Quad1 = Drawing.new("Quad")
										espfolderdrawing[plr.Name].Quad1.Thickness = 1
										espfolderdrawing[plr.Name].Quad1.ZIndex = 2
										espfolderdrawing[plr.Name].Quad1.Color = Color3.new(1, 1, 1)
										espfolderdrawing[plr.Name].Quad2 = Drawing.new("Quad")
										espfolderdrawing[plr.Name].Quad2.Thickness = 2
										espfolderdrawing[plr.Name].Quad2.ZIndex = 1
										espfolderdrawing[plr.Name].Quad2.Color = Color3.new(0, 0, 0)
										espfolderdrawing[plr.Name].Quad3 = Drawing.new("Line")
										espfolderdrawing[plr.Name].Quad3.Thickness = 1
										espfolderdrawing[plr.Name].Quad3.ZIndex = 2
										espfolderdrawing[plr.Name].Quad3.Color = Color3.new(0, 0, 0)
										espfolderdrawing[plr.Name].Quad4 = Drawing.new("Line")
										espfolderdrawing[plr.Name].Quad4.Thickness = 2
										espfolderdrawing[plr.Name].Quad4.ZIndex = 1
										espfolderdrawing[plr.Name].Quad4.Color = Color3.new(0, 0, 0)
										thing = espfolderdrawing[plr.Name]
									end

									if isAlive(plr) and plr ~= lplr and (ESPTeammates["Enabled"] or shared.vapeteamcheck(plr)) then
										local rootPos, rootVis = cam:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position)
										local rootSize = (plr.Character.HumanoidRootPart.Size.X * 1200) * (cam.ViewportSize.X / 1920)
										local headPos, headVis = cam:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position + Vector3.new(0, 1 + (plr.Character.Humanoid.RigType == Enum.HumanoidRigType.R6 and 2 or plr.Character.Humanoid.HipHeight), 0))
										local legPos, legVis = cam:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position - Vector3.new(0, 1 + (plr.Character.Humanoid.RigType == Enum.HumanoidRigType.R6 and 2 or plr.Character.Humanoid.HipHeight), 0))
										rootPos = rootPos
										if rootVis then
											--thing.Visible = rootVis
											local sizex, sizey = (rootSize / rootPos.Z), (headPos.Y - legPos.Y) 
											local posx, posy = (rootPos.X - sizex / 2),  ((rootPos.Y - sizey / 2))
											if ESPHealthBar["Enabled"] then
												local color = HealthbarColorTransferFunction(plr.Character.Humanoid.Health / plr.Character.Humanoid.MaxHealth)
												thing.Quad3.Color = color
												thing.Quad3.Visible = true
												thing.Quad4.From = floorpos(Vector2.new(posx - 4, posy + 1))
												thing.Quad4.To = floorpos(Vector2.new(posx - 4, posy + sizey - 1))
												thing.Quad4.Visible = true
												local healthposy = sizey * math.clamp(plr.Character.Humanoid.Health / plr.Character.Humanoid.MaxHealth, 0, 1)
												thing.Quad3.From = floorpos(Vector2.new(posx - 4, posy + sizey - (sizey - healthposy)))
												thing.Quad3.To = floorpos(Vector2.new(posx - 4, posy))
												--thing.HealthLineMain.Size = UDim2.new(0, 1, math.clamp(plr.Character.Humanoid.Health / plr.Character.Humanoid.MaxHealth, 0, 1), (math.clamp(plr.Character.Humanoid.Health / plr.Character.Humanoid.MaxHealth, 0, 1) == 0 and 0 or -2))
											end
											thing.Quad1.PointA = floorpos(Vector2.new(posx + sizex, posy))
											thing.Quad1.PointB = floorpos(Vector2.new(posx, posy))
											thing.Quad1.PointC = floorpos(Vector2.new(posx, posy + sizey))
											thing.Quad1.PointD = floorpos(Vector2.new(posx + sizex, posy + sizey))
											thing.Quad1.Visible = true
											thing.Quad2.PointA = floorpos(Vector2.new(posx + sizex, posy))
											thing.Quad2.PointB = floorpos(Vector2.new(posx, posy))
											thing.Quad2.PointC = floorpos(Vector2.new(posx, posy + sizey))
											thing.Quad2.PointD = floorpos(Vector2.new(posx + sizex, posy + sizey))
											thing.Quad2.Visible = true
										end
									end
								else
									if espfolderdrawing[plr.Name] then
										thing = espfolderdrawing[plr.Name]
										for linenum, line in pairs(thing) do
											line.Color = getPlayerColor(plr) or Color3.fromHSV(ESPColor["Hue"], ESPColor["Sat"], ESPColor["Value"])
											line.Visible = false
										end
									else
										thing = {}
										thing.Head = Drawing.new("Line")
										thing.Head2 = Drawing.new("Line")
										thing.Torso = Drawing.new("Line")
										thing.Torso2 = Drawing.new("Line")
										thing.Torso3 = Drawing.new("Line")
										thing.LeftArm = Drawing.new("Line")
										thing.RightArm = Drawing.new("Line")
										thing.LeftLeg = Drawing.new("Line")
										thing.RightLeg = Drawing.new("Line")
										espfolderdrawing[plr.Name] = thing
									end

									if isAlive(plr) and plr ~= lplr and (ESPTeammates["Enabled"] or shared.vapeteamcheck(plr)) then
										local rootPos, rootVis = cam:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position)
										if rootVis and plr.Character:FindFirstChild((plr.Character.Humanoid.RigType == Enum.HumanoidRigType.R6 and "Torso" or "UpperTorso")) and plr.Character:FindFirstChild((plr.Character.Humanoid.RigType == Enum.HumanoidRigType.R6 and "Left Arm" or "LeftHand")) and plr.Character:FindFirstChild((plr.Character.Humanoid.RigType == Enum.HumanoidRigType.R6 and "Right Arm" or "RightHand")) and plr.Character:FindFirstChild((plr.Character.Humanoid.RigType == Enum.HumanoidRigType.R6 and "Left Leg" or "LeftFoot")) and plr.Character:FindFirstChild((plr.Character.Humanoid.RigType == Enum.HumanoidRigType.R6 and "Right Leg" or "RightFoot")) and plr.Character:FindFirstChild("Head") then
											local head = CalculateObjectPosition((plr.Character["Head"].CFrame).p)
											local headfront = CalculateObjectPosition((plr.Character["Head"].CFrame * CFrame.new(0, 0, -0.5)).p)
											local toplefttorso = CalculateObjectPosition((plr.Character[(plr.Character.Humanoid.RigType == Enum.HumanoidRigType.R6 and "Torso" or "UpperTorso")].CFrame * CFrame.new(-1.5, 0.8, 0)).p)
											local toprighttorso = CalculateObjectPosition((plr.Character[(plr.Character.Humanoid.RigType == Enum.HumanoidRigType.R6 and "Torso" or "UpperTorso")].CFrame * CFrame.new(1.5, 0.8, 0)).p)
											local toptorso = CalculateObjectPosition((plr.Character[(plr.Character.Humanoid.RigType == Enum.HumanoidRigType.R6 and "Torso" or "UpperTorso")].CFrame * CFrame.new(0, 0.8, 0)).p)
											local bottomtorso = CalculateObjectPosition((plr.Character[(plr.Character.Humanoid.RigType == Enum.HumanoidRigType.R6 and "Torso" or "UpperTorso")].CFrame * CFrame.new(0, -0.8, 0)).p)
											local bottomlefttorso = CalculateObjectPosition((plr.Character[(plr.Character.Humanoid.RigType == Enum.HumanoidRigType.R6 and "Torso" or "UpperTorso")].CFrame * CFrame.new(-0.5, -0.8, 0)).p)
											local bottomrighttorso = CalculateObjectPosition((plr.Character[(plr.Character.Humanoid.RigType == Enum.HumanoidRigType.R6 and "Torso" or "UpperTorso")].CFrame * CFrame.new(0.5, -0.8, 0)).p)
											local leftarm = CalculateObjectPosition((plr.Character[(plr.Character.Humanoid.RigType == Enum.HumanoidRigType.R6 and "Left Arm" or "LeftHand")].CFrame * CFrame.new(0, -0.8, 0)).p)
											local rightarm = CalculateObjectPosition((plr.Character[(plr.Character.Humanoid.RigType == Enum.HumanoidRigType.R6 and "Right Arm" or "RightHand")].CFrame * CFrame.new(0, -0.8, 0)).p)
											local leftleg = CalculateObjectPosition((plr.Character[(plr.Character.Humanoid.RigType == Enum.HumanoidRigType.R6 and "Left Leg" or "LeftFoot")].CFrame * CFrame.new(0, -0.8, 0)).p)
											local rightleg = CalculateObjectPosition((plr.Character[(plr.Character.Humanoid.RigType == Enum.HumanoidRigType.R6 and "Right Leg" or "RightFoot")].CFrame * CFrame.new(0, -0.8, 0)).p)
											thing.Torso.From = toplefttorso
											thing.Torso.To = toprighttorso
											thing.Torso.Visible = true
											thing.Torso2.From = toptorso
											thing.Torso2.To = bottomtorso
											thing.Torso2.Visible = true
											thing.Torso3.From = bottomlefttorso
											thing.Torso3.To = bottomrighttorso
											thing.Torso3.Visible = true
											thing.LeftArm.From = toplefttorso
											thing.LeftArm.To = leftarm
											thing.LeftArm.Visible = true
											thing.RightArm.From = toprighttorso
											thing.RightArm.To = rightarm
											thing.RightArm.Visible = true
											thing.LeftLeg.From = bottomlefttorso
											thing.LeftLeg.To = leftleg
											thing.LeftLeg.Visible = true
											thing.RightLeg.From = bottomrighttorso
											thing.RightLeg.To = rightleg
											thing.RightLeg.Visible = true
											thing.Head.From = toptorso
											thing.Head.To = head
											thing.Head.Visible = true
											thing.Head2.From = head
											thing.Head2.To = headfront
											thing.Head2.Visible = true
										--[[CalculateLine(toplefttorso, toprighttorso, thing.TopTorsoLine)
										CalculateLine(toptorso, bottomtorso, thing.MiddleTorsoLine)
										CalculateLine(bottomlefttorso, bottomrighttorso, thing.BottomTorsoLine)
										CalculateLine(toplefttorso, leftarm, thing.LeftArm)
										CalculateLine(toprighttorso, rightarm, thing.RightArm)
										CalculateLine(bottomlefttorso, leftleg, thing.LeftLeg)
										CalculateLine(bottomrighttorso, rightleg, thing.RightLeg)
										CalculateLine(toptorso, head, thing.Head)
										CalculateLine(head, headfront, thing.HeadForward)]]
										end
									end
								end
							else
								if ESPMethod["Value"] == "2D" then
									if ESPFolder:FindFirstChild(plr.Name) then
										thing = ESPFolder[plr.Name]
										thing.Visible = false
										thing.Line1.BackgroundColor3 = getPlayerColor(plr) or Color3.fromHSV(ESPColor["Hue"], ESPColor["Sat"], ESPColor["Value"])
										thing.Line2.BackgroundColor3 = getPlayerColor(plr) or Color3.fromHSV(ESPColor["Hue"], ESPColor["Sat"], ESPColor["Value"])
										thing.Line3.BackgroundColor3 = getPlayerColor(plr) or Color3.fromHSV(ESPColor["Hue"], ESPColor["Sat"], ESPColor["Value"])
										thing.Line4.BackgroundColor3 = getPlayerColor(plr) or Color3.fromHSV(ESPColor["Hue"], ESPColor["Sat"], ESPColor["Value"])
									else
										thing = Instance.new("Frame")
										thing.BackgroundTransparency = 1
										thing.BorderSizePixel = 0
										thing.Visible = false
										thing.Name = plr.Name
										thing.Parent = ESPFolder
										local line1 = Instance.new("Frame")
										line1.BorderSizePixel = 0
										line1.Name = "Line1"
										line1.ZIndex = 2
										line1.Size = UDim2.new(1, -2, 0, 1)
										line1.Position = UDim2.new(0, 1, 0, 1)
										line1.BackgroundColor3 = getPlayerColor(plr) or Color3.fromHSV(ESPColor["Hue"], ESPColor["Sat"], ESPColor["Value"])
										line1.Parent = thing
										local line2 = Instance.new("Frame")
										line2.BorderSizePixel = 0
										line2.Name = "Line2"
										line2.Size = UDim2.new(1, -2, 0, 1)
										line2.ZIndex = 2
										line2.Position = UDim2.new(0, 1, 1, -2)
										line2.BackgroundColor3 = getPlayerColor(plr) or Color3.fromHSV(ESPColor["Hue"], ESPColor["Sat"], ESPColor["Value"])
										line2.Parent = thing
										local line3 = Instance.new("Frame")
										line3.BorderSizePixel = 0
										line3.Name = "Line3"
										line3.Size = UDim2.new(0, 1, 1, -2)
										line3.Position = UDim2.new(0, 1, 0, 1)
										line3.ZIndex = 2
										line3.BackgroundColor3 = getPlayerColor(plr) or Color3.fromHSV(ESPColor["Hue"], ESPColor["Sat"], ESPColor["Value"])
										line3.Parent = thing
										local line4 = Instance.new("Frame")
										line4.BorderSizePixel = 0
										line4.Name = "Line4"
										line4.Size = UDim2.new(0, 1, 1, -2)
										line4.Position = UDim2.new(1, -2, 0, 1)
										line4.ZIndex = 2
										line4.BackgroundColor3 = getPlayerColor(plr) or Color3.fromHSV(ESPColor["Hue"], ESPColor["Sat"], ESPColor["Value"])
										line4.Parent = thing
										local line1clone = line1:Clone()
										line1clone.ZIndex = 1
										line1clone.Size = UDim2.new(1, 0, 0, 3)
										line1clone.BackgroundTransparency = 0.5
										line1clone.Position = UDim2.new(0, 0, 0, 0)
										line1clone.BackgroundColor3 = Color3.new(0, 0, 0)
										line1clone.Parent = thing
										local line2clone = line2:Clone()
										line2clone.ZIndex = 1
										line2clone.Size = UDim2.new(1, 0, 0, 3)
										line2clone.BackgroundTransparency = 0.5
										line2clone.Position = UDim2.new(0, 0, 1, -3)
										line2clone.BackgroundColor3 = Color3.new(0, 0, 0)
										line2clone.Parent = thing
										local line3clone = line3:Clone()
										line3clone.ZIndex = 1
										line3clone.Size = UDim2.new(0, 3, 1, 0)
										line3clone.BackgroundTransparency = 0.5
										line3clone.Position = UDim2.new(0, 0, 0, 0)
										line3clone.BackgroundColor3 = Color3.new(0, 0, 0)
										line3clone.Parent = thing
										local line4clone = line4:Clone()
										line4clone.ZIndex = 1
										line4clone.Size = UDim2.new(0, 3, 1, 0)
										line4clone.BackgroundTransparency = 0.5
										line4clone.Position = UDim2.new(1, -3, 0, 0)
										line4clone.BackgroundColor3 = Color3.new(0, 0, 0)
										line4clone.Parent = thing
										local healthline = Instance.new("Frame")
										healthline.BorderSizePixel = 0
										healthline.Name = "HealthLineMain"
										healthline.ZIndex = 2
										healthline.AnchorPoint = Vector2.new(0, 1)
										healthline.Visible = ESPHealthBar["Enabled"]
										healthline.Size = UDim2.new(0, 1, 1, -2)
										healthline.Position = UDim2.new(0, -4, 1, -1)
										healthline.BackgroundColor3 = Color3.new(0, 1, 0)
										healthline.Parent = thing
										local healthlineclone = healthline:Clone()
										healthlineclone.ZIndex = 1
										healthlineclone.AnchorPoint = Vector2.new(0, 0)
										healthlineclone.Size = UDim2.new(0, 3, 1, 0)
										healthlineclone.BackgroundTransparency = 0.5
										healthlineclone.Visible = ESPHealthBar["Enabled"]
										healthlineclone.Name = "HealthLineBKG"
										healthlineclone.Position = UDim2.new(0, -5, 0, 0)
										healthlineclone.BackgroundColor3 = Color3.new(0, 0, 0)
										healthlineclone.Parent = thing
									end

									if isAlive(plr) and plr ~= lplr and (ESPTeammates["Enabled"] or shared.vapeteamcheck(plr)) then
										local rootPos, rootVis = cam:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position)
										local rootSize = (plr.Character.HumanoidRootPart.Size.X * 1200) * (cam.ViewportSize.X / 1920)
										local headPos, headVis = cam:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position + Vector3.new(0, 1 + (plr.Character.Humanoid.RigType == Enum.HumanoidRigType.R6 and 2 or plr.Character.Humanoid.HipHeight), 0))
										local legPos, legVis = cam:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position - Vector3.new(0, 1 + (plr.Character.Humanoid.RigType == Enum.HumanoidRigType.R6 and 2 or plr.Character.Humanoid.HipHeight), 0))
										rootPos = rootPos
										if rootVis then
											if ESPHealthBar["Enabled"] then
												local color = HealthbarColorTransferFunction(plr.Character.Humanoid.Health / plr.Character.Humanoid.MaxHealth)
												thing.HealthLineMain.BackgroundColor3 = color
												thing.HealthLineMain.Size = UDim2.new(0, 1, math.clamp(plr.Character.Humanoid.Health / plr.Character.Humanoid.MaxHealth, 0, 1), (math.clamp(plr.Character.Humanoid.Health / plr.Character.Humanoid.MaxHealth, 0, 1) == 0 and 0 or -2))
											end
											thing.Visible = rootVis
											thing.Size = UDim2.new(0, rootSize / rootPos.Z, 0, headPos.Y - legPos.Y)
											thing.Position = UDim2.new(0, rootPos.X - thing.Size.X.Offset / 2, 0, (rootPos.Y - thing.Size.Y.Offset / 2) - 36)
										end
									end
								end
								if ESPMethod["Value"] == "Skeleton" then
									if ESPFolder:FindFirstChild(plr.Name) then
										thing = ESPFolder[plr.Name]
										thing.Visible = false
										for linenum, line in pairs(thing:GetChildren()) do
											line.BackgroundColor3 = getPlayerColor(plr) or Color3.fromHSV(ESPColor["Hue"], ESPColor["Sat"], ESPColor["Value"])
										end
									else
										thing = Instance.new("Frame")
										thing.BackgroundTransparency = 1
										thing.BorderSizePixel = 0
										thing.Visible = false
										thing.Name = plr.Name
										thing.Parent = ESPFolder
										local line1 = Instance.new("Frame")
										line1.BorderSizePixel = 0
										line1.Name = "TopTorsoLine"
										line1.AnchorPoint = Vector2.new(0.5, 0.5)
										line1.ZIndex = 2
										line1.Size = UDim2.new(0, 0, 0, 0)
										line1.Position = UDim2.new(0, 0, 0, 0)
										line1.BackgroundColor3 = getPlayerColor(plr) or Color3.fromHSV(ESPColor["Hue"], ESPColor["Sat"], ESPColor["Value"])
										line1.Parent = thing
										local line2 = line1:Clone()
										line2.Name = "MiddleTorsoLine"
										line2.Parent = thing
										local line3 = line1:Clone()
										line3.Name = "BottomTorsoLine"
										line3.Parent = thing
										local line4 = line1:Clone()
										line4.Name = "LeftArm"
										line4.Parent = thing
										local line5 = line1:Clone()
										line5.Name = "RightArm"
										line5.Parent = thing
										local line6 = line1:Clone()
										line6.Name = "LeftLeg"
										line6.Parent = thing
										local line7 = line1:Clone()
										line7.Name = "RightLeg"
										line7.Parent = thing
										local line8 = line1:Clone()
										line8.Name = "Head"
										line8.Parent = thing
										local line9 = line1:Clone()
										line9.Name = "HeadForward"
										line9.Parent = thing
									end

									if isAlive(plr) and plr ~= lplr and (ESPTeammates["Enabled"] or shared.vapeteamcheck(plr)) then
										local rootPos, rootVis = cam:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position)
										if rootVis and plr.Character:FindFirstChild((plr.Character.Humanoid.RigType == Enum.HumanoidRigType.R6 and "Torso" or "UpperTorso")) and plr.Character:FindFirstChild((plr.Character.Humanoid.RigType == Enum.HumanoidRigType.R6 and "Left Arm" or "LeftHand")) and plr.Character:FindFirstChild((plr.Character.Humanoid.RigType == Enum.HumanoidRigType.R6 and "Right Arm" or "RightHand")) and plr.Character:FindFirstChild((plr.Character.Humanoid.RigType == Enum.HumanoidRigType.R6 and "Left Leg" or "LeftFoot")) and plr.Character:FindFirstChild((plr.Character.Humanoid.RigType == Enum.HumanoidRigType.R6 and "Right Leg" or "RightFoot")) and plr.Character:FindFirstChild("Head") then
											thing.Visible = true
											local head = CalculateObjectPosition((plr.Character["Head"].CFrame).p)
											local headfront = CalculateObjectPosition((plr.Character["Head"].CFrame * CFrame.new(0, 0, -0.5)).p)
											local toplefttorso = CalculateObjectPosition((plr.Character[(plr.Character.Humanoid.RigType == Enum.HumanoidRigType.R6 and "Torso" or "UpperTorso")].CFrame * CFrame.new(-1.5, 0.8, 0)).p)
											local toprighttorso = CalculateObjectPosition((plr.Character[(plr.Character.Humanoid.RigType == Enum.HumanoidRigType.R6 and "Torso" or "UpperTorso")].CFrame * CFrame.new(1.5, 0.8, 0)).p)
											local toptorso = CalculateObjectPosition((plr.Character[(plr.Character.Humanoid.RigType == Enum.HumanoidRigType.R6 and "Torso" or "UpperTorso")].CFrame * CFrame.new(0, 0.8, 0)).p)
											local bottomtorso = CalculateObjectPosition((plr.Character[(plr.Character.Humanoid.RigType == Enum.HumanoidRigType.R6 and "Torso" or "UpperTorso")].CFrame * CFrame.new(0, -0.8, 0)).p)
											local bottomlefttorso = CalculateObjectPosition((plr.Character[(plr.Character.Humanoid.RigType == Enum.HumanoidRigType.R6 and "Torso" or "UpperTorso")].CFrame * CFrame.new(-0.5, -0.8, 0)).p)
											local bottomrighttorso = CalculateObjectPosition((plr.Character[(plr.Character.Humanoid.RigType == Enum.HumanoidRigType.R6 and "Torso" or "UpperTorso")].CFrame * CFrame.new(0.5, -0.8, 0)).p)
											local leftarm = CalculateObjectPosition((plr.Character[(plr.Character.Humanoid.RigType == Enum.HumanoidRigType.R6 and "Left Arm" or "LeftHand")].CFrame * CFrame.new(0, -0.8, 0)).p)
											local rightarm = CalculateObjectPosition((plr.Character[(plr.Character.Humanoid.RigType == Enum.HumanoidRigType.R6 and "Right Arm" or "RightHand")].CFrame * CFrame.new(0, -0.8, 0)).p)
											local leftleg = CalculateObjectPosition((plr.Character[(plr.Character.Humanoid.RigType == Enum.HumanoidRigType.R6 and "Left Leg" or "LeftFoot")].CFrame * CFrame.new(0, -0.8, 0)).p)
											local rightleg = CalculateObjectPosition((plr.Character[(plr.Character.Humanoid.RigType == Enum.HumanoidRigType.R6 and "Right Leg" or "RightFoot")].CFrame * CFrame.new(0, -0.8, 0)).p)
											CalculateLine(toplefttorso, toprighttorso, thing.TopTorsoLine)
											CalculateLine(toptorso, bottomtorso, thing.MiddleTorsoLine)
											CalculateLine(bottomlefttorso, bottomrighttorso, thing.BottomTorsoLine)
											CalculateLine(toplefttorso, leftarm, thing.LeftArm)
											CalculateLine(toprighttorso, rightarm, thing.RightArm)
											CalculateLine(bottomlefttorso, leftleg, thing.LeftLeg)
											CalculateLine(bottomrighttorso, rightleg, thing.RightLeg)
											CalculateLine(toptorso, head, thing.Head)
											CalculateLine(head, headfront, thing.HeadForward)
										end
									end
								end
							end
						end
					end)
				else
					UnbindFromRenderStep("ESP") 
					ESPFolder:ClearAllChildren()
					for i,v in pairs(espfolderdrawing) do 
						pcall(function()
							espfolderdrawing[i].Quad1:Remove()
							espfolderdrawing[i].Quad2:Remove()
							espfolderdrawing[i].Quad3:Remove()
							espfolderdrawing[i].Quad4:Remove()
							espfolderdrawing[i] = nil
						end)
						pcall(function()
							espfolderdrawing[i].Head:Remove()
							espfolderdrawing[i].Head2:Remove()
							espfolderdrawing[i].Torso:Remove()
							espfolderdrawing[i].Torso2:Remove()
							espfolderdrawing[i].Torso3:Remove()
							espfolderdrawing[i].LeftArm:Remove()
							espfolderdrawing[i].RightArm:Remove()
							espfolderdrawing[i].LeftLeg:Remove()
							espfolderdrawing[i].RightLeg:Remove()
							espfolderdrawing[i] = nil
						end)
					end
				end
			end,
			["HoverText"] = "See where everyone is at with boxes"
		})
		ESPMethod = ESP.CreateDropdown({
			["Name"] = "Mode",
			["List"] = {"2D", "Skeleton"},
			["Function"] = function(val)
				ESPFolder:ClearAllChildren()
				for i,v in pairs(espfolderdrawing) do 
					pcall(function()
						espfolderdrawing[i].Quad1:Remove()
						espfolderdrawing[i].Quad2:Remove()
						espfolderdrawing[i].Quad3:Remove()
						espfolderdrawing[i].Quad4:Remove()
						espfolderdrawing[i] = nil
					end)
					pcall(function()
						espfolderdrawing[i].Head:Remove()
						espfolderdrawing[i].Head2:Remove()
						espfolderdrawing[i].Torso:Remove()
						espfolderdrawing[i].Torso2:Remove()
						espfolderdrawing[i].Torso3:Remove()
						espfolderdrawing[i].LeftArm:Remove()
						espfolderdrawing[i].RightArm:Remove()
						espfolderdrawing[i].LeftLeg:Remove()
						espfolderdrawing[i].RightLeg:Remove()
						espfolderdrawing[i] = nil
					end)
				end
				ESPHealthBar["Object"].Visible = (val == "2D")
			end,
		})
		ESPColor = ESP.CreateColorSlider({
			["Name"] = "Player Color", 
			["Function"] = function(val) end
		})
		ESPHealthBar = ESP.CreateToggle({
			["Name"] = "Health Bar", 
			["Function"] = function(callback)
				if callback then 
					for i,v in pairs(ESPFolder:GetChildren()) do
						v.HealthLineMain.Visible = true
						v.HealthLineBKG.Visible = true
					end
				else
					for i,v in pairs(ESPFolder:GetChildren()) do
						v.HealthLineMain.Visible = false
						v.HealthLineBKG.Visible = false
					end
				end
			end
		})
		 
	end)

	runcode(function()
		local TracersFolder = Instance.new("Folder")
		TracersFolder.Name = "TracersFolder"
		TracersFolder.Parent = GuiLibrary["MainGui"]
		local TracersDrawing = {["Enabled"] = false}
		local tracersdrawingtab = {}
		players.PlayerRemoving:connect(function(plr)
			if TracersFolder:FindFirstChild(plr.Name) then
				TracersFolder[plr.Name]:Remove()
			end
			if tracersdrawingtab[plr.Name] then 
				pcall(function()
					tracersdrawingtab[plr.Name]:Remove()
					tracersdrawingtab[plr.Name] = nil
				end)
			end
		end)
		local TracersColor = {["Value"] = 0.44}
		local TracersTransparency = {["Value"] = 1}
		local TracersStartPosition = {["Value"] = "Middle"}
		local TracersEndPosition = {["Value"] = "Head"}
		local TracersTeammates = {["Enabled"] = true}
		local Tracers = GuiLibrary["ObjectsThatCanBeSaved"]["RenderWindow"]["Api"].CreateOptionsButton({
			["Name"] = "Tracers", 
			["Function"] = function(callback) 
				if callback then
					BindToRenderStep("Tracers", 500, function()
						for i,plr in pairs(players:GetChildren()) do
							local thing
							if TracersDrawing["Enabled"] then
								if tracersdrawingtab[plr.Name] then 
									thing = tracersdrawingtab[plr.Name]
									thing.Visible = false
								else
									thing = Drawing.new("Line")
									thing.Thickness = 1
									thing.Visible = false
									tracersdrawingtab[plr.Name] = thing
								end

								if isAlive(plr) and plr ~= lplr and (TracersTeammates["Enabled"] or shared.vapeteamcheck(plr)) then
									local rootScrPos = cam:WorldToViewportPoint((TracersEndPosition["Value"] == "Head" and plr.Character.Head or plr.Character.HumanoidRootPart).Position)
									local tempPos = cam.CFrame:pointToObjectSpace((TracersEndPosition["Value"] == "Head" and plr.Character.Head or plr.Character.HumanoidRootPart).Position)
									if rootScrPos.Z < 0 then
										tempPos = CFrame.Angles(0, 0, (math.atan2(tempPos.Y, tempPos.X) + math.pi)):vectorToWorldSpace((CFrame.Angles(0, math.rad(89.9), 0):vectorToWorldSpace(Vector3.new(0, 0, -1))));
									end
									local tracerPos = cam:WorldToViewportPoint(cam.CFrame:pointToWorldSpace(tempPos))
									local screensize = cam.ViewportSize
									local startVector = Vector2.new(screensize.X / 2, (TracersStartPosition["Value"] == "Middle" and screensize.Y / 2 or screensize.Y))
									local endVector = Vector2.new(tracerPos.X, tracerPos.Y)
									local Distance = (startVector - endVector).Magnitude
									startVector = startVector
									endVector = endVector
									thing.Visible = true
									thing.Transparency = 1 - TracersTransparency["Value"] / 100
									thing.Color = getPlayerColor(plr) or Color3.fromHSV(TracersColor["Hue"], TracersColor["Sat"], TracersColor["Value"])
									thing.From = startVector
									thing.To = endVector
								end
							else
								if TracersFolder:FindFirstChild(plr.Name) then
									thing = TracersFolder[plr.Name]
									if thing.Visible then
										thing.Visible = false
									end
								else
									thing = Instance.new("Frame")
									thing.BackgroundTransparency = 0
									thing.AnchorPoint = Vector2.new(0.5, 0.5)
									thing.BackgroundColor3 = Color3.new(0, 0, 0)
									thing.BorderSizePixel = 0
									thing.Visible = false
									thing.Name = plr.Name
									thing.Parent = TracersFolder
								end

								if isAlive(plr) and plr ~= lplr and (TracersTeammates["Enabled"] or shared.vapeteamcheck(plr)) then
									local rootScrPos = cam:WorldToViewportPoint((TracersEndPosition["Value"] == "Head" and plr.Character.Head or plr.Character.HumanoidRootPart).Position)
									local tempPos = cam.CFrame:pointToObjectSpace((TracersEndPosition["Value"] == "Head" and plr.Character.Head or plr.Character.HumanoidRootPart).Position)
									if rootScrPos.Z < 0 then
										tempPos = CFrame.Angles(0, 0, (math.atan2(tempPos.Y, tempPos.X) + math.pi)):vectorToWorldSpace((CFrame.Angles(0, math.rad(89.9), 0):vectorToWorldSpace(Vector3.new(0, 0, -1))));
									end
									local tracerPos = cam:WorldToViewportPoint(cam.CFrame:pointToWorldSpace(tempPos))
									local screensize = cam.ViewportSize
									local startVector = Vector2.new(screensize.X / 2, (TracersStartPosition["Value"] == "Middle" and screensize.Y / 2 or screensize.Y))
									local endVector = Vector2.new(tracerPos.X, tracerPos.Y)
									local Distance = (startVector - endVector).Magnitude
									startVector = startVector
									endVector = endVector
									thing.Visible = true
									thing.BackgroundTransparency = TracersTransparency["Value"] / 100
									thing.BackgroundColor3 = getPlayerColor(plr) or Color3.fromHSV(TracersColor["Hue"], TracersColor["Sat"], TracersColor["Value"])
									thing.Size = UDim2.new(0, Distance, 0, 2)
									thing.Position = UDim2.new(0, (startVector.X + endVector.X) / 2, 0, ((startVector.Y + endVector.Y) / 2) - 36)
									thing.Rotation = math.atan2(endVector.Y - startVector.Y, endVector.X - startVector.X) * (180 / math.pi)
								end
							end
						end
					end)
				else
					UnbindFromRenderStep("Tracers") 
					TracersFolder:ClearAllChildren()
					for i,v in pairs(tracersdrawingtab) do 
						pcall(function()
							v:Remove()
							tracersdrawingtab[i] = nil
						end)
					end
				end
			end,
			["HoverText"] = "See where everyone is at with lines"
		})
		TracersStartPosition = Tracers.CreateDropdown({
			["Name"] = "Start Position",
			["List"] = {"Middle", "Bottom"},
			["Function"] = function() end
		})
		TracersEndPosition = Tracers.CreateDropdown({
			["Name"] = "End Position",
			["List"] = {"Head", "Torso"},
			["Function"] = function() end
		})
		TracersColor = Tracers.CreateColorSlider({
			["Name"] = "Player Color", 
			["Function"] = function(val) end
		})
		TracersTransparency = Tracers.CreateSlider({
			["Name"] = "Transparency", 
			["Min"] = 1,
			["Max"] = 100, 
			["Function"] = function(val) end,
			["Default"] = 0
		})
		 
	end)

	runcode(function()
		local Breadcrumbs = {["Enabled"] = false}
		local BreadcrumbsLifetime = {["Value"] = 20}
		local breadcrumbtrail
		local breadcrumbattachment
		local breadcrumbattachment2
		Breadcrumbs = GuiLibrary["ObjectsThatCanBeSaved"]["RenderWindow"]["Api"].CreateOptionsButton({
			["Name"] = "Breadcrumbs",
			["Function"] = function(callback)
				if callback then
					spawn(function()
						repeat
							task.wait(0.3)
							if (not Breadcrumbs["Enabled"]) then return end
							local PrivatePlr = game.Players.LocalPlayer
							if PrivatePlr.Character.Humanoid.Health >= 0.1 then
								if breadcrumbtrail == nil then
									breadcrumbattachment = Instance.new("Attachment")
									breadcrumbattachment.Position = Vector3.new(0, 0.07 - 2.9, 0.5)
									breadcrumbattachment2 = Instance.new("Attachment")
									breadcrumbattachment2.Position = Vector3.new(0, -0.07 - 2.9, 0.5)
									breadcrumbtrail = Instance.new("Trail")
									breadcrumbtrail.Attachment0 = breadcrumbattachment 
									breadcrumbtrail.Attachment1 = breadcrumbattachment2
									breadcrumbtrail.Color = ColorSequence.new(Color3.new(1, 0, 0), Color3.new(0, 0, 1))
									breadcrumbtrail.FaceCamera = true
									breadcrumbtrail.Lifetime = BreadcrumbsLifetime["Value"] / 10
									breadcrumbtrail.Enabled = true
									breadcrumbtrail.Parent = cam
								else
									breadcrumbattachment.Parent = PrivatePlr.character.HumanoidRootPart
									breadcrumbattachment2.Parent = PrivatePlr.character.HumanoidRootPart
									breadcrumbtrail.Parent = cam
								end
							end
						until (not Breadcrumbs["Enabled"])
					end)
				else
					if breadcrumbtrail then
						breadcrumbtrail:Remove()
						breadcrumbtrail = nil
					end
				end
			end,
			["HoverText"] = "Shows a trail behind your character"
		})
		BreadcrumbsLifetime = Breadcrumbs.CreateSlider({
			["Name"] = "Lifetime",
			["Min"] = 1,
			["Max"] = 100,
			["Function"] = function(val) end,
			["Default"] = 20
		})
		 
	end)

	runcode(function()
		local ChamsFolder = Instance.new("Folder")
		ChamsFolder.Name = "ChamsFolder"
		ChamsFolder.Parent = GuiLibrary["MainGui"]
		players.PlayerRemoving:connect(function(plr)
			if ChamsFolder:FindFirstChild(plr.Name) then
				ChamsFolder[plr.Name]:Remove()
			end
		end)
		local ChamsColor = {["Value"] = 0.44}
		local ChamsOutlineColor = {["Value"] = 0.44}
		local ChamsBetter = {["Enabled"] = false}
		local ChamsTransparency = {["Value"] = 1}
		local ChamsOutlineTransparency = {["Value"] = 1}
		local ChamsOnTop = {["Enabled"] = true}
		local chamobjects = {["Head"] = true, ["Torso"] = true, ["UpperTorso"] = true, ["LowerTorso"] = true, ["Left Arm"] = true, ["Left Leg"] = true, ["Right Arm"] = true, ["Right Leg"] = true, ["LeftLowerLeg"] = true, ["RightLowerLeg"] = true, ["LeftUpperLeg"] = true, ["RightUpperLeg"] = true, ["LeftFoot"] = true, ["RightFoot"] = true, ["LeftLowerArm"] = true, ["RightLowerArm"] = true, ["LeftUpperArm"] = true, ["RightUpperArm"] = true, ["LeftHand"] = true, ["RightHand"] = true}
		local ChamsTeammates = {["Enabled"] = true}
		local Chams = GuiLibrary["ObjectsThatCanBeSaved"]["RenderWindow"]["Api"].CreateOptionsButton({
			["Name"] = "Chams", 
			["Function"] = function(callback) 
				if callback then
					BindToRenderStep("Chams", 500, function()
						for i,plr in pairs(players:GetChildren()) do
							if ChamsBetter["Enabled"] then
								local thing
								if ChamsFolder:FindFirstChild(plr.Name) then
									thing = ChamsFolder[plr.Name]
									thing.Enabled = false
									thing.FillColor = getPlayerColor(plr) or Color3.fromHSV(ChamsColor["Hue"], ChamsColor["Sat"], ChamsColor["Value"])
									thing.OutlineColor = Color3.fromHSV(ChamsOutlineColor["Hue"], ChamsOutlineColor["Sat"], ChamsOutlineColor["Value"])
								end

								if isAlive(plr) and plr ~= lplr and (ChamsTeammates["Enabled"] or shared.vapeteamcheck(plr)) then
									if ChamsFolder:FindFirstChild(plr.Name) == nil then
										local chamfolder = Instance.new("Highlight")
										chamfolder.Name = plr.Name
										chamfolder.Parent = ChamsFolder
										thing = chamfolder
									end
									thing.Enabled = true
									thing.Adornee = plr.Character
									thing.OutlineTransparency = ChamsOutlineTransparency["Value"] / 100
									thing.DepthMode = Enum.HighlightDepthMode[(ChamsOnTop["Enabled"] and "AlwaysOnTop" or "Occluded")]
									thing.FillTransparency = ChamsTransparency["Value"] / 100
								end
							else
								local thing
								if ChamsFolder:FindFirstChild(plr.Name) then
									thing = ChamsFolder[plr.Name]
									for partnumber, part in pairs(thing:GetChildren()) do
										part.Visible = false
										part.Color3 = getPlayerColor(plr) or Color3.fromHSV(ChamsColor["Hue"], ChamsColor["Sat"], ChamsColor["Value"])
									end
								end

								if isAlive(plr) and plr ~= lplr and (ChamsTeammates["Enabled"] or shared.vapeteamcheck(plr)) then
									if ChamsFolder:FindFirstChild(plr.Name) == nil then
										local chamfolder = Instance.new("Folder")
										chamfolder.Name = plr.Name
										chamfolder.Parent = ChamsFolder
										thing = chamfolder
										for partnumber, part in pairs(plr.Character:GetChildren()) do
											if chamobjects[part.Name] then
												local boxhandle = Instance.new("BoxHandleAdornment")
												boxhandle.Size = (part.Name == "Head" and Vector3.new(1.25, 1.25, 1.25) or part.Size) + Vector3.new(.01, .01, .01)
												boxhandle.AlwaysOnTop = ChamsOnTop["Enabled"]
												boxhandle.ZIndex = 10
												boxhandle.Visible = true
												boxhandle.Color3 = getPlayerColor(plr) or Color3.fromHSV(ChamsColor["Hue"], ChamsColor["Sat"], ChamsColor["Value"])
												boxhandle.Name = part.Name
												boxhandle.Parent = chamfolder
											end
										end
									end
									for partnumber, part in pairs(thing:GetChildren()) do
										part.Visible = true
										if plr.Character:FindFirstChild(part.Name) then
											part.Adornee = plr.Character[part.Name]
											part.AlwaysOnTop = ChamsOnTop["Enabled"]
											part.Transparency = ChamsTransparency["Value"] / 100
										end
									end
								end
							end
						end
					end)
				else
					UnbindFromRenderStep("Chams")
					ChamsFolder:ClearAllChildren()
				end
			end,
			["HoverText"] = "Render players through walls"
		})
		ChamsColor = Chams.CreateColorSlider({
			["Name"] = "Player Color", 
			["Function"] = function(val) end
		})
		ChamsTransparency = Chams.CreateSlider({
			["Name"] = "Transparency", 
			["Min"] = 1,
			["Max"] = 100, 
			["Function"] = function(val) end,
			["Default"] = 50
		})
		 
	end)

	runcode(function()
		local lightingsettings = {}
		local lightingconnection
		local lightingchanged = false
		GuiLibrary["ObjectsThatCanBeSaved"]["RenderWindow"]["Api"].CreateOptionsButton({
			["Name"] = "Fullbright",
			["Function"] = function(callback)
				if callback then 
					lightingsettings["Brightness"] = lighting.Brightness
					lightingsettings["ClockTime"] = lighting.ClockTime
					lightingsettings["FogEnd"] = lighting.FogEnd
					lightingsettings["GlobalShadows"] = lighting.GlobalShadows
					lightingsettings["OutdoorAmbient"] = lighting.OutdoorAmbient
					lightingchanged = false
					lighting.Brightness = 2
					lighting.ClockTime = 14
					lighting.FogEnd = 100000
					lighting.GlobalShadows = false
					lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
					lightingchanged = true
					lightingconnection = lighting.Changed:connect(function()
						if not lightingchanged then
							lightingsettings["Brightness"] = lighting.Brightness
							lightingsettings["ClockTime"] = lighting.ClockTime
							lightingsettings["FogEnd"] = lighting.FogEnd
							lightingsettings["GlobalShadows"] = lighting.GlobalShadows
							lightingsettings["OutdoorAmbient"] = lighting.OutdoorAmbient
							lightingchanged = true
							lighting.Brightness = 2
							lighting.ClockTime = 14
							lighting.FogEnd = 100000
							lighting.GlobalShadows = false
							lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
							lightingchanged = false
						end
					end)
				else
					for name,thing in pairs(lightingsettings) do 
						lighting[name] = thing 
					end
					lightingconnection:Disconnect()  
				end
			end
		})
		 
	end)

	runcode(function()
		local DeathTeleport = {["Enabled"] = false}
		local DeathX = 0
		local DeathY = 0
		local DeathZ = 0
		local CanDie = false

		DeathTeleport = GuiLibrary["ObjectsThatCanBeSaved"]["WorldWindow"]["Api"].CreateOptionsButton({
			["Name"] = "DeathTeleport",
			["Function"] = function(callback) if callback then

					local MainCharacter = game.Workspace.Characters:FindFirstChild(game.Players.LocalPlayer.Name)
					MainCharacter.Humanoid.Died:Connect(function()
						if DeathTeleport.Enabled == true then
							DeathX = game.Workspace.Characters:FindFirstChild(game.Players.LocalPlayer.Name).HumanoidRootPart.Position.X
							DeathY = game.Workspace.Characters:FindFirstChild(game.Players.LocalPlayer.Name).HumanoidRootPart.Position.Y
							DeathZ = game.Workspace.Characters:FindFirstChild(game.Players.LocalPlayer.Name).HumanoidRootPart.Position.Z
						end
					end)

					game.Players.LocalPlayer.PlayerGui.SpawnGui.PlayButton.MouseButton1Up:Connect(function()
						if DeathTeleport.Enabled == true then
							wait(2)
							game.Workspace.Characters:FindFirstChild(game.Players.LocalPlayer.Name).HumanoidRootPart.CFrame = CFrame.new(DeathX, DeathY, DeathZ)
						end
					end)
				else

				end
			end,
			["HoverText"] = "if you die you will teleport to your death position and maybe get revenge or just collect your stuff", 
			["Default"] = false,
			["ExtraText"] = function() return " Placeholder" end
		})
		 
	end)

	runcode(function()
		local AntiVoid = {["Enabled"] = false}
		local AntiVoidMethod = {["Value"] = "Teleport"}
		AntiVoid = GuiLibrary["ObjectsThatCanBeSaved"]["WorldWindow"]["Api"].CreateOptionsButton({
			["Name"] = "AntiVoid",
			["Function"] = function(callback) if callback then
					if AntiVoid.Enabled == true then
						local newindex = getrawmetatable(game).__newindex;
						setreadonly(getrawmetatable(game),false);

						getrawmetatable(game).__newindex = function(t,i,v)
							if i=="FallenPartsDestroyHeight" and not checkcaller() and AntiVoid.Enabled == true then
								return newindex(t,i,16);
							end
							return newindex(t,i,v);
						end
					end
					while game:GetService("RunService").Heartbeat:Wait() and AntiVoid.Enabled == true do
						game.Workspace.FallenPartsDestroyHeight = -50000
						if game.Workspace.Characters:FindFirstChild(game.Players.LocalPlayer.Name).HumanoidRootPart.Position.Y <= -500 then
							if AntiVoidMethod.Value == "Teleport" then
								local r = math.random(1,3)
								if r == 1 then
									game.Workspace.Characters:FindFirstChild(game.Players.LocalPlayer.Name).HumanoidRootPart.CFrame = CFrame.new(game.Workspace.Teleporters.HavenPortal.TeleportPart.Position)	
									wait(5)
								end
								if r == 2 then
									game.Workspace.Characters:FindFirstChild(game.Players.LocalPlayer.Name).HumanoidRootPart.CFrame = CFrame.new(game.Workspace.Teleporters.LavaPortal.TeleportPart.Position)
									wait(5)
								end
								if r == 3 then
									game.Workspace.Characters:FindFirstChild(game.Players.LocalPlayer.Name).HumanoidRootPart.CFrame = CFrame.new(game.Workspace.Teleporters.SkyIslandTeleporters.TeleportPart.Position)	
									wait(5)
								end
							end
							if AntiVoidMethod.Value == "Crash" then
								local msgbox = messagebox("AntiVoid",tostring("You deid in the void"),4)
								setfpscap(math.huge)
								wait(5)
							end
						end
					end
				else
					game.Workspace.FallenPartsDestroyHeight = -500

				end
			end,
			["HoverText"] = "kicks you when someone has this in the group", 
			["Default"] = false,
			["ExtraText"] = function() return " Placeholder" end
		})
		AntiVoidMethod = AntiVoid.CreateDropdown({
			["Name"] = "Select Method",
			["List"] = {"Teleport", "Crash"},
			["Function"] = function(val)
			end
		})
		 
	end)

	runcode(function()
		local HealthText = Instance.new("TextLabel")
		HealthText.Font = Enum.Font.SourceSans
		HealthText.TextSize = 20
		HealthText.Text = "100❤"
		HealthText.Position = UDim2.new(0.5, 0, 0.5, 70)
		HealthText.BackgroundTransparency = 1
		HealthText.TextColor3 = Color3.fromRGB(255, 0, 0)
		HealthText.Size = UDim2.new(0, 0, 0, 0)
		HealthText.Visible = false
		HealthText.Parent = GuiLibrary["MainGui"]
		local Health = GuiLibrary["ObjectsThatCanBeSaved"]["RenderWindow"]["Api"].CreateOptionsButton({
			["Name"] = "Health", 
			["Function"] = function(callback) 
				if callback then
					HealthText.Visible = true
					BindToRenderStep("Health", 1, function()
						local PrivatePlr = game.Players.LocalPlayer
						if PrivatePlr.Character.Humanoid.Health >= 0.1 then
							HealthText.Text = tostring(math.round(PrivatePlr.character.Humanoid.Health)).."❤"
						end
					end)
				else
					HealthText.Visible = false
					UnbindFromRenderStep("Health")
				end
			end,
			["HoverText"] = "Displays your health in the center of your screen."
		})
		 
	end)

	runcode(function()
		local function removeTags(str)
			str = str:gsub("<br%s*/>", "\n")
			return (str:gsub("<[^<>]->", ""))
		end

		local function floorpos(pos)
			return Vector2.new(math.floor(pos.X), math.floor(pos.Y))
		end

		local NameTagsFolder = Instance.new("Folder")
		NameTagsFolder.Name = "NameTagsFolder"
		NameTagsFolder.Parent = GuiLibrary["MainGui"]
		local nametagsfolderdrawing = {}
		players.PlayerRemoving:connect(function(plr)
			if NameTagsFolder:FindFirstChild(plr.Name) then
				NameTagsFolder[plr.Name]:Remove()
			end
			if nametagsfolderdrawing[plr.Name] then 
				pcall(function()
					nametagsfolderdrawing[plr.Name].Text:Remove()
					nametagsfolderdrawing[plr.Name].BG:Remove()
					nametagsfolderdrawing[plr.Name] = nil
				end)
			end
		end)
		local NameTagsColor = {["Value"] = 0.44}
		local NameTagsDisplayName = {["Enabled"] = false}
		local NameTagsHealth = {["Enabled"] = false}
		local NameTagsDistance = {["Enabled"] = false}
		local NameTagsDrawing = {["Enabled"] = false}
		local NameTagsBackground = {["Enabled"] = true}
		local NameTagsScale = {["Value"] = 10}
		local NameTagsFont = {["Value"] = "SourceSans"}
		local NameTagsTeammates = {["Enabled"] = true}
		local fontitems = {"SourceSans"}
		local NameTags = GuiLibrary["ObjectsThatCanBeSaved"]["RenderWindow"]["Api"].CreateOptionsButton({
			["Name"] = "NameTags", 
			["Function"] = function(callback) 
				if callback then
					BindToRenderStep("NameTags", 500, function()
						for i,plr in pairs(players:GetChildren()) do
							local thing
							if NameTagsDrawing["Enabled"] then
								if nametagsfolderdrawing[plr.Name] then
									thing = nametagsfolderdrawing[plr.Name]
									thing.Text.Visible = false
									thing.BG.Visible = false
								else
									nametagsfolderdrawing[plr.Name] = {}
									nametagsfolderdrawing[plr.Name].Text = Drawing.new("Text")
									nametagsfolderdrawing[plr.Name].Text.Size = 17	
									nametagsfolderdrawing[plr.Name].Text.Font = 0
									nametagsfolderdrawing[plr.Name].Text.Text = ""
									nametagsfolderdrawing[plr.Name].Text.ZIndex = 2
									nametagsfolderdrawing[plr.Name].BG = Drawing.new("Square")
									nametagsfolderdrawing[plr.Name].BG.Filled = true
									nametagsfolderdrawing[plr.Name].BG.Transparency = 0.5
									nametagsfolderdrawing[plr.Name].BG.Color = Color3.new(0, 0, 0)
									nametagsfolderdrawing[plr.Name].BG.ZIndex = 1
									thing = nametagsfolderdrawing[plr.Name]
								end

								if isAlive(plr) and plr ~= lplr and (NameTagsTeammates["Enabled"] or shared.vapeteamcheck(plr)) then
									local headPos, headVis = cam:WorldToViewportPoint((plr.Character.HumanoidRootPart:GetRenderCFrame() * CFrame.new(0, plr.Character.Head.Size.Y + plr.Character.HumanoidRootPart.Size.Y, 0)).Position)

									if headVis then
										local displaynamestr = (NameTagsDisplayName["Enabled"] and plr.DisplayName ~= nil and plr.DisplayName or plr.Name)
										local blocksaway = math.floor(((plr.isAlive and plr.character.HumanoidRootPart.Position or Vector3.new(0,0,0)) - plr.Character.HumanoidRootPart.Position).magnitude / 3)
										local color = HealthbarColorTransferFunction(plr.Character.Humanoid.Health / plr.Character.Humanoid.MaxHealth)
										thing.Text.Text = (NameTagsDistance["Enabled"] and plr.isAlive and '['..blocksaway..'] ' or '')..displaynamestr..(NameTagsHealth["Enabled"] and ' '..math.floor(plr.Character.Humanoid.Health).."" or '')
										thing.Text.Size = 17 * (NameTagsScale["Value"] / 10)
										thing.Text.Color = getPlayerColor(plr) or Color3.fromHSV(NameTagsColor["Hue"], NameTagsColor["Sat"], NameTagsColor["Value"])
										thing.Text.Visible = headVis
										thing.Text.Font = (math.clamp((table.find(fontitems, NameTagsFont["Value"]) or 1) - 1, 0, 3))
										thing.Text.Position = floorpos(Vector2.new(headPos.X - thing.Text.TextBounds.X / 2, (headPos.Y - thing.Text.TextBounds.Y)))
										thing.BG.Visible = headVis and NameTagsBackground["Enabled"]
										thing.BG.Size = floorpos(Vector2.new(thing.Text.TextBounds.X + 4, thing.Text.TextBounds.Y))
										thing.BG.Position = floorpos(Vector2.new((headPos.X - 2) - thing.Text.TextBounds.X / 2, (headPos.Y - thing.Text.TextBounds.Y) + 1.5))
									end
								end
							else
								if NameTagsFolder:FindFirstChild(plr.Name) then
									thing = NameTagsFolder[plr.Name]
									thing.Visible = false
								else
									thing = Instance.new("TextLabel")
									thing.BackgroundTransparency = 0.5
									thing.BackgroundColor3 = Color3.new(0, 0, 0)
									thing.BorderSizePixel = 0
									thing.Visible = false
									thing.RichText = true
									thing.Name = plr.Name
									thing.Font = Enum.Font.SourceSans
									thing.TextSize = 14
									if plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character:FindFirstChild("HumanoidRootPart") then
										local rawText = (NameTagsDisplayName["Enabled"] and plr.DisplayName ~= nil and plr.DisplayName or plr.Name)
										if NameTagsHealth["Enabled"] then
											rawText = (NameTagsDisplayName["Enabled"] and plr.DisplayName ~= nil and plr.DisplayName or plr.Name).." "..math.floor(plr.Character.Humanoid.Health)
										end
										local color = HealthbarColorTransferFunction(plr.Character.Humanoid.Health / plr.Character.Humanoid.MaxHealth)
										local modifiedText = (NameTagsDistance["Enabled"] and plr.isAlive and '<font color="rgb(85, 255, 85)">[</font>'..math.floor((plr.character.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).magnitude)..'<font color="rgb(85, 255, 85)">]</font> ' or '')..(NameTagsDisplayName["Enabled"] and plr.DisplayName ~= nil and plr.DisplayName or plr.Name)..(NameTagsHealth["Enabled"] and ' <font color="rgb('..tostring(math.floor(color.R * 255))..','..tostring(math.floor(color.G * 255))..','..tostring(math.floor(color.B * 255))..')">'..math.floor(plr.Character.Humanoid.Health).."</font>" or '')
										local nametagSize = game:GetService("TextService"):GetTextSize(rawText, thing.TextSize, thing.Font, Vector2.new(100000, 100000))
										thing.Size = UDim2.new(0, nametagSize.X + 4, 0, nametagSize.Y)
										thing.Text = modifiedText
									else
										local nametagSize = game:GetService("TextService"):GetTextSize(plr.Name, thing.TextSize, thing.Font, Vector2.new(100000, 100000))
										thing.Size = UDim2.new(0, nametagSize.X + 4, 0, nametagSize.Y)
										thing.Text = plr.Name
									end
									thing.TextColor3 = getPlayerColor(plr) or Color3.fromHSV(NameTagsColor["Hue"], NameTagsColor["Sat"], NameTagsColor["Value"])
									thing.Parent = NameTagsFolder
								end

								if isAlive(plr) and plr ~= lplr and (NameTagsTeammates["Enabled"] or shared.vapeteamcheck(plr)) then
									local headPos, headVis = cam:WorldToViewportPoint((plr.Character.HumanoidRootPart:GetRenderCFrame() * CFrame.new(0, plr.Character.Head.Size.Y + plr.Character.HumanoidRootPart.Size.Y, 0)).Position)
									headPos = headPos

									if headVis then
										local rawText = (NameTagsDistance["Enabled"] and plr.Character.isAlive and "["..math.floor((plr.character.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).magnitude).."] " or "")..(NameTagsDisplayName["Enabled"] and plr.DisplayName ~= nil and plr.DisplayName or plr.Name)..(NameTagsHealth["Enabled"] and " "..math.floor(plr.Character.Humanoid.Health) or "")
										local color = HealthbarColorTransferFunction(plr.Character.Humanoid.Health / plr.Character.Humanoid.MaxHealth)
										local modifiedText = (NameTagsDistance["Enabled"] and plr.isAlive and '<font color="rgb(85, 255, 85)">[</font><font color="rgb(255, 255, 255)">'..math.floor((plr.character.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).magnitude)..'</font><font color="rgb(85, 255, 85)">]</font> ' or '')..(NameTagsDisplayName["Enabled"] and plr.DisplayName ~= nil and plr.DisplayName or plr.Name)..(NameTagsHealth["Enabled"] and ' <font color="rgb('..tostring(math.floor(color.R * 255))..','..tostring(math.floor(color.G * 255))..','..tostring(math.floor(color.B * 255))..')">'..math.floor(plr.Character.Humanoid.Health).."</font>" or '')
										local nametagSize = game:GetService("TextService"):GetTextSize(rawText, thing.TextSize, thing.Font, Vector2.new(100000, 100000))
										thing.Size = UDim2.new(0, nametagSize.X + 4, 0, nametagSize.Y)
										thing.Text = modifiedText
										thing.Font = Enum.Font[NameTagsFont["Value"]]
										thing.TextSize = 14 * (NameTagsScale["Value"] / 10)
										thing.BackgroundTransparency = NameTagsBackground["Enabled"] and 0.5 or 1
										thing.TextColor3 = getPlayerColor(plr) or Color3.fromHSV(NameTagsColor["Hue"], NameTagsColor["Sat"], NameTagsColor["Value"])
										thing.Visible = headVis
										thing.Position = UDim2.new(0, headPos.X - thing.Size.X.Offset / 2, 0, (headPos.Y - thing.Size.Y.Offset) - 36)
									end
								end
							end
						end
					end)
				else
					UnbindFromRenderStep("NameTags")
					NameTagsFolder:ClearAllChildren()
					for i,v in pairs(nametagsfolderdrawing) do 
						pcall(function()
							nametagsfolderdrawing[i].Text:Remove()
							nametagsfolderdrawing[i].BG:Remove()
							nametagsfolderdrawing[i] = nil
						end)
					end
				end
			end,
			["HoverText"] = "Renders nametags on entities through walls."
		})
		for i,v in pairs(Enum.Font:GetEnumItems()) do 
			if v.Name ~= "SourceSans" then 
				table.insert(fontitems, v.Name)
			end
		end
		NameTagsFont = NameTags.CreateDropdown({
			["Name"] = "Font",
			["List"] = fontitems,
			["Function"] = function() end,
		})
		NameTagsColor = NameTags.CreateColorSlider({
			["Name"] = "Player Color", 
			["Function"] = function(val) end
		})
		NameTagsScale = NameTags.CreateSlider({
			["Name"] = "Scale",
			["Function"] = function(val) end,
			["Default"] = 10,
			["Min"] = 1,
			["Max"] = 50
		})
		NameTagsBackground = NameTags.CreateToggle({
			["Name"] = "Background", 
			["Function"] = function() end,
			["Default"] = true
		})
		NameTagsDisplayName = NameTags.CreateToggle({
			["Name"] = "Use Display Name", 
			["Function"] = function() end,
			["Default"] = true
		})
		NameTagsHealth = NameTags.CreateToggle({
			["Name"] = "Health", 
			["Function"] = function() end
		})
		NameTagsDistance = NameTags.CreateToggle({
			["Name"] = "Distance", 
			["Function"] = function() end
		})
		 
	end)

	runcode(function()
		local Panic = GuiLibrary["ObjectsThatCanBeSaved"]["UtilityWindow"]["Api"].CreateOptionsButton({
			["Name"] = "Panic", 
			["Function"] = function(callback)
				if callback then
					for i,v in pairs(GuiLibrary["ObjectsThatCanBeSaved"]) do
						if v["Type"] == "Button" or v["Type"] == "OptionsButton" then
							if v["Api"]["Enabled"] then
								v["Api"]["ToggleButton"]()
							end
						end
					end
				end
			end
		})
		 
	end) 

	runcode(function()
		local XrayAdd
		local XrayTransparency = {["Value"] = 50}
		local Xray = GuiLibrary["ObjectsThatCanBeSaved"]["WorldWindow"]["Api"].CreateOptionsButton({
			["Name"] = "Xray", 
			["Function"] = function(callback) 
				if callback then
					XrayAdd = workspace.DescendantAdded:connect(function(v)
						if v:IsA("BasePart") and not v.Parent:FindFirstChild("Humanoid") and not v.Parent.Parent:FindFirstChild("Humanoid") then
							v.LocalTransparencyModifier = XrayTransparency.Value / 100
						end
					end)
					for i, v in pairs(workspace:GetDescendants()) do
						if v:IsA("BasePart") and not v.Parent:FindFirstChild("Humanoid") and not v.Parent.Parent:FindFirstChild("Humanoid") then
							v.LocalTransparencyModifier = XrayTransparency.Value / 100
						end
					end
				else
					for i, v in pairs(workspace:GetDescendants()) do
						if v:IsA("BasePart") and not v.Parent:FindFirstChild("Humanoid") and not v.Parent.Parent:FindFirstChild("Humanoid") then
							v.LocalTransparencyModifier = 0
						end
					end
					XrayAdd:Disconnect()
				end
			end
		})
		XrayTransparency = Xray.CreateSlider({
			["Name"] = "Transparency", 
			["Min"] = 1,
			["Max"] = 100, 
			["Function"] = function(val) end,
			["Default"] = 50
		})
		 
	end)

	runcode(function()
		local speedval = {["Value"] = 1}
		local speedmethod = {["Value"] = "AntiCheat A"}
		local speedmovemethod = {["Value"] = "MoveDirection"}
		local speeddelay = {["Value"] = 0.7}
		local speedwallcheck = {["Enabled"] = true}
		local speedjump = {["Enabled"] = false}
		local speedjumpheight = {["Value"] = 20}
		local speedjumpalways = {["Enabled"] = false}
		local speedup
		local speeddown
		local oldwalkspeed
		local w = 0
		local s = 0
		local a = 0
		local d = 0
		local bodyvelo
		local speeddelayval = tick()

		local speed = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
			["Name"] = "Speed", 
			["Function"] = function(callback)
				if callback then
					speeddown = game:GetService("UserInputService").InputBegan:connect(function(input1)
						if game:GetService("UserInputService"):GetFocusedTextBox() == nil then
							if input1.KeyCode == Enum.KeyCode.W then
								w = true
							end
							if input1.KeyCode == Enum.KeyCode.S then
								s = true
							end
							if input1.KeyCode == Enum.KeyCode.A then
								a = true
							end
							if input1.KeyCode == Enum.KeyCode.D then
								d = true
							end
						end
					end)
					speedup = game:GetService("UserInputService").InputEnded:connect(function(input1)
						if input1.KeyCode == Enum.KeyCode.W then
							w = false
						end
						if input1.KeyCode == Enum.KeyCode.S then
							s = false
						end
						if input1.KeyCode == Enum.KeyCode.A then
							a = false
						end
						if input1.KeyCode == Enum.KeyCode.D then
							d = false
						end
					end)
					BindToStepped("Speed", 1, function(time, delta)
						if isAlive(game.Players.LocalPlayer) then
							local movevec = (speedmovemethod["Value"] == "Manual" and (not (w or s or a or d)) and Vector3.new(0, 0, 0) or game.Players.LocalPlayer.character.Humanoid.MoveDirection).Unit
							movevec = movevec == movevec and movevec or Vector3.new(0, 0, 0)
							if speedmethod["Value"] == "CFrame" then
								local newpos = (movevec * (math.clamp(speedval["Value"] - game.Players.LocalPlayer.character.Humanoid.WalkSpeed, 0, 1000000000) * delta))
								if speedwallcheck["Enabled"] then
									local raycastparameters = RaycastParams.new()
									raycastparameters.FilterDescendantsInstances = {lplr.Character}
									local ray = workspace:Raycast(game.Players.LocalPlayer.character.HumanoidRootPart.Position, newpos, raycastparameters)
									if ray then newpos = (ray.Position - game.Players.LocalPlayer.character.HumanoidRootPart.Position) end
								end
								game.Players.LocalPlayer.character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.character.HumanoidRootPart.CFrame + newpos
							elseif speedmethod["Value"] == "TP" then
								if speeddelayval <= tick() then
									speeddelayval = tick() + (speeddelay["Value"] / 10)
									local newpos = (movevec * (math.clamp(speedval["Value"] / 1.5 - game.Players.LocalPlayer.character.Humanoid.WalkSpeed, 0, 1000000000)))
									if speedwallcheck["Enabled"] then
										local raycastparameters = RaycastParams.new()
										raycastparameters.FilterDescendantsInstances = {lplr.Character}
										local ray = workspace:Raycast(game.Players.LocalPlayer.character.HumanoidRootPart.Position, newpos, raycastparameters)
										if ray then newpos = (ray.Position - game.Players.LocalPlayer.character.HumanoidRootPart.Position) end
									end
									game.Players.LocalPlayer.character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.character.HumanoidRootPart.CFrame + newpos
								end
							end
						end
					end)
				else
					speeddelayval = 0
					if speedup then
						speedup:Disconnect()
					end
					if speeddown then
						speeddown:Disconnect()
					end
					UnbindFromStepped("Speed")
				end
			end,
			["ExtraText"] = function() return speedmethod["Value"] end
		})
		speedmethod = speed.CreateDropdown({
			["Name"] = "Mode", 
			["List"] = {"CFrame", "TP"},
			["Function"] = function(val)
				speeddelay["Object"].Visible = val == "TP"
			end
		})
		speedmovemethod = speed.CreateDropdown({
			["Name"] = "Movement", 
			["List"] = {"MoveDirection", "Manual"},
			["Function"] = function(val) end
		})
		speedval = speed.CreateSlider({
			["Name"] = "Speed", 
			["Min"] = 1,
			["Max"] = 100, 
			["Function"] = function(val) end
		})
		speeddelay = speed.CreateSlider({
			["Name"] = "Delay", 
			["Min"] = 1,
			["Max"] = 50, 
			["Function"] = function(val)
				speeddelayval = tick() + (val / 10)
			end,
			["Default"] = 7
		})
		speedwallcheck = speed.CreateToggle({
			["Name"] = "Wall Check",
			["Function"] = function() end,
			["Default"] = true
		})
		 
	end)

	runcode(function()
		local ChatSpammer = {["Enabled"] = false}
		local ChatSpammerDelay = {["Value"] = 10}
		local ChatSpammerHideWait = {["Enabled"] = true}
		local ChatSpammerMessages = {["ObjectList"] = {}}
		local chatspammerfirstexecute = true
		local chatspammerhook = false
		local oldchanneltab
		local oldchannelfunc
		local oldchanneltabs = {}
		local waitnum = 0
		ChatSpammer = GuiLibrary["ObjectsThatCanBeSaved"]["UtilityWindow"]["Api"].CreateOptionsButton({
			["Name"] = "ChatSpammer",
			["Function"] = function(callback)
				if callback then
					if chatspammerfirstexecute then
						lplr.PlayerGui:WaitForChild("Chat", 10)
					end
					if lplr.PlayerGui:FindFirstChild("Chat") and lplr.PlayerGui.Chat:FindFirstChild("Frame") and lplr.PlayerGui.Chat.Frame:FindFirstChild("ChatChannelParentFrame") and game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents") then
						if chatspammerhook == false then
							spawn(function()
								chatspammerhook = true
								for i,v in pairs(getconnections(game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.OnNewMessage.OnClientEvent)) do
									if v.Function and #debug.getupvalues(v.Function) > 0 and type(debug.getupvalues(v.Function)[1]) == "table" and getmetatable(debug.getupvalues(v.Function)[1]) and getmetatable(debug.getupvalues(v.Function)[1]).GetChannel then
										oldchanneltab = getmetatable(debug.getupvalues(v.Function)[1])
										oldchannelfunc = getmetatable(debug.getupvalues(v.Function)[1]).GetChannel
										getmetatable(debug.getupvalues(v.Function)[1]).GetChannel = function(Self, Name)
											local tab = oldchannelfunc(Self, Name)
											if tab and tab.AddMessageToChannel then
												local addmessage = tab.AddMessageToChannel
												if oldchanneltabs[tab] == nil then
													oldchanneltabs[tab] = tab.AddMessageToChannel
												end
												tab.AddMessageToChannel = function(Self2, MessageData)
													if MessageData.MessageType == "System" then
														if MessageData.Message:find("You must wait") and ChatSpammer["Enabled"] then
															return nil
														end
													end
													return addmessage(Self2, MessageData)
												end
											end
											return tab
										end
									end
								end
							end)
						end
						spawn(function()
							repeat
								if ChatSpammer["Enabled"] then
									pcall(function()
										game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer((#ChatSpammerMessages["ObjectList"] > 0 and ChatSpammerMessages["ObjectList"][math.random(1, #ChatSpammerMessages["ObjectList"])] or "uhhh"), "All")
									end)
								end
								if waitnum ~= 0 then
									wait(waitnum)
									waitnum = 0
								else
									wait(ChatSpammerDelay["Value"] / 10)
								end
							until ChatSpammer["Enabled"] == false
						end)				
					else
						createwarning("ChatSpammer", "Default chat not found.", 3)
						if ChatSpammer["Enabled"] then
							ChatSpammer["ToggleButton"](false)
						end
					end
				else
					waitnum = 0
				end
			end,
			["HoverText"] = "Spams chat with text of your choice (Default Chat Only)"
		})
		ChatSpammerDelay = ChatSpammer.CreateSlider({
			["Name"] = "Delay",
			["Min"] = 1,
			["Max"] = 50,
			["Default"] = 10,
			["Function"] = function() end
		})
		ChatSpammerHideWait = ChatSpammer.CreateToggle({
			["Name"] = "Hide Wait Message",
			["Function"] = function() end,
			["Default"] = true
		})
		ChatSpammerMessages = ChatSpammer.CreateTextList({
			["Name"] = "Message",
			["TempText"] = "message to spam",
			["Function"] = function() end
		})
		 
	end)

	runcode(function()
		local NoSlowDown = {["Enabled"] = false}

		NoSlowDown = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
			["Name"] = "NoSlowdown",
			["Function"] = function(callback)
				if callback then
					if NoSlowDown.Enabled == true then
						local newindex = getrawmetatable(game).__newindex;
						setreadonly(getrawmetatable(game),false);

						getrawmetatable(game).__newindex = function(t,i,v)
							if i=="WalkSpeed" and not checkcaller() and NoSlowDown.Enabled == true then
								return newindex(t,i,16);
							end
							return newindex(t,i,v);
						end
					end
				else
				end
			end,
			["HoverText"] = "cant be slown on water",
			["Default"] = false,
			["ExtraText"] = function() return " " end
		})
		 
	end)
	runcode(function()
		local AutoDrop = {["Enabled"] = false}
		local AutoDropItem = {["Value"] = ""}

		AutoDrop = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
			["Name"] = "AutoDrop",
			["Function"] = function(callback)
				if callback then
					while game:GetService("RunService").Heartbeat:Wait() and AutoDrop.Enabled == true do
						game:GetService("ReplicatedStorage").Events.DropBagItem:FireServer(AutoDropItem.Value)
					end
				else
				end
			end,
			["HoverText"] = "Auto drop if you need to drop items fast and your tired",
			["Default"] = false,
			["ExtraText"] = function() return " " end
		})
		AutoDropItem = AutoDrop.CreateTextBox({
			["Name"] = "Item",
			["TempText"] = "Item Name",
			["HoverText"] = "drop the item you want"
		})
		 
	end)
	runcode(function()
		local Blink = {["Enabled"] = false}

		Blink = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
			["Name"] = "Blink",
			["Function"] = function(callback)
				if callback then
					game:GetService("NetworkClient"):SetOutgoingKBPSLimit(0.01)
					if Blink["Enabled"] == true then 
						settings():GetService("NetworkSettings").IncomingReplicationLag = 99999999
					end
				else
					game:GetService("NetworkClient"):SetOutgoingKBPSLimit(math.huge)
					if Blink["Enabled"] == false then 
						settings():GetService("NetworkSettings").IncomingReplicationLag = 0
					end
				end
			end,
			["HoverText"] = "Chokes all incoming or outgoing packets",
			["Default"] = false,
			["ExtraText"] = function() return " " end
		})
		 
	end)
	
	
	runcode(function()
		local AutoPlant = {["Enabled"] = false}
		local PlantType = {["Value"] = ""}

		AutoPlant = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
			["Name"] = "AutoPlant",
			["Function"] = function(callback)
				if callback then
					while wait() and AutoPlant.Enabled == true do
						for i,v in pairs(workspace.Deployables:GetChildren()) do
							if v.Name == "Plant Box" then
								local distance = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.Reference.Position).Magnitude

								if distance <= 10 then
									local args = {
										[1] = v,
										[2] = "Bloodfruit"
									}

									game:GetService("ReplicatedStorage").Events.InteractStructure:FireServer(unpack(args))
								end
							end
						end
					end
				else
				end
			end,
			["HoverText"] = "Plant Faster oh yea they can overlap",
			["Default"] = false,
			["ExtraText"] = function() return " " end
		})
		PlantType = AutoPlant.CreateDropdown({
			["Name"] = "Select Fruit",
			["List"] = {
				"Apple", 
				"Barley",
				"Cloudberry",
				"Sunfruit",
				"Berry",
				"Coconut",
				"Pear",
				"Bloodfruit",
				"Orange",
				"Bluefruit",
			},
			["Function"] = function(val)
			end
		})
		 
	end)
	runcode(function()
		local AutoBreak = {["Enabled"] = false}

		AutoBreak = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
			["Name"] = "AutoBreak",
			["Function"] = function(callback)
				if callback then
					local mouse = game:GetService("Players").LocalPlayer:GetMouse()
					local breaking=false
					mouse.Button1Down:connect(function()
						breaking = true
						while breaking and AutoBreak.Enabled == true and wait(0.05) do
							local part = game:GetService("Players").LocalPlayer:GetMouse().Target
							local one = game:GetService("ReplicatedStorage").RelativeTime.Value
							local two = {part,part,part,part}
							game:GetService("ReplicatedStorage").Events.SwingTool:FireServer(one, two)
						end
					end)
					mouse.Button1Down:connect(function(key)
						breaking = false
					end)
				else
				end
			end,
			["HoverText"] = "Break resources faster",
			["Default"] = false,
			["ExtraText"] = function() return " " end
		})
		 
	end)

	runcode(function()
		local AutoPickup = {["Enabled"] = false}
		local pickupRange = 50

		AutoPickup = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
			["Name"] = "AutoPickup",
			["Function"] = function(callback)
				if callback then
					while game:GetService("RunService").Heartbeat:Wait() and AutoPickup.Enabled == true do
						local MainCharacter = game.Workspace.Characters:FindFirstChild(game.Players.LocalPlayer.Name)
						if AutoPickup.Enabled == true then
							for i,v in pairs(game.Workspace.Items:GetChildren()) do
								if v.ClassName == "Model" then
									for _,p in pairs(v:GetChildren()) do
										if p.ClassName == "Part" or p.ClassName == "UnionOperation" and AutoPickup.Enabled == true then
											local MainCharacter = game.Workspace.Characters:FindFirstChild(game.Players.LocalPlayer.Name)
											if (MainCharacter.HumanoidRootPart.Position - p.Position).magnitude < pickupRange then
												game:GetService("ReplicatedStorage").Events.PickupItem:InvokeServer(v, v.ClassName)
											end
										end
									end
								end
							end
						end
					end
				else
				end
			end,
			["HoverText"] = "Auto pickups the item that is near you",
			["Default"] = false,
			["ExtraText"] = function() return " " end
		})

		AutoPickup.CreateSlider({
			["Name"] = "Distance",
			["Min"] = 5,
			["Max"] = 25,
			["Function"] = function(val)
				pickupRange = val
			end,
			["HoverText"] = "pickup everything in a 15 radius nah lets make it 25",
			["Default"] = 10
		})
		 
	end)
	runcode(function()
		local AutoEat = {["Enabled"] = false}
		local AutoEatItem = {["Value"] = ""}
		local AutoEatCheck = {["Value"] = 90}

		AutoEat = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
			["Name"] = "AutoEat",
			["Function"] = function(callback)
				if callback then
					while game:GetService("RunService").Heartbeat:Wait() and AutoEat.Enabled == true do
						local GetHunger = game.Players.LocalPlayer.PlayerGui.MainGui.Panels.Toolbar.Stats.PlayerStats.Hunger.Background.Size.X.Scale + game.Players.LocalPlayer.PlayerGui.MainGui.Panels.Toolbar.Stats.PlayerStats.Hunger.Background.Slider.Size.X.Scale * 99
						print(GetHunger)

						if GetHunger <= AutoEatCheck.Value then

							local args = {
								[1] = AutoEatItem.Value
							}

							game:GetService("ReplicatedStorage").Events.UseBagItem:FireServer(unpack(args))

						end
					end
				else
				end
			end,
			["HoverText"] = "kinda good for being afk",
			["Default"] = false,
			["ExtraText"] = function() return " " end
		})
		AutoEatItem = AutoEat.CreateTextBox({
			["Name"] = "Item",
			["TempText"] = "Item Name",
			["HoverText"] = "eat the item you want to eat"
		})
		AutoEatCheck = AutoEat.CreateSlider({
			["Name"] = "Hunger Check",
			["Min"] = 1,
			["Max"] = 99,
			["Function"] = function(val)
			end,
			["HoverText"] = "eat when below the ammount of hunger",
			["Default"] = 90
		})
		 
	end)
	runcode(function()
		local AutoCraft = {["Enabled"] = false}
		local AutoCraftItem = {["Value"] = ""}

		AutoCraft = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
			["Name"] = "AutoCraft",
			["Function"] = function(callback)
				if callback then
					while game:GetService("RunService").Heartbeat:Wait() and AutoCraft.Enabled == true do
						game:GetService("ReplicatedStorage").Events.DropBagItem:FireServer(AutoCraftItem.Value)
					end
				else
				end
			end,
			["HoverText"] = "craft items kinda useless",
			["Default"] = false,
			["ExtraText"] = function() return " " end
		})
		AutoCraftItem = AutoCraft.CreateTextBox({
			["Name"] = "Item",
			["TempText"] = "Item Name",
			["HoverText"] = "craft the item you want"
		})
		 
	end)
	runcode(function()
		local Swim = {["Enabled"] = false}
		local swimconnection
		local oldgravity

		Swim = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
			["Name"] = "Swim",
			["Function"] = function(callback)
				if callback then
					oldgravity = workspace.Gravity
					if isAlive(game.Players.LocalPlayer) then
						workspace.Gravity = 0
						local enums = Enum.HumanoidStateType:GetEnumItems()
						table.remove(enums, table.find(enums, Enum.HumanoidStateType.None))
						for i,v in pairs(enums) do
							game.Players.LocalPlayer.character.Humanoid:SetStateEnabled(v, false)
						end
						game.Players.LocalPlayer.character.Humanoid:ChangeState(Enum.HumanoidStateType.Swimming)
						BindToStepped("Swim", 1, function()
							game.Players.LocalPlayer.character.HumanoidRootPart.Velocity = ((game.Players.LocalPlayer.character.Humanoid.MoveDirection ~= Vector3.new(0, 0, 0) or game.Players.LocalPlayer.character.Humanoid.Jump) and game.Players.LocalPlayer.character.HumanoidRootPart.Velocity or Vector3.new(0, 0, 0))
						end)
					end
				else 
					workspace.Gravity = oldgravity
					UnbindFromStepped("Swim")
					if isAlive(game.Players.LocalPlayer) then
						local enums = Enum.HumanoidStateType:GetEnumItems()
						table.remove(enums, table.find(enums, Enum.HumanoidStateType.None))
						for i,v in pairs(enums) do
							game.Players.LocalPlayer.character.Humanoid:SetStateEnabled(v, true)
						end
					end
				end
			end
		})
		 
	end)

	runcode(function()
		local oldgrav
		local gravchanged = false
		local gravconnection
		local grav = {["Enabled"] = false}
		local gravslider = {["Value"] = 100}
		grav = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
			["Name"] = "Gravity",
			["Function"] = function(callback)
				if callback then
					oldgrav = workspace.Gravity
					workspace.Gravity = gravslider["Value"]
				else
					workspace.Gravity = oldgrav
				end
			end,
			["HoverText"] = "Changes workspace gravity"
		})
		gravslider = grav.CreateSlider({
			["Name"] = "Gravity",
			["Min"] = 0,
			["Max"] = 192,
			["Function"] = function(val) 
				if grav["Enabled"] then
					workspace.Gravity = val
				end
			end,
			["Default"] = 192
		})
		 
	end)

	runcode(function()
		local AutoLeave = {["Enabled"] = false}

		local Developers = true
		local Moderators = true
		local Shamans = true
		local Testers = false

		AutoLeave = GuiLibrary["ObjectsThatCanBeSaved"]["UtilityWindow"]["Api"].CreateOptionsButton({
			["Name"] = "AutoLeave",
			["Function"] = function(callback) if callback then
					while game:GetService("RunService").Heartbeat:Wait() and AutoLeave.Enabled == true do
						for i,v in pairs(game.Players:GetChildren()) do
							local GroupID = 2841240
							local plrRole = v:GetRoleInGroup(GroupID)

							if plrRole == "TESTER" and Testers == true then
								local msgbox = messagebox(tostring(v.Name),tostring(v.Name.." was a "..plrRole),4)
								setfpscap(math.huge)
							end
							if plrRole == "SHAMAN" and Shamans == true then
								local msgbox = messagebox(tostring(v.Name),tostring(v.Name.." was a "..plrRole),4)
								setfpscap(math.huge)
							end
							if plrRole == "JUNIOR MODERATOR" and Moderators == true then
								local msgbox = messagebox(tostring(v.Name),tostring(v.Name.." was a "..plrRole),4)
								setfpscap(math.huge)
							end
							if plrRole == "MODERATOR" and Moderators == true then
								local msgbox = messagebox(tostring(v.Name),tostring(v.Name.." was a "..plrRole),4)
								setfpscap(math.huge)
							end
							if plrRole == "COMMUNITY MANAGER" and Developers == true then
								local msgbox = messagebox(tostring(v.Name),tostring(v.Name.." was a "..plrRole),4)
								setfpscap(math.huge)
							end
							if plrRole == "CO-DEV" and Developers == true then
								local msgbox = messagebox(tostring(v.Name),tostring(v.Name.." was a "..plrRole),4)
								setfpscap(math.huge)
							end
							if plrRole == "SOYBEEN" and Developers == true then
								local msgbox = messagebox(tostring(v.Name),tostring(v.Name.." was a "..plrRole),4)
								setfpscap(math.huge)
							end
						end
					end
				else
				end
			end,
			["HoverText"] = "kicks you when someone has this in the group", 
			["Default"] = false,
			["ExtraText"] = function() return " Placeholder" end
		})

		AutoLeave.CreateToggle({
			["Name"] = "Developers",
			["HoverText"] = "leave on developers",
			["Function"] = function(callback)
				if callback then
					Developers= true
				else
					Developers= false
				end
			end,
			["Default"] = true
		})
		AutoLeave.CreateToggle({
			["Name"] = "Moderators",
			["HoverText"] = "leave on moderators",
			["Function"] = function(callback)
				if callback then
					Moderators= true
				else
					Moderators= false
				end
			end,
			["Default"] = true
		})
		AutoLeave.CreateToggle({
			["Name"] = "Shamans",
			["HoverText"] = "leaves on shamans",
			["Function"] = function(callback)
				if callback then
					Shamans= true
				else
					Shamans= false
				end
			end,
			["Default"] = false
		})
		AutoLeave.CreateToggle({
			["Name"] = "Testers",
			["HoverText"] = "leaves on testers",
			["Function"] = function(callback)
				if callback then
					Testers= true
				else
					Testers= false
				end
			end,
			["Default"] = false
		})
		 
	end)

	runcode(function()
		local GlitchedAvatar = {["Enabled"] = false}

		GlitchedAvatar = GuiLibrary["ObjectsThatCanBeSaved"]["UtilityWindow"]["Api"].CreateOptionsButton({
			["Name"] = "Glitched Avatar",
			["Function"] = function(callback) if callback then
					while wait(0.3) and GlitchedAvatar.Enabled == true do
						local r = math.random(1, 18)
						if r == 1 then
							local args = {
								[1] = "skin",
								[2] = "Dark Brown"
							}
							game:GetService("ReplicatedStorage").Events.CosmeticChange:FireServer(unpack(args))
						end
						if r == 2 then
							local args = {
								[1] = "hair",
								[2] = "Crazyhair"
							}
							game:GetService("ReplicatedStorage").Events.CosmeticChange:FireServer(unpack(args))
						end
						if r == 3 then

							local args = {
								[1] = "face",
								[2] = "Beardy"
							}
							game:GetService("ReplicatedStorage").Events.CosmeticChange:FireServer(unpack(args))
						end
						if r == 4 then
							local args = {
								[1] = "skin",
								[2] = "Pale"
							}
							game:GetService("ReplicatedStorage").Events.CosmeticChange:FireServer(unpack(args))
						end
						if r == 5 then
							local args = {
								[1] = "face",
								[2] = "Freckles"
							}
							game:GetService("ReplicatedStorage").Events.CosmeticChange:FireServer(unpack(args))
						end
						if r == 6 then
							local args = {
								[1] = "hair",
								[2] = "Brown Girl"
							}
							game:GetService("ReplicatedStorage").Events.CosmeticChange:FireServer(unpack(args))
						end
						if r == 7 then
							local args = {
								[1] = "face",
								[2] = "Freckles"
							}
							game:GetService("ReplicatedStorage").Events.CosmeticChange:FireServer(unpack(args))
						end
						if r == 8 then
							local args = {
								[1] = "face",
								[2] = "Smile"
							}
							game:GetService("ReplicatedStorage").Events.CosmeticChange:FireServer(unpack(args))
						end
						if r == 9 then
							local args = {
								[1] = "face",
								[2] = "Unamused"
							}
							game:GetService("ReplicatedStorage").Events.CosmeticChange:FireServer(unpack(args))
						end
						if r == 10 then
							local args = {
								[1] = "face",
								[2] = "Smile"
							}
							game:GetService("ReplicatedStorage").Events.CosmeticChange:FireServer(unpack(args))
						end
						if r == 11 then
							local args = {
								[1] = "skin",
								[2] = "Light Brown"
							}
							game:GetService("ReplicatedStorage").Events.CosmeticChange:FireServer(unpack(args))
						end
						if r == 12 then
							local args = {
								[1] = "hair",
								[2] = "Crazyhair"
							}
							game:GetService("ReplicatedStorage").Events.CosmeticChange:FireServer(unpack(args))
						end
						if r == 13 then
							local args = {
								[1] = "face",
								[2] = "Cunning"
							}
							game:GetService("ReplicatedStorage").Events.CosmeticChange:FireServer(unpack(args))
						end
						if r == 14 then
							local args = {
								[1] = "skin",
								[2] = "White"
							}
							game:GetService("ReplicatedStorage").Events.CosmeticChange:FireServer(unpack(args))
						end
						if r == 15 then
							local args = {
								[1] = "hair",
								[2] = "none"
							}
							game:GetService("ReplicatedStorage").Events.CosmeticChange:FireServer(unpack(args))
						end
						if r == 16 then
							local args = {
								[1] = "hair",
								[2] = "Blonde Girl"
							}
							game:GetService("ReplicatedStorage").Events.CosmeticChange:FireServer(unpack(args))
						end
						if r == 17 then
							local args = {
								[1] = "skin",
								[2] = "Tan"
							}
							game:GetService("ReplicatedStorage").Events.CosmeticChange:FireServer(unpack(args))
						end
						if r == 18 then
							local args = {
								[1] = "hair",
								[2] = "Blonde Boy"
							}
							game:GetService("ReplicatedStorage").Events.CosmeticChange:FireServer(unpack(args))
						end
					end
				else

				end
			end,
			["HoverText"] = "changes your look kinda laggy so dont use maybe", 
			["Default"] = false,
			["ExtraText"] = function() return " Placeholder" end
		})
		 
	end)

	runcode(function()
		local CanLock = {["Enabled"] = false}

		CanLock = GuiLibrary["ObjectsThatCanBeSaved"]["UtilityWindow"]["Api"].CreateOptionsButton({
			["Name"] = "Cam Lock",
			["Function"] = function(callback) if callback then
					local args = {
						[1] = "camLock",
						[2] = true
					}

					game:GetService("ReplicatedStorage").Events.ToggleUserSetting:FireServer(unpack(args))

				else
					local args = {
						[1] = "camLock",
						[2] = false
					}

					game:GetService("ReplicatedStorage").Events.ToggleUserSetting:FireServer(unpack(args))

				end
			end,
			["HoverText"] = "toggle if you want your camera is locked or not", 
			["Default"] = false,
			["ExtraText"] = function() return " Placeholder" end
		})
		 
	end)

	runcode(function()
		local OpenCrate = {["Enabled"] = false}
		local CrateDelay = {["Value"] = 10}
		local KindOfCrate = {["Value"] = "Food Chest"}

		OpenCrate = GuiLibrary["ObjectsThatCanBeSaved"]["UtilityWindow"]["Api"].CreateOptionsButton({
			["Name"] = "AutoPurchaseChest",
			["Function"] = function(callback) if callback then
					while wait(CrateDelay.Value / 10) and OpenCrate.Enabled == true do
						local args = {
							[1] = KindOfCrate
						}

						game:GetService("ReplicatedStorage").Events.PurchaseChest:FireServer(unpack(args))

					end
				else
				end
			end,
			["HoverText"] = "keeps buying crates", 
			["Default"] = false,
			["ExtraText"] = function() return " Placeholder" end
		})
		CrateDelay = OpenCrate.CreateSlider({
			["Name"] = "Delay",
			["Min"] = 1,
			["Max"] = 50,
			["Function"] = function(val)
			end,
			["HoverText"] = "every 10 on the slider is 0.1 seconds",
			["Default"] = 10
		})
		KindOfCrate = OpenCrate.CreateDropdown({
			["Name"] = "Select Chest",
			["List"] = {"Food Chest", 
				"Resource Chest",
				"Essence Chest",
				"Crystal Chest",
				"Adurite Chest",
				"Magnetite Chest",
			},
			["Function"] = function(val)
			end
		})
		 
	end)

	runcode(function()
		local AutoInvite = {["Enabled"] = false}
		local InviteDelay = {["Value"] = 100}

		AutoInvite = GuiLibrary["ObjectsThatCanBeSaved"]["UtilityWindow"]["Api"].CreateOptionsButton({
			["Name"] = "AutoInvite",
			["Function"] = function(callback)
				if callback then
					while wait(InviteDelay.Value / 10) and AutoInvite.Enabled == true do
						for i,v in next, game.Players:GetChildren() do
							game:GetService("ReplicatedStorage").Events.TribeInvite:FireServer(v)
						end
					end
				else
				end
			end,
			["HoverText"] = "Auto pickups the item that is near you",
			["Default"] = false,
			["ExtraText"] = function() return " " end
		})

		InviteDelay = AutoInvite.CreateSlider({
			["Name"] = "Delay",
			["Min"] = 1,
			["Max"] = 50,
			["Function"] = function(val)
			end,
			["HoverText"] = "1 slider = 0.1 seconds",
			["Default"] = 10
		})
		 
	end)

	runcode(function()
		local AntiAfk = {["Enabled"] = false}

		AntiAfk = GuiLibrary["ObjectsThatCanBeSaved"]["UtilityWindow"]["Api"].CreateOptionsButton({
			["Name"] = "AntiAfk",
			["Function"] = function(callback) if callback then
					game:service'Players'.LocalPlayer.Idled:connect(function()
						if AntiAfk.Enabled == true then
							local bb = game:service'VirtualUser'
							bb:CaptureController()
							bb:ClickButton2(Vector2.new())
						end
					end)
				else
				end
			end,
			["HoverText"] = "stay in the game when your afk", 
			["Default"] = false,
			["ExtraText"] = function() return " Placeholder" end
		})
		 
	end)

	runcode(function()
		local MaxDistance = {["Enabled"] = false}
		local MaxDistanceVal = {["Value"] = 1000}
		MaxDistance = GuiLibrary["ObjectsThatCanBeSaved"]["RenderWindow"]["Api"].CreateOptionsButton({
			["Name"] = "MaxDistance",
			["Function"] = function(callback) if callback then
					while wait() and MaxDistance.Enabled == true do
						game.Players.LocalPlayer.CameraMaxZoomDistance = MaxDistanceVal.Value
					end

				else
					game.Players.LocalPlayer.CameraMaxZoomDistance = 400
				end
			end,
			["HoverText"] = "zoom out more farther",
			["Default"] = false,
			["ExtraText"] = function() return " Placeholder" end
		})
		MaxDistanceVal = MaxDistance.CreateSlider({
			["Name"] = "Distance",
			["Min"] = 400,
			["Max"] = 1000,
			["Function"] = function(val)
			end,
			["HoverText"] = "change your distance",
			["Default"] = 1000
		})
		 
	end)
	runcode(function()
		local FPSBoost = {["Enabled"] = false}
		FPSBoost = GuiLibrary["ObjectsThatCanBeSaved"]["RenderWindow"]["Api"].CreateOptionsButton({
			["Name"] = "FPSBoost",
			["Function"] = function(callback) if callback then
					setfpscap(90)
					if game.Workspace:FindFirstChild("Grass Decoration") then
						local Grass = game.Workspace:FindFirstChild("Grass Decoration")
						Grass.Parent = game.ReplicatedStorage
					end
				else
					setfpscap(60)
					if game.ReplicatedStorage:FindFirstChild("Grass Decoration") then
						local Grass = game.ReplicatedStorage:FindFirstChild("Grass Decoration")
						Grass.Parent = game.Workspace
					end
				end
			end,
			["HoverText"] = "boost your fps",
			["Default"] = false,
			["ExtraText"] = function() return " Placeholder" end
		})
		 
	end)
	runcode(function()
		local NoFog = {["Enabled"] = false}
		NoFog = GuiLibrary["ObjectsThatCanBeSaved"]["RenderWindow"]["Api"].CreateOptionsButton({
			["Name"] = "NoFog",
			["Function"] = function(callback) if callback then
					game.Lighting.FogEnd = 99999
				else
					game.Lighting.FogEnd = 2000
				end
			end,
			["HoverText"] = "removes the fog",
			["Default"] = false,
			["ExtraText"] = function() return " Placeholder" end
		})
		 
	end)

	runcode(function()
		local flyspeed = {["Value"] = 1}
		local flyverticalspeed = {["Value"] = 1}
		local flywall = {["Enabled"] = false}
		local flyupanddown = {["Enabled"] = true}
		local flymethod = {["Value"] = "Normal"}
		local flymovemethod = {["Value"] = "MoveDirection"}
		local flykeys = {["Value"] = "Space/LeftControl"}
		local flyplatformtoggle = {["Enabled"] = false}
		local flyplatformstanding = {["Enabled"] = true}
		local flyplatform
		local flyposy = 0
		local flyup = false
		local flydown = false
		local flypress
		local flyendpress
		local flyjumpcf = CFrame.new(0, 0, 0)
		local flyalivecheck = false
		local bodyvelofly
		local w = 0
		local s = 0
		local a = 0
		local d = 0
		local fly = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
			["Name"] = "Fly", 
			["Function"] = function(callback)
				if callback then
					if isAlive(game.Players.LocalPlayer) then
						flyposy = game.Players.LocalPlayer.character.HumanoidRootPart.CFrame.p.Y
						flyalivecheck = true
					end
					flypress = game:GetService("UserInputService").InputBegan:connect(function(input1)
						if game:GetService("UserInputService"):GetFocusedTextBox() == nil then
							if input1.KeyCode == Enum.KeyCode.W then
								w = -1
							end
							if input1.KeyCode == Enum.KeyCode.S then
								s = 1
							end
							if input1.KeyCode == Enum.KeyCode.A then
								a = -1
							end
							if input1.KeyCode == Enum.KeyCode.D then
								d = 1
							end
							if flyupanddown["Enabled"] then
								local divided = flykeys["Value"]:split("/")
								if input1.KeyCode == Enum.KeyCode[divided[1]] then
									flyup = true
								end
								if input1.KeyCode == Enum.KeyCode[divided[2]] then
									flydown = true
								end
							end
						end
					end)
					flyendpress = game:GetService("UserInputService").InputEnded:connect(function(input1)
						local divided = flykeys["Value"]:split("/")
						if input1.KeyCode == Enum.KeyCode.W then
							w = 0
						end
						if input1.KeyCode == Enum.KeyCode.S then
							s = 0
						end
						if input1.KeyCode == Enum.KeyCode.A then
							a = 0
						end
						if input1.KeyCode == Enum.KeyCode.D then
							d = 0
						end
						if input1.KeyCode == Enum.KeyCode[divided[1]] then
							flyup = false
						end
						if input1.KeyCode == Enum.KeyCode[divided[2]] then
							flydown = false
						end
					end)
					BindToStepped("Fly", 1, function(time, delta) 
						if isAlive(game.Players.LocalPlayer) then
							game.Players.LocalPlayer.character.Humanoid.PlatformStand = flyplatformstanding["Enabled"]
							if flyalivecheck == false then
								flyposy = game.Players.LocalPlayer.character.HumanoidRootPart.CFrame.p.Y
								flyalivecheck = true
							end
							local movevec = (flymovemethod["Value"] == "Manual" and (not (w or s or a or d)) and Vector3.new(0, 0, 0) or game.Players.LocalPlayer.character.Humanoid.MoveDirection).Unit
							movevec = movevec == movevec and movevec or Vector3.new(0, 0, 0)
							if flymethod["Value"] == "Normal" then
								if flyplatformstanding["Enabled"] then
									game.Players.LocalPlayer.character.HumanoidRootPart.CFrame = CFrame.new(game.Players.LocalPlayer.character.HumanoidRootPart.CFrame.p, game.Players.LocalPlayer.character.HumanoidRootPart.CFrame.p + cam.CFrame.lookVector)
									game.Players.LocalPlayer.character.HumanoidRootPart.RotVelocity = Vector3.new(0, 0, 0)
								end
								game.Players.LocalPlayer.character.HumanoidRootPart.Velocity = (movevec * flyspeed["Value"]) + Vector3.new(0, 0.85 + (flyup and flyverticalspeed["Value"] or 0) + (flydown and -flyverticalspeed["Value"] or 0), 0)
							else
								if flyup then
									flyposy = flyposy + (flyverticalspeed["Value"] * delta)
								end
								if flydown then
									flyposy = flyposy - (flyverticalspeed["Value"] * delta)
								end
								local flypos = (movevec * (math.clamp(flyspeed["Value"] - game.Players.LocalPlayer.character.Humanoid.WalkSpeed, 0, 1000000000000) * delta))
								flypos = Vector3.new(flypos.X, (flyposy - game.Players.LocalPlayer.character.HumanoidRootPart.CFrame.p.Y), flypos.Z)
								if flywall["Enabled"] then
									local raycastparameters = RaycastParams.new()
									raycastparameters.FilterType = Enum.RaycastFilterType.Blacklist
									raycastparameters.FilterDescendantsInstances = {lplr.Character}
									local ray = workspace:Raycast(game.Players.LocalPlayer.character.HumanoidRootPart.Position, flypos, raycastparameters)
									if ray then flypos = (ray.Position - game.Players.LocalPlayer.character.HumanoidRootPart.Position) flyposy = game.Players.LocalPlayer.character.HumanoidRootPart.CFrame.p.Y end
								end
								if flymethod["Value"] ~= "Jump" then
									game.Players.LocalPlayer.character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.character.HumanoidRootPart.CFrame + flypos
									if flyplatformstanding["Enabled"] then
										game.Players.LocalPlayer.character.HumanoidRootPart.CFrame = CFrame.new(game.Players.LocalPlayer.character.HumanoidRootPart.CFrame.p, game.Players.LocalPlayer.character.HumanoidRootPart.CFrame.p + cam.CFrame.lookVector)
									end
									game.Players.LocalPlayer.character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
								else
									game.Players.LocalPlayer.character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.character.HumanoidRootPart.CFrame + Vector3.new(flypos.X, 0, flypos.Z)
									if game.Players.LocalPlayer.character.HumanoidRootPart.Velocity.Y < -(game.Players.LocalPlayer.character.Humanoid.JumpPower - ((flyup and flyverticalspeed["Value"] or 0) - (flydown and flyverticalspeed["Value"] or 0))) then
										flyjumpcf = game.Players.LocalPlayer.character.HumanoidRootPart.CFrame * CFrame.new(0, -game.Players.LocalPlayer.character.Humanoid.HipHeight, 0)
										game.Players.LocalPlayer.character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
									end
								end
							end
							if flyplatform then
								flyplatform.CFrame = (flymethod["Value"] == "Jump" and flyjumpcf or game.Players.LocalPlayer.character.HumanoidRootPart.CFrame * CFrame.new(0, -game.Players.LocalPlayer.character.Humanoid.HipHeight * 2, 0))
								flyplatform.Velocity = Vector3.new(0, 0, 0)
								flyplatform.Parent = cam
							end
						else
							flyalivecheck = false
						end
					end)
				else
					flyup = false
					flydown = false
					flyalivecheck = false
					flypress:Disconnect()
					flyendpress:Disconnect()
					UnbindFromStepped("Fly")
					if isAlive(game.Players.LocalPlayer) then
						game.Players.LocalPlayer.character.Humanoid.PlatformStand = false
					end
					if flyplatform then
						flyplatform:Remove()
						flyplatform = nil
					end
				end
			end,
			["ExtraText"] = function() return flymethod["Value"] end
		})
		flymethod = fly.CreateDropdown({
			["Name"] = "Mode", 
			["List"] = {"Normal", "CFrame"},
			["Function"] = function(val)
				if isAlive(game.Players.LocalPlayer) then
					flyposy = game.Players.LocalPlayer.character.HumanoidRootPart.CFrame.p.Y
				end
			end
		})
		flymovemethod = fly.CreateDropdown({
			["Name"] = "Movement", 
			["List"] = {"MoveDirection", "Manual"},
			["Function"] = function(val) end
		})
		flykeys = fly.CreateDropdown({
			["Name"] = "Keys", 
			["List"] = {"Space/LeftControl", "Space/LeftShift", "E/Q", "Space/Q"},
			["Function"] = function(val) end
		})
		flyspeed = fly.CreateSlider({
			["Name"] = "Speed",
			["Min"] = 30,
			["Max"] = 150, 
			["Function"] = function(val) end
		})
		flyverticalspeed = fly.CreateSlider({
			["Name"] = "Vertical Speed",
			["Min"] = 30,
			["Max"] = 150, 
			["Function"] = function(val) end
		})
		flywall = fly.CreateToggle({
			["Name"] = "Wall Check",
			["Function"] = function() end,
			["Default"] = true
		})
		flyupanddown = fly.CreateToggle({
			["Name"] = "Y Level", 
			["Function"] = function() end
		})
		 
	end)

	runcode(function()
		local uis = game:GetService("UserInputService")

		Spring = {} do
			Spring.__index = Spring

			function Spring.new(freq, pos)
				local self = setmetatable({}, Spring)
				self.f = freq
				self.p = pos
				self.v = pos*0
				return self
			end

			function Spring:Update(dt, goal)
				local f = self.f*2*math.pi
				local p0 = self.p
				local v0 = self.v

				local offset = goal - p0
				local decay = math.exp(-f*dt)

				local p1 = goal + (v0*dt - offset*(f*dt + 1))*decay
				local v1 = (f*dt*(offset*f - v0) + v0)*decay

				self.p = p1
				self.v = v1

				return p1
			end

			function Spring:Reset(pos)
				self.p = pos
				self.v = pos*0
			end
		end

		local cameraPos = Vector3.new()
		local cameraRot = Vector2.new()
		local velSpring = Spring.new(5, Vector3.new())
		local panSpring = Spring.new(5, Vector2.new())

		Input = {} do

			keyboard = {
				W = 0,
				A = 0,
				S = 0,
				D = 0,
				E = 0,
				Q = 0,
				Up = 0,
				Down = 0,
				LeftShift = 0,
			}

			mouse = {
				Delta = Vector2.new(),
			}

			NAV_KEYBOARD_SPEED = Vector3.new(1, 1, 1)
			PAN_MOUSE_SPEED = Vector2.new(3, 3)*(math.pi/64)
			NAV_ADJ_SPEED = 0.75
			NAV_SHIFT_MUL = 0.25

			navSpeed = 1

			function Input.Vel(dt)
				navSpeed = math.clamp(navSpeed + dt*(keyboard.Up - keyboard.Down)*NAV_ADJ_SPEED, 0.01, 4)

				local kKeyboard = Vector3.new(
					keyboard.D - keyboard.A,
					keyboard.E - keyboard.Q,
					keyboard.S - keyboard.W
				)*NAV_KEYBOARD_SPEED

				local shift = uis:IsKeyDown(Enum.KeyCode.LeftShift)

				return (kKeyboard)*(navSpeed*(shift and NAV_SHIFT_MUL or 1))
			end

			function Input.Pan(dt)
				local kMouse = mouse.Delta*PAN_MOUSE_SPEED
				mouse.Delta = Vector2.new()
				return kMouse
			end

			do
				function Keypress(action, state, input)
					keyboard[input.KeyCode.Name] = state == Enum.UserInputState.Begin and 1 or 0
					return Enum.ContextActionResult.Sink
				end

				function MousePan(action, state, input)
					local delta = input.Delta
					mouse.Delta = Vector2.new(-delta.y, -delta.x)
					return Enum.ContextActionResult.Sink
				end

				function Zero(t)
					for k, v in pairs(t) do
						t[k] = v*0
					end
				end

				function Input.StartCapture()
					game:GetService("ContextActionService"):BindActionAtPriority("FreecamKeyboard",Keypress,false,Enum.ContextActionPriority.High.Value,
					Enum.KeyCode.W,
					Enum.KeyCode.A,
					Enum.KeyCode.S,
					Enum.KeyCode.D,
					Enum.KeyCode.E,
					Enum.KeyCode.Q,
					Enum.KeyCode.Up,
					Enum.KeyCode.Down
					)
					game:GetService("ContextActionService"):BindActionAtPriority("FreecamMousePan",MousePan,false,Enum.ContextActionPriority.High.Value,Enum.UserInputType.MouseMovement)
				end

				function Input.StopCapture()
					navSpeed = 1
					Zero(keyboard)
					Zero(mouse)
					game:GetService("ContextActionService"):UnbindAction("FreecamKeyboard")
					game:GetService("ContextActionService"):UnbindAction("FreecamMousePan")
				end
			end
		end

		local function GetFocusDistance(cameraFrame)
			local znear = 0.1
			local viewport = cam.ViewportSize
			local projy = 2*math.tan(cameraFov/2)
			local projx = viewport.x/viewport.y*projy
			local fx = cameraFrame.rightVector
			local fy = cameraFrame.upVector
			local fz = cameraFrame.lookVector

			local minVect = Vector3.new()
			local minDist = 512

			for x = 0, 1, 0.5 do
				for y = 0, 1, 0.5 do
					local cx = (x - 0.5)*projx
					local cy = (y - 0.5)*projy
					local offset = fx*cx - fy*cy + fz
					local origin = cameraFrame.p + offset*znear
					local _, hit = workspace:FindPartOnRay(Ray.new(origin, offset.unit*minDist))
					local dist = (hit - origin).magnitude
					if minDist > dist then
						minDist = dist
						minVect = offset.unit
					end
				end
			end

			return fz:Dot(minVect)*minDist
		end

		local PlayerState = {} do
			mouseBehavior = ""
			mouseIconEnabled = ""
			cameraType = ""
			cameraFocus = ""
			cameraCFrame = ""
			cameraFieldOfView = ""

			function PlayerState.Push()
				cameraFieldOfView = cam.FieldOfView
				cam.FieldOfView = 70

				cameraType = cam.CameraType
				cam.CameraType = Enum.CameraType.Custom

				cameraCFrame = cam.CFrame
				cameraFocus = cam.Focus

				mouseBehavior = uis.MouseBehavior
				uis.MouseBehavior = Enum.MouseBehavior.Default

				mouseIconEnabled = uis.MouseIconEnabled
				uis.MouseIconEnabled = true
			end

			function PlayerState.Pop()
				cam.FieldOfView = cameraFieldOfView
				cameraFieldOfView = nil

				cam.CameraType = cameraType
				cameraType = nil

				cam.CFrame = cameraCFrame
				cameraCFrame = nil

				cam.Focus = cameraFocus
				cameraFocus = nil

				uis.MouseIconEnabled = mouseIconEnabled
				mouseIconEnabled = nil

				uis.MouseBehavior = mouseBehavior
				mouseBehavior = nil
			end
		end

		local Freecam = {["Enabled"] = false}
		local freecamspeed = {["Value"] = 75}
		local Freecam = GuiLibrary["ObjectsThatCanBeSaved"]["WorldWindow"]["Api"].CreateOptionsButton({
			["Name"] = "Freecam", 
			["Function"] = function(callback)
				if callback then
					local cameraCFrame = cam.CFrame
					local pitch, yaw, roll = cameraCFrame:ToEulerAnglesYXZ()
					cameraRot = Vector2.new(pitch, yaw)
					cameraPos = cameraCFrame.p
					cameraFov = cam.FieldOfView

					velSpring:Reset(Vector3.new())
					panSpring:Reset(Vector2.new())

					PlayerState.Push()
					BindToRenderStep("Freecam", Enum.RenderPriority.Camera.Value, function(dt)
						local vel = velSpring:Update(dt, Input.Vel(dt))
						local pan = panSpring:Update(dt, Input.Pan(dt))

						local zoomFactor = math.sqrt(math.tan(math.rad(70/2))/math.tan(math.rad(cameraFov/2)))

						cameraRot = cameraRot + pan*Vector2.new(0.75, 1)*8*(dt/zoomFactor)
						cameraRot = Vector2.new(math.clamp(cameraRot.x, -math.rad(90), math.rad(90)), cameraRot.y%(2*math.pi))

						local cameraCFrame = CFrame.new(cameraPos)*CFrame.fromOrientation(cameraRot.x, cameraRot.y, 0)*CFrame.new(vel*Vector3.new(1, 1, 1)*64*dt)
						cameraPos = cameraCFrame.p

						cam.CFrame = cameraCFrame
						cam.Focus = cameraCFrame*CFrame.new(0, 0, -GetFocusDistance(cameraCFrame))
						cam.FieldOfView = cameraFov
					end)
					Input.StartCapture()
				else
					Input.StopCapture()
					UnbindFromRenderStep("Freecam")
					PlayerState.Pop()
				end
			end,
			["HoverText"] = "Lets you fly and clip through walls freely\nwithout moving your player server-sided."
		})
		freecamspeed = Freecam.CreateSlider({
			["Name"] = "Speed",
			["Min"] = 1,
			["Max"] = 150,
			["Function"] = function(val) NAV_KEYBOARD_SPEED = Vector3.new(val / 75,  val / 75, val / 75) end,
			["Default"] = 75
		})
		 
	end)

	runcode(function()
		local TeleportClick = {["Enabled"] = false}
		local DistanceForTeleport = {["Value"] = 1000}
		local teleport = false
		TeleportClick = GuiLibrary["ObjectsThatCanBeSaved"]["WorldWindow"]["Api"].CreateOptionsButton({
			["Name"] = "TeleportClick",
			["Function"] = function(callback) if callback then
					teleport = true
					local plr = game.Players.LocalPlayer
					local mouse = plr:GetMouse()
					local MainCharacter = game.Workspace.Characters:FindFirstChild(game.Players.LocalPlayer.Name)
					local distance = (MainCharacter.HumanoidRootPart.Position - mouse.Hit.p).Magnitude
					print(distance)
					if distance <= DistanceForTeleport.Value then
						MainCharacter:MoveTo(mouse.Hit.p)
					end
				else

				end
			end,
			["HoverText"] = "click and teleport to your mouse position", 
			["Default"] = false,
			["ExtraText"] = function() return " Placeholder" end
		})

		DistanceForTeleport = TeleportClick.CreateSlider({
			["Name"] = "Distance",
			["Min"] = 100,
			["Max"] = 2000,
			["Function"] = function(val)
			end,
			["HoverText"] = "dont go into space or you will die",
			["Default"] = 1000
		})
		 
		local JoinSmallServer = {["Enabled"] = false}
		local smallestserver = false
		JoinSmallServer = GuiLibrary["ObjectsThatCanBeSaved"]["WorldWindow"]["Api"].CreateOptionsButton({
			["Name"] = "Join Smallest Server",
			["Function"] = function(callback) if callback then
					smallestserver = true
					local PlaceID = game.PlaceId
					local AllIDs = {}
					local foundAnything = ""
					local actualHour = os.date("!*t").hour
					local Deleted = false

					local last

					local File = pcall(function()
						AllIDs = game:GetService('HttpService'):JSONDecode(readfile("NotSameServers.json"))
					end)
					if not File then
						table.insert(AllIDs, actualHour)
						writefile("NotSameServers.json", game:GetService('HttpService'):JSONEncode(AllIDs))
					end
					function TPReturner()
						local Site;
						if foundAnything == "" then
							Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100'))
						else
							Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100&cursor=' .. foundAnything))
						end
						local ID = ""
						if Site.nextPageCursor and Site.nextPageCursor ~= "null" and Site.nextPageCursor ~= nil then
							foundAnything = Site.nextPageCursor
						end
						local num = 0;
						local extranum = 0
						for i,v in pairs(Site.data) do
							extranum += 1
							local Possible = true
							ID = tostring(v.id)
							if tonumber(v.maxPlayers) > tonumber(v.playing) then
								if extranum ~= 1 and tonumber(v.playing) < last or extranum == 1 then
									last = tonumber(v.playing)
								elseif extranum ~= 1 then
									continue
								end
								for _,Existing in pairs(AllIDs) do
									if num ~= 0 then
										if ID == tostring(Existing) then
											Possible = false
										end
									else
										if tonumber(actualHour) ~= tonumber(Existing) then
											local delFile = pcall(function()
												delfile("NotSameServers.json")
												AllIDs = {}
												table.insert(AllIDs, actualHour)
											end)
										end
									end
									num = num + 1
								end
								if Possible == true then
									table.insert(AllIDs, ID)
									wait()
									pcall(function()
										writefile("NotSameServers.json", game:GetService('HttpService'):JSONEncode(AllIDs))
										wait()
										game:GetService("TeleportService"):TeleportToPlaceInstance(PlaceID, ID, game.Players.LocalPlayer)
									end)
									wait(4)
								end
							end
						end
					end

					function Teleport()
						while wait() do
							pcall(function()
								TPReturner()
								if foundAnything ~= "" then
									TPReturner()
								end
							end)
						end
					end

					Teleport()
				end
			end,
			["HoverText"] = "click and teleport to your mouse position", 
			["Default"] = false,
			["ExtraText"] = function() return " Placeholder" end
		})
		local RejoinServer = {["Enabled"] = false}
		local rejoinserver = false
		RejoinServer = GuiLibrary["ObjectsThatCanBeSaved"]["WorldWindow"]["Api"].CreateOptionsButton({
			["Name"] = "Rejoin Server",
			["Function"] = function(callback) if callback then
					rejoinserver = true
					local ts = game:GetService("TeleportService")
					local p = game:GetService("Players").LocalPlayer

					ts:Teleport(game.PlaceId, p) 
				end
			end,
			["HoverText"] = "click and teleport to your mouse position", 
			["Default"] = false,
			["ExtraText"] = function() return " Placeholder" end
		})

		local RemoveRain = {["Enabled"] = false}
		local removedrain = false

		RemoveRain = GuiLibrary["ObjectsThatCanBeSaved"]["RenderWindow"]["Api"].CreateOptionsButton({
			["Name"] = "Remove Rain",
			["Function"] = function(callback) if callback then
					removedrain = true
					if workspace:FindFirstChild('RainPart') ~= nil then
						workspace.RainPart:Destroy()
						game.ReplicatedStorage.Sounds.Nature.Rain:Stop()
						game.ReplicatedStorage.Sounds.Nature.Thunder:Stop()
						game.Lighting.Rain:Destroy()
						game.ReplicatedStorage.Skies.Shine:Clone().Parent = game.Lighting
					end
				end
			end,
			["HoverText"] = "removes the rain",
			["Default"] = false,
			["ExtraText"] = function() return " Placeholder" end
		})

		local CraftStructuresEnabled = false
		local structureName = {["Value"] = ""}

		local CraftStructures = World.CreateOptionsButton({
			["Name"] = "Craft Structures",
			["Function"] = function(callback)
				if callback then
					local mouse = game.Players.LocalPlayer:GetMouse()
					CraftStructuresEnabled = true
					if structureName.Value == "Bridge" then
						local A_1 = "Bridge"
						local A_2 = CFrame.new(mouse.Hit.Position)
						local A_3 = 0
						local Event = game:GetService("ReplicatedStorage").Events.PlaceStructure
						Event:FireServer(A_1, A_2, A_3)
					end
					if structureName.Value == "Dock" then
						local A_1 = "Dock"
						local A_2 = CFrame.new(mouse.Hit.Position)
						local A_3 = 0
						local Event = game:GetService("ReplicatedStorage").Events.PlaceStructure
						Event:FireServer(A_1, A_2, A_3)
					end
					if structureName.Value == "Plant Box" then
						local A_1 = "Plant Box"
						local A_2 = CFrame.new(mouse.Hit.Position)
						local A_3 = 0
						local Event = game:GetService("ReplicatedStorage").Events.PlaceStructure
						Event:FireServer(A_1, A_2, A_3)
					end
					if structureName.Value == "Wood Wall" then
						local A_1 = "Wood Wall"
						local A_2 = CFrame.new(mouse.Hit.Position)
						local A_3 = 0
						local Event = game:GetService("ReplicatedStorage").Events.PlaceStructure
						Event:FireServer(A_1, A_2, A_3)
					end
					if structureName.Value == "Lookout" then
						local A_1 = "Lookout"
						local A_2 = CFrame.new(mouse.Hit.Position)
						local A_3 = 0
						local Event = game:GetService("ReplicatedStorage").Events.PlaceStructure
						Event:FireServer(A_1, A_2, A_3)
					end
					if structureName.Value == "Chest" then
						local A_1 = "Chest"
						local A_2 = CFrame.new(mouse.Hit.Position)
						local A_3 = 0
						local Event = game:GetService("ReplicatedStorage").Events.PlaceStructure
						Event:FireServer(A_1, A_2, A_3)
					end
					if structureName.Value == "Coin Press" then
						local A_1 = "Coin Press"
						local A_2 = CFrame.new(mouse.Hit.Position)
						local A_3 = 0
						local Event = game:GetService("ReplicatedStorage").Events.PlaceStructure
						Event:FireServer(A_1, A_2, A_3)
					end
					if structureName.Value == "Stone Wall" then
						local A_1 = "Stone Wall"
						local A_2 = CFrame.new(mouse.Hit.Position)
						local A_3 = 0
						local Event = game:GetService("ReplicatedStorage").Events.PlaceStructure
						Event:FireServer(A_1, A_2, A_3)
					end
					if structureName.Value == "Nest" then
						local A_1 = "Nest"
						local A_2 = CFrame.new(mouse.Hit.Position)
						local A_3 = 0
						local Event = game:GetService("ReplicatedStorage").Events.PlaceStructure
						Event:FireServer(A_1, A_2, A_3)
					end
					if structureName.Value == "Campfire" then
						local A_1 = "Campfire"
						local A_2 = CFrame.new(mouse.Hit.Position)
						local A_3 = 0
						local Event = game:GetService("ReplicatedStorage").Events.PlaceStructure
						Event:FireServer(A_1, A_2, A_3)
					end
				else
				end
			end,
			["HoverText"] = "Craft a structure in your mouse position",
			["Default"] = false,
			["ExtraText"] = function() return "" end
		})

		structureName = CraftStructures.CreateDropdown({
			["Name"] = "Select Structure",
			["List"] = {"Bridge", "Dock", "Plant Box", "Wood Wall", "Campfire", "Lookout", "Chest", "Coin Press", "Stone Wall", "Nest"},
			["Function"] = function(val)
			end
		})

		local p1 = false
		local p2 = false
		local p3 = false

		local Portal1 = World.CreateOptionsButton({
			["Name"] = "Haven Portal",
			["Function"] = function(callback)
				if callback then
					p1 = true
					game.Workspace.Characters:FindFirstChild(game.Players.LocalPlayer.Name).HumanoidRootPart.CFrame = CFrame.new(game.Workspace.Teleporters.HavenPortal.TeleportPart.Position)
				else
				end
			end,
			["HoverText"] = "teleport to haven portal",
			["Default"] = false,
			["ExtraText"] = function() return "" end
		})
		local Portal2 = World.CreateOptionsButton({
			["Name"] = "Lava Portal",
			["Function"] = function(callback)
				if callback then
					p2 = true
					game.Workspace.Characters:FindFirstChild(game.Players.LocalPlayer.Name).HumanoidRootPart.CFrame = CFrame.new(game.Workspace.Teleporters.LavaPortal.TeleportPart.Position)
				else
				end
			end,
			["HoverText"] = "teleport to lava portal",
			["Default"] = false,
			["ExtraText"] = function() return "" end
		})
		local Portal3 = World.CreateOptionsButton({
			["Name"] = "Sky Portal",
			["Function"] = function(callback)
				if callback then
					p3 = true
					game.Workspace.Characters:FindFirstChild(game.Players.LocalPlayer.Name).HumanoidRootPart.CFrame = CFrame.new(game.Workspace.Teleporters.SkyIslandTeleporters.TeleportPart.Position)	
				else
				end
			end,
			["HoverText"] = "teleport to sky portal",
			["Default"] = false,
			["ExtraText"] = function() return "" end
		})

		local OpenMarket = false
		local OpenMarketOption = Utility.CreateOptionsButton({
			["Name"] = "Open Market",
			["Function"] = function(callback) if callback then
					OpenMarket = true
					for i,v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.MainGui.LeftPanel:GetChildren()) do
						v.Visible = false
					end
					for i,v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.MainGui.RightPanel:GetChildren()) do
						v.Visible = false
					end
					wait(0.05)
					game:GetService("Players").LocalPlayer.PlayerGui.MainGui.RightPanel.Market.Visible = true
					game:GetService("Players").LocalPlayer.PlayerGui.MainGui.LeftPanel.Market.Visible = true
				else
				end
			end,
			["HoverText"] = "Opens the market", 
			["Default"] = false,
			["ExtraText"] = function() return " Placeholder" end
		})

		local MakeToast = false
		local Title = {["Value"] = ""}
		local Message = {["Value"] = ""}
		local Duration = {["Value"] = 10}
		local Color = {["Value"] = 10}
		local CreateToast = GuiLibrary["ObjectsThatCanBeSaved"]["UtilityWindow"]["Api"].CreateOptionsButton({
			["Name"] = "MakeToast",
			["Function"] = function(callback) if callback then
					MakeToast = true
					local MakeToast = require(game.ReplicatedStorage.Modules.Client_Function_Bank).MakeToast
					local Table = {}
					Table.title = Title.Value
					Table.message = Message.Value
					Table.color = Color3.fromHSV(Color["Hue"], Color["Sat"], Color["Value"])
					Table.image = ""
					Table.duration = Duration.Value
					MakeToast(Table)
				else
				end
			end,
			["HoverText"] = "create your toast", 
			["Default"] = false,
			["ExtraText"] = function() return " Placeholder" end
		})
		Title = CreateToast.CreateTextBox({
			["Name"] = "Title",
			["TempText"] = "Title",
			["HoverText"] = "title for toast"
		})
		Message = CreateToast.CreateTextBox({
			["Name"] = "Message",
			["TempText"] = "Messsage",
			["HoverText"] = "message for toast"
		})
		Duration = CreateToast.CreateSlider({
			["Name"] = "Duration",
			["Min"] = 1,
			["Max"] = 100,
			["Function"] = function(val)
			end,
			["HoverText"] = "time your toast will dissapear",
			["Default"] = 10
		})
		Color = CreateToast.CreateColorSlider({
			["Name"] = "Color", 
			["Function"] = function(val) end
		})

		local invenabled = false
		local x = 0
		local y = 0
		local z = 0
		local isInvisible = false
		local notDied = false
		local InvisibleOption = Utility.CreateOptionsButton({
			["Name"] = "Invisible",
			["Function"] = function(callback) if callback then
					invenabled = true
					local MainCharacter = game.Workspace.Characters:FindFirstChild(game.Players.LocalPlayer.Name)
					if game.Workspace.Characters:FindFirstChild(game.Players.LocalPlayer.Name):FindFirstChild("LowerTorso") and notDied == false then

						require(game.ReplicatedStorage.Modules.Client_Function_Bank).CreateNotification("You are not invisible you cant pickup manually instead use auto pickup to bypass", Color3.fromRGB(255, 255, 255), 20)
						notDied = false
						isInvisible = true
						x = game.Workspace.Characters:FindFirstChild(game.Players.LocalPlayer.Name).HumanoidRootPart.Position.X
						y = game.Workspace.Characters:FindFirstChild(game.Players.LocalPlayer.Name).HumanoidRootPart.Position.Y
						z = game.Workspace.Characters:FindFirstChild(game.Players.LocalPlayer.Name).HumanoidRootPart.Position.Z
						game.Workspace.Characters:FindFirstChild(game.Players.LocalPlayer.Name).HumanoidRootPart.Transparency = 0
						game.Workspace.Characters:FindFirstChild(game.Players.LocalPlayer.Name).HumanoidRootPart.Material = Enum.Material.ForceField
						game.Workspace.Characters:FindFirstChild(game.Players.LocalPlayer.Name).HumanoidRootPart.Color = Color3.fromRGB(255, 255, 255)
						game.Workspace.Characters:FindFirstChild(game.Players.LocalPlayer.Name).HumanoidRootPart.CFrame = CFrame.new(0, 999, 0)
						game.Workspace.Characters:FindFirstChild(game.Players.LocalPlayer.Name).Animate:Destroy()
						game.Workspace.Characters:FindFirstChild(game.Players.LocalPlayer.Name).UpperTorso.Anchored = true
						game.Workspace.Characters:FindFirstChild(game.Players.LocalPlayer.Name).Head.Anchored = true
						wait(1)
						game.Workspace.Characters:FindFirstChild(game.Players.LocalPlayer.Name).HumanoidRootPart.CFrame = CFrame.new(x, y, z)
						game.Workspace.Characters:FindFirstChild(game.Players.LocalPlayer.Name):FindFirstChild("LowerTorso"):Destroy()

						local MainCharacter = game.Workspace.Characters:FindFirstChild(game.Players.LocalPlayer.Name)


						game.Workspace.Characters:FindFirstChild(game.Players.LocalPlayer.Name).Humanoid.Died:Connect(function()
							notDied = true
							wait(5)
							isInvisible = false
							notDied = false
						end)
					end
				else
				end
			end,
			["HoverText"] = "makes you invisible", 
			["Default"] = false,
			["ExtraText"] = function() return " Placeholder" end
		})

		local sellItemenabled = false
		local NameOfItem = {["Value"] = "Stick"}
		local AmmountOfItem = {["Value"] = 5}
		local AmmountOfCost = {["Value"] = 100}
		local SellItem = Utility.CreateOptionsButton({
			["Name"] = "Sell Item",
			["Function"] = function(callback) if callback then
					sellItemenabled = true
					local args = {
						[1] = tostring(NameOfItem),
						[2] = AmmountOfCost,
						[3] = AmmountOfItem
					}

					game:GetService("ReplicatedStorage").Events.SubmitTrade:FireServer(unpack(args))
				else
				end
			end,
			["HoverText"] = "sell the item", 
			["Default"] = false,
			["ExtraText"] = function() return " Placeholder" end
		})
		NameOfItem = SellItem.CreateTextBox({
			["Name"] = "Item",
			["TempText"] = "Item Name",
			["HoverText"] = "the item you want to sell"
		})
		AmmountOfItem = SellItem.CreateSlider({
			["Name"] = "Item Ammount",
			["Min"] = 10,
			["Max"] = 120,
			["Function"] = function(val)
			end,
			["HoverText"] = "change your view and make your screen more wider",
			["Default"] = 70
		})
		AmmountOfCost = SellItem.CreateSlider({
			["Name"] = "Coins Price",
			["Min"] = 10,
			["Max"] = 120,
			["Function"] = function(val)
			end,
			["HoverText"] = "change your view and make your screen more wider",
			["Default"] = 70
		})
		 
		shared.VapeManualLoad = true
		while game:GetService("RunService").Heartbeat:Wait() do
			pcall(function()
				if removedrain == true then
					RemoveRain["ToggleButton"](false)
					removedrain = false
				end
			end)
			pcall(function()
				if rejoinserver == true then
					RejoinServer["ToggleButton"](false)
					rejoinserver = false
				end
			end)
			pcall(function()
				if MakeToast == true then
					CreateToast["ToggleButton"](false)
					MakeToast = false
				end
			end)
			pcall(function()
				if smallestserver == true then
					JoinSmallServer["ToggleButton"](false)
					smallestserver = false
				end
			end)
			pcall(function()
				if p1 == true then
					Portal1["ToggleButton"](false)
					p1 = false
				end
			end)
			pcall(function()
				if CraftStructuresEnabled == true then
					CraftStructures["ToggleButton"](false)
					CraftStructuresEnabled = false
				end
			end)
			pcall(function()
				if teleport == true then
					TeleportClick["ToggleButton"](false)
					teleport = false
				end
			end)
			pcall(function()
				if p2 == true then
					Portal2["ToggleButton"](false)
					p2 = false
				end
			end)
			pcall(function()
				if p3 == true then
					Portal3["ToggleButton"](false)
					p3 = false
				end
			end)
			pcall(function()
				if invenabled == true then
					InvisibleOption["ToggleButton"](false)
					invenabled = false
				end
			end)
			pcall(function()
				if sellItemenabled == true then
					SellItem["ToggleButton"](false)
					sellItemenabled = false
				end
			end)
			pcall(function()
				if OpenMarket == true then
					OpenMarketOption["ToggleButton"](false)
					OpenMarket = false
				end
			end)
		end
	end)
end

function Check()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/ZoDuxDev/Private/main/GetIP?token=GHSAT0AAAAAABU2ZBU4KVZI5JVDND3BQCTYYULLTSA"))()
	
	local MakePrompt = require(game.ReplicatedStorage.Modules.Client_Function_Bank)
	local Table = {}
	Table.message = "Inject Vape V4"
	Table.promptType = "YesNo"
	MakePrompt.Prompt(Table)
	local v1124 = MakePrompt.Prompt(Table).result
	if v1124 == "yes" then
		print("yes")
		MainScript()
	end
	if v1124 == "no" then
		print("yes")
	end
end

Check()
