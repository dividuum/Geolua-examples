-- Example code for http://geolua.com. Do whatever you want with it.

function show_text(player_id)
    geo.ui.clear(player_id)
    geo.ui.append(player_id, geo.widget.text[[
        = Widget Gallery

        In this "adventure", you'll see all available widgets
        Geolua provides. 

        = The text widget
  
        This text is displayed using the //text// widget. The text
        widget allows markup, so images and links are possible too.

        {{http://www.lua.org/images/lua.gif}}

        = The button widget

        The following widget is the Button widget.
        Press it, to see the next widget.
    ]])
    geo.ui.append(player_id, geo.widget.button{
        text = "I'm a button";
        onClick = function()
            show_input(player_id)
        end;
    })
end

function show_input(player_id)
    geo.ui.clear(player_id)
    geo.ui.append(player_id, geo.widget.text[[
        = Thanks

        You clicked the button

        = The input widget

        Here is an input widget. Enter
        any value (or leave it empty) and
        submit it.
    ]])
    geo.ui.append(player_id, geo.widget.input{
        text = "Submit";
        onSubmit = function(event)
            show_places(player_id, event.value)
        end;
    })
end

function show_places(player_id, input_value)
    geo.ui.clear(player_id)
    geo.ui.append(player_id, geo.widget.text[[
        = Thanks
    ]])
    if input_value == "" then
        geo.ui.append(player_id, geo.widget.text"You submitted an empty value")
    else
        geo.ui.append(player_id, geo.widget.text("You submitted the value //" .. input_value .. "//"))
    end
    geo.ui.append(player_id, geo.widget.text[[
        = The places widget

        Here is the places widget. It shows places
        sorted by distance from your location.
    ]])
    geo.ui.append(player_id, geo.widget.places{
        places = {{
            id = "north";
            image = "http://upload.wikimedia.org/wikipedia/commons/f/fe/Arctic_Ocean.png";
            text = "North pole";
            location = { lat = 90, lon = 0 };
            onSelected = function(event)
                show_qrcode(player_id, event.id)
            end;
        }, {
            id = "south";
            image = "http://upload.wikimedia.org/wikipedia/commons/5/59/Pole-south.gif";
            text = "South pole";
            location = { lat = -90, lon = 0 };
            onSelected = function(event)
                show_qrcode(player_id, event.id)
            end;
        }}
    })
end

function show_qrcode(player_id, place)
    local clicked_qr = false
    selected_place = place -- save globally for the compass widget

    geo.ui.clear(player_id)
    geo.ui.append(player_id, geo.widget.text[[
        = Thanks
    ]])
    geo.ui.append(player_id, geo.widget.text("You selected the " .. place.. " pole"))
    geo.ui.append(player_id, geo.widget.text[[
        = The QR code widget

        The following widget is the QR code widget. If you scan this QR 
        code on your phone, and select //join game//, this widget detects
        that it was scanned.
    ]])
    geo.ui.append(player_id, geo.widget.qrcode{
        onScanned = function(event)
            if event.medium == "click" then
                if clicked_qr then return end
                clicked_qr = true
                geo.ui.append(player_id, geo.widget.text[[
                    You clicked the QR code. To see the multiplayer
                    interaction, you must scan it. 
                ]])
                geo.ui.append(player_id, geo.widget.button{
                    text = "Skip QR widget";
                    onClick = function(event)
                        show_compass(player_id)
                    end
                })
                return
            end
            show_phone_ui(event.scan_player_id, player_id)
            geo.ui.clear(player_id)
            geo.ui.append(player_id, geo.widget.text[[
                = Scanned
    
                The QR code was scanned by your phone.
                Waiting for the phone to continue.
            ]])
        end
    })
end

function show_phone_ui(mobile_player_id, desktop_player_id)
    geo.ui.clear(mobile_player_id)
    geo.ui.append(mobile_player_id, geo.widget.text[[
        = Thanks for scanning

        This phone is now in the game you started on 
        your desktop. 

        If you click the button, the game will continue 
        on your desktop.
    ]])
    geo.ui.append(mobile_player_id, geo.widget.button{
        text = "Continue";
        onClick = function()
            show_compass(desktop_player_id)
            geo.ui.clear(mobile_player_id)
            geo.ui.append(mobile_player_id, geo.widget.text[[
                = Thanks
    
                This demonstration will now continue on your desktop.
            ]])
        end
    })
end

function show_compass(player_id)
    geo.ui.clear(player_id)
    geo.ui.append(player_id, geo.widget.text[[
        = The compass widget

        This widget guides the player to a location.
        If the location is reached, the game gets an event.

        This is the last available widget. Since I don't 
        expect you to reach the pole, this is the end of
        this demonstration :-)
    ]])
    if selected_place == "north" then
        geo.ui.append(player_id, geo.widget.text[[
            = To the north pole!
        ]])
        geo.ui.append(player_id, geo.widget.compass{
            target = { lat = 85, lon = 0 };
            radius = 15000;
            onInRange = function(event)
                show_cheater(player_id)
            end;
        })
    else
        geo.ui.append(player_id, geo.widget.text[[
            = To the south pole!
        ]])
        geo.ui.append(player_id, geo.widget.compass{
            target = { lat = -85, lon = 0 };
            radius = 15000;
            onInRange = function(event)
                show_cheater(player_id)
            end;
        })
    end
end

function show_cheater(player_id)
    geo.ui.clear(player_id)
    geo.ui.append(player_id, geo.widget.text[[
        = You cheated
        
        Or didn't you? I hope you don't freeze 
        out there.

        This is the every end of this demonstration.
        Hope you liked it.
    ]])
end

geo.event.join(function(event)
    if event.source == "create" then
        show_text(event.player_id)
    end
end)
