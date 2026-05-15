task.wait(1)

local CollectionService = game:GetService("CollectionService")

local posters = CollectionService:GetTagged("Poster")
local images: { Decal } = game:GetService("ServerStorage").PosterImages:GetChildren()

-- Decorate the posters in c00lkidd House
for i = 1, #posters do
	local poster = posters[i]
	local decal = poster.Decal

	-- Select a random image that is not used yet in the house
	local image

	repeat
		image = images[math.random(#images)]
	until not image:GetAttribute("used")

	image:SetAttribute("used", true)
	decal.Texture = image.Texture
end

return {}
