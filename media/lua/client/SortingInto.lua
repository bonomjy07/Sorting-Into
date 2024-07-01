SortingInto = {}

SortingInto.transferAllNearby = function ()
    -- Find player number
    local playerNum = SortingInto.getLocalPlayerNumber();
    if playerNum == nil then
        return
    end
    
    -- Player inventory
    local player = getSpecificPlayer(playerNum);
    local playerInventory = player:getInventory()
    
    -- Nearby containers
    local nearbyContainers = SortingInto.getNearbyContainers(playerNum)
    
    -- Create a table to track item types in nearby containers
    local containerItems = {}

    -- Iterate through nearby containers
    for _, container in ipairs(nearbyContainers) do
        if container then
            for j = 0, container:getItems():size() - 1 do
                local item = container:getItems():get(j)
                local itemType = item:getFullType()
                if not containerItems[itemType] then
                    containerItems[itemType] = container
                end
            end
        end
    end

    -- Transfer items from player inventory to appropriate containers
    for i = 0, playerInventory:getItems():size() - 1 do
        local item = playerInventory:getItems():get(i)
        local itemType = item:getFullType()
        local targetContainer = containerItems[itemType]
        
        local isEquipped = item:isEquipped()
        
        local hotBar = getPlayerHotbar(playerNum)
        local isInHotbar = hotBar ~= nil and hotBar:isInHotbar(item)
        
        local canTransfer = targetContainer and not isEquipped and not isInHotbar
        if canTransfer then
            ISTimedActionQueue.add(ISInventoryTransferAction:new(player, item, playerInventory, targetContainer))
        end
    end
end

SortingInto.getLocalPlayerNumber = function ()
    -- Loop through all active players
    for i = 0, getNumActivePlayers() - 1 do
        local player = getSpecificPlayer(i)
        if player and player:isLocalPlayer() then
            return player:getPlayerNum()
        end
    end
    
    return nil -- Return nil if the local player is not found
end

SortingInto.getNearbyContainers = function(playerNum)
    local nearbyContainers = {}
    local loot = getPlayerLoot(playerNum);

    -- Determine if we are nearby valid containers
    for _,container in ipairs(loot.backpacks) do
        local inv = container.inventory
        local isFloor = container.inventory:getType() == "floor"
        local isProxyContainerMod =  container.inventory:getType() == "local" -- TODO: how to handle proxyContainer mod.
        -- local containerIso = inv:getParent() 
        
        local isValidContainer = inv ~= nil and not isFloor and not isProxyContainerMod
        if isValidContainer then
            table.insert(nearbyContainers, inv)
        end
    end
    
    return nearbyContainers;
end

local function IsLCTRLPressed()
    local ctrlKeyCode = 29 -- Key code for L-CTRL key
    return isKeyDown(ctrlKeyCode)
end

SortingInto = {}

-- Override the original function.
function ISInventoryPage:transferAll()
    if IsLCTRLPressed() then
        SortingInto.transferAllNearby()
    else
        self.inventoryPane:transferAll();
    end
end

SortingInto.transferAllNearby = function ()
    -- Find player number
    local playerNum = SortingInto.getLocalPlayerNumber();
    if playerNum == nil then
        return
    end

    -- Player inventory
    local player = getSpecificPlayer(playerNum);
    local playerInventory = player:getInventory()

    -- Nearby containers
    local nearbyContainers = SortingInto.getNearbyContainers(playerNum)

    -- Create a table to track item types in nearby containers
    local containerItems = {}

    -- Iterate through nearby containers
    for _, container in ipairs(nearbyContainers) do
        if container then
            for j = 0, container:getItems():size() - 1 do
                local item = container:getItems():get(j)
                local itemType = item:getFullType()
                if not containerItems[itemType] then
                    containerItems[itemType] = container
                end
            end
        end
    end

    -- Transfer items from player inventory to appropriate containers
    for i = 0, playerInventory:getItems():size() - 1 do
        local item = playerInventory:getItems():get(i)
        local itemType = item:getFullType()
        local targetContainer = containerItems[itemType]

        local isEquipped = item:isEquipped()

        local hotBar = getPlayerHotbar(playerNum)
        local isInHotbar = hotBar ~= nil and hotBar:isInHotbar(item)

        local canTransfer = targetContainer and not isEquipped and not isInHotbar
        if canTransfer then
            ISTimedActionQueue.add(ISInventoryTransferAction:new(player, item, playerInventory, targetContainer))
        end
    end
end

SortingInto.getLocalPlayerNumber = function ()
    -- Loop through all active players
    for i = 0, getNumActivePlayers() - 1 do
        local player = getSpecificPlayer(i)
        if player and player:isLocalPlayer() then
            return player:getPlayerNum()
        end
    end

    return nil -- Return nil if the local player is not found
end

SortingInto.getNearbyContainers = function(playerNum)
    local nearbyContainers = {}
    local loot = getPlayerLoot(playerNum);

    -- Determine if we are nearby valid containers
    for _,container in ipairs(loot.backpacks) do
        local inv = container.inventory
        local isFloor = container.inventory:getType() == "floor"
        local isProxyContainerMod =  container.inventory:getType() == "local" -- TODO: how to handle proxyContainer mod.
        -- local containerIso = inv:getParent() 

        local isValidContainer = inv ~= nil and not isFloor and not isProxyContainerMod
        if isValidContainer then
            table.insert(nearbyContainers, inv)
        end
    end

    return nearbyContainers;
end

local function IsLCTRLPressed()
    local ctrlKeyCode = 29 -- Key code for L-CTRL key
    return isKeyDown(ctrlKeyCode)
end

-- Override the original function.
function ISInventoryPage:transferAll()
    if IsLCTRLPressed() then
        SortingInto.transferAllNearby()
    else
        self.inventoryPane:transferAll();
    end
end
