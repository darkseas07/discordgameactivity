local serverMaxCount = 32 -- Server max kişi sayısı
local clientID = 803997860030447616 -- Discord developer'dan oluşturduğunuz applicationın client id
local resimAsset = "logo" -- Oluşturduğunuz applicationa yüklediğiniz resmin adı
local resimAssetSmall = "logoSmall" -- Oluşturduğunuz applicationa yüklediğiniz küçük resmin adı
local textString = "Darkseas" -- Resimdeki büyük yazıya gelince gözükecek olan yazı
local smallText = "Discord link yazılabilir" -- Resimdeki küçük yazıya gelince gözükecek olan yazı
local waitDelay = 10000 -- 10 saniyede bir kişinin oyunda hangi caddede ne yaptığını yeniler. Saniyesini ayarlarken 1000 ile çarpınız.

Citizen.CreateThread(function()
	while true do
		SetDiscordAppId(clientID)
		SetDiscordRichPresenceAsset(resimAsset)
        SetDiscordRichPresenceAssetText(textString) 
        SetDiscordRichPresenceAssetSmall(resimAssetSmall)
        SetDiscordRichPresenceAssetSmallText(smallText)
		Citizen.Wait(60)
	end
end)

Citizen.CreateThread(function()
	while true do
		local veh = GetVehiclePedIsUsing(PlayerPedId())
		local vehModel = GetEntityModel(veh)
		local vehName = GetLabelText(GetDisplayNameFromVehicleModel(vehModel))
		if vehName and vehName == "NULL" then vehName = GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsUsing(PlayerPedId()))) end
		local x,y,z = table.unpack(GetEntityCoords(PlayerPedId(),true))
		local streetHash = GetStreetNameAtCoord(x, y, z)
		local playerId = GetPlayerServerId(PlayerId())
		local playerCount = #GetActivePlayers()
		Citizen.Wait(waitDelay)
		if streetHash ~= nil then
			streetName = GetStreetNameFromHashKey(streetHash)
			if IsPedOnFoot(PlayerPedId()) and not IsEntityInWater(PlayerPedId()) then
				if IsPedSprinting(PlayerPedId()) then
					SetRichPresence(streetName.."'de koşuyor. ID: "..playerId.." / Oyuncu: ".. playerCount .."/"..serverMaxCount)
				elseif IsPedRunning(PlayerPedId()) then
					SetRichPresence(streetName.."'de koşuyor. ID: "..playerId.." / Oyuncu: ".. playerCount .."/"..serverMaxCount)
				elseif IsPedWalking(PlayerPedId()) then
					SetRichPresence(streetName.."'de yürüyor. ID: "..playerId.." / Oyuncu: ".. playerCount .."/"..serverMaxCount)
				elseif IsPedStill(PlayerPedId()) then
					SetRichPresence(streetName.."'de duruyor. ID: "..playerId.." / Oyuncu: ".. playerCount .."/"..serverMaxCount)
				end
			elseif GetVehiclePedIsUsing(PlayerPedId()) ~= nil and not IsPedInAnyHeli(PlayerPedId()) and not IsPedInAnyPlane(PlayerPedId()) and not IsPedOnFoot(PlayerPedId()) and not IsPedInAnySub(PlayerPedId()) and not IsPedInAnyBoat(PlayerPedId()) then
				local KMH = math.ceil(GetEntitySpeed(GetVehiclePedIsUsing(PlayerPedId())) * 3.6)
				if KMH > 0 then
					SetRichPresence(streetName.."'de araç sürüyor. ID: "..playerId.." / Oyuncu: ".. playerCount .."/"..serverMaxCount)
				elseif KMH == 0 then
					SetRichPresence(streetName.."'de araç ile bekliyor. ID: "..playerId.." / Oyuncu: ".. playerCount .."/"..serverMaxCount)
				end
			elseif IsPedInAnyHeli(PlayerPedId()) or IsPedInAnyPlane(PlayerPedId()) then
				if IsEntityInAir(GetVehiclePedIsUsing(PlayerPedId())) or GetEntityHeightAboveGround(GetVehiclePedIsUsing(PlayerPedId())) > 1.0 then
					SetRichPresence(streetName.."'de uçak/heli uçuruyor. ID: "..playerId.." / Oyuncu: ".. playerCount .."/"..serverMaxCount)
				else
					SetRichPresence(streetName.."'de uçak/heli içinde bekliyor. ID: "..playerId.." / Oyuncu: ".. playerCount .."/"..serverMaxCount)
				end
			elseif IsEntityInWater(PlayerPedId()) then
				SetRichPresence(streetName.."'de yüzüyor. ID: "..playerId.." / Oyuncu: ".. playerCount .."/"..serverMaxCount)
			elseif IsPedInAnyBoat(PlayerPedId()) and IsEntityInWater(GetVehiclePedIsUsing(PlayerPedId())) then
				SetRichPresence(streetName.."'de tekne sürüyor. ID: "..playerId.." / Oyuncu: ".. playerCount .."/"..serverMaxCount)
			elseif IsPedInAnySub(PlayerPedId()) and IsEntityInWater(GetVehiclePedIsUsing(PlayerPedId())) then
				SetRichPresence(streetName.."'de denizaltı sürüyor. ID: "..playerId.." / Oyuncu: ".. playerCount .."/"..serverMaxCount)
			end
		end
	end
end)