speed = 120 --minutes per complete swipe
freq = 120 -- update frequency (Hz)

tau=math.pi*2
offset = 0
display_aspect = 0
display_w, display_h = 0,0
content_aspect = 0
speed=((1/speed)/60)*tau

function update_aspect(name, value)
	if value > 0 then
		if name == "osd-width"  then display_w = value end
		if name == "osd-height" then display_h = value end
	end
	if display_w > 0 and display_h > 0 then
		display_aspect = display_w/display_h
	end
end
mp.observe_property("osd-width", "number", update_aspect)
mp.observe_property("osd-height", "number", update_aspect)

function thing()
	if content_aspect == 0 then
		content_aspect = mp.get_property("video-params/aspect") or 0
	elseif display_aspect > 0 then
		offset = (offset + speed/freq)%tau
		if (content_aspect/display_aspect) > 1 then
			mp.set_property_number("video-pan-y", math.sin(offset)*(1 - (content_aspect/display_aspect))*.5)
			mp.set_property_number("video-pan-x", 0)
		else
			mp.set_property_number("video-pan-x", math.sin(offset)*(1 - (display_aspect/content_aspect))*.5)
			mp.set_property_number("video-pan-y", 0)
		end
	end
end
mp.add_periodic_timer(1/freq, thing)