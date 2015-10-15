wildFactor = 8

getRandomInt = ( min, max ) ->
  return Math.floor( Math.random() * ( max - min + 1 ) ) + min

isWild = ->
  random = getRandomInt 1, wildFactor
  if random is 1
    return true
  else
    return false

Die = Backbone.Model.extend
  defaults:
    held: false
    value: 1 # getRandomInt 1, 6
    wild: false # isWild()
    active: false

Die::roll = ->
  if _game.roll is 1
    @.set 'active', true
    @.set 'wild', false
    @.set 'held', false
  if !@.get 'held'
    @.set 'value', getRandomInt 1, 6
    if !@.get 'wild'
      iswild = isWild()
      if iswild
        @.set 'wild', true
        @.set 'held', true
  return @

dice = [1..5].map ( i ) ->
  bewild = isWild()
  beheld = false
  if bewild
    beheld = true
  return new Die
    value: getRandomInt 1, 6
    wild: bewild
    held: beheld
