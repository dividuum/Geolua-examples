-- Example code for http://geolua.com. Do whatever you want with it.

LOCATIONS = {
    [1] = {
        name = "den Balken";
        hint = "Holzig und schraeg!";
    };
    [2] = {
        name = "den Kuehlschrank";
        hint = "Nicht allzu warm";
        image = "http://www.dokus4.me/wp-content/uploads/2011/02/eisbaer770.jpg";
    };
    [3] = {
        name = "das Regal";
        hint = "Beim sortierten Geruempel";
    };
    [4] = {
        name = "die Leinwand";
        hint = "Hinter das Offensichtliche gucken";
    };
}
            
found_locations = {}
players = {}

function num_remaining(player_id)
    local n = 0
    for via_id, found in pairs(found_locations[player_id]) do
        n = n + 1
    end
    return 4 - n
end

function add_hints(player_id)
    local found = found_locations[player_id]
    geo.ui.append(player_id, geo.widget.text[[
        Es gibt folgende Hinweise fuer dich:

    ]])
    for via_id, config in pairs(LOCATIONS) do
        if not found[via_id] then
            geo.ui.append(player_id, geo.widget.text(string.format([[
             * %s
            ]], config.hint)))
        end
    end
end

function completed(player_id)
    geo.game.badge(player_id, 34)
    geo.ui.clear(player_id)
    geo.ui.append(player_id, geo.widget.text[[
        = EPIC WIN
        Du hast alle gefunden.
        Gute Arbeit!

        Hier ist dein Badge!

        <<badge(34)>>
    ]])
end

function scanned(player_id, via_id)
    local found = found_locations[player_id]
    geo.ui.clear(player_id)
    if found[via_id] then
        geo.ui.append(player_id, geo.widget.text[[
            = Whut?
            Ne. Diesen QR code hattest du schon.
        ]])
    else
        found[via_id] = true
        geo.ui.append(player_id, geo.widget.text(string.format([[
            = Woot!
            Du hast %s gefunden. Gute Arbeit.
        ]], LOCATIONS[via_id].name)))
        if LOCATIONS[via_id].image then
            geo.ui.append(player_id, geo.widget.text(string.format([[
               {{%s}}
            ]], LOCATIONS[via_id].image)))
        end
    end
    local remaining = num_remaining(player_id)
    if remaining <= 0 then
        completed(player_id)
    else
        geo.ui.append(player_id, geo.widget.text(string.format([[
            Es gibt noch %d weitere QR codes.
        ]], remaining)))
        add_hints(player_id)
        geo.ui.append(player_id, geo.widget.text[[
            Also. Weitersuchen und einscannen!
        ]])
    end
end

geo.event.join(function(event)
    found_locations[event.player_id] = {}
    geo.ui.append(event.player_id, geo.widget.text[[
        = Entropia QR Jagd
        {{https://entropia.de/wiki/images/thumb/b/bf/Zentropia_10.JPG/800px-Zentropia_10.JPG}}
        Die Schnitzeljagd findet im Entropia statt.
        Dort sind 4 QR Codes versteckt.
    ]])
    add_hints(event.player_id)
    geo.ui.append(event.player_id, geo.widget.text[[
        Wenn du einen der QR codes findest, einfach einscannen.
    ]])
end)

geo.event.qr_scan(function(event)
    if event.source ~= "adventure" then
        return
    end
    scanned(event.player_id, event.via_id)
end)
