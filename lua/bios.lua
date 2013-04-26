biosver="0.01"

function getGithubContents( path )
        local pType, pPath, pName, checkPath = {}, {}, {}, {}
        local response = http.get("https://api.github.com/repos/"..gUser.."/"..gRepo.."/contents/"..path.."/?ref="..gBranch)
        if response then
                response = response.readAll()
                if response ~= nil then
                        for str in response:gmatch('"type":"(%w+)"') do table.insert(pType, str) end
                        for str in response:gmatch('"path":"([^\"]+)"') do table.insert(pPath, str) end
                        for str in response:gmatch('"name":"([^\"]+)"') do table.insert(pName, str) end
                end
        else
                writeCenter( "Error: Can't resolve URL" )
                sleep(2)
                term.clear()
                term.setCursorPos(1,1)
                error()
        end
        return pType, pPath, pName
end

function downloadManager( path )
        local fType, fPath, fName = getGithubContents( path )
        for i,data in pairs(fType) do
                if data == "file" then
                        checkPath = http.get("https://raw.github.com/"..gUser.."/"..gRepo.."/"..gBranch.."/"..fPath[i])
                        if checkPath == nil then
                               
                                fPath[i] = fPath[i].."/"..fName[i]
                        end
                        local path = "downloads/"..gRepo.."/"..fPath[i]
                        if gPath ~= "" then path = gPath.."/"..gRepo.."/"..fPath[i] end
                        if not fileList.files[path] and not isBlackListed(fPath[i]) then
                                fileList.files[path] = {"https://raw.github.com/"..gUser.."/"..gRepo.."/"..gBranch.."/"..fPath[i],fName[i]}
                        end
                end
        end
        for i, data in pairs(fType) do
                if data == "dir" then
                        local path = "downloads/"..gRepo.."/"..fPath[i]
                        if gPath ~= "" then path = gPath.."/"..gRepo.."/"..fPath[i] end
                        if not fileList.dirs[path] then
                                writeCenter("Listing directory: "..fName[i])
                                fileList.dirs[path] = {"https://raw.github.com/"dldir..fPath[i],fName[i]}
                                downloadManager( fPath[i] )
                        end
                end
        end
end

function dl()

end