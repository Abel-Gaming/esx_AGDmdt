ESX              = nil
local display = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(250)
	end

	while true do
        Citizen.Wait(10)
        ESX.PlayerData = ESX.GetPlayerData()
    end
end)

Citizen.CreateThread(function()
	while display do
		Citizen.Wait(0)
		SetDisplay(true)
		SetNuiFocus(true, true)
	end
end)

RegisterCommand(Config.Command, function()
	if ESX.PlayerData.job.name == 'police' then
		SetDisplay(not display)	
	else
		ESX.ShowNotification('~r~[ERROR]~w~ You are not a police officer')
	end
end)

function SearchPlate(plate)
	-- Trigger Server Callback
	ESX.TriggerServerCallback('esx_AGDmdt:GetVehicleInfo', function(retrivedInfo)
		
		--Set the display
		SetDisplay(true)

		-- Get Vehicle Name
		local VehicleDisplayName = GetDisplayNameFromVehicleModel(retrivedInfo.vehicle)

		-- Get Vehiclce Color
		local vehicleWanted = GetVehicleModelNumberOfSeats(retrivedInfo.vehicle)

		-- Get UPPERCASE job name
		local OwnerJobName = string.upper(retrivedInfo.ownerjob)
		
		-- Send NUI Information
		SendNUIMessage({
        	type = "vehicle-information-all",
			plate = retrivedInfo.plate,
			name = VehicleDisplayName,
			owner = retrivedInfo.owner,
			ownerjob = OwnerJobName,
			wantedstatus = vehicleWanted
    	})

	end, plate)
end

function SearchName(first, last)
	-- Trigger Server Callback
	ESX.TriggerServerCallback('esx_AGDmdt:GetPersonInfo', function(retrivedInfo)
		
		--Set the display
		SetDisplay(true)

		-- Capitalize Things
		local jobcapitalized = string.upper(retrivedInfo.job)
		local sexcapitalized = string.upper(retrivedInfo.sex)

		-- Send NUI Information
		SendNUIMessage({
        	type = "person-information-all",
			firstName = retrivedInfo.first,
			lastName = retrivedInfo.last,
			job = jobcapitalized,
			dob = retrivedInfo.dob,
			sex = sexcapitalized,
			height = retrivedInfo.height
    	})

	end, first, last)
end

function SetDisplay(bool)
	display = bool
	SetNuiFocus(bool, bool)
	SendNUIMessage({
		type = "ui",
		status = bool
	})
end

-- NUI Callbacks --
RegisterNUICallback("exit", function(data)
    SetDisplay(false)
end)

RegisterNUICallback("platesearch", function(data)
    local plate = data.text
	print('Searching plate: ' .. plate)
	SearchPlate(plate)
end)

RegisterNUICallback("namesearch", function(data)
    local firstname = data.textfirst
	local lastname = data.textsecond
	print('Searching name: ' .. firstname .. ' ' .. lastname)
	SearchName(firstname, lastname)
end)

RegisterNUICallback("error", function(data)
    ESX.ShowNotification('~r~[ERROR]~w~ ' .. data.error)
    SetDisplay(false)
end)