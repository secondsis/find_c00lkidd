local References = require(script.Parent.References)

local ShopItemInfo = References.ShopItemInfo

-- FOREVER CONNECTION
local cxnList = {}

-- For every item in the shop, set up the prompt trigger connection
for _, ItemName in ShopItemInfo do
	table.insert(cxnList, References.ShopSellItemOnPromptTrigger(ItemName))
end
