-- getting essential services
-- all code will be put into a github repository
-- Dollor-Lua/MH-Game-Stream/edit/master/Placement.lua

local rs = game:GetService("RunService")
local ts = game:GetService("TweenService")
local uis = game:GetService("UserInputService")

-- variables

local object = nil

local isPlacing = false
local canPlace = true
local startPlacing = true

local plr = game.Players.LocalPlayer
local mouse = plr:GetMouse() -- gets the mouse

local rotation = 0

-- defining functions

function detect_collisions()
	if isPlacing and object then
		local p = object.PrimaryPart
		local event = p.Touched:Connect(function() end) -- gets the touch event ready
		
		local parts = p:GetTouchingParts()
		
		canPlace = true
		
		for i,v in pairs(parts) do
			if v:FindFirstAncestor("Placed") then -- checks if the object has a great, great etc parent with the name.
				canPlace = false
			end
		end
	end
end

function movement()
	local pos = mouse.hit.p;
	local size = object.PrimaryPart.Size;
	local base = plr.Base.Value.Base
	pos = Vector3.new(pos.X, (base.Position.Y+0.5)+size.Y/2, pos.Z)
	
	local x = math.floor((pos.X/1)+0.5)
	local z = math.floor((pos.Z/1)+0.5)
	
	x = math.clamp(x, (base.Position.X-(base.Size.X/2))+(size.X/2), (base.Position.X+(base.Size.X/2))-(size.X/2))
	z = math.clamp(z, (base.Position.Z-(base.Size.Z/2))+(size.Z/2), (base.Position.Z+(base.Size.Z/2))-(size.Z/2))
	
	pos = Vector3.new(x, pos.Y, z);
	
	object:SetPrimaryPartCFrame(CFrame.new(pos) * CFrame.Angles(0, script.rot.Value, 0))
	detect_collisions()
end

function place()
	if object and isPlacing and canPlace then
		game.ReplicatedStorage.Events.PlaceBlock:FireServer(object:GetPrimaryPartCFrame().p, rotation, object.Name)
	end
end

function rotate()
	rotation = rotation + 90
	if rotation >= 360 then
		rotation = 0
	end
	
	ts:Create(script.rot, TweenInfo.new(1, Enum.EasingStyle.Linear), { Value = rotation }):Play()
end

function startPlacement(n)
	object = game.ReplicatedStorage.Objects[n]:Clone()
	object.Parent = workspace
	
	for i,v in pairs(object:GetDescendants()) do
		v.CanCollide = false
	end
	
	isPlacing = true
	startPlacing = false
	canPlace = true
	
	script.Parent.PlacementMain.Visible = true
	
	-- disable inventory
	-- disable shop
	-- disable settings
end

-- secondary functions

uis.InputBegan:Connect(function(inp, proc)
	if (not proc) then -- proc as in processed, tells us if the player is typing into chat or not.
		if inp.KeyCode == Enum.KeyCode.E then
			if isPlacing then
				place()
			end
		elseif inp.KeyCode == Enum.KeyCode.Z then
			-- disable placement gui
			-- enable inventory gui
		elseif inp.KeyCode == Enum.KeyCode.F then
			-- fire a remote event to undo the place
		elseif inp.KeyCode == Enum.KeyCode.Q then
			object:Destroy()
			
			object = nil
			isPlacing = false
			canPlace = true
			startPlacing = true
			script.Parent.PlacementMain.Visible = false
		elseif inp.KeyCode == Enum.KeyCode.R then
			if isPlacing then
				rotate()
			end
		end
	end
end)

script.Parent.TestButton.MouseButton1Click:Connect(function()
	if not isPlacing and startPlacing then
		startPlacement("TestBlock")
	end
end)

rs.RenderStepped:Connect(function(step)
	if isPlacing and object then
		mouse.TargetFilter = object
		movement()
	end
end)
