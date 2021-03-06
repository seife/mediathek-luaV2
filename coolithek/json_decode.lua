
function getJsonData(url, file)
	local box = nil
	local data = nil
	local dataExist = false
	if (not file) then
		data = jsonData
	else
		data = file
		if (H.fileExist(data) == true) then dataExist = true end
	end
	if ((dataExist == false) or (noCacheFiles == true)) then
		box = downloadFile(url, data, false)
	end

	local fp, s;
	fp = io.open(data, "r");
	if fp == nil then
		G.hideInfoBox(box)
		error("Error connecting to database server.")
	end;
	s = fp:read("*a");
	fp:close();
	G.hideInfoBox(box)
	return s;
end

function checkJsonError(tab)
	if tab.error > 0 then
		local box = G.paintInfoBox(tab.entry .. "\nAbort...");
		P.sleep(4);
		G.hideInfoBox(box)
		return false
	end
	return true
end

function decodeJson(data)
	local s = H.trim(data);
	local x = s.sub(s, 1, 1);
	if x ~= "{" and x ~= "[" then
		local box = G.paintInfoBox("Error parsing json data.");
		P.sleep(4);
		G.hideInfoBox(box)
		return nil
	end
	return J:decode(s);
end
