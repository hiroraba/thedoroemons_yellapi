require 'faye/websocket'
require 'json'
require 'csv'
require 'logger'
module YellApi
  class Backend
    KEEPALIVE_TIME = 15
    MAX_LOG_SIZE = 50
    def initialize(app)
      @app = app
      @clients = []
      @prefs = []
      CSV.foreach('./pref.csv', 'r:UTF-8') do |pref|
        @prefs.push(pref);
      end
      @log = Logger.new(STDOUT)
      @log.level = Logger::INFO
    end

    def call(env)
      if Faye::WebSocket.websocket?(env)
        ws = Faye::WebSocket.new(env, nil, ping: KEEPALIVE_TIME)

        ws.on :open do |event|
          p [:open, ws.object_id]
          @clients << ws
        end

        ws.on :message do |event|
          req = JSON.parse(event.data)
          @log.info("Receive:#{req}")
          resp = {}
          resp["name"] =  req["name"]
          resp["vol"] = req["vol"]
          resp["type"] = req["type"]
          resp["tama_size"] = req["tama_size"]

          index,shortestindex = 0, 0
          shortestdis,dis = 999999, 0

          for pref in @prefs do
            dis = get_distance(pref[0], pref[1], req["lat"], req["lon"])
            if shortestdis > dis then
              shortestdis = dis
              shortestindex = index
            end
            index += 1
          end

          resp["area"] = get_area_from_pref(shortestindex)
          @clients.each { |client| 
            @log.info("Send:#{resp}")
            client.send resp.to_json
          }
        end

        ws.on :close do |event|
          p [:close, ws.object_id]
          @clients.delete(ws)
          ws = nil
        end
        ws.rack_response
      else
        @app.call(env)
      end
    end

    private
    def get_distance(lat1, lon1, lat2, lon2)
      y1 = lat1.to_i * Math::PI / 180
      x1 = lon1.to_i * Math::PI / 180
      y2 = lat2.to_i * Math::PI / 180
      x2 = lon2.to_i * Math::PI / 180
      earth_r = 6378140
      deg = Math::sin(y1) * Math::sin(y2) + Math::cos(y1) * Math::cos(y2) * Math::cos(x2 - x1)
      distance = earth_r * (Math::atan(-deg / Math::sqrt(-deg * deg + 1)) + Math::PI / 2) / 1000
    end

    def get_area_from_pref(pref)
      #北海道
      if Array(0).include?(pref) then return 0 end
      #東北
      if Array(1..6).include?(pref) then return 1 end
      #関東
      if Array(7..13).include?(pref) then return 2 end
      #中部
      if Array(14..22).include?(pref) then return 3 end
      #近畿
      if Array(23..29).include?(pref) then return 4 end 
      #中国
      if Array(30..34).include?(pref) then return 5 end
      #四国
      if Array(35..38).include?(pref) then return 6 end
      #九州沖縄
      if Array(39..46).include?(pref) then return 7 end
      2
    end
  end
end
