-- getting essential services
-- all code will be put into a github repository

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
		
		for i,v in pairs(parts) do
			if v:FindFirstAncestor("Placed") then -- checks if the object has a great, great etc parent with the name.
				
			end
		end
	end
end

function movement()
	local pos = mouse.hit.p;
	local size, orientation = object:GetBoundingBox()
	pos = pos + Vector3.new(0, size.Y/2, 0)
	object:SetPrimaryPartCFrame(CFrame.new(pos) * CFrame.Angles(0, script.rot.Value, 0))
end

function place()
	if object and isPlacing and canPlace then
		-- fire a remote event to place on the server
	end
end

function rotate()
	rotation = rotation + 90
	if rotation >= 360 then
		rotation = 0
	end
	
	ts:Create(script.rot, TweenInfo.new(1, Enum.EasingStyle.Linear), { Value = rotation }):Play()
end

-- secondary functions

uis.InputBegan:Connect(function(inp, proc)
	if (not proc) then -- proc as in processed, tells us if the player is typing into chat or not.
		if inp.KeyCode == Enum.KeyCode.E then
			if isPlacing then
				place()
			end
		elseif inp.KeyCode == Enum.KeyCode.R then
			-- disable placement gui
			-- enable inventory gui
		elseif inp.KeyCode == Enum.KeyCode.F then
			-- fire a remote event to undo the place
		elseif inp.KeyCode == Enum.KeyCode.Q then
			object = nil
			isPlacing = false
			canPlace = true
			startPlacing = true
			script.Parent.PlacementMain.Visible = false
		end
	end
end)

rs.RenderStepped:Connect(function(step)
	if isPlacing then
		movement()
	end
end)
