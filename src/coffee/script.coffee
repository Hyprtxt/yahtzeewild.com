$rollDice  = $ '#rollDice'

_game = new Game()
_view = new GameView collection: new DiceCollection dice

Array::unique = ->
  @reduce ( accum, current ) ->
    if accum.indexOf( current ) < 0
      accum.push current
    accum
  , []

diceValues = ->
  return _view.collection.models.map ( die ) ->
    return die.get 'value'

getFourSets = ->
  result = []
  result.push diceValues().sort().slice 0, 4
  result.push diceValues().sort().slice 1, 5
  return result

diceValueCounts = ->
  result = []
  [1..6].forEach ( num ) ->
    result.push diceValues().reduce ( prev, curr, idx, arr ) ->
      if curr is num
        return prev + 1
      else
        return prev
    , 0
    return
  return result

sumSingleValue = ( val ) ->
  return diceValues().reduce ( prev, curr, idx, arr ) ->
    if curr is val
      return prev + curr
    else
      return prev
  , 0

sumDice = ->
  return diceValues().reduce ( prev, curr, idx, arr ) ->
    return prev + curr
  , 0

takeZeroPrompt = ( score ) ->
  if confirm 'Score 0?'
    $( '.' + score ).attr 'disabled', true
    _game[ score + 'Done' ] = true
    _game[ score ] = 0
    _game.endTurn()
  return

$('.top').on 'click', ( e ) ->
  $current = $( e.currentTarget )
  $current.attr 'disabled', true
  int = $current.data 'top'
  _game[ 'top' + int + 'Done' ] = true
  _game[ 'top' + int ] = sumSingleValue int
  _game.endTurn()
  return

$('.kind3').on 'click', ( e ) ->
  has3kind = diceValueCounts().filter ( val ) ->
    return val >= 3
  # console.log has3kind
  if has3kind.length isnt 0
    $( e.currentTarget ).attr 'disabled', true
    _game.kind3Done = true
    _game.kind3 = sumDice()
    _game.endTurn()
  else
    takeZeroPrompt 'kind3'
  return

$('.kind4').on 'click', ( e ) ->
  has4kind = diceValueCounts().filter ( val ) ->
    return val >= 4
  # console.log has4kind
  if has4kind.length isnt 0
    $( e.currentTarget ).attr 'disabled', true
    _game.kind4Done = true
    _game.kind4 = sumDice()
    _game.endTurn()
  else
    takeZeroPrompt 'kind4'
  return

$('.house').on 'click', ( e ) ->
  has3kind = diceValueCounts().filter ( val ) ->
    return val >= 3
  if has3kind && diceValues().unique().length is 2
    $( e.currentTarget ).attr 'disabled', true
    _game.houseDone = true
    _game.house = 25
    _game.endTurn()
  else
    takeZeroPrompt 'house'
  return

$('.small').on 'click', ( e ) ->
  smallStraights = [
    [1..4]
    [2..5]
    [3..6]
  ]
  result = false
  getFourSets().forEach ( set ) ->
    return smallStraights.forEach ( straight ) ->
      if JSON.stringify( set ) is JSON.stringify( straight )
        result = true
      return
  if result
    $( e.currentTarget ).attr 'disabled', true
    _game.smallDone = true
    _game.small = 30
    _game.endTurn()
  else
    takeZeroPrompt 'small'
  return

$('.large').on 'click', ( e ) ->
  largeStraights = [
    [1..5]
    [2..6]
  ]
  result = false
  largeStraights.forEach ( straight ) ->
    if JSON.stringify( diceValues().sort() ) is JSON.stringify( straight )
      result = true
    return
  if result
    $( e.currentTarget ).attr 'disabled', true
    _game.largeDone = true
    _game.large = 40
    _game.endTurn()
  else
    takeZeroPrompt 'large'
  return

$('.chance').on 'click', ( e ) ->
  $( e.currentTarget ).attr 'disabled', true
  _game.chanceDone = true
  _game.chance = sumDice()
  _game.endTurn()
  return

$('.yahtzee').on 'click', ( e ) ->
  has5kind = diceValueCounts().filter ( val ) ->
    return val >= 5
  # console.log has5kind
  if has5kind.length isnt 0
    $( e.currentTarget ).attr 'disabled', true
    _game.kind5Done = true
    _game.kind5 = 50
    _game.endTurn()
  else
    takeZeroPrompt 'kind5'
  return

$rollDice.on 'click', ( e ) ->
  _game.roll++
  if _game.roll < 4
    _game.render()
    return _view.rollAll()
  else
    return alert 'nope, take a score'
