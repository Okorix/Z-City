local luaModules = {
	tbl = {
		eightbit = {
			name = "eightbit",
			startFunc = function()
				if system.IsLinux() then
					print("If the eightbit module doesn't work, you should update the 32-bit glibc library (and C/C++ related 32-bit libraries in general)")
				end

				require("eightbit")

				if eightbit.SetDamp1 then
					eightbit.SetDamp1(0.85)
				end

				if eightbit.SetProotCutoff then
					eightbit.SetProotCutoff(0.7)
				end

				if eightbit.SetProotGain then
					eightbit.SetProotGain(0.7)
				end
			end,
			notInstalledFunc = function()
				MsgC(Color(255, 0, 0), "Eightbit module is not found! Install it to keep voice effects.\n")
			end
		},
		datadesc = {
			name = "datadesc",
			notinstalledfunc = function()
				MsgC(Color(255, 0, 0), "Datadesc module is not found! Install it to keep replacements fully working.\n")
			end
		},
        gmnetwork = {
            name = "network",
        }
	}
}

for i,v in pairs(luaModules.tbl) do
	local moduleName = v.name
	local moduleStartFunction = v.startFunc
	local moduleNotInstalledFunction = v.notInstalledFunc
	if util.IsBinaryModuleInstalled(moduleName) then
		if not v.noAutoRequire then
			require(moduleName)
		end
		if moduleStartFunction ~= nil then
			moduleStartFunction()
		end
	else
		if moduleNotInstalledFunction ~= nil then
            moduleNotInstalledFunction()
        end
	end
end