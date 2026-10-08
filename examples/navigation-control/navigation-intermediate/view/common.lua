--====================================================================--
-- view/common.lua
--
-- what the three views share
--====================================================================--


local Common = {}


-- the room a Navigation Control has for a view: its own
-- size, less its nav bar
--
function Common.viewSize( navCtrl )
	return navCtrl.width, navCtrl.height - navCtrl.navBar.height
end


-- a view's background, the size of the view: a view is
-- anchored top center, so 0,0 is the middle of its top edge
--
function Common.newBackground( group, navCtrl, color )
	local w, h = Common.viewSize( navCtrl )
	local o = display.newRect( 0, 0, w, h )
	o:setFillColor( unpack( color ) )
	o.anchorX, o.anchorY = 0.5, 0
	group:insert( o )
	return o
end


-- the functions a Navigation Control calls on a view, each optional.
-- these only say that they were called
--
function Common.addViewFunctions( navView )

	-- the view is about to go into the control
	navView.willBeAdded = function( self )
		print( self.title .. ": willBeAdded" )
	end

	-- a slide has started (true) or ended (false)
	navView.viewInMotion = function( self, isMoving )
		print( self.title .. ": viewInMotion", isMoving )
	end

	-- the view is on top, after its slide
	navView.viewDidAppear = function( self )
		print( self.title .. ": viewDidAppear" )
	end

	-- the view has been covered, or popped
	navView.viewDidDisappear = function( self )
		print( self.title .. ": viewDidDisappear" )
	end

	-- the view has been popped: the control has hidden it,
	-- removing its display objects is up to the view
	navView.willBeRemoved = function( self )
		print( self.title .. ": willBeRemoved" )
		self.view:removeSelf()
		self.view = nil
	end

end


return Common
