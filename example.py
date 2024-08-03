from bin import tdp

result = tdp.TORODynmapParser("main", "http://torosaba.net:60016")

if result.isError():
    print("Error:", result.getErrorMessage())
else:
    # Get markers

    dmap = tdp.TORODynmapParser.getMarkersFromSets(result.getSetsMK())

    markers = tdp.TORODynmapParser.getKeys(dmap)

    for e in markers:
        elm = tdp.TORODynmapParser.getMarker(dmap, e)
        print(elm.label)

    # Get other information

    players = result.getPlayers()

    for e in players:
        print(e.name + " in " + e.world + " at " + str(e.x) + "," + str(e.y) + "," + str(e.z))

    print("Total players: " + str(result.getPlayerCount()))

    print("Weather: " + str(result.getWeather()))
