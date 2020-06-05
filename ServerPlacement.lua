local last = {}

game.ReplicatedStorage.Events.PlaceBlock.OnServerEvent:Connect(function(plr, pos, rot, n)
	-- check if user owns atleast one of the block
	if game.ReplicatedStorage.Objects:FindFirstChild(n) then
		local b = game.ReplicatedStorage.Objects[n]:Clone()
		b:SetPrimaryPartCFrame(CFrame.new(pos) * CFrame.Angles(0, rot, 0))
		b.Parent = plr.Base.Value.Placed
	end
end)
