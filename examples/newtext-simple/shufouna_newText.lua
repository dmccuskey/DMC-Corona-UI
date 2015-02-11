

--===================================================================--
-- Imports
--===================================================================--

local Objects = require( 'lib.dmc_library.dmc_objects' )
local Widget = require( 'lib.dmc_widgets' )
local WidgetNewText = require( 'lib.dmc_widgets.widget_newtext' )


--===================================================================--
-- Setup, Constants
--===================================================================--

-- setup some aliases to make code cleaner
local inheritsFrom = Objects.inheritsFrom
local CoronaBase = Objects.CoronaBase


local FONT_REGULAR_AR = "HelveticaNeueLTArabic-Roman"
local FONT_LIGHT_AR = "HelveticaNeueLTArabic-Roman"
local FONT_MEDIUM_AR = "HelveticaNeueLTArabic-Roman"

local FONT_REGULAR_EN = "DINOffc"
local FONT_LIGHT_EN = "DINOffc"
local FONT_MEDIUM_EN = "DINOffc-Medi"

local FONT_DECO_EN = "Maybe-Bold"
local FONT_DECO_AR = "GESSTwoBold-Bold"


--===================================================================--
-- Support Functions
--===================================================================--


--====================================================================--
-- Shufouna newText Widget Class
--====================================================================--

local ShufounaNewText = inheritsFrom( WidgetNewText )
ShufounaNewText.NAME = "Shufouna newText Widget Class"


--== Class Constants

ShufounaNewText.FONT_LIGHT = "light_font"
ShufounaNewText.FONT_REGULAR = "regular_font"
ShufounaNewText.FONT_MEDIUM = "medium_font"
ShufounaNewText.FONT_DECO = 'font_deco'




--====================================================================--
--== Start: Setup DMC Objects


function ShufounaNewText:_init( params )
	-- print( "ShufounaNewText:_init" )
	params = params or {}
	self:superCall( "_init", params )
	--==--


	--== Sanity Check ==--

	--== Create Properties ==--

	self._font_type = params.font
	self._font = nil

	self._check_platform = true

	--== Object References ==--


end


-- _initComplete()
--
function ShufounaNewText:_initComplete()
	-- print( "ShufounaNewText:_initComplete" )
	self:superCall( "_initComplete" )
	--==--

	local o,f

	self:_checkTextLanguage()
	self:_checkTextAlignment()
	self:_getDisplayFont()
	self:getFontMetric()
	self:_createNewText()

end
function ShufounaNewText:_undoInitComplete()
	-- print( "ShufounaNewText:_undoInitComplete" )
	--==--
	self:superCall( "_undoInitComplete" )
end


--== END: Setup DMC Objects
--====================================================================--




--====================================================================--
--== Public Methods



function ShufounaNewText.__setters:check_platform( value )
	-- print( "ShufounaNewText.__setters:check_platform", value )
	if value ~= nil and self._check_platform ~= value then
		self._check_platform = value
	end
end


function ShufounaNewText.__setters:text( value )
	-- print( "ShufounaNewText.__setters:text", value )
	if value ~= nil and self._text ~= value then
		self._text = value

		self:_checkTextLanguage()
		self:_checkTextAlignment()
		self:_getDisplayFont()
		self:getFontMetric()
		self:_createNewText()
	end
end



function ShufounaNewText.__setters:font( value )
	-- print( "ShufounaNewText.__setters:font", value )
	if value ~= nil and self._font_type ~= value then
		self._font_type = value

		self:_getDisplayFont()
		self:getFontMetric()
		self:_createNewText()
	end
end




--====================================================================--
--== Private Methods



function ShufounaNewText:_checkTextLanguage()
	-- print( "ShufounaNewText:_checkTextLanguage" )

	local str = self._text or ""
	local byte = string.byte( str )

	if byte == 216 or byte == 217 then
		self._is_arabic = true
	else
		self._is_arabic = false
	end

end


function ShufounaNewText.__getters:isArabic( )
	-- print( "ShufounaNewText.__setters:font", value )
	local is_arabic = false
	if(self._is_arabic) then
		is_arabic = self._is_arabic
	end
	return is_arabic
end


function ShufounaNewText:_checkTextAlignment()
	-- print( "ShufounaNewText:_checkTextAlignment" )

	local check_platform = self._check_platform
	local is_arabic = self._is_arabic
	local check_language = self.check_language

	local val = 'left'

	if self._align == 'center' then return end

	-- hack, i think because Android is doing the correct thing.

	if self.IS_SIMULATOR and not check_platform then
		val = 'left'

	elseif self.IS_ANDROID and check_platform then
		val = 'left'

	elseif self.IS_IOS and not check_platform then
		val = 'left'

	else
		if is_arabic then
			val = 'right'
		else
			val = 'left'
		end

	end

	self._align = val
end


function ShufounaNewText:_getDisplayFont()
	-- print( "ShufounaNewText:_getDisplayFont" )

	local font_type = self._font_type
	local is_arabic = self._is_arabic

	local font_name

	if font_type == self.FONT_REGULAR then
		if is_arabic then
			font_name = FONT_REGULAR_AR
		else
			font_name = FONT_REGULAR_EN
		end

	elseif font_type == self.FONT_MEDIUM then
		if is_arabic then
			font_name = FONT_MEDIUM_AR
		else
			font_name = FONT_MEDIUM_EN
		end

	elseif font_type == self.FONT_LIGHT then
		if is_arabic then
			font_name = FONT_LIGHT_AR
		else
			font_name = FONT_LIGHT_EN
		end

	elseif font_type == self.FONT_DECO then
		if is_arabic then
			font_name = FONT_DECO_AR
		else
			font_name = FONT_DECO_EN
		end

	else
		if is_arabic then
			font_name = FONT_REGULAR_AR
		else
			font_name = FONT_REGULAR_EN
		end

	end

	self._font = font_name
end




--====================================================================--
--== Event Handlers



-- none




return ShufounaNewText
