local References = require(script.Parent.References)

local ShopItemInfo = References.ShopItemInfo

-- FOREVER CONNECTION
local cxnList = {}

for _, ItemName in ShopItemInfo do
	table.insert(cxnList, References.ShopSellItemOnPromptTrigger(ItemName))
end
