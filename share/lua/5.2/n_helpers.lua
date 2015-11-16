--[[
	Helper functions for lua
	Copyright (C) 2014, Michael Liebmann 'micha-bbg'

	License: GPL

	This program is free software; you can redistribute it and/or
	modify it under the terms of the GNU General Public
	License as published by the Free Software Foundation; either
	version 2 of the License, or (at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
	General Public License for more details.

	You should have received a copy of the GNU General Public
	License along with this program; if not, write to the
	Free Software Foundation, Inc., 51 Franklin St, Fifth Floor,
	Boston, MA  02110-1301, USA.
]]

local VERSION = 20151113.01

--[[
load the modul:
---------------
local helpers = require "n_helpers"

functions:
----------
pidOf(prog)
base64Enc(data)
base64Dec(data)
tprint([f], tbl)
( tprintFile (f, tbl) )
fileExist(file)
trim(s)
printf(...)
modulName()
scriptPath()
scriptBase()
checkAPIversion(major, minor)
]]

local posix = require "posix"
local helpers = {VERSION = VERSION}
local H = helpers


function H.pidOf(prog)
	local r = ""
	local h = io.popen("pidof " .. prog, "r")
	if h ~= nil then
		r = h:read("*a")
		if r ~= "" then r = string.gsub(r, "\n", "") end
		io.close( h )
	end
	return r
end

-- ###### base64 encode / decode #############################################
-- convert a image:
--	http://websemantics.co.uk/online_tools/image_to_data_uri_convertor/
-- function from http://lua-users.org/wiki/BaseSixtyFour

-- character table string
local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'

-- encoding
function H.base64Enc(data)
	return ((data:gsub('.', function(x) 
		local r,b='',x:byte()
		for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end
		return r;
	end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
		if (#x < 6) then return '' end
		local c=0
		for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end
		return b:sub(c+1,c+1)
	end)..({ '', '==', '=' })[#data%3+1])
end

-- decode
function H.base64Dec(data)
	data = string.gsub(data, '[^'..b..'=]', '')
	return (data:gsub('.', function(x)
		if (x == '=') then return '' end
		local r,f='',(b:find(x)-1)
		for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
		return r;
	end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
		if (#x ~= 8) then return '' end
		local c=0
		for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(7-i) or 0) end
		return string.char(c)
	end))
end
-- ###########################################################################

-- Print contents of `tbl`, with indentation.
-- `indent` sets the initial level of indentation.
-- function ist from https://gist.github.com/ripter/4270799
function H.tprint_OLD(tbl, indent)
	if not indent then indent = 0 end
	for k, v in pairs(tbl) do
		formatting = string.rep(" ", indent) .. k .. ": "
		if type(v) == "table" then
			print(formatting)
			H.tprint_OLD(v, indent+1)
		elseif type(v) == 'boolean' then
			print(formatting .. tostring(v))	
		elseif type(v) == 'function' then
			print(formatting .. tostring(v))	
		else
			print(formatting .. v)
		end
	end
end

function H.tprint(f, tbl, indent)
	if type(f) == "userdata" then
		mode = "file"
	else
		indent = tbl
		tbl    = f
	end
	if type(tbl) ~= "table" then error("No table given, exit...") end
	if not indent then indent = 0 end
	for k, v in pairs(tbl) do
		formatting = string.rep(" ", indent) .. k .. ": "
		if type(v) == "table" then
			if mode == "file" then
				f:write(formatting.."\n")
				H.tprint(f, v, indent+1)
			else
				print(formatting)
				H.tprint(v, indent+1)
			end
		elseif type(v) == 'boolean' then
			if mode == "file" then
				f:write(formatting .. tostring(v).."\n")
			else
				print(formatting .. tostring(v))
			end
		elseif type(v) == 'function' then
			if mode == "file" then
				f:write(formatting .. tostring(v).."\n")
			else
				print(formatting .. tostring(v))
			end
		else
			if mode == "file" then
				f:write(formatting .. v.."\n")
			else
				print(formatting .. v)
			end
		end
	end
end

function H.tprintFile (f, tbl, indent)
	if not indent then indent = 0 end
	for k, v in pairs(tbl) do
		formatting = string.rep(" ", indent) .. k .. ": "
		if type(v) == "table" then
			f:write(formatting.."\n")
			H.tprintFile(f, v, indent+1)
		elseif type(v) == 'boolean' then
			f:write(formatting .. tostring(v).."\n")	
		else
			f:write(formatting .. v .. "\n")
		end
	end
end

function H.fileExist(file)
	if posix.access(file, f) == nil then return false end
	return true
end

function H.trim(s)
	return (s:gsub("^%s*(.-)%s*$", "%1"))
end

function H.printf(...)
	print(string.format(...))
end

function H.modulName()
	return "n_helpers"
end

function H.checkModulVersion(version)
	if version > VERSION then
		error(string.format("\nModul '%s' version >= %.02f is required, existing version is %.02f", H.modulName(), version, VERSION))
	end
end

function H.scriptPath()
	return posix.dirname(debug.getinfo(2, "S").source:sub(2));
end

function H.scriptBase()
	local name = posix.basename(debug.getinfo(2, "S").source:sub(2));
	return string.sub(name, 1, #name-4)
end

function H.checkAPIversion(major, minor)
	if APIVERSION.MAJOR >= major and APIVERSION.MINOR >= minor then return true else return false end
end

return helpers