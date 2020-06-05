game.Players.PlayerAdded:Connect(function(plr)
	local base
	for i,v in pairs(workspace.Bases:GetChildren()) do
		if not v.Owner.Value then
			base = v
			v.Owner.Value = plr
			break
		end
	end
	
	local baseVal = Instance.new("ObjectValue")
	baseVal.Value = base
	baseVal.Name = "Base"
	baseVal.Parent = plr
end)

game.Players.PlayerRemoving:Connect(function(plr)
	local base = plr.Base.Value
	base.Owner.Value = nil
end)
