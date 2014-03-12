marta_api_key = process.env.MARTA_API_KEY
marta_trains_url = 'http://developer.itsmarta.com/RealtimeTrain/RestServiceNextTrain/GetRealtimeArrivals?apiKey='

request = require('request')
moment = require('moment')
_ = require('underscore')

arrivals = []
getArrivals = (callback) ->
  unless marta_api_key
    callback "No API KEY :("
    return

  request marta_trains_url + marta_api_key, (err, resp, body) ->
    arrivals = JSON.parse(body)
    callback()

filterArrivals = (opts={}) ->
  destRegex = new RegExp(opts.destination, 'i')
  stationRegex = new RegExp(opts.station, 'i')
  filtered = arrivals
  filtered = _.filter(filtered, (arrival) -> arrival.DIRECTION == opts.direction.charAt(0).toUpperCase()) if opts.direction
  filtered = _.filter(filtered, (arrival) -> arrival.LINE == opts.line.toUpperCase()) if opts.line
  filtered = _.filter(filtered, (arrival) -> arrival.DESTINATION.match(destRegex)) if opts.destination
  filtered = _.filter(filtered, (arrival) -> arrival.STATION.match(stationRegex)) if opts.station
  filtered


module.exports = (robot) ->
  robot.hear /^!train (headed (\w+) )?(on (\w+) )?(bound for ([\w ]+) )?for (.+)$/, (msg) ->
    getArrivals (err)->
      if err
        msg.send err
        return
      trains = filterArrivals(
        direction: msg.match[2], 
        line: msg.match[4], 
        station: msg.match[7], 
        destination: msg.match[6]
      )
      train = trains.shift()
      if train
        next_arrival = moment().add(parseInt(train.WAITING_SECONDS),'seconds')
        msg.send "train id #{train.TRAIN_ID} will arrive at #{train.STATION} #{next_arrival.fromNow()}"
      else
        msg.send "no train match :("
