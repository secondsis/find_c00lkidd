local ClientEventsModule = require(script.Parent.ClientEventsModule)
local module = {}

function module.ManipulateProperty(instance: Instance, property: string, value: any)
	instance[property] = value
end

return module
