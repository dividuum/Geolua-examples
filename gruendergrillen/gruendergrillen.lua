-- Gruendergrillen Adventure :-)

goal_players = 4
players = {}
num_players = 0

function qrcode_scanned(event)
end

function update_player_interface(player)
    local remaining = goal_players - num_players

    geo.ui.clear(player.id)
    geo.ui.append(player.id, geo.widget.text(string.format([=[
        = Fortschritt: %d/%d 
    ]=], num_players, goal_players)))
    if remaining <= 0 then
        geo.ui.append(player.id, geo.widget.text[=[
            Geschafft. Prima. Ich hoffe ihr habt jetzt einen kleinen Einblick bekommen, was mit Geolua machbar ist. 

            Ihr bekommt jetzt alle ein Bier. Kommt einfach kurz bei mir vorbei, dann gebe ich euch eins aus.

            {{http://dividuum.de/res/fw.jpg}}

            Danke für's mitmachen. Selbstverständlich ist auch der 
            [[https://dl.dropbox.com/u/44457653/geolua/gruendergrillen.lua|Sourcecode dieses Spiel einsehbar]].
        ]=])
    else
        if player.source == "create" then
            if num_players == 1 then
                geo.ui.append(player.id, geo.widget.text[=[
                    Hallo. Bisher hast du noch niemanden kennengelernt.
                    Finde jemand mit einem Handy und lasse den folgenden 
                    Code scannen.
                ]=])
            else
                geo.ui.append(player.id, geo.widget.text(string.format([=[
                    Du hast bereits %d Kontakt initiiert. Dir und deinen
                    Mitspielern fehlen noch %d weitere, dann bekomm ihr alle
                    jeweils ein Bier ausgegeben.
                ]=], num_players, remaining)))
            end
        else
            geo.ui.append(player.id, geo.widget.text(string.format([=[
                Du kannst jetzt deinem neuen Kontakt helfen, indem du selbst
                weitere Kontakte vermittelst. Finde jetzt auch jemanden mit 
                einem QR  Code fähigen Handy und lasse diesen Code scannen.
                Sobald ihr %d Spieler seid, bekommt ihr alle eine Bier 
                ausgegeben.
            ]=], goal_players)))
        end
        geo.ui.append(player.id, geo.widget.qrcode{
            onScanned = qrcode_scanned
        })

        local invite 
        invite = geo.ui.append(player.id, geo.widget.button{
            text = "Kein QR Code Scanner installiert?",
            onClick = function()
                geo.game.ping{
                    message = "Hilf dem Spiel " .. GAME_ID,
                    expire = 120
                }
                geo.ui.remove(player.id, invite)
                geo.ui.append(player.id, geo.widget.text(string.format([=[
                    Dein Kontakt kann jetzt in den nächsten 2 Minuten auch ueber
                    die geolua.com Webseite in dieses Spiel beitreten.

                    Auf der Webseite unter **Start a new adventure** taucht
                    dazu jetzt dieses Spiel auf mit folgendem Hinweis: 

                    **Hilf dem Spiel %s**
                ]=], GAME_ID)))
            end
        })
    end
end

function show_intro(player)
    geo.ui.clear(player.id)
    geo.ui.append(player.id, geo.widget.text(string.format([=[
        = Geolua sagt Hallo

        {{http://geolua.com/s/img/gamer.png}}

        Dieses kleine Beispiel soll kurz Geolua und 
        einige der Möglichkeiten demonstrieren.

        Ziel ist es, dass %d Kontakte vermittelt werden.
        Ein Kontakt gilt als vermittelt, wenn du den 
        gleich angezeigten QR Code einscannen lässt.

        Du und der scannende Mitspieler sind dann im 
        gleichen Team und könnt weitere Mitspieler
        dazuholen. Sobald ihr %d Spieler zusammen habt, 
        könnt ihr euch von mir jeweils ein Bier abholen.
    ]=], goal_players, goal_players)))
    geo.ui.append(player.id, geo.widget.button{
        text = "Ok. Los geht's",
        onClick = function()
            update_player_interface(player)
        end
    })
end

geo.event.join(function(event)
    num_players = num_players + 1
    local joining_player = {
        id = event.player_id,
        source = event.source,
    }
    players[event.player_id] = joining_player

    geo.game.unping()

    local remaining = goal_players - num_players

    for player_id, player in pairs(players) do
        if player.id == joining_player.id then
            show_intro(player)
        else
            geo.ui.clear(player.id)
            if remaining <= 0 then
                geo.ui.append(player.id, geo.widget.text[=[
                    = Letzter Mitspieler gefunden

                    Geschafft. Ihr habt das Ziel erreicht.
                    Ihr könnt euch jetzt alle ein Bier abholen.
                ]=])
            else
                geo.ui.append(player.id, geo.widget.text(string.format([=[
                    = Neuer Mitspieler

                    Soeben ist eine neuer Mitspieler in deine Gruppe
                    gekommen. Damit fehlen jetzt noch %d Mitspieler.
                ]=], remaining)))
            end
            geo.ui.append(player.id, geo.widget.button{
                text = "Ok",
                onClick = function()
                    update_player_interface(player)
                end
            })
        end
    end
end)
