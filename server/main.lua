ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('esx_AGDmdt:GetVehicleInfo', function(source, cb, plate)
	MySQL.Async.fetchAll('SELECT owner, vehicle FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	}, function(result)
		local retrivedInfo = {plate = plate}
		if result[1] then
			local tryxPlayerIdentifier = result[1].owner
			local vehiclemodelformatted = json.decode(result[1].vehicle)
			local vehiclemodel = vehiclemodelformatted.model
			local vehicleplate = vehiclemodelformatted.plate

			MySQL.Async.fetchAll('SELECT lastname, firstname, job FROM users WHERE identifier = @id', { ['@id'] = result[1].owner }, function(results)
			    local nameserverprint = ('%s %s'):format(results[1].firstname, results[1].lastname) 
			    retrivedInfo.owner = nameserverprint
			    retrivedInfo.identifier = tryxPlayerIdentifier
                retrivedInfo.ownerjob = results[1].job
				retrivedInfo.vehicle = vehiclemodel
				retrivedInfo.plate = vehicleplate
			    cb(retrivedInfo)
			end)
		else
			cb(retrivedInfo)
			print('ERROR')
		end
	end)
end)

ESX.RegisterServerCallback('esx_AGDmdt:GetPersonInfo', function(source, cb, firstname, lastname)
	MySQL.Async.fetchAll('SELECT firstname, lastname, job, dateofbirth, sex, height FROM users where firstname = @first and lastname = @last', {
		['@first'] = firstname,
		['@last'] = lastname
	}, function(results)
		local retrivedInfo = {}
		retrivedInfo.first = results[1].firstname
		retrivedInfo.last = results[1].lastname
		retrivedInfo.job = results[1].job
		retrivedInfo.dob = results[1].dateofbirth
		retrivedInfo.sex = results[1].sex
		retrivedInfo.height = results[1].height
		cb(retrivedInfo)
	end)
end)