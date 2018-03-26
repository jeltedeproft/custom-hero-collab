function ApplyNoDraw(event)
	local caster = event.target
	caster:AddNoDraw()
end

function RemoveNoDraw(event)
	local caster = event.target
	caster:RemoveNoDraw()
end