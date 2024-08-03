import haxe.Http;
import haxe.Json;
import haxe.Int64;

enum Weather {
    CLEAR;
    RAIN;
    THUNDER;
}

typedef Player = {
    var name: String;
    var account: String;
    var world: String;
    var arror: Int;
    var health: Int;
    var sort: Int;
    var type: String;
    var x: Int;
    var y: Int;
    var z: Int;
}

typedef Area = {
    var fillcolor: String;
    var ytop: Int;
    var color: String;
    var markup: Bool;
    var x: Array<Int>;
    var weight: Int;
    var z: Array<Int>;
    var ybottom: Int;
    var label: String;
    var opacity: Float;
    var fillopacity: Float;
    var desc: String;
}

typedef Marker = {
    var markup: Bool;
    var x: Int;
    var icon: String;
    var y: Int;
    var dim: String;
    var z: Int;
    var label: String;
}

class TORODynmapParser {
    public static function main() {}

    public var data: Null<String> = null;
    public var json: Null<Dynamic> = null;
    public var mdata: Null<String> = null;
    public var mjson: Null<Dynamic> = null;

    private var error: String = null;
    private var merror: Null<String> = null;

    public function new(targetWorld: String = "main", targetDomain: String = "http://torosaba.net:60016") {
        var req = new Http(targetDomain + "/up/world/" + targetWorld + "/");

        req.onData = function (data)
            this.data = data;

        req.onError = function (error)
            this.error = error;

        req.request();

        this.json = Json.parse(data);


        var mreq = new Http(targetDomain + "/tiles/_markers_/marker_" + targetWorld + ".json");

        mreq.onData = function (data)
        this.mdata = data;

        mreq.onError = function (error)
        this.merror = error;

        mreq.request();

        this.mjson = Json.parse(mdata);
    }

    // Get status as bool
    public function isError()
        return this.error != null || this.merror != null;

    // Get error message If it's not error, this returns null
    public function getErrorMessage()
        return this.error + "\n" + this.merror;

    // Get Now Weather (CLEAR or RAIN or THUNDER)
    public function getWeather() {
        if (this.json.hasStorm) {
            if (this.json.isThundering)
                return Weather.THUNDER;
            else
                return Weather.RAIN;
        } else
            return Weather.CLEAR;
    }

    // Get current tick of now
    public function getCurrentTick(): Int {
        return this.json.servertime;
    }

    // Get timestamp of request time
    public function getTimestamp(): Int64 {
        return this.json.timestamp;
    }

    // Get server player count
    public function getPlayerCount(): Int {
        return this.json.currentcount;
    }

    // Get server players
    public function getPlayers(): Array<Player> {
        return this.json.players;
    }

    // Get sets WorldGuard
    public function getSetsWG() {
        return Reflect.getProperty(this.mjson.sets, "worldguard.markerset");
    }

    // Get sets markers
    public function getSetsMK() {
        return Reflect.getProperty(this.mjson.sets, "markers");
    }

    // get Markers (Static)
    static public function getMarkersFromSets(sets: Dynamic) {
        var map: Map<String, Marker> = new Map();
        for (field in Reflect.fields(sets.markers)) {
            map.set(field, Reflect.field(sets.markers, field));
        }
        return map;
    }

    // get Areas (Static)
    static public function getAreasFromSets(sets: Dynamic) {
        var map: Map<String, Area> = new Map();
        for (field in Reflect.fields(sets.areas)) {
            map.set(field, Reflect.field(sets.areas, field));
        }
        return map;
    }

    // get MapKeys (Static)
    static public function getKeys(map: Map<String, Any>){
        var a: Array<String> = [];
        for (e in map.keys()) {
            a.push(e);
        }
        return a;
    }

    // get Area (Static)
    static public function getArea(map: Map<String, Area>, target: String) {
        return map.get(target);
    }

    // get Marker (Static)
    static public function getMarker(map: Map<String, Marker>, target: String) {
        return map.get(target);
    }

    // Get tile URL (Static)
    public static function getTileURL(x: Int, y: Int, targetWorld: String = "main", targetDomain: String = "http://torosaba.net:60016") {
        return targetDomain + "/tiles/" + targetWorld + "/flat/_/zzzzz_" + x * 32 + "_"+ y * 32 +".jpg";
    }
}
