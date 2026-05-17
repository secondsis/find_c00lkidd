local lightingModule = {}

local lighting = game:GetService("Lighting")
local atmosphere = lighting:WaitForChild("Atmosphere")
local sky = lighting:WaitForChild("Sky")
local bloom = lighting:WaitForChild("Bloom")
local depthOfField = lighting:WaitForChild("DepthOfField")
local sunrays = lighting:WaitForChild("SunRays")

local originalLightingBrightness = lighting.Brightness -- 3
local originalLightingClockTime = lighting.ClockTime --6.1
local originalLightingExposureCompensation = lighting.ExposureCompensation -- 0

local originalAtmosphereColor = atmosphere.Color
local originalAtmosphereDensity = atmosphere.Density

local Color3new = Color3.new

-- Lighting when the dark scene happens at McDarndolds
function lightingModule.McDarndolds()
	-- Lighting
	lighting.Brightness = 0
	lighting.ClockTime = 0
	lighting.ExposureCompensation = 0

	-- Atmosphere
	atmosphere.Density = 0.8
	atmosphere.Color = Color3new(0, 0, 0)
end

-- Normal Lighting
function lightingModule.Default()
	--Lighting
	lighting.Brightness = originalLightingBrightness
	lighting.ClockTime = originalLightingClockTime
	lighting.ExposureCompensation = originalLightingExposureCompensation

	-- Atmosphere
	atmosphere.Density = originalAtmosphereDensity
	atmosphere.Color = originalAtmosphereColor
end

-- Lighting for the PizzaPlace Scene
function lightingModule.PizzaScene()
	lighting.Brightness = 3
	lighting.ClockTime = 14
	lighting.ExposureCompensation = 0.6

	atmosphere.Density = 0.5
end

-- Lighting for the Introduction scene drive
function lightingModule.IntroductionDrive()
	lighting.Brightness = 3
	lighting.ClockTime = 12
	lighting.ExposureCompensation = 0
end

return lightingModule
