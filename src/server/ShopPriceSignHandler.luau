task.wait(4)

local References = require(script.Parent.References)

local ShopItemInfo = References.ShopItemInfo
local collectionService = game:GetService("CollectionService")

local signs = collectionService:GetTagged("SellLabel")

for i = 1, #signs do
	local item: TextLabel = signs[i]
	local itemName = "NIL"

	-- INEFFICIENT scuffed mess ahh
	if item.Parent and item.Parent.Parent and item.Parent.Parent.Parent then
		itemName = item.Parent.Parent.Parent.Name
	else
		warn("IMPORTANT: Item in shop doesn't have a name, defaulting to NIL. Index: " .. i)
	end

	local price = ShopItemInfo[itemName].Price
	if not price then
		warn("IMPORTANT: No price found for " .. itemName)
		continue
	end
	item.Text = "$" .. price
end
