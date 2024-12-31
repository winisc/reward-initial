-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRPC = Tunnel.getInterface("vRP")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
cRP = {}
Tunnel.bindInterface("rewardTrinity", cRP)
vCLIENT = Tunnel.getInterface("rewardTrinity")
-----------------------------------------------------------------------------------------------------------------------------------------
-- REWARD
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.prepare("reward/add", "INSERT INTO vip_reward(`user_id`, `vip`, `created_at`, `end_at`) VALUES (@user_id, @vip, @createdAt, @endAt)")
vRP.prepare("reward/remove", "DELETE FROM vip_reward WHERE user_id = @user_id")
vRP.prepare("reward/get", "SELECT * FROM vip_reward WHERE user_id = @user_id")

local webhookreward = "https://discord.com/api/webhooks/1308878376198602862/EaNTztMASEADZs4rkz0tkCCRD5xL6UBP_MOTR26J8h4o8NVJ9DHPsWeAseGqva0tejLv"

function SendWebhookMessage(webhook,message)
	if webhook ~= nil and webhook ~= "" then
		PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
	end
end

local vehicles = {
    [1] = {model = 'camaro'},
    [2] = {model = 'lancerevolutionx'},
    [3] = {model = 'm2'},
}


local timeVip = (86400 * 30) -- 30 dias
local addVip = function(user_id, vip, createdAt, endAt)
    vRP.query("reward/add", {
        user_id = parseInt(user_id),
        vip = vip,
        createdAt = createdAt,
        endAt = endAt
    })
end

-- local removeVip = function(user_id)
--     vRP.query("reward/remove", {
--         user_id = parseInt(user_id),
--     })
-- end

local getVip = function(user_id)
    return vRP.query("reward/get", {
        user_id = parseInt(user_id),
    })
end

local checkReward = function(user_id)
    if not user_id then return false end
    local vipData = getVip(user_id)
    if vipData and vipData[1] then
        return false
    end
    return true
end

function cRP.nameIdentity()
    local source = source
    local user_id = vRP.getUserId(source)

    local identity = vRP.userIdentity(user_id)
    if identity then
        return identity.name .. " " .. identity.name2
    end
end

function cRP.rewardSever(id)
    local source = source
    local user_id = vRP.getUserId(source)
    if not checkReward(user_id) then return false end

    local vehicle = vehicles[id]
    if not vehicle or vehicle and not vehicle.model then return false end

    local vehicleInfo = exports["snt-vehicles"]:getVehicleInfo(vehicle.model)
    local vName = ''
    if vehicleInfo then
        vName = vehicleInfo["name"]
    end

    addVip(user_id, 'Starter', os.time(), os.time() + timeVip)
    vRP.setPermission(user_id, 'Starter')

    if exports["snt-vehicles"]:generateRentalVehicle(user_id, vehicle.model, 30) then
        SendWebhookMessage(webhookreward,"```prolog\n[ID]: "..user_id.." \n[RESGATOU]: "..vName.." \n[RESGATOU]: STARTER VIP"..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
        TriggerClientEvent("Notify", source, "check", vName .. " adicionado a sua garagem.", 5000)
        TriggerClientEvent("Notify", source, "check", "Vip Nobre adicionado a sua conta.", 5000)
        return
    end

    TriggerClientEvent("Notify", source, "negado", "Falhou.", 5000)
end

function cRP.checkReward()
    local source = source
    local user_id = vRP.getUserId(source)
    return checkReward(user_id)
end

AddEventHandler('playerConnect', function(user_id, source)
    local vipDB = getVip(user_id)
    if vipDB and vipDB[1] then
        local vip = vipDB[1]
        local endTime = vip.end_at
        if tonumber(endTime) <= os.time() then
            if vRP.hasPermission(user_id, 'Starter') then
                vRP.remPermission(user_id, 'Starter')
            end
        end
    end
end)


-- RegisterCommand("addVip", function(source)
--     local user_id = vRP.getUserId(source)
--     if user_id then
--         addVip(user_id, 'Starter', os.time(), os.time() + 300)
--     end
-- end)

-- RegisterCommand("removeVip", function(source)
--     local user_id = vRP.getUserId(source)
--     if user_id then
--         removeVip(user_id)
--     end
-- end)

-- RegisterCommand("getVip", function(source)
--     local user_id = vRP.getUserId(source)
--     if user_id then
--         print(dump(getVip(user_id)))
--     end
-- end)
