$rollDice    = $ '#rollDice'
$submitScore = $ '#finalize-score'
$scoreBtns   = $ '.btn-score'
$rollValue   = $ '#rollValue'

_game = new Game()
_view = new GameView collection: new DiceCollection dice

Array::unique = ->
  return @reduce ( accum, current ) ->
    if accum.indexOf( current ) < 0
      accum.push current
    return accum
  , []

diceValues = ->
  return _view.collection.models.map ( die ) ->
    return die.get 'value'

getFourSets = ->
  result = []
  result.push diceValues().sort().filter ( element, idx ) ->
    if idx isnt 0
      return element
  result.push diceValues().sort().filter ( element, idx ) ->
    if idx isnt 1
      return element
  result.push diceValues().sort().filter ( element, idx ) ->
    if idx isnt 2
      return element
  result.push diceValues().sort().filter ( element, idx ) ->
    if idx isnt 3
      return element
  result.push diceValues().sort().filter ( element, idx ) ->
    if idx isnt 4
      return element
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
  # $( '.' + what ).attr 'disabled', 'disabled'
  _game[ what + 'Done' ] = true
  _game[ what ] = score
  _game.endTurn()
  $scoreBtns.off 'click', previewScore
  $submitScore.off 'click', submitScore
  return

hasNkind = ( num ) ->
  hasIt = diceValueCounts().filter ( val ) ->
    return val >= num
  if hasIt.length isnt 0
    return true
  else
    return false

hasFullHouse = ->
  if hasNkind( 3 ) && diceValues().unique().length is 2 && !hasNkind( 4 )
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

scoreTop = ( num ) ->
  return score 'top' + num, sumSingleValue num

scoreBottom = ( row ) ->
  return score row, findScoreBottom( row )

findScoreBottom = ( row ) ->
  if row is 'kind3'
    if hasNkind 3
      return sumDice()
    else
      return 0
  if row is 'kind4'
    if hasNkind 4
      return sumDice()
    else
      return 0
  if row is 'house'
    if hasFullHouse()
      return 25
    else
      return 0
  if row is 'small'
    if hasSmallStraight()
      return 30
    else
      return 0
  if row is 'large'
    if hasLargeStraight()
      return 40
    else
      return 0
  if row is 'kind5'
    if hasNkind 5
      if _game.kind5Done
        _game.bonusTurns++
        return 100
      else
        return 50
    else
      return 0
  return sumDice()

_enableScores = ( row ) ->
  if !_game.top1Done
    $( '#top1' ).removeAttr 'disabled'
  if !_game.top2Done
    $( '#top2' ).removeAttr 'disabled'
  if !_game.top3Done
    $( '#top3' ).removeAttr 'disabled'
  if !_game.top4Done
    $( '#top4' ).removeAttr 'disabled'
  if !_game.top5Done
    $( '#top5' ).removeAttr 'disabled'
  if !_game.top6Done
    $( '#top6' ).removeAttr 'disabled'
  if !_game.kind3Done
    $( '#kind3' ).removeAttr 'disabled'
  if !_game.kind4Done
    $( '#kind4' ).removeAttr 'disabled'
  if !_game.houseDone
    $( '#house' ).removeAttr 'disabled'
  if !_game.smallDone
    $( '#small' ).removeAttr 'disabled'
  if !_game.largeDone
    $( '#large' ).removeAttr 'disabled'
  if !_game.chanceDone
    $( '#chance' ).removeAttr 'disabled'
  if !_game.kind5Done
    $( '#kind5' ).removeAttr 'disabled'
  return

_currentRow = 0

previewScore = ( e ) ->
  _currentRow = $( e.currentTarget ).data 'score'
  $submitScore.removeAttr 'disabled'
  if typeof _currentRow is 'number'
    $rollValue.text sumSingleValue _currentRow
  else
    $rollValue.text findScoreBottom _currentRow
  return

submitScore = ( e ) ->
  $submitScore.attr 'disabled', 'disabled'
  $scoreBtns.attr 'disabled', 'disabled'
  if typeof _currentRow is 'number'
    scoreTop _currentRow
  else
    scoreBottom _currentRow
  return

rollTheDice = ( e ) ->
  if _game.roll is 0
    $scoreBtns.on 'click', previewScore
    $submitScore.on 'click', submitScore
  _game.roll++
  _game.render()
  if _game.roll < 4
    return _view.rollAll()
  else
    return alert 'nope, take a score'

$rollDice.on 'click', rollTheDice
