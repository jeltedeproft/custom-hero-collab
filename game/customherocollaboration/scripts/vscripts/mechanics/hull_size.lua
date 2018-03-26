function SetHullSize(event)
	local caster = event.caster
	local hullsize = event.HullSize
	caster:SetHullRadius(hullsize) 
end