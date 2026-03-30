local isOpen = false

function OpenUI(data)
    if isOpen then return end
    isOpen = true
    SetNuiFocus(true, true)
    SendNuiMessage(json.encode({ action = 'open', data = data }))
end

function CloseUI()
    if not isOpen then return end
    isOpen = false
    SetNuiFocus(false, false)
    SendNuiMessage(json.encode({ action = 'close' }))
end

RegisterNuiCallback('close', function(_, cb)
    CloseUI()
    cb({ success = true })
end)
