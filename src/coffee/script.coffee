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

takeZeroPrompt = ( what ) ->
  if confirm 'Score 0?'
    score what, 0
  return

score = ( what, score ) ->
  $( '.' + what ).attr 'disabled', true
  _game[ what + 'Done' ] = true
  _game[ what ] = score
  _game.endTurn()

hasNkind = ( num ) ->
  hasIt = diceValueCounts().filter ( val ) ->
    return val >= num
  if hasIt.length isnt 0
    return true
  else
    return false

hasFullHouse = ->
  if hasNkind( 3 ) && diceValues().unique().length is 2
    return true
  else
    return false

hasSmallStraight = ->
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
  return result

hasLargeStraight = ->
  largeStraights = [
    [1..5]
    [2..6]
  ]
  result = false
  largeStraights.forEach ( straight ) ->
    if JSON.stringify( diceValues().sort() ) is JSON.stringify( straight )
      result = true
    return
  return result

scoreTop = ( e ) ->
  num = $( e.currentTarget ).data( 'top' )
  return score 'top' + num, sumSingleValue num

$('.top').on 'click', scoreTop

$('.kind3').on 'click', ( e ) ->
  if hasNkind 3
    score 'kind3', sumDice()
  else
    takeZeroPrompt 'kind3'
  return

$('.kind4').on 'click', ( e ) ->
  if hasNkind 4
    score 'kind4', sumDice()
  else
    takeZeroPrompt 'kind4'
  return

$('.house').on 'click', ( e ) ->
  if hasFullHouse()
    score 'house', 25
  else
    takeZeroPrompt 'house'
  return

$('.small').on 'click', ( e ) ->
  if hasSmallStraight()
    score 'small', 30
  else
    takeZeroPrompt 'small'
  return

$('.large').on 'click', ( e ) ->
  if hasLargeStraight()
    score 'large', 40
  else
    takeZeroPrompt 'large'
  return

$('.chance').on 'click', ( e ) ->
  score 'chance', sumDice()
  return

$('.yahtzee').on 'click', ( e ) ->
  if hasNkind 5
    score 'kind5', 50
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
