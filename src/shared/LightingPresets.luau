local lightingModule = {}

local lighting = game:GetService("Lighting")
local atmosphere = lighting:WaitForChild("Atmosphere")
local sky = lighting:WaitForChild("Sky")
local bloom = lighting:WaitForChild("Bloom")
local depthOfField = lighting:WaitForChild("DepthOfField")
local sunrays = lighting:WaitForChild("SunRays")

local originalLightingBrightness = lighting.Brightness
local originalLightingClockTime = lighting.ClockTime
local originalLightingExposureCompensation = lighting.ExposureCompensation

local originalAtmosphereColor = atmosphere.Color
local originalAtmosphereDensity = atmosphere.Density

local Color3new = Color3.new

function lightingModule.McDarndolds()
	-- Lighting
	lighting.Brightness = 0
	lighting.ClockTime = 0
	lighting.ExposureCompensation = 0

	-- Atmosphere
	atmosphere.Density = 0.8
	atmosphere.Color = Color3new(0, 0, 0)
end

function lightingModule.Default()
	--Lighting
	lighting.Brightness = originalLightingBrightness
	lighting.ClockTime = originalLightingClockTime
	lighting.ExposureCompensation = originalLightingExposureCompensation

	-- Atmosphere
	atmosphere.Density = originalAtmosphereDensity
	atmosphere.Color = originalAtmosphereColor
end

function lightingModule.PizzaScene()
	lighting.Brightness = 3
	lighting.ClockTime = 14
	lighting.ExposureCompensation = 0.6

	atmosphere.Density = 0.5
end

return lightingModule
