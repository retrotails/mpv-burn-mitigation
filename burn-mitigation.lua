--minutes per complete swipe
speed = 120

tau=math.pi*2
sin=math.sin
offset = 0
monitor_aspect = 0
monitor_w = 0
monitor_h = 0
content_aspect = 0
speed=((1/speed)/60)*tau

function update_aspect(name, value)
	if value > 0 then
		if name == "osd-width"  then monitor_w = value end
		if name == "osd-height" then monitor_h = value end
	end
	if monitor_w > 0 and monitor_h > 0 then
		monitor_aspect = monitor_w/monitor_h
	end
end
mp.observe_property("osd-width", "number", update_aspect)
mp.observe_property("osd-height", "number", update_aspect)

function thing(what)
	if content_aspect == 0 then
		local aspect = mp.get_property("video-params/aspect")
		if aspect then content_aspect = aspect end
	elseif monitor_aspect > 0 then
		offset = (offset + speed*0.01)%tau
		if (content_aspect/monitor_aspect) > 1 then
			mp.set_property_number("video-pan-y", sin(offset)*(1 - (content_aspect/monitor_aspect))*.5)
			mp.set_property_number("video-pan-x", 0)
		else
			mp.set_property_number("video-pan-x", sin(offset)*(1 - (monitor_aspect/content_aspect))*.5)
			mp.set_property_number("video-pan-y", 0)
		end
	end
end
mp.add_periodic_timer(.01, thing)