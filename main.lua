
local W,H = display.contentWidth, display.contentHeight
local H_CENTER, V_CENTER = W*0.5, H*0.5

local widgets = require( 'dmc_widgets' )

local sc, vp, o, f



--[[

local p = {
	width=W, height=H,
	default_anchor_ref={0.5, 0.5},
	padding={0,0},
	offset={-20,0}
}
sc = widgets.newScroller( p )

-- v.anchorX, v.anchorY = 0.5,0.5

sc.x, sc.y = W/2, H/2


-- create view pager
p = {
	margin=40,
	radius=10,
}
vp = widgets.newViewPager( p )
vp.x, vp.y = 100, 100

f = function(e)
	-- print( e.name, e.type, e.data.index )
	if e.data.direction ~= vp.SAME_PAGE then
		sc:showPage( e.data.index )
	end
end
vp:addEventListener( vp.EVENT, f )


f = function(e)
	if e.type == sc.SLIDES_MODIFIED then
		-- print( e.name, e.type, e.data.count )
		vp.pages = e.data.count
	end
	if e.type == sc.CENTER_STAGE then
		-- print( e.name, e.type, e.data.index )
		vp.index = e.data.index
	end
end
sc:addEventListener( sc.EVENT, f )


--== add views

local deltaW, deltaH = 200, 100

o = display.newRect( 0,0, W-deltaW,H-deltaH )
o.anchorX, o.anchorY = 0.5,0.5
o:setFillColor(0.5,0.5,0, 0.5)
sc:addSlide( o, {} )

o = display.newRect( 0,0, W-deltaW,H-deltaH )
o.anchorX, o.anchorY = 0.5,0.5
o:setFillColor(0,.5,0, 0.5)
sc:addSlide( o, {} )

o = display.newRect( 0,0, W-deltaW,H-deltaH )
o.anchorX, o.anchorY = 0.5,0.5
o:setFillColor(1,0,0, 0.5)
sc:addSlide( o, {} )


sc:showPage(1)
-- vp.index = 1

--]]

local function onRender( event )
	print( 'Main:onRender' )

	local view = event.view
	local index = event.index

	local o

	o = display.newText( tostring(index), 40,30, native.systemFont, 32)
	o.anchorX, o.anchorY = 0.5,0
	view:insert( o )

	view._o = o

end

local function onUnrender( event )
print( 'Main:onUnrender' )

	local view = event.view
	local o

	o = view._o
	o:removeSelf()

	view._o = nil

end

local function onEvent( event )
print( 'onEvent' )

end



-- create view pager
p = {
	width=W-100,
	height=H-100,
}
o = widgets.newSlideView( p )
o.x, o.y = 50,0

local rp

for i = 1, 4 do

	rp = {
		isCategory = false,
		height = 100,
		onItemRender=onRender,
		onItemUnrender=onUnrender,
		onItemEvent=onEvent,
		data = i
	}

	o:insertSlide( rp )

end

