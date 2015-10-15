$rollDice    = $ '#rollDice'
$submitScore = $ '#finalize-score'
$scoreBtns   = $ '.btn-score'
$rollValue   = $ '#rollValue'
$scoreZero   = $ '#score-zero'

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

scoreTop = ( num ) ->
  return score 'top' + num, sumSingleValue num

scoreBottom = ( row ) ->
  return score row, findScoreBottom( row )

findScoreBottom = ( row ) ->
  if row is 'kind3'
    return sumDice()
  if row is 'kind4'
    return sumDice()
  if row is 'house'
    return 25
  if row is 'small'
    return 30
  if row is 'large'
    return 40
  if row is 'kind5'
    return 50
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
    if hasNkind 3
      $( '#kind3' ).removeAttr 'disabled'
    else
      $( '#kind3' ).attr 'disabled', 'disabled'
  if !_game.kind4Done
    if hasNkind 4
      $( '#kind4' ).removeAttr 'disabled'
    else
      $( '#kind4' ).attr 'disabled', 'disabled'
  if !_game.houseDone
    if hasFullHouse()
      $( '#house' ).removeAttr 'disabled'
    else
      $( '#house' ).attr 'disabled', 'disabled'
  if !_game.smallDone
    if hasSmallStraight()
      $( '#small' ).removeAttr 'disabled'
    else
      $( '#small' ).attr 'disabled', 'disabled'
  if !_game.largeDone
    if hasLargeStraight()
      $( '#large' ).removeAttr 'disabled'
    else
      $( '#large' ).attr 'disabled', 'disabled'
  if !_game.chanceDone
    $( '#chance' ).removeAttr 'disabled'
  if !_game.kind5Done
    if hasNkind 5
      $( '#kind5' ).removeAttr 'disabled'
    else
      $( '#kind5' ).attr 'disabled', 'disabled'
  return

_currentRow = 0

$scoreZero.on 'click', ( e ) ->
  $scoreBtns.attr 'disabled', 'disabled'
  $scoreBtns.off 'click'
  $scoreBtns.on 'click', ( e ) ->
    score $( e.currentTarget ).data( 'score' ), 0
    return
  $submitScore.attr 'disabled', 'disabled'
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

$rollDice.on 'click', ( e ) ->
  if _game.roll is 0
    $scoreBtns.on 'click', previewScore
    $submitScore.on 'click', submitScore
  _game.roll++
  _game.render()
  if _game.roll < 4
    return _view.rollAll()
  else
    return alert 'nope, take a score'
