Sintaksa = require("sintaksa")

-- Obrađuje, prevodi i ispisuje grešku
local function obradi_gresku(greska)
	print("Greska!", greska)
end

-- "Prevodi" kod iz meseca u lua
local function prevedi()
	io.input(arg[1])

	local mesec_kod = io.read("*all")
	local lua_kod = mesec_kod

	for k, v in pairs(Sintaksa) do
		-- Osigurava da se samo cele reči gledaju pri zameni
		local key = k:gsub("[%-%.%+%[%]%(%)%$%^%%%?%*]", "%%%0")

		-- Zameni samo cele reči
		lua_kod = string.gsub(lua_kod, "%f[%a_]" .. key .. "%f[^%a_]", v)
	end

	return lua_kod
end

-- Izvršava kod i hvata greške
local function izvrsi()
	local kod = prevedi()
	local chunk, greska = loadstring(kod)

	if chunk then
		chunk()
	else
		obradi_gresku(greska)
	end
end

-- Osigurava da se CLI koristi pravilno
if #arg ~= 1 then
	print("Potreban tacno jedan fajl, na primer:\n\nmesec fajl.mes\n")
	return
end

xpcall(izvrsi, obradi_gresku)
